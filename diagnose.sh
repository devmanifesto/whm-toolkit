#!/bin/bash

echo "==========================================="
echo "  Diagnóstico WHM Toolkit Plugin"
echo "==========================================="
echo

PLUGIN_DIR="/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
APPCONFIG_FILE="/var/cpanel/apps/whm_toolkit.conf"

echo "🔍 Verificando archivos del plugin..."
echo "📁 Directorio del plugin: $PLUGIN_DIR"

if [ -d "$PLUGIN_DIR" ]; then
    echo "   ✅ Directorio existe"
    echo "   📋 Contenido:"
    ls -la "$PLUGIN_DIR"
else
    echo "   ❌ Directorio NO existe"
fi

echo
echo "📄 Verificando archivo CGI..."
if [ -f "$PLUGIN_DIR/whm-toolkit.cgi" ]; then
    echo "   ✅ Archivo CGI existe"
    echo "   📊 Permisos: $(ls -la "$PLUGIN_DIR/whm-toolkit.cgi" | awk '{print $1, $3, $4}')"
    
    echo "   🧪 Probando sintaxis Perl..."
    if perl -c "$PLUGIN_DIR/whm-toolkit.cgi" >/dev/null 2>&1; then
        echo "   ✅ Sintaxis Perl correcta"
    else
        echo "   ❌ Error de sintaxis Perl"
    fi
else
    echo "   ❌ Archivo CGI NO existe"
fi

echo
echo "⚙️ Verificando configuración AppConfig..."
if [ -f "$APPCONFIG_FILE" ]; then
    echo "   ✅ Archivo AppConfig existe"
    echo "   📊 Permisos: $(ls -la "$APPCONFIG_FILE" | awk '{print $1, $3, $4}')"
    echo "   📋 Contenido:"
    cat "$APPCONFIG_FILE"
else
    echo "   ❌ Archivo AppConfig NO existe"
fi

echo
echo "🔧 Verificando registro AppConfig..."
if /usr/local/cpanel/bin/register_appconfig --list | grep -i whm_toolkit >/dev/null 2>&1; then
    echo "   ✅ Plugin registrado en AppConfig"
    /usr/local/cpanel/bin/register_appconfig --list | grep -i whm_toolkit
else
    echo "   ❌ Plugin NO registrado en AppConfig"
fi

echo
echo "🌐 Verificando acceso web..."
echo "   🔗 URL del plugin: https://$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost"):2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"

echo
echo "📊 Verificando servicios..."
echo "   🔄 Estado de cPanel:"
if systemctl is-active --quiet cpanel; then
    echo "   ✅ cPanel activo"
else
    echo "   ❌ cPanel inactivo"
fi

echo "   🌐 Estado de Apache:"
if systemctl is-active --quiet httpd; then
    echo "   ✅ Apache activo"
else
    echo "   ❌ Apache inactivo"
fi

echo
echo "📝 Verificando logs..."
echo "   📋 Últimas líneas del log de errores:"
tail -5 /usr/local/cpanel/logs/error_log 2>/dev/null || echo "   ⚠️ No se puede acceder al log"

echo
echo "🔧 Intentando reparación automática..."
echo "   🧹 Limpiando registro anterior..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true

echo "   📋 Re-registrando plugin..."
if [ -f "$APPCONFIG_FILE" ]; then
    /usr/local/cpanel/bin/register_appconfig "$APPCONFIG_FILE"
    echo "   ✅ Plugin re-registrado"
else
    echo "   ❌ No se puede re-registrar (archivo no existe)"
fi

echo "   🔄 Reiniciando servicios..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true
/scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true

echo
echo "==========================================="
echo "  Diagnóstico completado"
echo "==========================================="
echo
echo "💡 Recomendaciones:"
echo "1. Verifica que el plugin aparezca en WHM → Plugins"
echo "2. Prueba el acceso directo por URL"
echo "3. Si no funciona, ejecuta este diagnóstico nuevamente"
echo "4. Revisa los logs de error para más detalles" 