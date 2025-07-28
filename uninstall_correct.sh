#!/bin/bash

# WHM Toolkit - Desinstalador Corregido
# Para la estructura oficial de plugins de WHM

set -e

PLUGIN_NAME="WHM Toolkit"
PLUGIN_DIR="/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
APPCONFIG_FILE="/var/cpanel/apps/whm_toolkit.conf"

echo "==========================================="
echo "  Desinstalación de $PLUGIN_NAME"
echo "  Estructura oficial de plugins WHM"
echo "==========================================="
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
if [ -d "$PLUGIN_DIR" ]; then
    echo "📋 Respaldando archivos del plugin..."
    cp -r "$PLUGIN_DIR" "$BACKUP_DIR/"
    echo "   ✅ Plugin respaldado"
fi

if [ -f "$APPCONFIG_FILE" ]; then
    echo "📋 Respaldando configuración AppConfig..."
    cp "$APPCONFIG_FILE" "$BACKUP_DIR/"
    echo "   ✅ AppConfig respaldado"
fi

# Desregistrar de AppConfig
echo "🗑️  Desregistrando de AppConfig..."
if [ -f "$APPCONFIG_FILE" ]; then
    /usr/local/cpanel/bin/unregister_appconfig whm_toolkit || true
    echo "   ✅ Desregistrado de AppConfig"
else
    echo "   ℹ️  No estaba registrado en AppConfig"
fi

# Eliminar archivos del plugin
echo "🧹 Eliminando archivos del plugin..."
if [ -d "$PLUGIN_DIR" ]; then
    rm -rf "$PLUGIN_DIR"
    echo "   ✅ Directorio del plugin eliminado"
else
    echo "   ℹ️  Directorio del plugin no encontrado"
fi

# Eliminar configuración AppConfig
if [ -f "$APPCONFIG_FILE" ]; then
    rm -f "$APPCONFIG_FILE"
    echo "   ✅ Configuración AppConfig eliminada"
fi

# Limpiar instalaciones anteriores no oficiales
echo "🧹 Limpiando instalaciones anteriores..."
rm -rf "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
rm -rf "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_*.png"

echo
echo "==========================================="
echo "  ✅ Desinstalación completada"
echo "==========================================="
echo
echo "📁 Respaldo guardado en: $BACKUP_DIR"
echo
echo "🎯 Para reinstalar:"
echo "   wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install_correct.sh | bash"
echo
echo "===========================================" 