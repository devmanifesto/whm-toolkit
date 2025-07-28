#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit v3.0 - Instalación desde Git"
echo "  Instalación rápida y automatizada"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Verificar Git
if ! command -v git >/dev/null 2>&1; then
    echo "❌ Error: Git no está instalado"
    echo "💡 Instalar con: yum install git -y"
    exit 1
fi

# Verificar cPanel/WHM
if [ ! -d "/usr/local/cpanel" ]; then
    echo "❌ Error: cPanel/WHM no está instalado"
    exit 1
fi

echo "📥 Descargando WHM Toolkit desde GitHub..."

# Limpiar directorio temporal si existe
rm -rf /tmp/whm-toolkit

# Clonar repositorio
cd /tmp
if git clone https://github.com/devmanifesto/whm-toolkit.git; then
    echo "   ✅ Repositorio clonado exitosamente"
else
    echo "   ❌ Error clonando repositorio"
    echo "   💡 Verificar conexión a internet y URL del repositorio"
    exit 1
fi

# Cambiar al directorio del proyecto
cd whm-toolkit

echo "🔍 Verificando archivos descargados..."

# Verificar archivos necesarios
REQUIRED_FILES=(
    "whm-toolkit-final.cgi"
    "whm-toolkit-final.conf"
    "install-whm-toolkit-final.sh"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file encontrado"
    else
        echo "   ❌ $file no encontrado"
        exit 1
    fi
done

echo "🚀 Ejecutando instalación..."

# Hacer ejecutable el script de instalación
chmod +x install-whm-toolkit-final.sh

# Ejecutar instalación
if ./install-whm-toolkit-final.sh; then
    echo
    echo "==========================================="
    echo "  ✅ INSTALACIÓN DESDE GIT COMPLETADA"
    echo "==========================================="
    echo
    echo "🎯 El plugin está disponible en:"
    echo "   📋 Menú WHM: Plugins → WHM_Toolkit"
    echo "   🌐 URL: https://$(hostname -I | awk '{print $1}'):2087/cgi/addon_whm_toolkit.cgi"
    echo
    echo "🛠️ Scripts disponibles en /tmp/whm-toolkit/:"
    echo "   • diagnose-whm-toolkit-final.sh (diagnóstico)"
    echo "   • uninstall-whm-toolkit-final.sh (desinstalación)"
    echo
    echo "📋 Si el plugin no aparece:"
    echo "   1. Espera 2-3 minutos"
    echo "   2. Refresca WHM (Ctrl+F5)"
    echo "   3. Ejecuta: cd /tmp/whm-toolkit && ./diagnose-whm-toolkit-final.sh"
    echo
    echo "==========================================="
else
    echo
    echo "==========================================="
    echo "  ❌ ERROR EN LA INSTALACIÓN"
    echo "==========================================="
    echo
    echo "🔧 Para diagnosticar el problema:"
    echo "   cd /tmp/whm-toolkit"
    echo "   ./diagnose-whm-toolkit-final.sh"
    echo
    echo "📞 Para soporte:"
    echo "   https://github.com/devmanifesto/whm-toolkit/issues"
    echo
    echo "==========================================="
    exit 1
fi