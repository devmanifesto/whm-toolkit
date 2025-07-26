#!/bin/bash

# WHM Toolkit - Desinstalador Oficial
# Siguiendo documentación oficial de cPanel

set -e

PLUGIN_NAME="WHM Toolkit"

echo "=========================================="
echo "  Desinstalación Oficial de $PLUGIN_NAME"
echo "=========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Crear respaldo
BACKUP_DIR="/tmp/whm-toolkit-backup-$(date +%Y%m%d_%H%M%S)"
echo "💾 Creando respaldo en: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Respaldar archivos si existen
[ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ] && \
    cp "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" "$BACKUP_DIR/"

[ -f "/var/cpanel/apps/whm_toolkit.conf" ] && \
    cp "/var/cpanel/apps/whm_toolkit.conf" "$BACKUP_DIR/"

# Desregistrar de AppConfig
echo "🗑️  Desregistrando de AppConfig..."
if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    /usr/local/cpanel/bin/unregister_appconfig whm_toolkit || true
    echo "   ✅ Desregistrado de AppConfig"
else
    echo "   ℹ️  No estaba registrado en AppConfig"
fi

# Eliminar archivos del plugin
echo "🧹 Eliminando archivos del plugin..."
rm -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
rm -f "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png"
rm -f "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png"

# Limpiar instalaciones anteriores no oficiales
echo "🧹 Limpiando instalaciones anteriores..."
rm -rf "/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit"

echo
echo "=========================================="
echo "  ✅ Desinstalación completada"
echo "=========================================="
echo
echo "📁 Respaldo guardado en: $BACKUP_DIR"
echo
echo "🎯 Para reinstalar:"
echo "   wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install_official_whm.sh | bash"
echo 