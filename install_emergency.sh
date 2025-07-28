#!/bin/bash

# WHM Toolkit - Instalador de Emergencia
# Versión corregida y probada

set -e

PLUGIN_NAME="WHM Toolkit"
PLUGIN_VERSION="1.0.0"
GITHUB_REPO="https://github.com/devmanifesto/whm-toolkit"

# Directorios oficiales según estructura real de plugins WHM
ADDONFEATURES_DIR="/usr/local/cpanel/whostmgr/addonfeatures"
PLUGIN_DIR="$ADDONFEATURES_DIR/whm-toolkit"
APPCONFIG_DIR="/var/cpanel/apps"
TEMP_DIR="/tmp/whm-toolkit-emergency-install"

echo "==========================================="
echo "  Instalador de Emergencia - $PLUGIN_NAME"
echo "  Estructura oficial de plugins WHM"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🧹 Limpieza completa de instalaciones previas..."

# Desregistrar TODAS las versiones anteriores posibles
echo "   Desregistrando versiones anteriores..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig whm-toolkit 2>/dev/null || true

# Eliminar TODOS los directorios y archivos posibles de versiones anteriores
echo "   Eliminando archivos de versiones anteriores..."
rm -rf "$PLUGIN_DIR"
rm -rf "$TEMP_DIR"
rm -rf "/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit"
rm -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
rm -f "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_"*.png
rm -f "/var/cpanel/apps/whm_toolkit.conf"
rm -f "/var/cpanel/apps/WHM_Toolkit.conf"
rm -f "/var/cpanel/apps/whm-toolkit.conf"

# Limpiar entradas de configuraciones anteriores
echo "   Limpiando configuraciones anteriores..."
if [ -f "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf" ]; then
    sed -i '/whm.toolkit/d' /usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf 2>/dev/null || true
    sed -i '/WHM.Toolkit/d' /usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf 2>/dev/null || true
fi

echo "📁 Creando estructura de directorios..."
mkdir -p "$PLUGIN_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

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

echo "📋 Instalando archivos del plugin..."
# Instalar archivo principal
if [ -f "whm-toolkit.cgi" ]; then
    echo "   ✅ Instalando whm-toolkit.cgi..."
    cp "whm-toolkit.cgi" "$PLUGIN_DIR/"
    chmod 755 "$PLUGIN_DIR/whm-toolkit.cgi"
    chown root:root "$PLUGIN_DIR/whm-toolkit.cgi"
else
    echo "   ❌ Error: No se encontró whm-toolkit.cgi"
    exit 1
fi

# Instalar configuración del plugin
if [ -f "whm-toolkit.conf" ]; then
    echo "   ✅ Instalando whm-toolkit.conf..."
    cp "whm-toolkit.conf" "$PLUGIN_DIR/"
    chmod 644 "$PLUGIN_DIR/whm-toolkit.conf"
    chown root:root "$PLUGIN_DIR/whm-toolkit.conf"
else
    echo "   ❌ Error: No se encontró whm-toolkit.conf"
    exit 1
fi

echo "🎨 Creando iconos..."
# Crear icono 24x24
echo "   Creando icon_24.png..."
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x18\x00\x00\x00\x18\x08\x06\x00\x00\x00\xe0w=\xf8\x00\x00\x00\tpHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9b\xee<\x1a\x00\x00\x00\rIDAT8\x8d\x63\x00\x01\x00\x00\x05\x00\x01\r\n-\xdb\x00\x00\x00\x00IEND\xaeB`\x82' > "$PLUGIN_DIR/icon_24.png"

# Crear icono 32x32
echo "   Creando icon_32.png..."
cp "$PLUGIN_DIR/icon_24.png" "$PLUGIN_DIR/icon_32.png"

# Establecer permisos de iconos
echo "   Estableciendo permisos de iconos..."
chmod 644 "$PLUGIN_DIR/icon_24.png"
chmod 644 "$PLUGIN_DIR/icon_32.png"
chown root:root "$PLUGIN_DIR/icon_24.png"
chown root:root "$PLUGIN_DIR/icon_32.png"

echo "📝 Instalando configuración AppConfig..."
# Copiar configuración AppConfig al directorio oficial
cp "whm-toolkit.conf" "$APPCONFIG_DIR/whm_toolkit.conf"
chmod 644 "$APPCONFIG_DIR/whm_toolkit.conf"
chown root:root "$APPCONFIG_DIR/whm_toolkit.conf"

echo "⚙️  Registrando con AppConfig..."
/usr/local/cpanel/bin/register_appconfig "$APPCONFIG_DIR/whm_toolkit.conf"
sleep 2

echo "🔄 Reiniciando servicios..."
if [ -f "/scripts/restartsrv_cpanel" ]; then
    echo "   Reiniciando cPanel..."
    /scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true
fi

if [ -f "/scripts/restartsrv_httpd" ]; then
    echo "   Reiniciando Apache..."
    /scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true
fi

echo "✅ Verificación final..."
echo "📋 Archivos instalados:"

# Verificar archivos uno por uno
if [ -f "$PLUGIN_DIR/whm-toolkit.cgi" ]; then
    echo "   Plugin CGI: ✅"
else
    echo "   Plugin CGI: ❌"
    exit 1
fi

if [ -f "$PLUGIN_DIR/whm-toolkit.conf" ]; then
    echo "   Plugin Config: ✅"
else
    echo "   Plugin Config: ❌"
    exit 1
fi

if [ -f "$APPCONFIG_DIR/whm_toolkit.conf" ]; then
    echo "   AppConfig: ✅"
else
    echo "   AppConfig: ❌"
    exit 1
fi

# Verificar iconos
ICON_COUNT=0
if [ -f "$PLUGIN_DIR/icon_24.png" ]; then
    ICON_COUNT=$((ICON_COUNT + 1))
fi
if [ -f "$PLUGIN_DIR/icon_32.png" ]; then
    ICON_COUNT=$((ICON_COUNT + 1))
fi
echo "   Iconos: $ICON_COUNT/2 archivos"

echo "🧪 Probando sintaxis del CGI..."
if perl -c "$PLUGIN_DIR/whm-toolkit.cgi" >/dev/null 2>&1; then
    echo "   ✅ Sintaxis Perl correcta"
else
    echo "   ❌ Error de sintaxis Perl"
    exit 1
fi

# Limpiar archivos temporales
cd /
rm -rf "$TEMP_DIR"

SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "tu-servidor")

echo
echo "==========================================="
echo "  ✅ Instalación completada exitosamente"
echo "==========================================="
echo
echo "🎯 El plugin debería aparecer en:"
echo "   WHM → Plugins → WHM_Toolkit"
echo
echo "🌐 Acceso directo:"
echo "   https://$SERVER_IP:2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo
echo "📁 Estructura instalada:"
echo "   $PLUGIN_DIR/"
echo "   ├── whm-toolkit.cgi"
echo "   ├── whm-toolkit.conf"
echo "   ├── icon_24.png"
echo "   └── icon_32.png"
echo
echo "💡 Pasos adicionales:"
echo "1. Cierra completamente tu navegador"
echo "2. Limpia la caché del navegador"
echo "3. Espera 2-3 minutos"
echo "4. Abre WHM en una ventana nueva"
echo "5. Ve a Plugins en el menú lateral"
echo
echo "📚 Documentación:"
echo "   $GITHUB_REPO"
echo
echo "===========================================" 