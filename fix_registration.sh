#!/bin/bash

echo "==========================================="
echo "  Reparación de Registro AppConfig"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

APPCONFIG_FILE="/var/cpanel/apps/whm_toolkit.conf"

echo "🔍 Verificando archivo AppConfig..."
if [ -f "$APPCONFIG_FILE" ]; then
    echo "   ✅ Archivo existe"
    echo "   📋 Contenido:"
    cat "$APPCONFIG_FILE"
else
    echo "   ❌ Archivo NO existe"
    exit 1
fi

echo
echo "🧹 Limpiando registros anteriores..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig whm-toolkit 2>/dev/null || true

echo
echo "📋 Intentando registro múltiples veces..."
for i in {1..5}; do
    echo "   Intento $i..."
    /usr/local/cpanel/bin/register_appconfig "$APPCONFIG_FILE"
    sleep 2
done

echo
echo "🔄 Reiniciando servicios críticos..."
echo "   Reiniciando cPanel..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true

echo "   Reiniciando Apache..."
/scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true

echo "   Reconstruyendo caché de WHM..."
/usr/local/cpanel/bin/rebuild_whostmgr_locale_cache >/dev/null 2>&1 || true

echo "   Actualizando configuración HTTP..."
/scripts/rebuildhttpdconf >/dev/null 2>&1 || true

echo
echo "🔍 Verificando registro..."
if /usr/local/cpanel/bin/register_appconfig --list | grep -i whm_toolkit >/dev/null 2>&1; then
    echo "   ✅ Plugin registrado correctamente"
    /usr/local/cpanel/bin/register_appconfig --list | grep -i whm_toolkit
else
    echo "   ❌ Plugin NO registrado"
    echo "   📋 Lista completa de plugins registrados:"
    /usr/local/cpanel/bin/register_appconfig --list
fi

echo
echo "🌐 Verificando acceso web..."
PLUGIN_DIR="/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
if [ -f "$PLUGIN_DIR/whm-toolkit.cgi" ]; then
    echo "   ✅ Plugin CGI existe"
    echo "   🧪 Probando sintaxis..."
    if perl -c "$PLUGIN_DIR/whm-toolkit.cgi" >/dev/null 2>&1; then
        echo "   ✅ Sintaxis Perl correcta"
    else
        echo "   ❌ Error de sintaxis Perl"
    fi
else
    echo "   ❌ Plugin CGI NO existe"
fi

echo
echo "📝 Verificando logs..."
echo "   Últimas líneas del log de errores:"
tail -3 /usr/local/cpanel/logs/error_log 2>/dev/null || echo "   ⚠️ No se puede acceder al log"

echo
echo "==========================================="
echo "  Reparación completada"
echo "==========================================="
echo
echo "💡 Pasos adicionales:"
echo "1. Cierra completamente tu navegador"
echo "2. Limpia la caché del navegador"
echo "3. Espera 2-3 minutos"
echo "4. Abre WHM en una ventana nueva"
echo "5. Ve a Plugins en el menú lateral"
echo
echo "🌐 URL directa para probar:"
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")
echo "   https://$SERVER_IP:2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo
echo "===========================================" 