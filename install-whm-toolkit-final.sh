#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit v3.0 - Instalador Final"
echo "  Versión optimizada y completamente funcional"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Verificar cPanel/WHM
if [ ! -d "/usr/local/cpanel" ]; then
    echo "❌ Error: cPanel/WHM no está instalado"
    exit 1
fi

echo "🔍 Verificando dependencias de Perl..."

# Verificar si CGI.pm está disponible
if ! perl -MCGI -e 'print "CGI module OK\n"' >/dev/null 2>&1; then
    echo "   ⚠️ Módulo CGI de Perl no encontrado"
    echo "   📦 Instalando módulo CGI..."
    
    # Intentar instalar CGI usando diferentes métodos
    if command -v yum >/dev/null 2>&1; then
        yum install -y perl-CGI >/dev/null 2>&1 || true
    elif command -v dnf >/dev/null 2>&1; then
        dnf install -y perl-CGI >/dev/null 2>&1 || true
    elif command -v apt-get >/dev/null 2>&1; then
        apt-get update >/dev/null 2>&1 && apt-get install -y libcgi-pm-perl >/dev/null 2>&1 || true
    fi
    
    # Verificar nuevamente
    if perl -MCGI -e 'print "CGI module OK\n"' >/dev/null 2>&1; then
        echo "   ✅ Módulo CGI instalado exitosamente"
    else
        echo "   ⚠️ No se pudo instalar automáticamente el módulo CGI"
        echo "   💡 Instalando usando CPAN..."
        echo "yes" | cpan CGI >/dev/null 2>&1 || true
        
        # Verificación final
        if perl -MCGI -e 'print "CGI module OK\n"' >/dev/null 2>&1; then
            echo "   ✅ Módulo CGI instalado via CPAN"
        else
            echo "   ❌ Error: No se pudo instalar el módulo CGI"
            echo "   🔧 Instalar manualmente con:"
            echo "      yum install perl-CGI -y"
            echo "      o"
            echo "      cpan CGI"
            exit 1
        fi
    fi
else
    echo "   ✅ Módulo CGI de Perl disponible"
fi

echo "🧹 Limpieza completa de versiones anteriores..."

# Desregistrar todas las versiones posibles
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit_v2 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit_v2 2>/dev/null || true

# Eliminar archivos anteriores
rm -rf "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
rm -rf "/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit"
rm -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
rm -f "/var/cpanel/apps/whm_toolkit.conf"
rm -f "/var/cpanel/apps/whm_toolkit_v2.conf"
rm -f "/var/cpanel/apps/WHM_Toolkit.conf"

echo "📁 Creando estructura optimizada..."

# Crear directorios necesarios
mkdir -p "/usr/local/cpanel/whostmgr/docroot/addon_plugins"

echo "📋 Creando plugin principal optimizado..."

# Verificar si el archivo CGI existe en el directorio actual
if [ -f "./whm-toolkit-final.cgi" ]; then
    cp "./whm-toolkit-final.cgi" "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo "   ✅ Plugin copiado desde archivo local"
elif [ -f "/tmp/whm-toolkit-final.cgi" ]; then
    cp "/tmp/whm-toolkit-final.cgi" "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo "   ✅ Plugin copiado desde /tmp/"
else
    echo "   ❌ Error: No se encontró whm-toolkit-final.cgi"
    echo "   📋 Asegúrate de que el archivo esté en el directorio actual o en /tmp/"
    exit 1
fi

echo "📝 Creando configuración AppConfig optimizada..."

# Verificar si el archivo de configuración existe
if [ -f "./whm-toolkit-final.conf" ]; then
    cp "./whm-toolkit-final.conf" "/var/cpanel/apps/whm_toolkit.conf"
    echo "   ✅ Configuración copiada desde archivo local"
elif [ -f "/tmp/whm-toolkit-final.conf" ]; then
    cp "/tmp/whm-toolkit-final.conf" "/var/cpanel/apps/whm_toolkit.conf"
    echo "   ✅ Configuración copiada desde /tmp/"
else
    # Crear configuración directamente si no existe el archivo
    cat > "/var/cpanel/apps/whm_toolkit.conf" << 'CONFIG_EOF'
name=WHM_Toolkit
version=3.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas avanzadas para administración de WHM
description=Plugin optimizado con estructura correcta y funcional para WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr

[app]
name=WHM_Toolkit
version=3.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas avanzadas para administración de WHM
description=Plugin optimizado con estructura correcta y funcional para WHM
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
CONFIG_EOF
    echo "   ✅ Configuración creada directamente"
fi

echo "🎨 Creando iconos optimizados..."
# Crear iconos PNG básicos pero válidos (24x24)
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x18\x00\x00\x00\x18\x08\x06\x00\x00\x00\xe0w=\xf8\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9b\xee<\x1a\x00\x00\x01\x00IDAT8\x8d\x63\xf8\x0f\x00\x01\x01\x01\x00\x18\xdd\x8d\xb4\x00\x00\x00\x00IEND\xaeB`\x82' > "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png"

# Crear icono 32x32
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00 \x00\x00\x00 \x08\x06\x00\x00\x00szz\xf4\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9b\xee<\x1a\x00\x00\x01\x00IDAT8\x8d\x63\xf8\x0f\x00\x01\x01\x01\x00\x18\xdd\x8d\xb4\x00\x00\x00\x00IEND\xaeB`\x82' > "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png"

