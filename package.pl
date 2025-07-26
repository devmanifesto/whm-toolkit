#!/usr/bin/perl

use strict;
use warnings;
use File::Path;
use Archive::Tar;
use Compress::Zlib;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $package_name = "whm-toolkit-v$plugin_version";

# Lista de archivos a incluir en el paquete
my @files_to_package = (
    'whm-toolkit.cgi',
    'whm-toolkit.conf',
    'install.pl',
    'uninstall.pl',
    'README.md',
    'package.pl'
);

print "=== Empaquetando $plugin_name v$plugin_version ===\n\n";

# Verificar que todos los archivos existan
print "Verificando archivos...\n";
foreach my $file (@files_to_package) {
    if (-f $file) {
        print "  ✓ $file\n";
    } else {
        die "Error: No se encontró el archivo $file\n";
    }
}

# Crear directorio temporal
my $temp_dir = "/tmp/$package_name";
if (-d $temp_dir) {
    rmtree($temp_dir);
}
mkdir($temp_dir, 0755) or die "Error creando directorio temporal: $!\n";

# Copiar archivos al directorio temporal
print "\nCopiando archivos al paquete...\n";
foreach my $file (@files_to_package) {
    system("cp $file $temp_dir/") == 0 or die "Error copiando $file: $!\n";
    print "  - $file copiado\n";
}

# Crear archivo de información del paquete
my $package_info = "$temp_dir/PACKAGE_INFO";
open(my $info, ">", $package_info) or die "Error creando archivo de información: $!\n";
print $info "PLUGIN_NAME=$plugin_name\n";
print $info "PLUGIN_VERSION=$plugin_version\n";
print $info "PACKAGE_DATE=" . localtime() . "\n";
print $info "PACKAGE_FILES=" . join(",", @files_to_package) . "\n";
close($info);
print "  - PACKAGE_INFO creado\n";

# Crear archivo de instalación rápida
my $quick_install = "$temp_dir/quick_install.sh";
open(my $qi, ">", $quick_install) or die "Error creando script de instalación rápida: $!\n";
print $qi "#!/bin/bash\n";
print $qi "# Script de instalación rápida para $plugin_name v$plugin_version\n\n";
print $qi "echo \"Instalando $plugin_name v$plugin_version...\"\n";
print $qi "perl install.pl --force --verbose\n";
print $qi "echo \"Instalación completada.\"\n";
close($qi);
chmod(0755, $quick_install);
print "  - quick_install.sh creado\n";

# Crear archivo tar.gz
print "\nCreando archivo de distribución...\n";
my $tar_file = "$package_name.tar.gz";

# Usar tar para crear el archivo
my $tar_cmd = "cd /tmp && tar -czf $tar_file $package_name/";
system($tar_cmd) == 0 or die "Error creando archivo tar.gz: $!\n";

# Mover el archivo al directorio actual
system("mv /tmp/$tar_file ./") == 0 or die "Error moviendo archivo: $!\n";

# Limpiar directorio temporal
rmtree($temp_dir);

# Verificar el archivo creado
my $file_size = -s $tar_file;
my $file_size_mb = sprintf("%.2f", $file_size / 1024 / 1024);

print "\n=== Empaquetado completado exitosamente ===\n";
print "Archivo creado: $tar_file\n";
print "Tamaño: $file_size_mb MB\n";
print "Ubicación: " . `pwd` . "\n";

print "\nPara instalar el plugin:\n";
print "1. Sube $tar_file a tu servidor WHM\n";
print "2. Extrae el archivo: tar -xzf $tar_file\n";
print "3. Ejecuta: perl install.pl --force --verbose\n";
print "4. O usa el script rápido: ./quick_install.sh\n";

print "\nContenido del paquete:\n";
foreach my $file (@files_to_package) {
    print "  - $file\n";
}
print "  - PACKAGE_INFO\n";
print "  - quick_install.sh\n"; 