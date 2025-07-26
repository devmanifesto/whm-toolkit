#!/bin/bash

# WHM Toolkit - Desinstalador
# Repositorio: https://github.com/devmanifesto/whm-toolkit

set -e

PLUGIN_NAME="WHM Toolkit"
INSTALL_DIR="/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit"

echo "=========================================="
echo "  Desinstalación de $PLUGIN_NAME"
echo "=========================================="
echo

# Verificar que estamos ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Este script debe ejecutarse como root"
    echo "   Ejecuta: sudo $0"
    exit 1
fi

# Verificar si está instalado
if [ ! -d "$INSTALL_DIR" ]; then
    echo "ℹ️  El plugin no está instalado en $INSTALL_DIR"
    exit 0
fi

echo "🔍 Plugin encontrado en: $INSTALL_DIR"

# Confirmar desinstalación
read -p "¿Estás seguro de que quieres desinstalar $PLUGIN_NAME? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Desinstalación cancelada"
    exit 0
fi

# Crear respaldo
BACKUP_DIR="/tmp/whm-toolkit-uninstall-backup-$(date +%Y%m%d_%H%M%S)"
echo "💾 Creando respaldo en: $BACKUP_DIR"
cp -r "$INSTALL_DIR" "$BACKUP_DIR"

# Desinstalar
echo "🗑️  Desinstalando plugin..."
rm -rf "$INSTALL_DIR"

# Verificar desinstalación
if [ ! -d "$INSTALL_DIR" ]; then
    echo "✅ Plugin desinstalado exitosamente"
    echo "📁 Respaldo guardado en: $BACKUP_DIR"
else
    echo "❌ Error: No se pudo desinstalar completamente"
    exit 1
fi

echo
echo "🎯 Para reinstalar, ejecuta:"
echo "   wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install_from_github.sh | bash"
echo 