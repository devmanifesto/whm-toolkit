#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit v3.0 - Diagnóstico Avanzado"
echo "==========================================="
echo

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Función para verificar archivos
check_file() {
    local file="$1"
    local description="$2"
    
    echo -n "🔍 $description: "
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ Existe${NC}"
        ls -la "$file"
        echo
        return 0
    else
        echo -e "${RED}❌ No existe${NC}"
        return 1
    fi
}

# Función para verificar permisos
check_permissions() {
    local file="$1"
    local expected="$2"
    
    if [ -f "$file" ]; then
        local actual=$(stat -c "%a" "$file" 2>/dev/null)
        if [ "$actual" = "$expected" ]; then
            echo -e "   ${GREEN}✅ Permisos correctos ($actual)${NC}"
        else
            echo -e "   ${YELLOW}⚠️ Permisos incorrectos: $actual (esperado: $expected)${NC}"
            echo -e "   ${BLUE}💡 Corregir con: chmod $expected $file${NC}"
        fi
    fi
}

# Función para verificar ownership
check_ownership() {
    local file="$1"
    
    if [ -f "$file" ]; then
        local owner=$(stat -c "%U:%G" "$file" 2>/dev/null)
        if [ "$owner" = "root:root" ]; then
            echo -e "   ${GREEN}✅ Ownership correcto ($owner)${NC}"
        else
            echo -e "   ${YELLOW}⚠️ Ownership incorrecto: $owner (esperado: root:root)${NC}"
            echo -e "   ${BLUE}💡 Corregir con: chown root:root $file${NC}"
        fi
    fi
}

echo "1. VERIFICACIÓN DE ARCHIVOS PRINCIPALES"
echo "======================================="
check_file "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" "Plugin CGI principal"
check_permissions "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" "755"
check_ownership "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"

check_file "/var/cpanel/apps/whm_toolkit.conf" "Configuración AppConfig"
check_permissions "/var/cpanel/apps/whm_toolkit.conf" "644"
check_ownership "/var/cpanel/apps/whm_toolkit.conf"

echo "2. VERIFICACIÓN DE ICONOS"
echo "========================"
check_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png" "Icono 24x24"
check_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png" "Icono 32x32"

echo "3. VERIFICACIÓN DE SINTAXIS PERL"
echo "================================"
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "🐪 Verificando sintaxis Perl:"
    if perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" 2>&1; then
        echo -e "${GREEN}✅ Sintaxis correcta${NC}"
    else
        echo -e "${RED}❌ Error de sintaxis${NC}"
        echo -e "${BLUE}💡 Revisar el código Perl del plugin${NC}"
    fi
    echo
fi

echo "4. VERIFICACIÓN DE MÓDULOS PERL"
echo "==============================="
echo "🐪 Verificando módulos Perl requeridos:"

# Verificar CGI
if perl -MCGI -e 'print "CGI module OK\n"' 2>/dev/null; then
    echo -e "   ${GREEN}✅ CGI module disponible${NC}"
else
    echo -e "   ${RED}❌ CGI module NO disponible${NC}"
    echo -e "   ${BLUE}💡 Instalar con: yum install perl-CGI o cpan CGI${NC}"
fi

# Verificar strict y warnings (siempre disponibles)
echo -e "   ${GREEN}✅ strict y warnings disponibles${NC}"

echo

echo "5. VERIFICACIÓN DE REGISTRO APPCONFIG"
echo "====================================="
echo "📋 Verificando registro en AppConfig:"
if /usr/local/cpanel/bin/manage_appconfig --list 2>/dev/null | grep -i "WHM_Toolkit"; then
    echo -e "${GREEN}✅ Plugin registrado correctamente${NC}"
else
    echo -e "${RED}❌ Plugin NO registrado${NC}"
    echo -e "${BLUE}💡 Re-registrar con: /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf${NC}"
fi
echo

