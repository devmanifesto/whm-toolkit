#!/usr/bin/perl

use strict;
use warnings;
use CGI;
use Cpanel::JSON ();
use Cpanel::JSON::XS ();
use Cpanel::Lite::WHM ();
use Cpanel::Lite::WHM::API ();
use Cpanel::Lite::WHM::API::Response ();
use Cpanel::Lite::WHM::API::Response::Parser ();
use Cpanel::Lite::WHM::API::Response::Parser::JSON ();
use Cpanel::Lite::WHM::API::Response::Parser::XML ();
use Cpanel::Lite::WHM::API::Response::Parser::YAML ();
use Cpanel::Lite::WHM::API::Response::Parser::CSV ();
use Cpanel::Lite::WHM::API::Response::Parser::TSV ();
use Cpanel::Lite::WHM::API::Response::Parser::HTML ();
use Cpanel::Lite::WHM::API::Response::Parser::Text ();
use Cpanel::Lite::WHM::API::Response::Parser::Raw ();
use Cpanel::Lite::WHM::API::Response::Parser::None ();
use Cpanel::Lite::WHM::API::Response::Parser::Auto ();
use Cpanel::Lite::WHM::API::Response::Parser::JSON::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::XML::LibXML ();
use Cpanel::Lite::WHM::API::Response::Parser::YAML::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::CSV::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::TSV::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::HTML::Parser ();
use Cpanel::Lite::WHM::API::Response::Parser::Text::CSV ();
use Cpanel::Lite::WHM::API::Response::Parser::Raw::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::None::XS ();
use Cpanel::Lite::WHM::API::Response::Parser::Auto::XS ();

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_description = "Herramientas útiles para administración de WHM";

# Obtener parámetros de la solicitud
my $cgi = CGI->new();
my $action = $cgi->param('action') || 'main';

# Configurar headers
print "Content-Type: text/html\n\n";

# Manejar diferentes acciones
if ($action eq 'main') {
    show_main_interface();
} elsif ($action eq 'hello_world') {
    show_hello_world();
} else {
    show_main_interface();
}

sub show_main_interface {
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$plugin_name</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2em;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
        }
        .content {
            padding: 30px;
        }
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .tool-card {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            transition: transform 0.2s, box-shadow 0.2s;
            cursor: pointer;
        }
        .tool-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .tool-card h3 {
            margin: 0 0 10px 0;
            color: #495057;
        }
        .tool-card p {
            margin: 0;
            color: #6c757d;
            font-size: 0.9em;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.2s;
        }
        .btn:hover {
            background: #0056b3;
        }
        .status {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$plugin_name</h1>
            <p>$plugin_description</p>
        </div>
        <div class="content">
            <div class="status">
                <strong>Estado:</strong> Plugin instalado correctamente - Versión $plugin_version
            </div>
            
            <h2>Herramientas Disponibles</h2>
            <div class="tools-grid">
                <div class="tool-card" onclick="location.href='?action=hello_world'">
                    <h3>Hello World</h3>
                    <p>Prueba básica del plugin - muestra un mensaje de saludo</p>
                </div>
                <div class="tool-card">
                    <h3>Análisis de Sistema</h3>
                    <p>Información detallada sobre el estado del servidor</p>
                </div>
                <div class="tool-card">
                    <h3>Gestor de Dominios</h3>
                    <p>Administración avanzada de dominios y subdominios</p>
                </div>
                <div class="tool-card">
                    <h3>Monitor de Recursos</h3>
                    <p>Monitoreo en tiempo real de CPU, memoria y disco</p>
                </div>
                <div class="tool-card">
                    <h3>Backup Manager</h3>
                    <p>Herramientas para gestión de respaldos</p>
                </div>
                <div class="tool-card">
                    <h3>Security Scanner</h3>
                    <p>Escaneo de seguridad y vulnerabilidades</p>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_hello_world {
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World - $plugin_name</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 20px;
            text-align: center;
        }
        .content {
            padding: 30px;
            text-align: center;
        }
        .hello-message {
            font-size: 2em;
            color: #28a745;
            margin: 20px 0;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background 0.2s;
        }
        .btn:hover {
            background: #0056b3;
        }
        .info-box {
            background: #e7f3ff;
            border: 1px solid #b3d9ff;
            border-radius: 5px;
            padding: 15px;
            margin: 20px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>Hello World</h1>
            <p>Prueba del plugin WHM Toolkit</p>
        </div>
        <div class="content">
            <div class="hello-message">
                ¡Hola Mundo! 🚀
            </div>
            <p>El plugin WHM Toolkit está funcionando correctamente.</p>
            
            <div class="info-box">
                <strong>Información del Plugin:</strong><br>
                Nombre: $plugin_name<br>
                Versión: $plugin_version<br>
                Descripción: $plugin_description
            </div>
            
            <a href="?action=main" class="btn">Volver al Menú Principal</a>
        </div>
    </div>
</body>
</html>
HTML
} 