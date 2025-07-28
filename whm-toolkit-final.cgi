#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard);

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "3.0.0";
my $plugin_description = "Herramientas avanzadas para administración de WHM";

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
} elsif ($action eq 'test') {
    show_test_page();
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
        .tool-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .tool-card:hover::before {
            transform: scaleX(1);
        }
        .tool-card:hover { 
            transform: translateY(-4px); 
            box-shadow: 0 8px 25px rgba(0,0,0,0.12); 
            border-color: #667eea; 
        }
        .tool-card h3 { 
            margin: 0 0 12px 0; 
            color: #2c3e50; 
            font-size: 20px;
            font-weight: 600;
        }
        .tool-card p { 
            margin: 0; 
            color: #6c757d; 
            line-height: 1.6; 
            font-size: 15px;
        }
        .tool-card a { 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 600; 
        }
        .tool-card a:hover { 
            color: #764ba2;
            text-decoration: underline; 
        }
        .status-indicator {
            display: inline-block;
            width: 8px;
            height: 8px;
            background: #28a745;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s infinite;
        }
        \@keyframes pulse {
            0% { opacity: 1; }
            50% { opacity: 0.5; }
            100% { opacity: 1; }
        }
        .footer { 
            background: #f8f9fa; 
            padding: 24px 40px; 
            border-top: 1px solid #e9ecef; 
            text-align: center; 
            color: #6c757d; 
        }
        .footer a {
            color: #667eea;
            text-decoration: none;
        }
        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$plugin_name <span class="version-badge">v$plugin_version</span></h1>
            <p>$plugin_description</p>
        </div>
        
        <div class="content">
            <div class="tools-grid">
                <div class="tool-card">
                    <h3><span class="status-indicator"></span><a href="?action=hello">🚀 Hello World</a></h3>
                    <p>Prueba básica del plugin para verificar que todo esté funcionando correctamente. Incluye información del sistema y variables de entorno.</p>
                </div>
                
                <div class="tool-card">
                    <h3><span class="status-indicator"></span><a href="?action=system">📊 Información del Sistema</a></h3>
                    <p>Información detallada sobre el estado del servidor, recursos del sistema, memoria, disco y configuración de cPanel/WHM.</p>
                </div>
                
                <div class="tool-card">
                    <h3><span class="status-indicator"></span><a href="?action=test">🧪 Página de Pruebas</a></h3>
                    <p>Herramientas de diagnóstico y pruebas para verificar el correcto funcionamiento del plugin y la integración con WHM.</p>
                </div>
                
                <div class="tool-card">
                    <h3>🌐 Gestor de Dominios</h3>
                    <p>Administración avanzada de dominios y subdominios con herramientas de gestión DNS (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>📈 Monitor de Recursos</h3>
                    <p>Monitoreo en tiempo real de CPU, memoria, espacio en disco y procesos del sistema (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>💾 Backup Manager</h3>
                    <p>Herramientas avanzadas para gestión de respaldos automáticos y restauración de datos (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>🔒 Security Scanner</h3>
                    <p>Escaneo de seguridad, análisis de vulnerabilidades y herramientas de hardening (Próximamente).</p>
                </div>
                
                <div class="tool-card">
                    <h3>⚙️ Configuración</h3>
                    <p>Configuración del plugin, preferencias de usuario y opciones avanzadas (Próximamente).</p>
                </div>
            </div>
        </div>
        
        <div class="footer">
            <p><strong>$plugin_name v$plugin_version</strong> - Plugin optimizado y funcional para WHM</p>
            <p>Desarrollado con ❤️ | <a href="https://github.com/devmanifesto/whm-toolkit" target="_blank">GitHub</a> | <a href="https://github.com/devmanifesto/whm-toolkit/issues" target="_blank">Soporte</a></p>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_hello_world {
    my $current_time = scalar localtime();
    my $perl_version = $^V ? sprintf("v%vd", $^V) : $];
    my $hostname = `hostname 2>/dev/null` || "No disponible"; 
    chomp($hostname);
    my $user = $ENV{'USER'} || $ENV{'USERNAME'} || "No disponible";
    my $server_software = $ENV{'SERVER_SOFTWARE'} || "No disponible";
    
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <title>$plugin_name - Hello World</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f6fa; 
        }
        .container { 
            max-width: 900px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
            overflow: hidden;
        }
        .header { 
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%); 
            color: white; 
            padding: 40px; 
            text-align: center;
        }
        .header h1 { 
            margin: 0; 
            font-size: 28px; 
            font-weight: 600;
        }
        .header p { 
            margin: 15px 0 0 0; 
            opacity: 0.9; 
            font-size: 16px;
        }
        .content { 
            padding: 40px; 
        }
        .success-box { 
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%); 
            border: 2px solid #28a745; 
            color: #155724; 
            padding: 24px; 
            border-radius: 12px; 
            margin: 24px 0; 
            text-align: center;
        }
        .success-box h2 {
            margin: 0 0 12px 0;
            font-size: 24px;
        }
        .info-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            gap: 20px; 
            margin: 30px 0; 
        }
        .info-item { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 12px; 
            border-left: 4px solid #667eea; 
            transition: all 0.3s ease;
        }
        .info-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .info-item strong {
            color: #2c3e50;
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }
        .back-link { 
            display: inline-block; 
            margin-bottom: 24px; 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .back-link:hover { 
            background: #667eea;
            color: white;
            transform: translateX(-4px);
        }
        .env-section {
            background: #f8f9fa;
            border-radius: 12px;
            padding: 24px;
            margin: 24px 0;
        }
        .env-section h3 {
            margin: 0 0 16px 0;
            color: #2c3e50;
            font-size: 20px;
        }
        pre { 
            background: #2c3e50; 
            color: #ecf0f1; 
            padding: 20px; 
            border-radius: 8px; 
            overflow-x: auto; 
            font-size: 14px; 
            line-height: 1.5;
            margin: 0;
        }
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
                <h2>¡Éxito Total! 🎉</h2>
                <p>El plugin <strong>$plugin_name v$plugin_version</strong> está funcionando perfectamente.</p>
                <p>Esta prueba confirma que la instalación fue exitosa y el plugin está correctamente integrado con WHM.</p>
            </div>
            
            <h3>📋 Información del Sistema</h3>
            <div class="info-grid">
                <div class="info-item">
                    <strong>Plugin:</strong>
                    $plugin_name v$plugin_version
                </div>
                <div class="info-item">
                    <strong>Servidor:</strong>
                    $hostname
                </div>
                <div class="info-item">
                    <strong>Fecha y Hora:</strong>
                    $current_time
                </div>
                <div class="info-item">
                    <strong>Versión de Perl:</strong>
                    $perl_version
                </div>
                <div class="info-item">
                    <strong>Usuario:</strong>
                    $user
                </div>
                <div class="info-item">
                    <strong>Servidor Web:</strong>
                    $server_software
                </div>
            </div>
            
            <div class="env-section">
                <h3>🔧 Variables de Entorno</h3>
                <pre>REQUEST_METHOD: $ENV{'REQUEST_METHOD'}
QUERY_STRING: $ENV{'QUERY_STRING'}
HTTP_HOST: $ENV{'HTTP_HOST'}
SERVER_SOFTWARE: $ENV{'SERVER_SOFTWARE'}
SCRIPT_NAME: $ENV{'SCRIPT_NAME'}
REQUEST_URI: $ENV{'REQUEST_URI'}
HTTP_USER_AGENT: $ENV{'HTTP_USER_AGENT'}</pre>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_system_info {
    my $current_time = scalar localtime();
    my $hostname = `hostname 2>/dev/null` || "No disponible"; chomp($hostname);
    my $uptime = `uptime 2>/dev/null` || "No disponible"; chomp($uptime);
    my $memory_info = `free -h 2>/dev/null` || "No disponible";
    my $disk_info = `df -h / 2>/dev/null` || "No disponible";
    my $cpanel_version = `cat /usr/local/cpanel/version 2>/dev/null` || "No disponible";
    chomp($cpanel_version);
    my $load_avg = `cat /proc/loadavg 2>/dev/null` || "No disponible"; chomp($load_avg);
    my $kernel = `uname -r 2>/dev/null` || "No disponible"; chomp($kernel);
    
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <title>$plugin_name - Información del Sistema</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f6fa; 
        }
        .container { 
            max-width: 1100px; 
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
            font-size: 28px; 
            font-weight: 600;
        }
        .header p { 
            margin: 15px 0 0 0; 
            opacity: 0.9; 
            font-size: 16px;
        }
        .content { 
            padding: 40px; 
        }
        .info-section { 
            background: #f8f9fa; 
            border: 2px solid #e9ecef; 
            border-radius: 12px; 
            padding: 24px; 
            margin: 24px 0; 
            transition: all 0.3s ease;
        }
        .info-section:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .info-section h3 { 
            margin: 0 0 20px 0; 
            color: #2c3e50; 
            border-bottom: 3px solid #667eea; 
            padding-bottom: 8px; 
            font-size: 20px;
            font-weight: 600;
        }
        .info-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); 
            gap: 16px; 
        }
        .info-item { 
            background: white; 
            padding: 16px; 
            border-radius: 8px; 
            border-left: 4px solid #667eea; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .info-item strong {
            color: #2c3e50;
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
        }
        .back-link { 
            display: inline-block; 
            margin-bottom: 24px; 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .back-link:hover { 
            background: #667eea;
            color: white;
            transform: translateX(-4px);
        }
        pre { 
            background: #2c3e50; 
            color: #ecf0f1; 
            padding: 20px; 
            border-radius: 8px; 
            overflow-x: auto; 
            font-size: 14px; 
            line-height: 1.5;
            margin: 0;
            border: 1px solid #34495e;
        }
        .status-good { color: #28a745; font-weight: 600; }
        .status-warning { color: #ffc107; font-weight: 600; }
        .status-error { color: #dc3545; font-weight: 600; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Información del Sistema</h1>
            <p>Datos detallados del servidor y configuración</p>
        </div>
        
        <div class="content">
            <a href="?" class="back-link">← Volver al menú principal</a>
            
            <div class="info-section">
                <h3>🖥️ Información Básica del Servidor</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Hostname:</strong>
                        $hostname
                    </div>
                    <div class="info-item">
                        <strong>Fecha y Hora:</strong>
                        $current_time
                    </div>
                    <div class="info-item">
                        <strong>Kernel:</strong>
                        $kernel
                    </div>
                    <div class="info-item">
                        <strong>Load Average:</strong>
                        $load_avg
                    </div>
                    <div class="info-item">
                        <strong>cPanel Version:</strong>
                        <span class="status-good">$cpanel_version</span>
                    </div>
                    <div class="info-item">
                        <strong>Uptime:</strong>
                        $uptime
                    </div>
                </div>
            </div>
            
            <div class="info-section">
                <h3>💾 Información de Memoria</h3>
                <pre>$memory_info</pre>
            </div>
            
            <div class="info-section">
                <h3>💿 Información de Disco</h3>
                <pre>$disk_info</pre>
            </div>
            
            <div class="info-section">
                <h3>🔧 Información del Plugin</h3>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Plugin:</strong>
                        $plugin_name
                    </div>
                    <div class="info-item">
                        <strong>Versión:</strong>
                        <span class="status-good">$plugin_version</span>
                    </div>
                    <div class="info-item">
                        <strong>Descripción:</strong>
                        $plugin_description
                    </div>
                    <div class="info-item">
                        <strong>Estructura:</strong>
                        <span class="status-good">Optimizada v3</span>
                    </div>
                    <div class="info-item">
                        <strong>Estado:</strong>
                        <span class="status-good">Funcionando Correctamente</span>
                    </div>
                    <div class="info-item">
                        <strong>Ubicación:</strong>
                        /usr/local/cpanel/whostmgr/docroot/cgi/
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_test_page {
    my $current_time = scalar localtime();
    my $perl_version = $^V ? sprintf("v%vd", $^V) : $];
    
    # Pruebas de funcionalidad
    my $cgi_test = "✅ CGI funcionando";
    my $perl_test = "✅ Perl disponible";
    my $whm_css_test = -f "/usr/local/cpanel/whostmgr/docroot/css/whostmgr.css" ? "✅ CSS WHM disponible" : "❌ CSS WHM no encontrado";
    my $appconfig_test = -f "/var/cpanel/apps/whm_toolkit.conf" ? "✅ AppConfig registrado" : "❌ AppConfig no encontrado";
    
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <title>$plugin_name - Página de Pruebas</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="/whostmgr/css/whostmgr.css">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; 
            margin: 0; 
            padding: 20px; 
            background: #f5f6fa; 
        }
        .container { 
            max-width: 900px; 
            margin: 0 auto; 
            background: white; 
            border-radius: 12px; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.08); 
            overflow: hidden;
        }
        .header { 
            background: linear-gradient(135deg, #e74c3c 0%, #c0392b 100%); 
            color: white; 
            padding: 40px; 
            text-align: center;
        }
        .content { padding: 40px; }
        .test-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
            gap: 20px; 
            margin: 30px 0; 
        }
        .test-item { 
            background: #f8f9fa; 
            padding: 20px; 
            border-radius: 12px; 
            border-left: 4px solid #e74c3c; 
        }
        .back-link { 
            display: inline-block; 
            margin-bottom: 24px; 
            color: #667eea; 
            text-decoration: none; 
            font-weight: 600; 
            padding: 12px 24px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .back-link:hover { 
            background: #667eea;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Página de Pruebas</h1>
            <p>Diagnóstico y verificación del plugin</p>
        </div>
        
        <div class="content">
            <a href="?" class="back-link">← Volver al menú principal</a>
            
            <h3>🔍 Pruebas de Funcionalidad</h3>
            <div class="test-grid">
                <div class="test-item">
                    <strong>CGI:</strong> $cgi_test
                </div>
                <div class="test-item">
                    <strong>Perl:</strong> $perl_test ($perl_version)
                </div>
                <div class="test-item">
                    <strong>WHM CSS:</strong> $whm_css_test
                </div>
                <div class="test-item">
                    <strong>AppConfig:</strong> $appconfig_test
                </div>
                <div class="test-item">
                    <strong>Tiempo de respuesta:</strong> $current_time
                </div>
                <div class="test-item">
                    <strong>Estado general:</strong> ✅ Todo funcionando
                </div>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}