echo "6. VERIFICACIÓN DE CONFIGURACIÓN"
echo "================================"
if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "📝 Contenido de la configuración:"
    cat "/var/cpanel/apps/whm_toolkit.conf"
    echo
    
    echo "🔍 Validando formato AppConfig:"
    if /usr/local/cpanel/bin/register_appconfig "/var/cpanel/apps/whm_toolkit.conf" --dry-run 2>&1; then
        echo -e "${GREEN}✅ Formato correcto${NC}"
    else
        echo -e "${RED}❌ Formato incorrecto${NC}"
        echo -e "${BLUE}💡 Revisar la sintaxis del archivo de configuración${NC}"
    fi
    echo
fi

echo "7. PRUEBA DE EJECUCIÓN DIRECTA"
echo "=============================="
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "🌐 Probando ejecución directa del CGI:"
    cd "/usr/local/cpanel/whostmgr/docroot/cgi/"
    
    # Crear un entorno mínimo para la prueba
    export REQUEST_METHOD="GET"
    export QUERY_STRING=""
    export HTTP_HOST="localhost"
    export SERVER_SOFTWARE="Apache"
    
    if timeout 10 ./addon_whm_toolkit.cgi 2>&1 | head -10; then
        echo -e "${GREEN}✅ CGI ejecuta correctamente${NC}"
    else
        echo -e "${RED}❌ Error ejecutando CGI${NC}"
        echo -e "${BLUE}💡 Revisar logs de error para más detalles${NC}"
    fi
    echo
fi

echo "8. VERIFICACIÓN DE SERVICIOS"
echo "============================"
echo "🔄 Estado de servicios:"

# Verificar cPanel
if systemctl is-active cpanel >/dev/null 2>&1; then
    echo -e "   cPanel: ${GREEN}✅ Activo${NC}"
elif service cpanel status >/dev/null 2>&1; then
    echo -e "   cPanel: ${GREEN}✅ Activo (SysV)${NC}"
else
    echo -e "   cPanel: ${RED}❌ Inactivo${NC}"
    echo -e "   ${BLUE}💡 Reiniciar con: systemctl restart cpanel${NC}"
fi

# Verificar Apache
if systemctl is-active httpd >/dev/null 2>&1; then
    echo -e "   Apache: ${GREEN}✅ Activo${NC}"
elif systemctl is-active apache2 >/dev/null 2>&1; then
    echo -e "   Apache: ${GREEN}✅ Activo${NC}"
elif service httpd status >/dev/null 2>&1; then
    echo -e "   Apache: ${GREEN}✅ Activo (SysV)${NC}"
else
    echo -e "   Apache: ${RED}❌ Inactivo${NC}"
    echo -e "   ${BLUE}💡 Reiniciar con: systemctl restart httpd${NC}"
fi

echo

echo "9. VERIFICACIÓN DE LOGS"
echo "======================="
echo "📊 Últimos errores relacionados con plugins:"
if [ -f "/usr/local/cpanel/logs/error_log" ]; then
    RECENT_ERRORS=$(tail -50 "/usr/local/cpanel/logs/error_log" | grep -i -E "(plugin|whm_toolkit|appconfig|addon_whm_toolkit)" | tail -10)
    if [ -n "$RECENT_ERRORS" ]; then
        echo "$RECENT_ERRORS"
    else
        echo -e "${GREEN}✅ No hay errores recientes relacionados${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ Log de errores no encontrado${NC}"
fi
echo

echo "10. INFORMACIÓN DEL SISTEMA"
echo "=========================="
echo "🖥️ Información del servidor:"
echo "   Hostname: $(hostname)"
echo "   cPanel Version: $(cat /usr/local/cpanel/version 2>/dev/null || echo 'No disponible')"
echo "   Perl Version: $(perl -v | grep 'This is perl' | cut -d'(' -f1 || echo 'No disponible')"
echo "   Sistema: $(uname -a)"
echo "   Fecha actual: $(date)"
echo

