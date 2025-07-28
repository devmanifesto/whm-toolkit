#!/bin/bash

echo "==========================================="
echo "  WHM Toolkit - Instalador Oficial"
echo "  Basado en documentación oficial de WHM"
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

echo "🧹 Limpieza completa de versiones anteriores..."
# Desregistrar plugins anteriores
/usr/local/cpanel/bin/unregister_appconfig whm_toolkit 2>/dev/null || true
/usr/local/cpanel/bin/unregister_appconfig WHM_Toolkit 2>/dev/null || true

# Eliminar archivos anteriores
rm -rf /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit
rm -f /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
rm -f /var/cpanel/apps/whm_toolkit.conf

echo "📁 Creando estructura oficial de WHM..."

# Crear directorio del plugin (estructura oficial)
mkdir -p /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit

echo "📋 Creando plugin principal..."
# Crear plugin CGI
cat > /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi << 'EOF'
#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "4.0.0";

# Headers
print header(-type => 'text/html', -charset => 'UTF-8');

# Obtener parámetros
my $cgi = CGI->new();
my $action = $cgi->param('action') || 'main';

# Enrutamiento principal
if ($action eq 'hello') {
    show_hello_world();
} elsif ($action eq 'system') {
    show_system_info();
} else {
    show_main_interface();
}

