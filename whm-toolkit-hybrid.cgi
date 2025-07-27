#!/usr/bin/perl

# WHM Toolkit Plugin - Versión Híbrida
# Intenta usar el framework de WHM, con fallback a standalone

use strict;
use warnings;

# Variables del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_description = "Herramientas útiles para administración de WHM";

# Función para obtener parámetros de la URL
sub get_param {
    my ($param_name) = @_;
    my $query_string = $ENV{'QUERY_STRING'} || '';
    
    foreach my $pair (split /&/, $query_string) {
        my ($name, $value) = split /=/, $pair;
        if (defined $name && defined $value) {
            $name =~ tr/+/ /;
            $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
            $value =~ tr/+/ /;
            $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
            
            if ($name eq $param_name) {
                return $value;
            }
        }
    }
    return '';
}

# Función para intentar cargar el framework de WHM
sub try_whm_framework {
    my $whm_available = 0;
    my $whm;
    
    eval {
        # Intentar cargar los módulos de WHM
        require lib;
        lib->import('/usr/local/cpanel');
        
        eval 'use Whostmgr::HTMLInterface ()';
        die $@ if $@;
        
        eval 'use Cpanel::Hostname ()';
        die $@ if $@;
        
        # Si llegamos aquí, los módulos están disponibles
        $whm = Whostmgr::HTMLInterface->new();
        $whm_available = 1;
    };
    
    if ($@) {
        # Los módulos no están disponibles o hay un error
        $whm_available = 0;
    }
    
    return ($whm_available, $whm);
}

# Función para generar contenido usando framework WHM
sub generate_whm_content {
    my ($whm, $action) = @_;
    
    # Configurar el título de la página
    $whm->set_page_title($plugin_name);
    
    # Contenido principal según la acción
    my $content = '';
    
    if ($action eq 'hello_world') {
        $content = generate_hello_world_content_whm();
    } else {
        $content = generate_main_content_whm();
    }
    
    # Generar la página completa usando el template de WHM
    print $whm->header();
    print $content;
    print $whm->footer();
}

