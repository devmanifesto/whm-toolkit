#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit v2 - Desinstalador"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🧹 Desinstalando WHM Toolkit v2..."

# Desregistrar de AppConfig
echo "📋 Desregistrando de AppConfig..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit_v2 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit_v2 2>/dev/null || true

# Eliminar archivos
echo "🗑️ Eliminando archivos..."
rm -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
rm -f "/var/cpanel/apps/whm_toolkit_v2.conf"

# Limpiar versiones anteriores también
echo "🧹 Limpiando versiones anteriores..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
rm -rf "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
rm -f "/var/cpanel/apps/whm_toolkit.conf"

echo "🔄 Reiniciando servicios..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true
/scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true

echo "✅ Verificando desinstalación..."
if [ ! -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "   ✅ Plugin CGI eliminado"
else
    echo "   ❌ Plugin CGI NO eliminado"
fi

if [ ! -f "/var/cpanel/apps/whm_toolkit_v2.conf" ]; then
    echo "   ✅ Configuración AppConfig eliminada"
else
    echo "   ❌ Configuración AppConfig NO eliminada"
fi

echo
echo "==========================================="
echo "  ✅ Desinstalación completada"
echo "==========================================="
echo
echo "💡 El plugin ha sido completamente eliminado."
echo "   Para reinstalar, ejecuta: wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install-v2.sh | bash"
echo
echo "===========================================" 