sub show_main_interface {
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <title>$plugin_name</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f6fa; 
            color: #2c3e50;
        }
        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
            overflow: hidden;
        }
        .header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 40px; 
            text-align: center;
        }
        .header h1 { 
            margin: 0; 
            font-size: 32px; 
            font-weight: 600;
        }
        .header p { 
            margin: 15px 0 0 0; 
            opacity: 0.9; 
            font-size: 18px;
        }
        .version-badge { 
            display: inline-block; 
            background: rgba(255,255,255,0.2); 
            padding: 6px 16px; 
            border-radius: 20px; 
            font-size: 14px; 
            margin-left: 15px;
        }
        .content { 
            padding: 40px; 
        }
        .tools-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); 
            gap: 24px; 
            margin-top: 30px; 
        }
        .tool-card { 
            background: #f8f9fa; 
            border: 2px solid #e9ecef; 
            border-radius: 12px; 
            padding: 24px; 
            transition: all 0.3s ease; 
            position: relative;
            overflow: hidden;
        }
        .tool-card:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
            border-color: #667eea; 
        }
        .tool-card h3 { 
            margin: 0 0 10px 0; 
            color: #333; 
        }
        .tool-card p { 
            margin: 0; 
            color: #666; 
            line-height: 1.5; 
        }
        .tool-card a { 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 500; 
        }
        .tool-card a:hover { 
            text-decoration: underline; 
        }
        .footer { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 0 0 12px 12px; 
            border-top: 1px solid #e9ecef; 
            text-align: center; 
            color: #666; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$plugin_name <span class="version-badge">v$plugin_version</span></h1>
            <p>Plugin oficial para administración de WHM</p>
        </div>
        
        <div class="content">
            <div class="tools-grid">
                <div class="tool-card">
                    <h3><a href="?action=hello">🚀 Hello World</a></h3>
                    <p>Prueba básica del plugin para verificar que todo esté funcionando correctamente.</p>
                </div>
                
                <div class="tool-card">
                    <h3><a href="?action=system">📊 Información del Sistema</a></h3>
                    <p>Información detallada sobre el estado del servidor, recursos y configuración.</p>
                </div>
                
                <div class="tool-card">
                    <h3>🌐 Gestor de Dominios</h3>
                    <p>Administración avanzada de dominios y subdominios (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>📈 Monitor de Recursos</h3>
                    <p>Monitoreo en tiempo real de CPU, memoria y espacio en disco (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>💾 Backup Manager</h3>
                    <p>Herramientas avanzadas para gestión de respaldos automáticos (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>🔒 Security Scanner</h3>
                    <p>Escaneo de seguridad y análisis de vulnerabilidades (Próximamente).</p>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p><strong>WHM Toolkit v$plugin_version</strong> - Plugin oficial y funcional</p>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_hello_world {
    my $current_time = scalar localtime();
    my $perl_version = $^V ? sprintf("v%vd", $^V) : $];
    my $hostname = `hostname`; chomp($hostname);
    
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>$plugin_name - Hello World</title>
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 800px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #28a745 0%, #20c997 100%); color: white; padding: 30px; border-radius: 8px 8px 0 0; }
        .content { padding: 30px; }
        .success-box { background: #d4edda; border: 1px solid #c3e6cb; color: #155724; padding: 20px; border-radius: 8px; margin: 20px 0; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; margin: 20px 0; }
        .info-item { background: #f8f9fa; padding: 15px; border-radius: 8px; border-left: 4px solid #667eea; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #667eea; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Hello World!</h1>
            <p>Plugin funcionando correctamente</p>
        </div>
        
        <div class="content">
            <a href="?" class="back-link">← Volver al menú principal</a>
            
            <div class="success-box">
                <h2>¡Éxito!</h2>
                <p>El plugin <strong>$plugin_name</strong> está funcionando perfectamente.</p>
                <p>Esta es una prueba que confirma que la instalación fue exitosa.</p>
            </div>
            
            <h3>📋 Información del Sistema</h3>
            <div class="info-grid">
                <div class="info-item">
                    <strong>Plugin:</strong> $plugin_name v$plugin_version
                </div>
                <div class="info-item">
                    <strong>Servidor:</strong> $hostname
                </div>
                <div class="info-item">
                    <strong>Fecha y Hora:</strong> $current_time
                </div>
                <div class="info-item">
                    <strong>Versión de Perl:</strong> $perl_version
                </div>
            </div>
            
            <h3>🔧 Variables de Entorno</h3>
            <div class="info-item">
                <pre style="margin: 0; font-size: 0.9em; overflow-x: auto;">
REQUEST_METHOD: $ENV{'REQUEST_METHOD'}
QUERY_STRING: $ENV{'QUERY_STRING'}
HTTP_HOST: $ENV{'HTTP_HOST'}
SERVER_SOFTWARE: $ENV{'SERVER_SOFTWARE'}
                </pre>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_system_info {
    my $current_time = scalar localtime();
    my $hostname = `hostname`; chomp($hostname);
    my $uptime = `uptime`; chomp($uptime);
    my $memory_info = `free -h 2>/dev/null` || "No disponible";
    my $disk_info = `df -h / 2>/dev/null` || "No disponible";
    my $cpanel_version = `cat /usr/local/cpanel/version 2>/dev/null` || "No disponible";
    chomp($cpanel_version);
    
    print <<HTML;
<!DOCTYPE html>
<html>
<head>
    <title>$plugin_name - Información del Sistema</title>
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1000px; margin: 0 auto; background: white; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 8px 8px 0 0; }
        .content { padding: 30px; }
        .info-section { background: #f8f9fa; border: 1px solid #e9ecef; border-radius: 8px; padding: 20px; margin: 20px 0; }
        .info-section h3 { margin: 0 0 15px 0; color: #333; border-bottom: 2px solid #667eea; padding-bottom: 5px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 15px; }
        .info-item { background: white; padding: 15px; border-radius: 8px; border-left: 4px solid #667eea; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #667eea; text-decoration: none; font-weight: 500; }
        .back-link:hover { text-decoration: underline; }
        pre { background: #f8f9fa; padding: 15px; border-radius: 8px; overflow-x: auto; font-size: 0.9em; border: 1px solid #e9ecef; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Información del Sistema</h1>
            <p>Datos detallados del servidor</p>
        </div>
        
        <div class="content">
            <a href="?" class="back-link">← Volver al menú principal</a>
            
            <div class="info-section">
                <h3>🖥️ Información Básica</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Hostname:</strong> $hostname
                    </div>
                    <div class="info-item">
                        <strong>Fecha y Hora:</strong> $current_time
                    </div>
                    <div class="info-item">
                        <strong>Uptime:</strong> $uptime
                    </div>
                    <div class="info-item">
                        <strong>cPanel Version:</strong> $cpanel_version
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <h3>💾 Memoria del Sistema</h3>
                <pre>$memory_info</pre>
            </div>
            
            <div class="info-section">
                <h3>💿 Espacio en Disco</h3>
                <pre>$disk_info</pre>
            </div>
            
            <div class="info-section">
                <h3>🔧 Información del Plugin</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Plugin:</strong> $plugin_name
                    </div>
                    <div class="info-item">
                        <strong>Versión:</strong> $plugin_version
                    </div>
                    <div class="info-item">
                        <strong>Estructura:</strong> Oficial WHM
                    </div>
                    <div class="info-item">
                        <strong>Estado:</strong> Funcionando
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}
EOF

echo "📝 Creando configuración AppConfig oficial..."
# Crear configuración AppConfig (formato oficial)
cat > /var/cpanel/apps/whm_toolkit.conf << 'EOF'
name=WHM_Toolkit
version=4.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas avanzadas para administración de WHM
description=Plugin oficial optimizado con estructura correcta y funcional para WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
service=whostmgr
url=addonfeatures/whm-toolkit/whm-toolkit.cgi

[app]
name=WHM_Toolkit
version=4.0.0
vendor=WHM_Toolkit_Team
summary=Herramientas avanzadas para administración de WHM
description=Plugin oficial optimizado con estructura correcta y funcional para WHM
url=https://github.com/devmanifesto/whm-toolkit
support=https://github.com/devmanifesto/whm-toolkit/issues
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

echo "⚙️ Estableciendo permisos..."
# Establecer permisos correctos
chmod 755 /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi
chown root:root /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi
chmod 644 /var/cpanel/apps/whm_toolkit.conf
chown root:root /var/cpanel/apps/whm_toolkit.conf

echo "🧪 Verificando sintaxis Perl..."
# Verificar sintaxis del plugin
if perl -c /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi >/dev/null 2>&1; then
    echo "   ✅ Sintaxis correcta"
else
    echo "   ❌ Error de sintaxis"
    exit 1
fi

echo "📋 Registrando plugin..."
# Registrar plugin
/usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf

echo "🔄 Reiniciando servicios..."
# Reiniciar servicios
systemctl restart cpanel
systemctl restart httpd

echo "✅ Verificando instalación..."
# Verificar archivos
if [ -f "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi" ]; then
    echo "   ✅ Plugin CGI instalado"
else
    echo "   ❌ Plugin CGI NO instalado"
    exit 1
fi

if [ -f "/var/cpanel/apps/whm_toolkit.conf" ]; then
    echo "   ✅ Configuración AppConfig instalada"
else
    echo "   ❌ Configuración AppConfig NO instalada"
    exit 1
fi

# Obtener IP del servidor
SERVER_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || echo "localhost")

echo
echo "==========================================="
echo "  ✅ Instalación completada exitosamente"
echo "==========================================="
echo
echo "🎯 Acceso:"
echo "   Menú: WHM → Plugins → WHM_Toolkit"
echo "   URL: https://$SERVER_IP:2087/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo
echo "📁 Estructura instalada:"
echo "   Plugin: /usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi"
echo "   Config: /var/cpanel/apps/whm_toolkit.conf"
echo
echo "💡 Características:"
echo "   ✅ Estructura oficial /addonfeatures/"
echo "   ✅ Configuración AppConfig correcta"
echo "   ✅ Plugin funcional con Hello World"
echo "   ✅ Interfaz moderna y responsiva"
echo
echo "🔧 Comando de instalación desde GitHub:"
echo "   curl -sSL https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install-whm-official.sh | bash"
echo
echo "===========================================" 