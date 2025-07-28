#!/bin/bash

echo "🔧 Creando plugin simple..."

# Crear plugin básico
cat > "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" << 'EOF'
#!/usr/bin/perl
use strict;
use warnings;
use CGI qw(:standard);

print header(-type => "text/html", -charset => "UTF-8");

my $cgi = CGI->new();
my $action = $cgi->param("action") || "main";

if ($action eq "hello") {
    print "<html><head><title>Hello World</title></head><body><h1>Hello World!</h1><p>Plugin funcionando: " . scalar(localtime()) . "</p><a href=\"?\">Volver</a></body></html>";
} else {
    print "<html><head><title>WHM Toolkit v2</title></head><body><h1>WHM Toolkit v2</h1><div><h3><a href=\"?action=hello\">Hello World</a></h3><p>Prueba del plugin</p></div></body></html>";
}
EOF

# Establecer permisos
chmod 755 "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
chown root:root "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"

echo "✅ Plugin creado"

# Verificar sintaxis
echo "🧪 Probando sintaxis..."
if perl -c "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi" >/dev/null 2>&1; then
    echo "✅ Sintaxis correcta"
else
    echo "❌ Error de sintaxis"
    echo "🔍 Mostrando el archivo:"
    cat "/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi"
fi

echo "🌐 URL: https://86.48.19.40:2087/cgi/addon_whm_toolkit.cgi" 