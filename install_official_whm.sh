#!/bin/bash

# WHM Toolkit - Instalador Oficial siguiendo documentación de cPanel
# Basado en: https://api.docs.cpanel.net/guides/guide-to-whm-plugins/

set -e

PLUGIN_NAME="WHM Toolkit"
PLUGIN_VERSION="1.0.0"
GITHUB_REPO="https://github.com/devmanifesto/whm-toolkit"

# Directorios oficiales según documentación cPanel
WHM_CGI_DIR="/usr/local/cpanel/whostmgr/docroot/cgi"
ADDON_PLUGINS_DIR="/usr/local/cpanel/whostmgr/docroot/addon_plugins"
APPCONFIG_DIR="/var/cpanel/apps"
TEMP_DIR="/tmp/whm-toolkit-official-install"

echo "=========================================="
echo "  Instalación Oficial de $PLUGIN_NAME"
echo "  Siguiendo documentación de cPanel/WHM"
echo "=========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Limpiar instalación anterior
echo "🧹 Limpiando instalaciones anteriores..."
if [ -f "$APPCONFIG_DIR/whm_toolkit.conf" ]; then
    /usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
fi
rm -rf "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
rm -rf "$ADDON_PLUGINS_DIR/whm_toolkit_*.png"
rm -rf "$TEMP_DIR"

# Crear directorios
echo "📁 Creando directorios..."
mkdir -p "$ADDON_PLUGINS_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Descargar desde GitHub
echo "⬇️  Descargando desde GitHub..."
if command -v wget >/dev/null 2>&1; then
    wget -q "$GITHUB_REPO/archive/refs/heads/main.zip" -O whm-toolkit.zip
elif command -v curl >/dev/null 2>&1; then
    curl -sL "$GITHUB_REPO/archive/refs/heads/main.zip" -o whm-toolkit.zip
else
    echo "❌ Error: Se necesita wget o curl"
    exit 1
fi

unzip -q whm-toolkit.zip
mv whm-toolkit-main/* .

# Instalar archivo principal
echo "📋 Instalando archivo principal..."
cp "whm-toolkit-standalone.cgi" "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
chmod 755 "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
chown root:root "$WHM_CGI_DIR/addon_whm_toolkit.cgi"

# Crear iconos (placeholders)
echo "🎨 Creando iconos..."
# Crear icono simple en base64 (24x24 PNG transparente)
echo "iVBORw0KGgoAAAANSUhEUgAAABgAAAAYCAYAAADgdz34AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAAdgAAAHYBTnsmCAAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAFYSURBVEiJ7ZU9SwNBEIafgwQSCxsLwcJCG1sLG0uxsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLGwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCwsLCw==" | base64 -d > "$ADDON_PLUGINS_DIR/whm_toolkit_24.png"
cp "$ADDON_PLUGINS_DIR/whm_toolkit_24.png" "$ADDON_PLUGINS_DIR/whm_toolkit_32.png"

# Instalar configuración AppConfig
echo "⚙️  Registrando con AppConfig..."
cp "whm_toolkit.conf" "$APPCONFIG_DIR/whm_toolkit.conf"
chmod 644 "$APPCONFIG_DIR/whm_toolkit.conf"

# Registrar con AppConfig
/usr/local/cpanel/bin/register_appconfig "$APPCONFIG_DIR/whm_toolkit.conf"

# Verificar instalación
echo "✅ Verificando instalación..."
if [ -f "$WHM_CGI_DIR/addon_whm_toolkit.cgi" ] && [ -f "$APPCONFIG_DIR/whm_toolkit.conf" ]; then
    echo "   ✅ Archivos instalados correctamente"
else
    echo "   ❌ Error en la instalación"
    exit 1
fi

# Limpiar
rm -rf "$TEMP_DIR"

echo
echo "=========================================="
echo "  ✅ Instalación completada exitosamente"
echo "=========================================="
echo
echo "🎯 El plugin debería aparecer ahora en:"
echo "   WHM → Plugins → WHM Toolkit"
echo
echo "🌐 O accede directamente:"
echo "   https://tu-servidor:2087/cgi/addon_whm_toolkit.cgi"
echo
echo "📚 Documentación:"
echo "   $GITHUB_REPO"
echo