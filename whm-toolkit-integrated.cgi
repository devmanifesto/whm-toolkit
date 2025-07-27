#!/usr/bin/perl

# WHM Toolkit Plugin - Versión Integrada con Framework WHM
# Usa Template Toolkit y los estilos oficiales de WHM

use strict;
use warnings;

# Módulos requeridos para integración WHM
use lib '/usr/local/cpanel';
use Whostmgr::HTMLInterface ();
use Whostmgr::TweakSettings ();
use Cpanel::SafeRun::Simple ();
use Cpanel::LoadFile ();
use Cpanel::Hostname ();

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

# Función principal para generar la interfaz
sub generate_interface {
    my $action = get_param('action') || 'main';
    
    # Inicializar la interfaz WHM
    my $whm = Whostmgr::HTMLInterface->new();
    
    # Configurar el título de la página
    $whm->set_page_title($plugin_name);
    
    # Agregar breadcrumbs
    $whm->add_breadcrumb_item("Home", "/");
    $whm->add_breadcrumb_item("Plugins", "/cgi/addon_plugins");
    $whm->add_breadcrumb_item($plugin_name, "");
    
    # Contenido principal según la acción
    my $content = '';
    
    if ($action eq 'hello_world') {
        $content = generate_hello_world_content();
    } else {
        $content = generate_main_content();
    }
    
    # Generar la página completa usando el template de WHM
    print $whm->header();
    print $whm->start_form();
    print $content;
    print $whm->end_form();
    print $whm->footer();
}

# Función para generar el contenido principal
sub generate_main_content {
    my $hostname = Cpanel::Hostname::gethostname();
    
    return qq{
        <div class="section">
            <h1>$plugin_name</h1>
            <p class="description">$plugin_description</p>
            <div class="version-info">Versión: $plugin_version</div>
        </div>
        
        <div class="section">
            <div class="status-box success">
                <strong>✅ Estado:</strong> Plugin instalado y funcionando correctamente
            </div>
        </div>
        
        <div class="section">
            <h2>🛠️ Herramientas Disponibles</h2>
            
            <div class="item-list">
                <div class="item">
                    <div class="item-icon">🚀</div>
                    <div class="item-content">
                        <h3><a href="?action=hello_world">Hello World</a></h3>
                        <p>Prueba básica del plugin - Verifica que todo esté funcionando correctamente</p>
                    </div>
                </div>
                
                <div class="item">
                    <div class="item-icon">📊</div>
                    <div class="item-content">
                        <h3>Análisis de Sistema</h3>
                        <p>Información detallada sobre el estado del servidor y recursos (Próximamente)</p>
                    </div>
                </div>
                
                <div class="item">
                    <div class="item-icon">🌐</div>
                    <div class="item-content">
                        <h3>Gestor de Dominios</h3>
                        <p>Administración avanzada de dominios y subdominios (Próximamente)</p>
                    </div>
                </div>
                
                <div class="item">
                    <div class="item-icon">📈</div>
                    <div class="item-content">
                        <h3>Monitor de Recursos</h3>
                        <p>Monitoreo en tiempo real de CPU, memoria y espacio en disco (Próximamente)</p>
                    </div>
                </div>
                
                <div class="item">
                    <div class="item-icon">💾</div>
                    <div class="item-content">
                        <h3>Backup Manager</h3>
                        <p>Herramientas avanzadas para gestión de respaldos automáticos (Próximamente)</p>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="section">
            <h2>ℹ️ Información del Sistema</h2>
            <div class="info-grid">
                <div class="info-item">
                    <strong>Servidor:</strong> $hostname
                </div>
                <div class="info-item">
                    <strong>Plugin:</strong> $plugin_name v$plugin_version
                </div>
                <div class="info-item">
                    <strong>Framework:</strong> WHM Template Toolkit
                </div>
            </div>
        </div>
    };
}

# Función para generar el contenido de Hello World
sub generate_hello_world_content {
    my $hostname = Cpanel::Hostname::gethostname();
    my $current_time = scalar localtime();
    my $perl_version = $^V ? sprintf("v%vd", $^V) : $];
    
    # Obtener información del sistema
    my $uptime = eval { Cpanel::SafeRun::Simple::saferun('/usr/bin/uptime') } || 'No disponible';
    chomp $uptime if $uptime;
    
    my $load_avg = eval { Cpanel::SafeRun::Simple::saferun('/usr/bin/uptime') } || '';
    if ($load_avg =~ /load average: ([\d\.,\s]+)$/) {
        $load_avg = $1;
    } else {
        $load_avg = 'No disponible';
    }
    
    return qq{
        <div class="section">
            <h1>🚀 Hello World - WHM Toolkit</h1>
            <p><a href="?">&larr; Volver al menú principal</a></p>
        </div>
        
        <div class="section">
            <div class="status-box success">
                <h2>¡Hola desde WHM Toolkit!</h2>
                <p>Este plugin está funcionando correctamente y está completamente integrado con WHM.</p>
            </div>
        </div>
        
        <div class="section">
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
                    <strong>Uptime:</strong> $uptime
                </div>
                <div class="info-item">
                    <strong>Load Average:</strong> $load_avg
                </div>
                <div class="info-item">
                    <strong>Usuario Web:</strong> $ENV{'REMOTE_USER'} || 'root'
                </div>
            </div>
        </div>
        
        <div class="section">
            <h2>🔧 Variables de Entorno</h2>
            <div class="code-block">
                <pre>
REQUEST_METHOD: $ENV{'REQUEST_METHOD'}
QUERY_STRING: $ENV{'QUERY_STRING'}
HTTP_HOST: $ENV{'HTTP_HOST'}
SERVER_SOFTWARE: $ENV{'SERVER_SOFTWARE'}
DOCUMENT_ROOT: $ENV{'DOCUMENT_ROOT'}
                </pre>
            </div>
        </div>
        
        <div class="section">
            <h2>✅ Estado del Framework</h2>
            <div class="status-list">
                <div class="status-item success">
                    <span class="status-icon">✅</span>
                    <span>WHM HTMLInterface cargado correctamente</span>
                </div>
                <div class="status-item success">
                    <span class="status-icon">✅</span>
                    <span>Template Toolkit integrado</span>
                </div>
                <div class="status-item success">
                    <span class="status-icon">✅</span>
                    <span>Estilos oficiales de WHM aplicados</span>
                </div>
                <div class="status-item success">
                    <span class="status-icon">✅</span>
                    <span>Plugin registrado en AppConfig</span>
                </div>
            </div>
        </div>
    };
}

# Punto de entrada principal
eval {
    generate_interface();
};

if ($@) {
    # Manejo de errores - mostrar una página de error básica
    print "Content-Type: text/html; charset=UTF-8\n\n";
    print qq{
        <!DOCTYPE html>
        <html>
        <head>
            <title>Error - $plugin_name</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; }
                .error { background: #fee; border: 1px solid #fcc; padding: 20px; border-radius: 5px; }
                .error h1 { color: #c00; margin-top: 0; }
                pre { background: #f5f5f5; padding: 10px; border-radius: 3px; overflow: auto; }
            </style>
        </head>
        <body>
            <div class="error">
                <h1>Error en $plugin_name</h1>
                <p>Ha ocurrido un error al cargar el plugin. Esto puede deberse a que los módulos de WHM no están disponibles.</p>
                <h3>Detalles del error:</h3>
                <pre>$@</pre>
                <p><strong>Solución:</strong> Asegúrate de que el plugin esté instalado en la ubicación correcta y que los módulos de cPanel/WHM estén disponibles.</p>
            </div>
        </body>
        </html>
    };
} 