#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit - Limpieza Completa"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

echo "🧹 Limpieza completa de todas las versiones..."

# Desregistrar todos los plugins posibles
echo "📋 Desregistrando plugins..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit_v2 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit_v2 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit_v3 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit_v3 2>/dev/null || true

# Eliminar todas las estructuras posibles
echo "🗑️ Eliminando archivos..."
rm -rf /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit
rm -rf /usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit
rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit_v2.cgi
rm -f /var/cpanel/apps/whm_toolkit.conf
rm -f /var/cpanel/apps/whm_toolkit_v2.conf
rm -f /var/cpanel/apps/whm_toolkit_v3.conf
rm -f /var/cpanel/apps/WHM_Toolkit.conf

# Limpiar archivos temporales
echo "🧹 Limpiando archivos temporales..."
rm -f /tmp/whm-toolkit*
rm -f /tmp/install-whm-toolkit*

echo "🔄 Reiniciando servicios..."
systemctl restart cpanel
systemctl restart httpd

echo "✅ Verificando limpieza..."
if [ ! -d "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit" ] && [ ! -f "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" ]; then
    echo "   ✅ Limpieza completada exitosamente"
else
    echo "   ⚠️ Algunos archivos podrían no haberse eliminado"
fi

echo
echo "==========================================="
echo "  ✅ Limpieza completada"
echo "==========================================="
echo
echo "💡 Para reinstalar:"
echo "   curl -sSL https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install-whm-official.sh | bash"
echo
echo "===========================================" 