echo "⚙️ Estableciendo permisos correctos..."
chmod 755 "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
chmod 644 "/var/cpanel/apps/whm_toolkit.conf"
chmod 644 "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png"
chmod 644 "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png"

chown root:root "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
chown root:root "/var/cpanel/apps/whm_toolkit.conf"
chown root:root "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png"
chown root:root "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png"

echo "🧪 Verificando sintaxis del plugin..."
if perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" >/dev/null 2>&1; then
    echo "   ✅ Sintaxis Perl correcta"
else
    echo "   ❌ Error de sintaxis Perl"
    echo "   🔍 Detalles del error:"
    perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    exit 1
fi

echo "📋 Registrando plugin en AppConfig..."
if /usr/local/cpanel/bin/register_appconfig "/var/cpanel/apps/whm_toolkit.conf"; then
    echo "   ✅ Plugin registrado exitosamente"
else
    echo "   ❌ Error registrando plugin"
    echo "   🔍 Intentando diagnóstico..."
    /usr/local/cpanel/bin/register_appconfig "/var/cpanel/apps/whm_toolkit.conf" --dry-run
    exit 1
fi

echo "🔄 Reiniciando servicios necesarios..."
echo "   🔄 Reiniciando cPanel..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true

echo "   🔄 Reiniciando Apache..."
/scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true

echo "   🔄 Reconstruyendo menú WHM..."
/usr/local/cpanel/bin/rebuild_whm_menu >/dev/null 2>&1 || true

echo "✅ Verificación final..."
sleep 3

# Verificar archivos
ERRORS=0

if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "   ✅ Plugin CGI instalado correctamente"
else
    echo "   ❌ Plugin CGI NO instalado"
    ERRORS=$((ERRORS + 1))
fi

if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "   ✅ Configuración AppConfig instalada"
else
    echo "   ❌ Configuración AppConfig NO instalada"
    ERRORS=$((ERRORS + 1))
fi

# Verificar registro
if /usr/local/cpanel/bin/manage_appconfig --list 2>/dev/null | grep -q "WHM_Toolkit"; then
    echo "   ✅ Plugin registrado en AppConfig"
else
    echo "   ❌ Plugin NO registrado en AppConfig"
    ERRORS=$((ERRORS + 1))
fi

# Verificar permisos
PERMS=$(stat -c "%a" "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" 2>/dev/null)
if [ "$PERMS" = "755" ]; then
    echo "   ✅ Permisos correctos (755)"
else
    echo "   ⚠️ Permisos: $PERMS (esperado: 755)"
fi

# Obtener IP del servidor
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

if [ $ERRORS -eq 0 ]; then
    echo
    echo "==========================================="
    echo "  ✅ INSTALACIÓN COMPLETADA EXITOSAMENTE"
    echo "==========================================="
    echo
    echo "🎯 Acceso al Plugin:"
    echo "   📋 Menú WHM: Plugins → WHM_Toolkit"
    echo "   🌐 URL Directa: https://$SERVER_IP:2087/cgi/addon_whm_toolkit.cgi"
    echo
    echo "📁 Archivos Instalados:"
    echo "   🐪 Plugin: /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo "   ⚙️ Config: /var/cpanel/apps/whm_toolkit.conf"
    echo "   🎨 Iconos: /usr/local/cpanel/whostmgr/docroot/addon_plugins/"
    echo
    echo "💡 Características:"
    echo "   ✅ Estructura optimizada /docroot/cgi/"
    echo "   ✅ Configuración AppConfig correcta"
    echo "   ✅ Plugin funcional con Hello World"
    echo "   ✅ Interfaz moderna y responsiva"
    echo "   ✅ Sistema de pruebas integrado"
    echo "   ✅ Información detallada del sistema"
    echo
    echo "🔧 Si el plugin no aparece en el menú:"
    echo "   1. Espera 2-3 minutos para que WHM actualice"
    echo "   2. Refresca la página de WHM (Ctrl+F5)"
    echo "   3. Cierra sesión y vuelve a iniciar en WHM"
    echo "   4. Ejecuta: ./diagnose-whm-toolkit-final.sh"
    echo
    echo "🧪 Prueba rápida:"
    echo "   curl -k https://$SERVER_IP:2087/cgi/addon_whm_toolkit.cgi"
    echo
    echo "==========================================="
else
    echo
    echo "==========================================="
    echo "  ⚠️ INSTALACIÓN COMPLETADA CON ERRORES"
    echo "==========================================="
    echo
    echo "❌ Se encontraron $ERRORS errores durante la instalación"
    echo "🔧 Ejecuta el script de diagnóstico para más detalles:"
    echo "   ./diagnose-whm-toolkit-final.sh"
    echo
    echo "==========================================="
    exit 1
fi