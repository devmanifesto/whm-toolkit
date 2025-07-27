#!/bin/bash

# WHM Toolkit - Script para corregir registro del plugin
# Usa comandos reales de cPanel/WHM

echo "==========================================="
echo "  Corrigiendo registro de WHM Toolkit"
echo "==========================================="
echo

# Verificar que somos root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🔄 Reiniciando servicios cPanel..."
# Reiniciar solo cPanel (WHM se reinicia automáticamente)
/scripts/restartsrv_cpanel --wait
echo

echo "🔄 Reiniciando servicios WHM..."
# Intentar diferentes métodos para reiniciar WHM
if [ -f "/scripts/restartsrv_whostmgr" ]; then
    /scripts/restartsrv_whostmgr --wait
elif [ -f "/scripts/restartsrv_httpd" ]; then
    /scripts/restartsrv_httpd --wait
else
    systemctl restart httpd 2>/dev/null || service httpd restart 2>/dev/null || echo "⚠️  No se pudo reiniciar httpd"
fi
echo

echo "🧹 Limpiando caché de WHM..."
# Limpiar caché de WHM usando métodos disponibles
if [ -f "/usr/local/cpanel/bin/rebuild_whostmgr_locale_cache" ]; then
    /usr/local/cpanel/bin/rebuild_whostmgr_locale_cache
fi

if [ -f "/usr/local/cpanel/scripts/rebuildhttpdconf" ]; then
    /usr/local/cpanel/scripts/rebuildhttpdconf
fi
echo

echo "📋 Re-registrando plugin..."
# Re-registrar el plugin múltiples veces para asegurar persistencia
/usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf
sleep 2
/usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf
echo

echo "🔍 Verificando registro..."
# Verificar si el plugin está en la lista de aplicaciones
if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "✅ Archivo de configuración existe"
    ls -la /var/cpanel/apps/whm_toolkit.conf
else
    echo "❌ Archivo de configuración no encontrado"
fi
echo

echo "🌐 Verificando acceso directo..."
# Probar acceso directo al CGI
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "✅ Plugin accesible en: https://$(hostname -I | awk '{print $1}'):2087/cgi/addon_whm_toolkit.cgi"
else
    echo "❌ Archivo CGI no encontrado"
fi
echo

echo "💡 Pasos adicionales manuales:"
echo "1. Cierra sesión de WHM completamente"
echo "2. Espera 30 segundos"
echo "3. Inicia sesión nuevamente en WHM"
echo "4. Ve a Plugins en el menú lateral"
echo "5. Busca 'WHM_Toolkit' o 'WHM Toolkit'"
echo
echo "🔗 Si no aparece, accede directamente:"
echo "   https://$(hostname -I | awk '{print $1}'):2087/cgi/addon_whm_toolkit.cgi"
echo

echo "==========================================="
echo "  Proceso completado"
echo "===========================================" 