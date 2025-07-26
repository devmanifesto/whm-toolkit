#!/usr/bin/perl

use strict;
use warnings;
use File::Path;
use Getopt::Long;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_dir = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";

# Variables de configuración
my $force_uninstall = 0;
my $keep_backup = 0;
my $verbose = 0;

# Procesar argumentos de línea de comandos
GetOptions(
    "force" => \$force_uninstall,
    "keep-backup" => \$keep_backup,
    "verbose" => \$verbose,
    "help" => sub { show_help(); exit 0; }
);

# Mostrar información de desinstalación
print "=== Desinstalación de $plugin_name v$plugin_version ===\n\n";

# Verificar si está instalado
unless (-d $plugin_dir) {
    print "El plugin no está instalado en $plugin_dir\n";
    exit 0;
}

# Confirmar desinstalación
unless ($force_uninstall) {
    print "¿Estás seguro de que quieres desinstalar $plugin_name? (y/N): ";
    my $response = <STDIN>;
    chomp($response);
    unless ($response =~ /^[yY]$/) {
        print "Desinstalación cancelada.\n";
        exit 0;
    }
}

# Crear respaldo antes de desinstalar
if (!$keep_backup) {
    print "Creando respaldo antes de desinstalar...\n";
    my $backup_dir = "/backup/whm-toolkit/backup_" . time();
    unless (mkdir($backup_dir, 0755)) {
        warn "Advertencia: No se pudo crear el directorio de respaldo $backup_dir\n";
    } else {
        system("cp -r $plugin_dir/* $backup_dir/");
        print "  - Respaldo creado en: $backup_dir\n";
    }
}

# Eliminar registro del plugin en WHM
print "Eliminando registro del plugin en WHM...\n";
remove_plugin_from_whm();

# Eliminar archivos del plugin
print "Eliminando archivos del plugin...\n";
if (rmtree($plugin_dir)) {
    print "  - Directorio del plugin eliminado: $plugin_dir\n";
} else {
    warn "Advertencia: No se pudo eliminar completamente el directorio $plugin_dir\n";
}

# Eliminar archivo de log
my $log_file = "/var/log/whm-toolkit.log";
if (-f $log_file) {
    unlink($log_file) or warn "Advertencia: No se pudo eliminar el archivo de log $log_file\n";
    print "  - Archivo de log eliminado: $log_file\n";
}

# Limpiar directorio de respaldo si está vacío
my $backup_base_dir = "/backup/whm-toolkit";
if (-d $backup_base_dir && !$keep_backup) {
    my @files = glob("$backup_base_dir/*");
    if (@files == 0) {
        rmdir($backup_base_dir) or warn "Advertencia: No se pudo eliminar el directorio de respaldo vacío\n";
        print "  - Directorio de respaldo vacío eliminado\n";
    }
}

print "\n=== Desinstalación completada exitosamente ===\n";
print "El plugin $plugin_name v$plugin_version ha sido desinstalado.\n\n";

if (!$keep_backup) {
    print "Nota: Se ha creado un respaldo de los archivos del plugin.\n";
    print "Si necesitas restaurar, puedes encontrar los archivos en /backup/whm-toolkit/\n\n";
}

sub remove_plugin_from_whm {
    # Eliminar entrada del registro de plugins de WHM
    my $whm_plugins_file = "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf";
    
    unless (-f $whm_plugins_file) {
        print "  - Archivo de plugins no encontrado\n";
        return;
    }
    
    # Leer archivo y eliminar línea del plugin
    open(my $fh, "<", $whm_plugins_file) or die "Error abriendo archivo de plugins: $!\n";
    my @lines = <$fh>;
    close($fh);
    
    my @new_lines = grep { !/^whm-toolkit\|/ } @lines;
    
    # Escribir archivo actualizado
    open(my $fh, ">", $whm_plugins_file) or die "Error escribiendo archivo de plugins: $!\n";
    print $fh @new_lines;
    close($fh);
    
    print "  - Plugin eliminado del registro de WHM\n";
}

sub show_help {
    print "Uso: perl uninstall.pl [opciones]\n\n";
    print "Opciones:\n";
    print "  --force              Forzar desinstalación sin confirmación\n";
    print "  --keep-backup        Mantener archivos de respaldo\n";
    print "  --verbose            Mostrar información detallada\n";
    print "  --help               Mostrar esta ayuda\n\n";
    print "Ejemplo:\n";
    print "  perl uninstall.pl --force --verbose\n";
} 