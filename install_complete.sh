#!/bin/bash

# WHM Toolkit - Instalación Completa
# Garantiza que todos los archivos estén correctamente instalados

set -e

PLUGIN_NAME="WHM Toolkit"
PLUGIN_VERSION="1.0.0"
GITHUB_REPO="https://github.com/devmanifesto/whm-toolkit"

# Directorios oficiales según documentación cPanel
WHM_CGI_DIR="/usr/local/cpanel/whostmgr/docroot/cgi"
ADDON_PLUGINS_DIR="/usr/local/cpanel/whostmgr/docroot/addon_plugins"
APPCONFIG_DIR="/var/cpanel/apps"
TEMP_DIR="/tmp/whm-toolkit-complete-install"

echo "==========================================="
echo "  Instalación Completa de $PLUGIN_NAME"
echo "  Reinstalación desde cero"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🧹 Etapa 1: Limpieza completa..."
# Desregistrar cualquier versión anterior
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true

# Eliminar todos los archivos relacionados
rm -rf "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
rm -rf "$ADDON_PLUGINS_DIR/whm_toolkit_*.png"
rm -rf "$APPCONFIG_DIR/whm_toolkit.conf"
rm -rf "$APPCONFIG_DIR/WHM_Toolkit.conf"
rm -rf "$TEMP_DIR"

echo "📁 Etapa 2: Creando directorios..."
mkdir -p "$ADDON_PLUGINS_DIR"
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "⬇️  Etapa 3: Descargando desde GitHub..."
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

echo "📋 Etapa 4: Verificando archivos descargados..."
echo "   Archivos disponibles:"
ls -la *.cgi *.conf 2>/dev/null || echo "   ⚠️  Algunos archivos pueden no estar disponibles"

echo "📋 Etapa 5: Instalando archivo CGI..."
# Priorizar la versión híbrida
if [ -f "whm-toolkit-hybrid.cgi" ]; then
    echo "   ✅ Usando versión híbrida (recomendada)"
    cp "whm-toolkit-hybrid.cgi" "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
elif [ -f "whm-toolkit-integrated.cgi" ]; then
    echo "   ✅ Usando versión integrada"
    cp "whm-toolkit-integrated.cgi" "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
elif [ -f "whm-toolkit-standalone.cgi" ]; then
    echo "   ✅ Usando versión standalone"
    cp "whm-toolkit-standalone.cgi" "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
else
    echo "   ❌ Error: No se encontró ningún archivo CGI"
    exit 1
fi

chmod 755 "$WHM_CGI_DIR/addon_whm_toolkit.cgi"
chown root:root "$WHM_CGI_DIR/addon_whm_toolkit.cgi"

echo "🎨 Etapa 6: Creando iconos..."
# Crear iconos simples usando printf (más compatible)
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x18\x00\x00\x00\x18\x08\x06\x00\x00\x00\xe0w=\xf8\x00\x00\x00\tpHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9b\xee<\x1a\x00\x00\x00\rIDAT8\x8d\x63\x00\x01\x00\x00\x05\x00\x01\r\n-\xdb\x00\x00\x00\x00IEND\xaeB`\x82' > "$ADDON_PLUGINS_DIR/whm_toolkit_24.png"
cp "$ADDON_PLUGINS_DIR/whm_toolkit_24.png" "$ADDON_PLUGINS_DIR/whm_toolkit_32.png"

echo "📝 Etapa 7: Creando configuración AppConfig..."
# Crear el archivo de configuración directamente si no existe
if [ ! -f "whm_toolkit.conf" ]; then
    echo "   Creando whm_toolkit.conf desde cero..."
    cat > "$APPCONFIG_DIR/whm_toolkit.conf" << 'EOF'
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas útiles para administración de WHM
description=Un conjunto completo de herramientas para administradores de sistemas que utilizan WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr

[app]
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas útiles para administración de WHM
description=Un conjunto completo de herramientas para administradores de sistemas que utilizan WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr

[script]
type=whm
target=/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
url=cgi/addon_whm_toolkit.cgi

[icon]
24x24=/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png
32x32=/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png

[acl]
reseller=1
all=1

[features]
whm_toolkit=1

[group]
Plugins

[category]
system_administration
EOF
else
    echo "   Copiando whm_toolkit.conf existente..."
    cp "whm_toolkit.conf" "$APPCONFIG_DIR/whm_toolkit.conf"
fi

chmod 644 "$APPCONFIG_DIR/whm_toolkit.conf"
chown root:root "$APPCONFIG_DIR/whm_toolkit.conf"

echo "⚙️  Etapa 8: Registrando con AppConfig..."
/usr/local/cpanel/bin/register_appconfig "$APPCONFIG_DIR/whm_toolkit.conf"
sleep 2
/usr/local/cpanel/bin/register_appconfig "$APPCONFIG_DIR/whm_toolkit.conf"

echo "🔄 Etapa 9: Reiniciando servicios..."
if [ -f "/scripts/restartsrv_cpanel" ]; then
    echo "   Reiniciando cPanel..."
    /scripts/restartsrv_cpanel --wait
fi

if [ -f "/scripts/restartsrv_httpd" ]; then
    echo "   Reiniciando Apache..."
    /scripts/restartsrv_httpd --wait
fi

echo "✅ Etapa 10: Verificación final..."
echo "📋 Archivos instalados:"
echo "   CGI: $(ls -la $WHM_CGI_DIR/addon_whm_toolkit.cgi 2>/dev/null && echo "✅" || echo "❌")"
echo "   Config: $(ls -la $APPCONFIG_DIR/whm_toolkit.conf 2>/dev/null && echo "✅" || echo "❌")"
echo "   Iconos: $(ls -la $ADDON_PLUGINS_DIR/whm_toolkit_*.png 2>/dev/null | wc -l) archivos"

echo "🧪 Probando sintaxis del CGI..."
if perl -c "$WHM_CGI_DIR/addon_whm_toolkit.cgi" 2>/dev/null; then
    echo "   ✅ Sintaxis Perl correcta"
else
    echo "   ⚠️  Advertencia: Problemas de sintaxis detectados"
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
echo "🌐 Acceso directo garantizado:"
echo "   https://$SERVER_IP:2087/cgi/addon_whm_toolkit.cgi"
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