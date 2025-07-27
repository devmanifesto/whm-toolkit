#!/bin/bash

# WHM Toolkit - Script de Diagnóstico
# Verifica por qué el plugin no aparece en el menú de WHM

echo "==========================================="
echo "  Diagnóstico WHM Toolkit Plugin"
echo "==========================================="
echo

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para verificar archivos
check_file() {
    local file="$1"
    local description="$2"
    
    echo -n "🔍 $description: "
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ Existe${NC}"
        ls -la "$file"
        echo
    else
        echo -e "${RED}❌ No existe${NC}"
    fi
}

# Función para verificar directorios
check_dir() {
    local dir="$1"
    local description="$2"
    
    echo -n "📁 $description: "
    if [ -d "$dir" ]; then
        echo -e "${GREEN}✅ Existe${NC}"
        ls -la "$dir"
        echo
    else
        echo -e "${RED}❌ No existe${NC}"
    fi
}

echo "1. VERIFICANDO ARCHIVOS PRINCIPALES"
echo "=================================="
check_file "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" "Archivo principal CGI"
check_file "/var/cpanel/apps/whm_toolkit.conf" "Configuración AppConfig"

echo "2. VERIFICANDO ICONOS"
echo "===================="
check_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png" "Icono 24x24"
check_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png" "Icono 32x32"

echo "3. VERIFICANDO PERMISOS"
echo "======================"
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "🔐 Permisos del archivo CGI:"
    ls -la "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo
fi

echo "4. VERIFICANDO SINTAXIS PERL"
echo "============================"
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "🐪 Verificando sintaxis Perl:"
    perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo
fi

echo "5. VERIFICANDO REGISTRO APPCONFIG"
echo "================================="
echo "📋 Estado de registro AppConfig:"
if /usr/local/cpanel/bin/manage_appconfig --list 2>/dev/null | grep -i whm_toolkit; then
    echo -e "${GREEN}✅ Plugin registrado en AppConfig${NC}"
else
    echo -e "${RED}❌ Plugin NO registrado en AppConfig${NC}"
fi
echo

echo "6. VERIFICANDO CONFIGURACIÓN APPCONFIG"
echo "======================================"
if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "📝 Contenido de whm_toolkit.conf:"
    cat "/var/cpanel/apps/whm_toolkit.conf"
    echo
    
    echo "🔍 Verificando formato AppConfig:"
    /usr/local/cpanel/bin/register_appconfig "/var/cpanel/apps/whm_toolkit.conf" --dry-run 2>&1 || true
    echo
fi

echo "7. VERIFICANDO LOGS DE CPANEL"
echo "============================="
echo "📊 Últimas entradas de logs relacionadas con plugins:"
if [ -f "/usr/local/cpanel/logs/error_log" ]; then
    tail -20 "/usr/local/cpanel/logs/error_log" | grep -i plugin || echo "No hay errores de plugins recientes"
fi
echo

echo "8. VERIFICANDO SERVICIOS"
echo "========================"
echo "🔄 Estado de servicios cPanel/WHM:"
systemctl is-active cpanel 2>/dev/null || service cpanel status 2>/dev/null || echo "Servicio cpanel: Estado desconocido"
systemctl is-active whostmgr 2>/dev/null || service whostmgr status 2>/dev/null || echo "Servicio whostmgr: Estado desconocido"
echo

echo "9. VERIFICANDO ACCESO DIRECTO"
echo "============================="
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "🌐 Probando acceso directo al CGI:"
    cd /usr/local/cpanel/whostmgr/docroot/cgi/
    echo "REQUEST_METHOD=GET" | ./addon_whm_toolkit.cgi 2>&1 | head -10 || echo "Error ejecutando CGI"
    echo
fi

echo "10. VERIFICANDO ESTRUCTURA DE DIRECTORIOS WHM"
echo "============================================="
echo "📂 Estructura de directorios WHM:"
check_dir "/usr/local/cpanel/whostmgr/docroot" "Directorio docroot WHM"
check_dir "/usr/local/cpanel/whostmgr/docroot/cgi" "Directorio CGI"
check_dir "/usr/local/cpanel/whostmgr/docroot/addon_plugins" "Directorio addon_plugins"
check_dir "/var/cpanel/apps" "Directorio apps AppConfig"

echo "11. RECOMENDACIONES"
echo "=================="
echo -e "${BLUE}💡 Para solucionar problemas:${NC}"
echo "1. Reinicia los servicios cPanel/WHM:"
echo "   systemctl restart cpanel whostmgr"
echo "2. Limpia caché de WHM:"
echo "   /usr/local/cpanel/bin/rebuild_whm_menu"
echo "3. Re-registra el plugin:"
echo "   /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf"
echo "4. Verifica logs en tiempo real:"
echo "   tail -f /usr/local/cpanel/logs/error_log"
echo

echo "==========================================="
echo "  Diagnóstico completado"
echo "===========================================" 