# Función para generar contenido standalone
sub generate_standalone_content {
    my $action = get_param('action') || 'main';
    
    print "Content-Type: text/html; charset=UTF-8\n\n";
    
    print qq{
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
            background: #f5f5f5;
            color: #333;
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
            padding: 30px;
            text-align: center;
            position: relative;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header p {
            margin: 10px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        .info-badge {
            position: absolute;
            top: 20px;
            right: 20px;
            background: rgba(255,255,255,0.2);
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .content {
            padding: 30px;
        }
        .status {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }
        .tool-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            transition: all 0.3s ease;
            cursor: pointer;
            background: white;
        }
        .tool-card:hover {
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
            border-color: #667eea;
        }
        .tool-card.active {
            border-color: #667eea;
            background: #f8f9ff;
        }
        .tool-card h3 {
            margin: 0 0 10px 0;
            color: #333;
            font-size: 1.2em;
        }
        .tool-card p {
            margin: 0;
            color: #666;
            line-height: 1.5;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .info-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }
        h2 {
            color: #333;
            border-bottom: 2px solid #eee;
            padding-bottom: 10px;
            margin-top: 30px;
        }
        .breadcrumb {
            background: #e9ecef;
            padding: 10px 20px;
            margin: -20px -20px 20px -20px;
            font-size: 0.9em;
        }
        .breadcrumb a {
            color: #667eea;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .framework-notice {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="breadcrumb">
            <a href="/whostmgr/">WHM</a> → <a href="/cgi/addon_plugins">Plugins</a> → $plugin_name
        </div>
        <div class="header">
            <h1>$plugin_name</h1>
            <p>$plugin_description</p>
            <span class="info-badge">v$plugin_version</span>
        </div>
        <div class="content">
            <div class="framework-notice">
                <strong>ℹ️ Modo Standalone:</strong> El plugin está funcionando en modo standalone porque el framework de WHM no está disponible.
            </div>
    };
    
    if ($action eq 'hello_world') {
        print generate_hello_world_content_standalone();
    } else {
        print generate_main_content_standalone();
    }
    
    print qq{
        </div>
    </div>
</body>
</html>
    };
}

# Contenido principal para WHM framework
sub generate_main_content_whm {
    my $hostname = eval { 
        require Cpanel::Hostname;
        Cpanel::Hostname::gethostname();
    } || 'localhost';
    
    return qq{
        <div class="section">
            <h1>$plugin_name</h1>
            <p class="description">$plugin_description</p>
            <div class="version-info">Versión: $plugin_version</div>
        </div>
        
        <div class="section">
            <div class="status-box success">
                <strong>✅ Estado:</strong> Plugin integrado con framework WHM
            </div>
        </div>
        
        <div class="section">
            <h2>🛠️ Herramientas Disponibles</h2>
            <div class="item-list">
                <div class="item">
                    <h3><a href="?action=hello_world">🚀 Hello World</a></h3>
                    <p>Prueba básica del plugin con framework WHM</p>
                </div>
            </div>
        </div>
    };
}

# Contenido Hello World para WHM framework
sub generate_hello_world_content_whm {
    my $hostname = eval { 
        require Cpanel::Hostname;
        Cpanel::Hostname::gethostname();
    } || 'localhost';
    
    return qq{
        <div class="section">
            <h1>🚀 Hello World - WHM Framework</h1>
            <p><a href="?">&larr; Volver al menú principal</a></p>
        </div>
        
        <div class="section">
            <div class="status-box success">
                <h2>¡Framework WHM Funcionando!</h2>
                <p>Este plugin está usando el framework oficial de WHM con Template Toolkit.</p>
            </div>
        </div>
        
        <div class="section">
            <h2>📋 Información del Servidor</h2>
            <p><strong>Hostname:</strong> $hostname</p>
            <p><strong>Framework:</strong> WHM Template Toolkit</p>
        </div>
    };
}

# Contenido principal para modo standalone
sub generate_main_content_standalone {
    my $hostname = eval { 
        chomp(my $h = `hostname 2>/dev/null`);
        $h || 'localhost';
    } || 'localhost';
    
    return qq{
            <div class="status">
                <strong>✅ Estado:</strong> Plugin funcionando en modo standalone
            </div>
            
            <h2>🛠️ Herramientas Disponibles</h2>
            <div class="tools-grid">
                <div class="tool-card active" onclick="location.href='?action=hello_world'">
                    <h3>🚀 Hello World</h3>
                    <p>Prueba básica del plugin en modo standalone</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>📊 Análisis de Sistema</h3>
                    <p>Información detallada sobre el estado del servidor</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>🌐 Gestor de Dominios</h3>
                    <p>Administración avanzada de dominios</p>
                </div>
            </div>
            
            <h2>ℹ️ Información del Sistema</h2>
            <div class="info-grid">
                <div class="info-item">
                    <strong>Servidor:</strong> $hostname
                </div>
                <div class="info-item">
                    <strong>Plugin:</strong> $plugin_name v$plugin_version
                </div>
                <div class="info-item">
                    <strong>Modo:</strong> Standalone
                </div>
            </div>
    };
}

# Contenido Hello World para modo standalone
sub generate_hello_world_content_standalone {
    my $hostname = eval { 
        chomp(my $h = `hostname 2>/dev/null`);
        $h || 'localhost';
    } || 'localhost';
    
    my $current_time = scalar localtime();
    my $perl_version = $^V ? sprintf("v%vd", $^V) : $];
    
    return qq{
            <div class="status">
                <strong>🚀 Hello World - Modo Standalone</strong>
            </div>
            <p><a href="?">&larr; Volver al menú principal</a></p>
            
            <h2>📋 Información del Servidor</h2>
            <div class="info-grid">
                <div class="info-item">
                    <strong>Hostname:</strong> $hostname
                </div>
                <div class="info-item">
                    <strong>Fecha y Hora:</strong> $current_time
                </div>
                <div class="info-item">
                    <strong>Versión de Perl:</strong> $perl_version
                </div>
                <div class="info-item">
                    <strong>Modo:</strong> Standalone (Framework WHM no disponible)
                </div>
            </div>
            
            <h2>🔧 Variables de Entorno</h2>
            <div class="info-item">
                <pre style="margin: 0; font-size: 0.9em;">
REQUEST_METHOD: $ENV{'REQUEST_METHOD'}
QUERY_STRING: $ENV{'QUERY_STRING'}
HTTP_HOST: $ENV{'HTTP_HOST'}
SERVER_SOFTWARE: $ENV{'SERVER_SOFTWARE'}
                </pre>
            </div>
    };
}

# Punto de entrada principal
my $action = get_param('action') || 'main';

# Intentar usar el framework de WHM
my ($whm_available, $whm) = try_whm_framework();

if ($whm_available && $whm) {
    # Usar el framework de WHM
    generate_whm_content($whm, $action);
} else {
    # Usar modo standalone
    generate_standalone_content();
} 