#!/usr/bin/perl

use strict;
use warnings;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_dir = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";

print "=== Verificación y Corrección del Plugin WHM Toolkit ===\n\n";

# Verificar si el directorio del plugin existe
print "1. Verificando directorio del plugin...\n";
if (-d $plugin_dir) {
    print "  ✓ Directorio del plugin existe: $plugin_dir\n";
} else {
    print "  ✗ Directorio del plugin NO existe: $plugin_dir\n";
    print "    Ejecuta primero: perl install.pl --force\n";
    exit 1;
}

# Verificar si el archivo principal existe
print "\n2. Verificando archivo principal...\n";
my $main_file = "$plugin_dir/whm-toolkit.cgi";
if (-f $main_file) {
    print "  ✓ Archivo principal existe: $main_file\n";
    
    # Verificar permisos
    my $mode = (stat($main_file))[2];
    my $permissions = sprintf("%04o", $mode & 07777);
    print "  - Permisos actuales: $permissions\n";
    
    if ($permissions ne "0755") {
        print "  - Corrigiendo permisos...\n";
        chmod(0755, $main_file);
        print "  ✓ Permisos corregidos a 0755\n";
    }
} else {
    print "  ✗ Archivo principal NO existe: $main_file\n";
    exit 1;
}

# Verificar archivos de configuración de WHM
print "\n3. Verificando archivos de configuración de WHM...\n";

my @config_files = (
    "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf",
    "/usr/local/cpanel/whostmgr/addonfeatures/whm_plugins.conf",
    "/usr/local/cpanel/whostmgr/addonfeatures/plugins.conf"
);

foreach my $config_file (@config_files) {
    if (-f $config_file) {
        print "  ✓ Archivo de configuración existe: $config_file\n";
        
        # Verificar si el plugin está registrado
        open(my $fh, "<", $config_file) or next;
        my $found = 0;
        while (my $line = <$fh>) {
            if ($line =~ /^whm-toolkit\|/) {
                $found = 1;
                print "  ✓ Plugin registrado en: $config_file\n";
                print "    Línea: $line";
                last;
            }
        }
        close($fh);
        
        if (!$found) {
            print "  ✗ Plugin NO registrado en: $config_file\n";
            print "  - Agregando registro...\n";
            
            open(my $fh, ">>", $config_file) or die "Error abriendo $config_file: $!\n";
            print $fh "whm-toolkit|$plugin_name|$plugin_version|$plugin_dir/whm-toolkit.cgi|Advanced|Tools|1\n";
            close($fh);
            print "  ✓ Plugin registrado en: $config_file\n";
        }
    } else {
        print "  - Archivo de configuración no existe: $config_file\n";
    }
}

# Verificar enlaces simbólicos
print "\n4. Verificando enlaces simbólicos...\n";
my $symlink_path = "/usr/local/cpanel/whostmgr/addonfeatures/whm-toolkit";
if (-l $symlink_path) {
    print "  ✓ Enlace simbólico existe: $symlink_path\n";
    my $target = readlink($symlink_path);
    print "  - Apunta a: $target\n";
} elsif (-d $symlink_path) {
    print "  ✓ Directorio de plugin existe: $symlink_path\n";
} else {
    print "  ✗ Enlace simbólico NO existe: $symlink_path\n";
    print "  - Creando enlace simbólico...\n";
    symlink($plugin_dir, $symlink_path) or warn "Error creando enlace simbólico: $!\n";
    print "  ✓ Enlace simbólico creado\n";
}

# Verificar permisos del directorio
print "\n5. Verificando permisos del directorio...\n";
my $dir_mode = (stat($plugin_dir))[2];
my $dir_permissions = sprintf("%04o", $dir_mode & 07777);
print "  - Permisos del directorio: $dir_permissions\n";

if ($dir_permissions ne "0755") {
    print "  - Corrigiendo permisos del directorio...\n";
    chmod(0755, $plugin_dir);
    print "  ✓ Permisos del directorio corregidos\n";
}

# Verificar propietario
print "\n6. Verificando propietario...\n";
my ($uid, $gid) = (stat($plugin_dir))[4, 5];
my $owner = getpwuid($uid) || $uid;
my $group = getgrgid($gid) || $gid;
print "  - Propietario actual: $owner:$group\n";

if ($owner ne "root") {
    print "  - Cambiando propietario a root...\n";
    system("chown -R root:root $plugin_dir");
    print "  ✓ Propietario cambiado a root\n";
}

# Forzar recarga de configuración
print "\n7. Forzando recarga de configuración...\n";
foreach my $config_file (@config_files) {
    if (-f $config_file) {
        system("touch $config_file");
        print "  ✓ Archivo actualizado: $config_file\n";
    }
}

# Verificar que el plugin sea ejecutable
print "\n8. Verificando ejecutabilidad...\n";
if (-x $main_file) {
    print "  ✓ El archivo principal es ejecutable\n";
} else {
    print "  ✗ El archivo principal NO es ejecutable\n";
    chmod(0755, $main_file);
    print "  ✓ Permisos de ejecución agregados\n";
}

print "\n=== Verificación completada ===\n";
print "\nSi el plugin aún no aparece en WHM:\n";
print "1. Limpia el caché del navegador\n";
print "2. Cierra sesión y vuelve a iniciar sesión en WHM\n";
print "3. Verifica que estés usando la URL correcta de WHM\n";
print "4. Revisa los logs de WHM: tail -f /usr/local/cpanel/logs/error_log\n";
print "\nPara acceder directamente al plugin:\n";
print "https://tu-servidor:2087/whostmgr/addonfeatures/whm-toolkit/whm-toolkit.cgi\n"; 