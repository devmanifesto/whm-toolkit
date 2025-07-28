#!/bin/bash

# WHM Toolkit - Instalador Simple
# Versión que funciona directamente

set -e

echo "==========================================="
echo "  WHM Toolkit - Instalador Simple"
echo "  Versión 1.0.0"
echo "==========================================="
echo

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Error: Debe ejecutarse como root"
    exit 1
fi

# Directorios
PLUGIN_DIR="/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit"
APPCONFIG_DIR="/var/cpanel/apps"

echo "🧹 Limpiando instalaciones previas..."
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true
rm -rf "$PLUGIN_DIR"
rm -f "/var/cpanel/apps/whm_toolkit.conf"

echo "📁 Creando estructura..."
mkdir -p "$PLUGIN_DIR"

echo "📋 Creando plugin principal..."
cat > "$PLUGIN_DIR/whm-toolkit.cgi" << 'EOF'
#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";

# Obtener parámetros
my $cgi = CGI->new();
my $action = $cgi->param('action') || 'main';

# Headers
print $cgi->header(-type => 'text/html', -charset => 'UTF-8');

# Contenido principal
if ($action eq 'hello_world') {
    show_hello_world();
} elsif ($action eq 'system_info') {
    show_system_info();
} else {
    show_main_interface();
}

sub show_main_interface {
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>$plugin_name</title>
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        .plugin-container { padding: 20px; max-width: 1200px; margin: 0 auto; }
        .plugin-header { background: #f8f9fa; padding: 20px; border-radius: 5px; margin-bottom: 20px; border-left: 4px solid #007cba; }
        .tools-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .tool-card { background: white; border: 1px solid #ddd; border-radius: 5px; padding: 20px; }
        .tool-card:hover { box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .tool-card a { color: #007cba; text-decoration: none; }
    </style>
</head>
<body>
    <div class="plugin-container">
        <div class="plugin-header">
            <h1>$plugin_name v$plugin_version</h1>
            <p>Herramientas útiles para administración de WHM</p>
        </div>
        
        <div class="tools-grid">
            <div class="tool-card">
                <h3><a href="?action=hello_world">🚀 Hello World</a></h3>
                <p>Prueba básica del plugin</p>
            </div>
            
            <div class="tool-card">
                <h3><a href="?action=system_info">📊 Información del Sistema</a></h3>
                <p>Datos del servidor en tiempo real</p>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_hello_world {
    my $current_time = scalar localtime();
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>$plugin_name - Hello World</title>
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
</head>
<body>
    <div style="padding: 20px; max-width: 800px; margin: 0 auto;">
        <a href="?" style="color: #007cba;">&larr; Volver</a>
        
        <div style="background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 20px; border-radius: 5px; margin: 20px 0;">
            <h2>🚀 ¡Hello World!</h2>
            <p>El plugin está funcionando correctamente.</p>
            <p><strong>Hora actual:</strong> $current_time</p>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_system_info {
    my $hostname = `hostname`; chomp($hostname);
    my $uptime = `uptime`; chomp($uptime);
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>$plugin_name - Sistema</title>
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
</head>
<body>
    <div style="padding: 20px; max-width: 800px; margin: 0 auto;">
        <a href="?" style="color: #007cba;">&larr; Volver</a>
        
        <h2>📊 Información del Sistema</h2>
        <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;">
            <strong>Hostname:</strong> $hostname
        </div>
        <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin: 10px 0;">
            <strong>Uptime:</strong> $uptime
        </div>
    </div>
</body>
</html>
HTML
}
EOF

echo "📝 Creando configuración..."
cat > "$PLUGIN_DIR/whm-toolkit.conf" << 'EOF'
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas útiles para administración de WHM
description=Un conjunto completo de herramientas para administradores de sistemas que utilizan WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[app]
name=WHM_Toolkit
version=1.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas útiles para administración de WHM
description=Un conjunto completo de herramientas para administradores de sistemas que utilizan WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[script]
type=whm
target=/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[icon]
24x24=/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/icon_24.png
32x32=/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/icon_32.png

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

echo "🎨 Creando iconos..."
# Crear icono simple
printf '\x89PNG\r\n\x1a\n\x00\x00\x00\rIHDR\x00\x00\x00\x18\x00\x00\x00\x18\x08\x06\x00\x00\x00\xe0w=\xf8\x00\x00\x00\tpHYs\x00\x00\x0b\x13\x00\x00\x0b\x13\x01\x00\x9a\x9c\x18\x00\x00\x00\x19tEXtSoftware\x00www.inkscape.org\x9b\xee<\x1a\x00\x00\x00\rIDAT8\x8d\x63\x00\x01\x00\x00\x05\x00\x01\r\n-\xdb\x00\x00\x00\x00IEND\xaeB`\x82' > "$PLUGIN_DIR/icon_24.png"
cp "$PLUGIN_DIR/icon_24.png" "$PLUGIN_DIR/icon_32.png"

echo "⚙️ Estableciendo permisos..."
chmod 755 "$PLUGIN_DIR/whm-toolkit.cgi"
chmod 644 "$PLUGIN_DIR/whm-toolkit.conf"
chmod 644 "$PLUGIN_DIR/icon_24.png"
chmod 644 "$PLUGIN_DIR/icon_32.png"
chown -R root:root "$PLUGIN_DIR"

echo "📋 Registrando en AppConfig..."
cp "$PLUGIN_DIR/whm-toolkit.conf" "$APPCONFIG_DIR/whm_toolkit.conf"
chmod 644 "$APPCONFIG_DIR/whm_toolkit.conf"
chown root:root "$APPCONFIG_DIR/whm_toolkit.conf"

/usr/local/cpanel/bin/register_appconfig "$APPCONFIG_DIR/whm_toolkit.conf"

echo "🔄 Reiniciando servicios..."
/scripts/restartsrv_cpanel --wait >/dev/null 2>&1 || true

SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "tu-servidor")

echo
echo "==========================================="
echo "  ✅ Instalación completada"
echo "==========================================="
echo
echo "🎯 Acceso:"
echo "   Menú: WHM → Plugins → WHM_Toolkit"
echo "   URL: https://$SERVER_IP:2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo
echo "===========================================" 