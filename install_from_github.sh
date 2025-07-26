#!/bin/bash

# WHM Toolkit - Instalador desde GitHub
# Repositorio: https://github.com/devmanifesto/whm-toolkit

set -e  # Salir si hay algún error

PLUGIN_NAME="WHM Toolkit"
PLUGIN_VERSION="1.0.0"
GITHUB_REPO="https://github.com/devmanifesto/whm-toolkit"
TEMP_DIR="/tmp/whm-toolkit-install"
INSTALL_DIR="/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit"

echo "=========================================="
echo "  Instalación de $PLUGIN_NAME v$PLUGIN_VERSION"
echo "  Desde: $GITHUB_REPO"
echo "=========================================="
echo

# Verificar que estamos ejecutando como root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Este script debe ejecutarse como root"
    echo "   Ejecuta: sudo $0"
    exit 1
fi

# Verificar comandos necesarios
echo "🔍 Verificando dependencias..."
for cmd in wget curl git; do
    if command -v $cmd >/dev/null 2>&1; then
        DOWNLOAD_CMD=$cmd
        echo "   ✅ $cmd encontrado"
        break
    fi
done

if [ -z "$DOWNLOAD_CMD" ]; then
    echo "❌ Error: Se necesita wget, curl o git para descargar el plugin"
    exit 1
fi

# Limpiar instalación anterior si existe
if [ -d "$TEMP_DIR" ]; then
    echo "🧹 Limpiando directorio temporal anterior..."
    rm -rf "$TEMP_DIR"
fi

# Crear directorio temporal
echo "📁 Creando directorio temporal..."
mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

# Descargar el repositorio
echo "⬇️  Descargando plugin desde GitHub..."
if [ "$DOWNLOAD_CMD" = "git" ]; then
    git clone "$GITHUB_REPO.git" .
elif [ "$DOWNLOAD_CMD" = "wget" ]; then
    wget -q "$GITHUB_REPO/archive/refs/heads/main.zip" -O whm-toolkit.zip
    unzip -q whm-toolkit.zip
    mv whm-toolkit-main/* .
    rm -rf whm-toolkit-main whm-toolkit.zip
elif [ "$DOWNLOAD_CMD" = "curl" ]; then
    curl -sL "$GITHUB_REPO/archive/refs/heads/main.zip" -o whm-toolkit.zip
    unzip -q whm-toolkit.zip
    mv whm-toolkit-main/* .
    rm -rf whm-toolkit-main whm-toolkit.zip
fi

echo "   ✅ Descarga completada"

# Verificar que tenemos el archivo principal
if [ ! -f "whm-toolkit-standalone.cgi" ]; then
    echo "❌ Error: No se encontró el archivo principal del plugin"
    echo "   Verifica que el repositorio contenga whm-toolkit-standalone.cgi"
    exit 1
fi

# Crear directorio de instalación
echo "📂 Creando directorio de instalación..."
mkdir -p "$INSTALL_DIR"

# Instalar archivo principal
echo "📋 Instalando archivos del plugin..."
cp "whm-toolkit-standalone.cgi" "$INSTALL_DIR/index.cgi"
chmod 755 "$INSTALL_DIR/index.cgi"
echo "   ✅ Archivo principal instalado"

# Copiar archivos adicionales si existen
if [ -f "whm-toolkit.conf" ]; then
    cp "whm-toolkit.conf" "$INSTALL_DIR/"
    echo "   ✅ Archivo de configuración copiado"
fi

# Crear archivo .htaccess
echo "🔧 Configurando servidor web..."
cat > "$INSTALL_DIR/.htaccess" << 'EOF'
Options +ExecCGI
AddHandler cgi-script .cgi
DirectoryIndex index.cgi
EOF
echo "   ✅ Configuración web creada"

# Configurar permisos
echo "🔐 Configurando permisos..."
chown -R root:root "$INSTALL_DIR"
chmod -R 755 "$INSTALL_DIR"
echo "   ✅ Permisos configurados"

# Verificar sintaxis
echo "✅ Verificando instalación..."
if perl -c "$INSTALL_DIR/index.cgi" >/dev/null 2>&1; then
    echo "   ✅ Sintaxis del plugin correcta"
else
    echo "   ⚠️  Advertencia: Posibles problemas de sintaxis"
fi

# Limpiar archivos temporales
echo "🧹 Limpiando archivos temporales..."
rm -rf "$TEMP_DIR"

# Obtener información del servidor
SERVER_IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "TU-IP-SERVIDOR")

echo
echo "=========================================="
echo "  ✅ ¡Instalación completada exitosamente!"
echo "=========================================="
echo
echo "📍 Plugin instalado en:"
echo "   $INSTALL_DIR"
echo
echo "🌐 Accede al plugin usando:"
echo "   https://$SERVER_IP:2087/whostmgr/docroot/cgi/whm-toolkit/"
echo
echo "🔧 Para probar el plugin:"
echo "   1. Inicia sesión en WHM"
echo "   2. Abre la URL anterior en tu navegador"
echo "   3. Deberías ver la interfaz del plugin"
echo "   4. Haz clic en 'Hello World' para probar"
echo
echo "📚 Documentación completa:"
echo "   $GITHUB_REPO"
echo
echo "🐛 Si encuentras problemas, revisa los logs:"
echo "   tail -f /usr/local/cpanel/logs/error_log"
echo 