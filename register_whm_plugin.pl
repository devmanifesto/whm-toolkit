#!/usr/bin/perl

use strict;
use warnings;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_dir = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";

print "=== Registro del Plugin WHM Toolkit ===\n\n";

# Crear el archivo de configuración del plugin para WHM
my $whm_addon_dir = "/usr/local/cpanel/whostmgr/addonfeatures";
my $plugin_conf_file = "$whm_addon_dir/whm-toolkit.conf";

print "1. Creando archivo de configuración del plugin...\n";

# Si existe un directorio con ese nombre, usar un nombre diferente
if (-d "$whm_addon_dir/whm-toolkit") {
    $plugin_conf_file = "$whm_addon_dir/whm-toolkit-plugin.conf";
    print "  - Directorio existente detectado, usando nombre alternativo\n";
}

# Crear el contenido del archivo de configuración
my $config_content = <<EOF;
#!/usr/bin/perl

package whostmgr::whm_toolkit;

use strict;
use warnings;

sub new {
    my \$class = shift;
    my \$self = {};
    bless \$self, \$class;
    return \$self;
}

sub get_config {
    return {
        'name' => '$plugin_name',
        'version' => '$plugin_version',
        'description' => 'Herramientas útiles para administración de WHM',
        'author' => 'WHM Toolkit Team',
        'url' => '/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi',
        'category' => 'Advanced',
        'subcategory' => 'Tools',
        'icon' => 'whm-toolkit.png',
        'enabled' => 1
    };
}

1;
EOF

# Escribir el archivo de configuración
open(my $fh, ">", $plugin_conf_file) or die "Error creando archivo de configuración: $!\n";
print $fh $config_content;
close($fh);
chmod(0755, $plugin_conf_file);
print "  ✓ Archivo de configuración creado: $plugin_conf_file\n";

# Crear archivo de metadatos del plugin
my $metadata_file = "$plugin_dir/plugin.conf";
print "\n2. Creando archivo de metadatos...\n";

my $metadata_content = <<EOF;
[plugin]
name=$plugin_name
version=$plugin_version
description=Herramientas útiles para administración de WHM
author=WHM Toolkit Team
category=Advanced
subcategory=Tools
url=/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi
enabled=1
icon=whm-toolkit.png

[requirements]
whm_version=11.0
perl_version=5.10

[permissions]
access_level=root
ssl_required=0

[files]
main=whm-toolkit.cgi
config=whm-toolkit.conf
EOF

open(my $meta_fh, ">", $metadata_file) or die "Error creando archivo de metadatos: $!\n";
print $meta_fh $metadata_content;
close($meta_fh);
chmod(0644, $metadata_file);
print "  ✓ Archivo de metadatos creado: $metadata_file\n";

# Registrar en el archivo principal de plugins de WHM
my $main_plugins_file = "/usr/local/cpanel/whostmgr/docroot/cgi/addon_plugins.conf";
print "\n3. Registrando en archivo principal de plugins...\n";

# Crear el archivo si no existe
unless (-f $main_plugins_file) {
    open(my $fh, ">", $main_plugins_file) or die "Error creando archivo principal: $!\n";
    close($fh);
    chmod(0644, $main_plugins_file);
}

# Verificar si ya está registrado
my $already_registered = 0;
if (-f $main_plugins_file) {
    open(my $fh, "<", $main_plugins_file) or die "Error leyendo archivo: $!\n";
    while (my $line = <$fh>) {
        if ($line =~ /whm-toolkit/) {
            $already_registered = 1;
            last;
        }
    }
    close($fh);
}

# Agregar entrada si no está registrado
unless ($already_registered) {
    open(my $fh, ">>", $main_plugins_file) or die "Error escribiendo archivo: $!\n";
    print $fh "whm-toolkit:$plugin_name:$plugin_version:/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi:Advanced:Tools:1\n";
    close($fh);
    print "  ✓ Plugin registrado en archivo principal\n";
} else {
    print "  - Plugin ya registrado en archivo principal\n";
}

# Crear enlace directo en el menú de WHM
my $whm_menu_dir = "/usr/local/cpanel/whostmgr/docroot/cgi/addon";
print "\n4. Creando enlace en menú de WHM...\n";

unless (-d $whm_menu_dir) {
    mkdir($whm_menu_dir, 0755) or warn "Advertencia: No se pudo crear directorio de menú: $!\n";
}

if (-d $whm_menu_dir) {
    my $menu_link = "$whm_menu_dir/whm-toolkit.cgi";
    unless (-f $menu_link) {
        symlink("$plugin_dir/whm-toolkit.cgi", $menu_link) or warn "Error creando enlace de menú: $!\n";
        print "  ✓ Enlace de menú creado\n";
    } else {
        print "  - Enlace de menú ya existe\n";
    }
}

# Actualizar caché de WHM
print "\n5. Actualizando caché de WHM...\n";
system("touch /usr/local/cpanel/whostmgr/docroot/cgi/addon_plugins.conf");
system("touch $plugin_conf_file");
print "  ✓ Caché de WHM actualizado\n";

# Intentar reiniciar servicios web
print "\n6. Reiniciando servicios web...\n";
my @restart_commands = (
    "systemctl reload httpd",
    "systemctl reload apache2", 
    "service httpd reload",
    "service apache2 reload"
);

my $restarted = 0;
foreach my $cmd (@restart_commands) {
    if (system("$cmd 2>/dev/null") == 0) {
        print "  ✓ Servicio reiniciado con: $cmd\n";
        $restarted = 1;
        last;
    }
}

unless ($restarted) {
    print "  - No se pudo reiniciar automáticamente los servicios web\n";
    print "  - Intenta manualmente: systemctl reload httpd\n";
}

print "\n=== Registro completado ===\n";
print "\nAhora intenta acceder al plugin de estas formas:\n\n";
print "1. En WHM, busca en:\n";
print "   - Sección 'Plugins' o 'Add-ons'\n";
print "   - Sección 'Advanced' → 'Tools'\n";
print "   - Busca '$plugin_name'\n\n";

print "2. Acceso directo por URL:\n";
print "   https://tu-servidor:2087/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi\n\n";

print "3. Si aún no aparece:\n";
print "   - Limpia caché del navegador\n";
print "   - Cierra sesión y vuelve a entrar en WHM\n";
print "   - Espera unos minutos para que WHM actualice su caché\n\n";

print "Para verificar logs de errores:\n";
print "tail -f /usr/local/cpanel/logs/error_log\n"; 