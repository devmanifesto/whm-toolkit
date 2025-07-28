#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit - Instalador de Reparación"
echo "  Usando estructura alternativa"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Limpiar todo
echo "🧹 Limpieza completa..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
rm -rf "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
rm -f "/var/cpanel/apps/whm_toolkit.conf"

# Crear estructura alternativa
echo "📁 Creando estructura alternativa..."
mkdir -p "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"

# Crear plugin simple
echo "📋 Creando plugin..."
cat > "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi" << 'EOF'
#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header(-type => 'text/html', -charset => 'UTF-8');

my $action = param('action') || 'main';

if ($action eq 'hello') {
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
    <link rel="stylesheet" href="/whostmgr/css/whostmgr.css">
</head>
<body>
    <div style="padding: 20px;">
        <h1>🚀 Hello World!</h1>
        <p>Plugin funcionando: @{[scalar(localtime)]}</p>
        <a href="?" style="color: #007cba;">← Volver</a>
    </div>
</body>
</html>
HTML
} else {
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>WHM Toolkit</title>
    <link rel="stylesheet" href="/whostmgr/css/whostmgr.css">
</head>
<body>
    <div style="padding: 20px;">
        <h1>WHM Toolkit v1.0</h1>
        <div style="border: 1px solid #ddd; padding: 15px; margin: 10px 0; border-radius: 5px;">
            <h3><a href="?action=hello" style="color: #007cba; text-decoration: none;">🚀 Hello World</a></h3>
            <p>Prueba básica del plugin</p>
        </div>
    </div>
</body>
</html>
HTML
}
EOF

# Establecer permisos
chmod 755 "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi"
chown root:root "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi"

# Crear configuración AppConfig simplificada
echo "📝 Creando configuración AppConfig..."
cat > "/var/cpanel/apps/whm_toolkit.conf" << 'EOF'
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas WHM
description=Plugin de herramientas para WHM
service=whostmgr
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[app]
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas WHM
description=Plugin de herramientas para WHM
service=whostmgr
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[script]
type=whm
target=/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

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

chmod 644 "/var/cpanel/apps/whm_toolkit.conf"
chown root:root "/var/cpanel/apps/whm_toolkit.conf"

# Registrar plugin
echo "⚙️ Registrando plugin..."
/usr/local/cpanel/bin/register_appconfig "/var/cpanel/apps/whm_toolkit.conf"

# Reiniciar servicios
echo "🔄 Reiniciando servicios..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true
/scripts/restartsrv_httpd --wait >/dev/null 2>&1 || true

# Verificar instalación
echo "✅ Verificando instalación..."
if [ -f "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi" ]; then
    echo "   ✅ Plugin CGI instalado"
else
    echo "   ❌ Plugin CGI NO instalado"
fi

if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "   ✅ Configuración AppConfig instalada"
else
    echo "   ❌ Configuración AppConfig NO instalada"
fi

# Obtener IP del servidor
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

echo
echo "==========================================="
echo "  ✅ Instalación completada"
echo "==========================================="
echo
echo "🎯 Acceso:"
echo "   Menú: WHM → Plugins → WHM_Toolkit"
echo "   URL: https://$SERVER_IP:2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo
echo "💡 Si no aparece en el menú:"
echo "   1. Espera 2-3 minutos"
echo "   2. Cierra y abre el navegador"
echo "   3. Limpia la caché del navegador"
echo "   4. Prueba el acceso directo por URL"
echo
echo "===========================================" 