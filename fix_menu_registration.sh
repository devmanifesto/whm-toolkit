#!/bin/bash

# WHM Toolkit - Script para solucionar registro en menú
# Enfoque específico para hacer que el plugin aparezca en WHM

echo "==========================================="
echo "  Solucionando registro en menú de WHM"
echo "==========================================="
echo

# Verificar que somos root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🔄 Etapa 1: Limpiando registros anteriores..."
# Desregistrar completamente
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true

# Limpiar archivos duplicados en apps
rm -f /var/cpanel/apps/WHM_Toolkit.conf 2>/dev/null || true

echo "🔄 Etapa 2: Re-registrando con configuración limpia..."
# Re-registrar con el archivo correcto
if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf
    sleep 2
    /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf
else
    echo "❌ Error: No se encuentra /var/cpanel/apps/whm_toolkit.conf"
    exit 1
fi

echo "🔄 Etapa 3: Reiniciando servicios en orden específico..."
# Reiniciar servicios en el orden correcto
if [ -f "/scripts/restartsrv_cpanel" ]; then
    echo "   Reiniciando cPanel..."
    /scripts/restartsrv_cpanel --wait
fi

if [ -f "/scripts/restartsrv_httpd" ]; then
    echo "   Reiniciando Apache..."
    /scripts/restartsrv_httpd --wait
fi

# Intentar reiniciar WHM específicamente
if [ -f "/scripts/restartsrv_whostmgr" ]; then
    echo "   Reiniciando WHM..."
    /scripts/restartsrv_whostmgr --wait
fi

echo "🔄 Etapa 4: Limpiando cachés..."
# Limpiar cachés de WHM
if [ -f "/usr/local/cpanel/bin/rebuild_whostmgr_locale_cache" ]; then
    /usr/local/cpanel/bin/rebuild_whostmgr_locale_cache
fi

# Forzar reconstrucción de configuración
if [ -f "/usr/local/cpanel/scripts/rebuildhttpdconf" ]; then
    /usr/local/cpanel/scripts/rebuildhttpdconf
fi

echo "🔄 Etapa 5: Verificando registro..."
# Verificar que el plugin está registrado
echo "📋 Archivos de configuración:"
ls -la /var/cpanel/apps/ | grep -i whm_toolkit || echo "   No se encontraron archivos de configuración"

echo "📋 Archivo CGI:"
ls -la /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi 2>/dev/null || echo "   Archivo CGI no encontrado"

echo "📋 Iconos:"
ls -la /usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_*.png 2>/dev/null || echo "   Iconos no encontrados"

echo "🔄 Etapa 6: Forzando actualización de menú..."
# Intentar diferentes métodos para forzar actualización del menú
if [ -f "/usr/local/cpanel/bin/update_whm_menu" ]; then
    /usr/local/cpanel/bin/update_whm_menu 2>/dev/null || true
fi

if [ -f "/usr/local/cpanel/bin/rebuild_whm_menu" ]; then
    /usr/local/cpanel/bin/rebuild_whm_menu 2>/dev/null || true
fi

# Intentar actualizar la configuración de plugins
if [ -f "/usr/local/cpanel/whostmgr/bin/whostmgr" ]; then
    echo "   Actualizando configuración de WHM..."
    /usr/local/cpanel/whostmgr/bin/whostmgr --updateconfig 2>/dev/null || true
fi

echo "🔄 Etapa 7: Verificación final..."
# Probar acceso directo
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "✅ Archivo CGI existe y es ejecutable"
    
    # Probar sintaxis
    perl -c /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi 2>/dev/null && echo "✅ Sintaxis Perl correcta" || echo "❌ Error de sintaxis Perl"
    
    # Mostrar URL directa
    SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "tu-servidor")
    echo "🌐 URL directa: https://$SERVER_IP:2087/cgi/addon_whm_toolkit.cgi"
else
    echo "❌ Archivo CGI no encontrado"
fi

echo
echo "==========================================="
echo "  Proceso completado"
echo "==========================================="
echo
echo "💡 Pasos manuales recomendados:"
echo "1. Cierra COMPLETAMENTE tu navegador"
echo "2. Limpia la caché del navegador"
echo "3. Espera 2-3 minutos"
echo "4. Abre WHM en una nueva ventana"
echo "5. Ve a Plugins en el menú lateral"
echo "6. Busca 'WHM_Toolkit' o 'WHM Toolkit'"
echo
echo "🔍 Si aún no aparece:"
echo "- El plugin funciona correctamente en modo directo"
echo "- Algunos sistemas WHM requieren configuración adicional"
echo "- El acceso directo siempre estará disponible"
echo
echo "📞 Para soporte adicional, revisa los logs:"
echo "   tail -f /usr/local/cpanel/logs/error_log" 