# Obtener IP del servidor
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

echo "11. PRUEBAS DE CONECTIVIDAD"
echo "=========================="
echo "🌐 Probando acceso HTTP al plugin:"

# Probar acceso local
if command -v curl >/dev/null 2>&1; then
    echo "   🔍 Probando con curl..."
    if curl -k -s --max-time 10 "https://localhost:2087/cgi/addon_whm_toolkit.cgi" | head -5 | grep -q "WHM Toolkit"; then
        echo -e "   ${GREEN}✅ Plugin responde correctamente${NC}"
    else
        echo -e "   ${YELLOW}⚠️ Plugin no responde o respuesta inesperada${NC}"
    fi
else
    echo -e "   ${YELLOW}⚠️ curl no disponible para pruebas${NC}"
fi
echo

echo "12. RECOMENDACIONES Y SOLUCIONES"
echo "================================"
echo -e "${BLUE}💡 URLs de acceso:${NC}"
echo "   📋 Menú WHM: WHM → Plugins → WHM_Toolkit"
echo "   🌐 URL Directa: https://$SERVER_IP:2087/cgi/addon_whm_toolkit.cgi"
echo
echo -e "${BLUE}🔧 Si el plugin no aparece en el menú:${NC}"
echo "   1. Reiniciar servicios: systemctl restart cpanel httpd"
echo "   2. Reconstruir menú: /usr/local/cpanel/bin/rebuild_whm_menu"
echo "   3. Re-registrar: /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf"
echo "   4. Limpiar caché del navegador (Ctrl+F5)"
echo "   5. Cerrar sesión y volver a iniciar en WHM"
echo "   6. Esperar 2-3 minutos para que WHM actualice"
echo
echo -e "${BLUE}🐛 Si hay errores 500:${NC}"
echo "   1. Verificar sintaxis: perl -c /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
echo "   2. Revisar permisos: chmod 755 /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
echo "   3. Verificar ownership: chown root:root /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
echo "   4. Revisar logs: tail -f /usr/local/cpanel/logs/error_log"
echo
echo -e "${BLUE}📋 Comandos útiles:${NC}"
echo "   • Listar plugins: /usr/local/cpanel/bin/manage_appconfig --list"
echo "   • Probar configuración: /usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf --dry-run"
echo "   • Ver logs en tiempo real: tail -f /usr/local/cpanel/logs/error_log"
echo "   • Reiniciar todo: /scripts/restartsrv_cpanel && /scripts/restartsrv_httpd"
echo

echo "13. RESUMEN FINAL"
echo "================"

# Contar problemas encontrados
ISSUES=0

# Verificar archivos críticos
[ ! -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ] && ISSUES=$((ISSUES + 1))
[ ! -f "/var/cpanel/apps/whm_toolkit.conf" ] && ISSUES=$((ISSUES + 1))

# Verificar registro
if ! /usr/local/cpanel/bin/manage_appconfig --list 2>/dev/null | grep -q "WHM_Toolkit"; then
    ISSUES=$((ISSUES + 1))
fi

# Verificar sintaxis
if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    if ! perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" >/dev/null 2>&1; then
        ISSUES=$((ISSUES + 1))
    fi
fi

if [ $ISSUES -eq 0 ]; then
    echo -e "${GREEN}✅ DIAGNÓSTICO: Todo parece estar correcto${NC}"
    echo -e "${GREEN}   El plugin debería aparecer en el menú de WHM${NC}"
    echo -e "${GREEN}   Si no aparece, intenta refrescar la página (Ctrl+F5)${NC}"
else
    echo -e "${RED}❌ DIAGNÓSTICO: Se encontraron $ISSUES problemas${NC}"
    echo -e "${YELLOW}   Revisa las recomendaciones anteriores para solucionarlos${NC}"
fi

echo
echo "==========================================="
echo "  Diagnóstico completado"
echo "==========================================="