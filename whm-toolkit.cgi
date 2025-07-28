#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_description = "Herramientas útiles para administración de WHM";

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
        .plugin-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        .plugin-header {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            border-left: 4px solid #007cba;
        }
        .plugin-title {
            margin: 0;
            color: #333;
            font-size: 24px;
        }
        .plugin-version {
            color: #666;
            font-size: 14px;
            margin-top: 5px;
        }
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .tool-card {
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            transition: all 0.3s ease;
        }
        .tool-card:hover {
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-color: #007cba;
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
            color: #007cba;
            text-decoration: none;
        }
        .tool-card a:hover {
            text-decoration: underline;
        }
        .status-badge {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 12px;
            margin-left: 10px;
        }
    </style>
</head>
<body>
    <div class="plugin-container">
        <div class="plugin-header">
            <h1 class="plugin-title">$plugin_name <span class="status-badge">v$plugin_version</span></h1>
            <p class="plugin-version">$plugin_description</p>
        </div>
        
        <div class="tools-grid">
            <div class="tool-card">
                <h3><a href="?action=hello_world">🚀 Hello World</a></h3>
                <p>Prueba básica del plugin para verificar que todo esté funcionando correctamente.</p>
            </div>
            
            <div class="tool-card">
                <h3><a href="?action=system_info">📊 Información del Sistema</a></h3>
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
        
        <div style="margin-top: 30px; padding: 15px; background: #e9ecef; border-radius: 5px;">
            <p style="margin: 0; color: #666; font-size: 14px;">
                <strong>ℹ️ Información:</strong> Este plugin está siguiendo la estructura oficial de plugins de WHM.
                Para más información, visita: <a href="https://github.com/devmanifesto/whm-toolkit" target="_blank">GitHub</a>
            </p>
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
        .plugin-container {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .success-box {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 20px;
            border-radius: 5px;
            margin: 20px 0;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #007cba;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #007cba;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="plugin-container">
        <a href="?" class="back-link">&larr; Volver al menú principal</a>
        
        <div class="success-box">
            <h2>🚀 ¡Hello World!</h2>
            <p>El plugin <strong>$plugin_name</strong> está funcionando correctamente.</p>
            <p>Esta es una prueba básica que confirma que la instalación fue exitosa.</p>
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
        
        <div style="margin-top: 30px; padding: 15px; background: #e9ecef; border-radius: 5px;">
            <p style="margin: 0; color: #666; font-size: 14px;">
                <strong>✅ Estado:</strong> Plugin funcionando correctamente con estructura oficial de WHM.
            </p>
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
        .plugin-container {
            padding: 20px;
            max-width: 1000px;
            margin: 0 auto;
        }
        .info-section {
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
        }
        .info-section h3 {
            margin: 0 0 15px 0;
            color: #333;
            border-bottom: 2px solid #007cba;
            padding-bottom: 5px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #007cba;
        }
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #007cba;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        pre {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-size: 0.9em;
            border: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="plugin-container">
        <a href="?" class="back-link">&larr; Volver al menú principal</a>
        
        <h2>📊 Información del Sistema</h2>
        
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
                    <strong>Descripción:</strong> $plugin_description
                </div>
                <div class="info-item">
                    <strong>Estructura:</strong> Oficial WHM
                </div>
            </div>
        </div>
        
        <div style="margin-top: 30px; padding: 15px; background: #e9ecef; border-radius: 5px;">
            <p style="margin: 0; color: #666; font-size: 14px;">
                <strong>ℹ️ Nota:</strong> Esta información se obtiene en tiempo real del sistema.
                Algunos comandos pueden no estar disponibles dependiendo de los permisos del servidor.
            </p>
        </div>
    </div>
</body>
</html>
HTML
} 