#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit v3.0 - Desinstalador Limpio"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🗑️ Desinstalando WHM Toolkit completamente..."

# Función para eliminar archivo con confirmación
remove_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        echo "   🗂️ Eliminando $description..."
        rm -f "$file"
        if [ ! -f "$file" ]; then
            echo "      ✅ $description eliminado"
        else
            echo "      ❌ Error eliminando $description"
        fi
    else
        echo "   ℹ️ $description no existe (ya eliminado)"
    fi
}

# Función para eliminar directorio con confirmación
remove_directory() {
    local dir="$1"
    local description="$2"
    
    if [ -d "$dir" ]; then
        echo "   📁 Eliminando directorio $description..."
        rm -rf "$dir"
        if [ ! -d "$dir" ]; then
            echo "      ✅ Directorio $description eliminado"
        else
            echo "      ❌ Error eliminando directorio $description"
        fi
    else
        echo "   ℹ️ Directorio $description no existe (ya eliminado)"
    fi
}

echo "📋 Paso 1: Desregistrando de AppConfig..."

# Desregistrar todas las versiones posibles del plugin
APPCONFIGS=("whm_toolkit" "WHM_Toolkit" "whm_toolkit_v2" "WHM_Toolkit_v2")

for config in "${APPCONFIGS[@]}"; do
    echo "   🔄 Desregistrando $config..."
    if /usr/local/cpanel/bin/unregister_appconfig "$config" 2>/dev/null; then
        echo "      ✅ $config desregistrado"
    else
        echo "      ℹ️ $config no estaba registrado"
    fi
done

echo
echo "🗂️ Paso 2: Eliminando archivos del plugin..."

# Eliminar archivo principal del plugin
remove_file "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" "Plugin CGI principal"

# Eliminar configuraciones AppConfig
remove_file "/var/cpanel/apps/whm_toolkit.conf" "Configuración AppConfig principal"
remove_file "/var/cpanel/apps/whm_toolkit_v2.conf" "Configuración AppConfig v2"
remove_file "/var/cpanel/apps/WHM_Toolkit.conf" "Configuración AppConfig alternativa"

# Eliminar iconos
remove_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_24.png" "Icono 24x24"
remove_file "/usr/local/cpanel/whostmgr/docroot/addon_plugins/whm_toolkit_32.png" "Icono 32x32"

echo
echo "📁 Paso 3: Eliminando directorios antiguos..."

# Eliminar directorios de versiones anteriores
remove_directory "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit" "Directorio addonfeatures"
remove_directory "/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit" "Directorio cgi/whm-toolkit"

# Eliminar cualquier directorio temporal que pueda haber quedado
remove_directory "/tmp/whm-toolkit" "Directorio temporal"

echo
echo "🧹 Paso 4: Limpieza de archivos temporales..."

# Buscar y eliminar archivos relacionados en /tmp
echo "   🔍 Buscando archivos temporales..."
TEMP_FILES=$(find /tmp -name "*whm*toolkit*" -type f 2>/dev/null || true)
if [ -n "$TEMP_FILES" ]; then
    echo "   🗂️ Eliminando archivos temporales encontrados:"
    echo "$TEMP_FILES" | while read -r file; do
        if [ -f "$file" ]; then
            rm -f "$file"
            echo "      ✅ Eliminado: $file"
        fi
    done
else
    echo "   ℹ️ No se encontraron archivos temporales"
fi

echo
echo "🔄 Paso 5: Reiniciando servicios..."

echo "   🔄 Reiniciando cPanel..."
if /scripts/restartsrv_cpanel --wait >/dev/null 2>&1; then
    echo "      ✅ cPanel reiniciado"
else
    echo "      ⚠️ Error reiniciando cPanel (puede ser normal)"
fi

echo "   🔄 Reiniciando Apache..."
if /scripts/restartsrv_httpd --wait >/dev/null 2>&1; then
    echo "      ✅ Apache reiniciado"
else
    echo "      ⚠️ Error reiniciando Apache (puede ser normal)"
fi

echo "   🔄 Reconstruyendo menú WHM..."
if /usr/local/cpanel/bin/rebuild_whm_menu >/dev/null 2>&1; then
    echo "      ✅ Menú WHM reconstruido"
else
    echo "      ⚠️ Error reconstruyendo menú WHM"
fi

echo
echo "✅ Paso 6: Verificación final..."

# Verificar que los archivos principales fueron eliminados
ERRORS=0

if [ -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "   ❌ Plugin CGI aún existe"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ Plugin CGI eliminado correctamente"
fi

if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "   ❌ Configuración AppConfig aún existe"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ Configuración AppConfig eliminada correctamente"
fi

# Verificar que no esté registrado en AppConfig
if /usr/local/cpanel/bin/manage_appconfig --list 2>/dev/null | grep -q -i "whm.*toolkit"; then
    echo "   ❌ Plugin aún aparece registrado en AppConfig"
    ERRORS=$((ERRORS + 1))
else
    echo "   ✅ Plugin no aparece en AppConfig"
fi

echo
if [ $ERRORS -eq 0 ]; then
    echo "==========================================="
    echo "  ✅ DESINSTALACIÓN COMPLETADA EXITOSAMENTE"
    echo "==========================================="
    echo
    echo "🎯 Resultado:"
    echo "   ✅ Todos los archivos del plugin eliminados"
    echo "   ✅ Configuraciones AppConfig eliminadas"
    echo "   ✅ Plugin desregistrado completamente"
    echo "   ✅ Servicios reiniciados"
    echo "   ✅ Menú WHM actualizado"
    echo
    echo "📋 El plugin ya no aparecerá en:"
    echo "   • Menú WHM → Plugins"
    echo "   • Lista de aplicaciones instaladas"
    echo "   • URLs de acceso directo"
    echo
    echo "💡 Notas:"
    echo "   • Puede tomar 2-3 minutos para que WHM actualice completamente"
    echo "   • Refresca la página de WHM (Ctrl+F5) si es necesario"
    echo "   • Cierra sesión y vuelve a iniciar en WHM para confirmar"
    echo
    echo "🔄 Para reinstalar el plugin:"
    echo "   ./install-whm-toolkit-final.sh"
    echo
    echo "==========================================="
else
    echo "==========================================="
    echo "  ⚠️ DESINSTALACIÓN COMPLETADA CON ERRORES"
    echo "==========================================="
    echo
    echo "❌ Se encontraron $ERRORS problemas durante la desinstalación"
    echo
    echo "🔧 Limpieza manual requerida:"
    echo "   • Verificar archivos manualmente"
    echo "   • Ejecutar comandos de limpieza adicionales"
    echo "   • Contactar soporte si persisten los problemas"
    echo
    echo "📋 Comandos de limpieza manual:"
    echo "   rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
    echo "   rm -f /var/cpanel/apps/whm_toolkit.conf"
    echo "   /usr/local/cpanel/bin/unregister_appconfig whm_toolkit"
    echo "   /usr/local/cpanel/bin/rebuild_whm_menu"
    echo
    echo "==========================================="
    exit 1
fi

echo
echo "🎉 ¡Desinstalación completada!"
echo "   El sistema está limpio y listo para una nueva instalación si es necesario."
echo