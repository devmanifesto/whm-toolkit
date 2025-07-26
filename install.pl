#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use File::Path;
use Getopt::Long;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_dir = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";

# Variables de configuración
my $install_dir = "";
my $force_install = 0;
my $verbose = 0;

# Procesar argumentos de línea de comandos
GetOptions(
    "install-dir=s" => \$install_dir,
    "force" => \$force_install,
    "verbose" => \$verbose,
    "help" => sub { show_help(); exit 0; }
);

# Mostrar información de instalación
print "=== Instalación de $plugin_name v$plugin_version ===\n\n";

# Verificar si ya está instalado
if (-d $plugin_dir && !$force_install) {
    print "El plugin ya está instalado en $plugin_dir\n";
    print "Usa --force para reinstalar\n";
    exit 1;
}

# Crear directorio del plugin
print "Creando directorio del plugin...\n";
if (-d $plugin_dir) {
    print "  - El directorio ya existe, continuando...\n";
} else {
    unless (mkdir($plugin_dir, 0755)) {
        die "Error: No se pudo crear el directorio $plugin_dir: $!\n";
    }
    print "  - Directorio creado exitosamente\n";
}

# Copiar archivos del plugin
print "Copiando archivos del plugin...\n";

# Copiar archivo principal
if (-f "whm-toolkit.cgi") {
    if (-f "$plugin_dir/whm-toolkit.cgi" && $force_install) {
        print "  - Sobrescribiendo whm-toolkit.cgi existente...\n";
    }
    copy("whm-toolkit.cgi", "$plugin_dir/whm-toolkit.cgi") or die "Error copiando whm-toolkit.cgi: $!\n";
    chmod(0755, "$plugin_dir/whm-toolkit.cgi");
    print "  - whm-toolkit.cgi copiado\n";
} else {
    die "Error: No se encontró el archivo whm-toolkit.cgi\n";
}

# Copiar archivo de configuración
if (-f "whm-toolkit.conf") {
    if (-f "$plugin_dir/whm-toolkit.conf" && $force_install) {
        print "  - Sobrescribiendo whm-toolkit.conf existente...\n";
    }
    copy("whm-toolkit.conf", "$plugin_dir/whm-toolkit.conf") or die "Error copiando whm-toolkit.conf: $!\n";
    print "  - whm-toolkit.conf copiado\n";
}

# Crear archivo de registro
my $log_file = "/var/log/whm-toolkit.log";
if (-f $log_file) {
    print "  - Archivo de log ya existe: $log_file\n";
} else {
    open(my $log, ">", $log_file) or die "Error creando archivo de log: $!\n";
    close($log);
    chmod(0644, $log_file);
    print "  - Archivo de log creado: $log_file\n";
}

# Crear directorio de respaldo
my $backup_dir = "/backup/whm-toolkit";
if (-d $backup_dir) {
    print "  - Directorio de respaldo ya existe: $backup_dir\n";
} else {
    unless (mkdir($backup_dir, 0755)) {
        warn "Advertencia: No se pudo crear el directorio de respaldo $backup_dir\n";
    } else {
        print "  - Directorio de respaldo creado: $backup_dir\n";
    }
}

# Registrar el plugin en WHM
print "Registrando plugin en WHM...\n";
register_plugin_in_whm();

# Configurar permisos
print "Configurando permisos...\n";
system("chown -R root:root $plugin_dir");
system("chmod -R 755 $plugin_dir");

print "\n=== Instalación completada exitosamente ===\n";
print "El plugin $plugin_name v$plugin_version ha sido instalado en:\n";
print "  $plugin_dir\n\n";
print "Para acceder al plugin:\n";
print "1. Inicia sesión en WHM\n";
print "2. Ve a 'Plugins' en el menú lateral\n";
print "3. Busca '$plugin_name' y haz clic en él\n\n";
print "Para desinstalar, ejecuta: perl uninstall.pl\n";

sub register_plugin_in_whm {
    # Crear entrada en el registro de plugins de WHM
    my $whm_plugins_file = "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf";
    
    # Verificar si el archivo existe
    unless (-f $whm_plugins_file) {
        # Crear archivo si no existe
        open(my $fh, ">", $whm_plugins_file) or die "Error creando archivo de plugins: $!\n";
        close($fh);
        chmod(0644, $whm_plugins_file);
    }
    
    # Verificar si el plugin ya está registrado
    my $plugin_registered = 0;
    if (-f $whm_plugins_file) {
        open(my $fh, "<", $whm_plugins_file) or die "Error abriendo archivo de plugins: $!\n";
        while (my $line = <$fh>) {
            if ($line =~ /^whm-toolkit\|/) {
                $plugin_registered = 1;
                last;
            }
        }
        close($fh);
    }
    
    if ($plugin_registered && $force_install) {
        # Eliminar entrada existente
        open(my $fh, "<", $whm_plugins_file) or die "Error abriendo archivo de plugins: $!\n";
        my @lines = <$fh>;
        close($fh);
        
        my @new_lines = grep { !/^whm-toolkit\|/ } @lines;
        
        open(my $fh, ">", $whm_plugins_file) or die "Error escribiendo archivo de plugins: $!\n";
        print $fh @new_lines;
        close($fh);
        
        print "  - Entrada existente del plugin eliminada\n";
    }
    
    # Agregar entrada del plugin
    open(my $fh, ">>", $whm_plugins_file) or die "Error abriendo archivo de plugins: $!\n";
    print $fh "whm-toolkit|$plugin_name|$plugin_version|$plugin_dir/whm-toolkit.cgi|Advanced|Tools|1\n";
    close($fh);
    
    if ($plugin_registered && $force_install) {
        print "  - Plugin re-registrado en WHM\n";
    } else {
        print "  - Plugin registrado en WHM\n";
    }
    
    # También registrar en el archivo de configuración de WHM
    my $whm_config_file = "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf";
    if ($whm_config_file ne $whm_plugins_file) {
        open(my $fh, ">>", $whm_config_file) or die "Error abriendo archivo de configuración de WHM: $!\n";
        print $fh "whm-toolkit|$plugin_name|$plugin_version|$plugin_dir/whm-toolkit.cgi|Advanced|Tools|1\n";
        close($fh);
        print "  - Plugin registrado en configuración de WHM\n";
    }
    
    # Crear enlace simbólico si es necesario
    my $symlink_path = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";
    unless (-l $symlink_path) {
        if (-d $symlink_path) {
            print "  - Directorio de plugin ya existe\n";
        } else {
            symlink($plugin_dir, $symlink_path) or warn "Advertencia: No se pudo crear enlace simbólico: $!\n";
            print "  - Enlace simbólico creado\n";
        }
    }
    
    # Forzar recarga de configuración de WHM
    system("touch /usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf");
    print "  - Configuración de WHM actualizada\n";
}

sub show_help {
    print "Uso: perl install.pl [opciones]\n\n";
    print "Opciones:\n";
    print "  --install-dir DIR    Directorio de instalación personalizado\n";
    print "  --force              Forzar reinstalación\n";
    print "  --verbose            Mostrar información detallada\n";
    print "  --help               Mostrar esta ayuda\n\n";
    print "Ejemplo:\n";
    print "  perl install.pl --force --verbose\n";
} 