#!/usr/bin/perl

use strict;
use warnings;

print "=== Prueba del Plugin WHM Toolkit ===\n\n";

my $plugin_dir = "/usr/local/cpanel/whostmgr/docroot/cgi/whm-toolkit";
my $main_file = "$plugin_dir/index.cgi";

print "1. Verificando instalación...\n";

# Verificar directorio
if (-d $plugin_dir) {
    print "  ✓ Directorio del plugin existe: $plugin_dir\n";
} else {
    print "  ✗ Directorio del plugin NO existe\n";
    exit 1;
}

# Verificar archivo principal
if (-f $main_file) {
    print "  ✓ Archivo principal existe: $main_file\n";
} else {
    print "  ✗ Archivo principal NO existe\n";
    exit 1;
}

# Verificar permisos
my $mode = (stat($main_file))[2];
my $permissions = sprintf("%04o", $mode & 07777);
print "  - Permisos: $permissions\n";

if ($permissions eq "0755") {
    print "  ✓ Permisos correctos\n";
} else {
    print "  ⚠ Permisos incorrectos (deberían ser 0755)\n";
}

# Verificar que sea ejecutable
if (-x $main_file) {
    print "  ✓ Archivo es ejecutable\n";
} else {
    print "  ✗ Archivo NO es ejecutable\n";
}

# Verificar sintaxis del archivo
print "\n2. Verificando sintaxis del script...\n";
my $syntax_check = `perl -c $main_file 2>&1`;
if ($? == 0) {
    print "  ✓ Sintaxis correcta\n";
} else {
    print "  ✗ Error de sintaxis:\n";
    print "    $syntax_check\n";
}

# Verificar archivos adicionales
print "\n3. Verificando archivos adicionales...\n";

my @additional_files = (
    "$plugin_dir/whm-toolkit.conf",
    "$plugin_dir/.htaccess"
);

foreach my $file (@additional_files) {
    if (-f $file) {
        print "  ✓ $file existe\n";
    } else {
        print "  ✗ $file no existe\n";
    }
}

# Obtener información del servidor
print "\n4. Información del servidor...\n";

# Obtener IP del servidor
my $server_ip = `hostname -I 2>/dev/null | awk '{print \$1}'`;
chomp($server_ip);
if ($server_ip) {
    print "  - IP del servidor: $server_ip\n";
} else {
    $server_ip = "tu-servidor";
    print "  - No se pudo detectar la IP automáticamente\n";
}

# Verificar puerto de WHM
my $whm_port = "2087";
print "  - Puerto WHM: $whm_port\n";

print "\n=== URLs para acceder al plugin ===\n";
print "\n1. URL principal:\n";
print "   https://$server_ip:$whm_port/whostmgr/docroot/cgi/whm-toolkit/\n";

print "\n2. URL directa:\n";
print "   https://$server_ip:$whm_port/whostmgr/docroot/cgi/whm-toolkit/index.cgi\n";

print "\n3. Acceso directo:\n";
print "   https://$server_ip:$whm_port/whostmgr/docroot/cgi/whm_toolkit_access.cgi\n";

print "\n=== Instrucciones de prueba ===\n";
print "\n1. Abre una de las URLs anteriores en tu navegador\n";
print "2. Inicia sesión en WHM si no lo has hecho\n";
print "3. Deberías ver la interfaz del plugin con el mensaje 'Hello World'\n";
print "4. Prueba hacer clic en 'Hello World' para verificar la funcionalidad\n";

print "\nSi encuentras errores, revisa los logs:\n";
print "tail -f /usr/local/cpanel/logs/error_log\n";

print "\n=== Prueba completada ===\n"; 