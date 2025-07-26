#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;

print "=== Instalación Simple del Plugin WHM Toolkit ===\n\n";

my $plugin_name = "WHM Toolkit";
my $source_dir = ".";
my $whm_cgi_dir = "/usr/local/cpanel/whostmgr/docroot/cgi";

# Crear directorio específico para nuestro plugin en WHM
my $plugin_web_dir = "$whm_cgi_dir/whm-toolkit";

print "1. Creando directorio web del plugin...\n";
unless (-d $plugin_web_dir) {
    mkdir($plugin_web_dir, 0755) or die "Error creando directorio: $!\n";
    print "  ✓ Directorio creado: $plugin_web_dir\n";
} else {
    print "  - Directorio ya existe: $plugin_web_dir\n";
}

# Copiar archivo principal
print "\n2. Copiando archivos del plugin...\n";
copy("$source_dir/whm-toolkit.cgi", "$plugin_web_dir/index.cgi") or die "Error copiando archivo principal: $!\n";
chmod(0755, "$plugin_web_dir/index.cgi");
print "  ✓ Archivo principal copiado como index.cgi\n";

# Copiar archivo de configuración
if (-f "$source_dir/whm-toolkit.conf") {
    copy("$source_dir/whm-toolkit.conf", "$plugin_web_dir/whm-toolkit.conf") or warn "Error copiando configuración: $!\n";
    print "  ✓ Archivo de configuración copiado\n";
}

# Crear archivo .htaccess para el directorio
print "\n3. Creando configuración web...\n";
my $htaccess_content = <<EOF;
Options +ExecCGI
AddHandler cgi-script .cgi
DirectoryIndex index.cgi
EOF

open(my $ht, ">", "$plugin_web_dir/.htaccess") or warn "Error creando .htaccess: $!\n";
print $ht $htaccess_content;
close($ht);
print "  ✓ Archivo .htaccess creado\n";

# Crear enlace directo en el menú principal de WHM
print "\n4. Creando enlace en menú de WHM...\n";

# Buscar archivos de menú de WHM
my @menu_files = (
    "/usr/local/cpanel/whostmgr/docroot/templates/main_menu.tmpl",
    "/usr/local/cpanel/whostmgr/docroot/templates/menu.tmpl",
    "/usr/local/cpanel/whostmgr/docroot/cgi/main.cgi"
);

print "  - Archivos de menú encontrados:\n";
foreach my $menu_file (@menu_files) {
    if (-f $menu_file) {
        print "    ✓ $menu_file\n";
    } else {
        print "    ✗ $menu_file (no existe)\n";
    }
}

# Crear archivo de acceso directo
my $direct_access_file = "$whm_cgi_dir/whm_toolkit_access.cgi";
my $access_script = <<'EOF';
#!/usr/bin/perl
print "Location: /whostmgr/docroot/cgi/whm-toolkit/index.cgi\n\n";
EOF

open(my $access, ">", $direct_access_file) or warn "Error creando acceso directo: $!\n";
print $access $access_script;
close($access);
chmod(0755, $direct_access_file);
print "  ✓ Archivo de acceso directo creado\n";

# Configurar permisos
print "\n5. Configurando permisos...\n";
system("chown -R root:root $plugin_web_dir");
system("chmod -R 755 $plugin_web_dir");
print "  ✓ Permisos configurados\n";

print "\n=== Instalación completada ===\n";
print "\nPuedes acceder al plugin de estas formas:\n\n";

print "1. URL directa:\n";
print "   https://tu-servidor:2087/whostmgr/docroot/cgi/whm-toolkit/\n";
print "   https://tu-servidor:2087/whostmgr/docroot/cgi/whm-toolkit/index.cgi\n\n";

print "2. Acceso directo:\n";
print "   https://tu-servidor:2087/whostmgr/docroot/cgi/whm_toolkit_access.cgi\n\n";

print "3. Para agregarlo al menú de WHM manualmente:\n";
print "   - Busca la sección 'Server Configuration' o similar en WHM\n";
print "   - O agrega un marcador/favorito con la URL directa\n\n";

print "Reemplaza 'tu-servidor' con la IP o dominio de tu servidor.\n";
print "\nSi hay errores, revisa los logs:\n";
print "tail -f /usr/local/cpanel/logs/error_log\n"; 