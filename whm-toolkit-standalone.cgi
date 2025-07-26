#!/usr/bin/perl

use strict;
use warnings;

# Configuración del plugin
my $plugin_name = "WHM Toolkit";
my $plugin_version = "1.0.0";
my $plugin_description = "Herramientas útiles para administración de WHM";

# Función simple para obtener parámetros GET
sub get_param {
    my $param_name = shift;
    my $query_string = $ENV{'QUERY_STRING'} || '';
    
    foreach my $pair (split /&/, $query_string) {
        my ($name, $value) = split /=/, $pair;
        if ($name && $name eq $param_name) {
            # Decodificar URL básico
            $value =~ s/\+/ /g;
            $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
            return $value;
        }
    }
    return '';
}

# Obtener acción
my $action = get_param('action') || 'main';

# Configurar headers
print "Content-Type: text/html; charset=UTF-8\n\n";

# Manejar diferentes acciones
if ($action eq 'main') {
    show_main_interface();
} elsif ($action eq 'hello_world') {
    show_hello_world();
} else {
    show_main_interface();
}

sub show_main_interface {
    print <<HTML;
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
            background-color: #f5f5f5;
            line-height: 1.6;
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
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header p {
            margin: 15px 0 0 0;
            opacity: 0.9;
            font-size: 1.1em;
        }
        .content {
            padding: 40px;
        }
        .tools-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .tool-card {
            background: linear-gradient(145deg, #f8f9fa, #e9ecef);
            border: 1px solid #dee2e6;
            border-radius: 12px;
            padding: 25px;
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        .tool-card:before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea, #764ba2);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .tool-card:hover:before {
            transform: scaleX(1);
        }
        .tool-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            border-color: #667eea;
        }
        .tool-card h3 {
            margin: 0 0 15px 0;
            color: #495057;
            font-size: 1.3em;
            font-weight: 600;
        }
        .tool-card p {
            margin: 0;
            color: #6c757d;
            font-size: 0.95em;
        }
        .tool-card.active {
            background: linear-gradient(145deg, #e3f2fd, #bbdefb);
            border-color: #2196f3;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        .btn:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,123,255,0.3);
        }
        .status {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            font-weight: 500;
        }
        .info-badge {
            display: inline-block;
            background: #17a2b8;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8em;
            font-weight: 500;
            margin-left: 10px;
        }
        .footer {
            text-align: center;
            padding: 20px;
            color: #6c757d;
            border-top: 1px solid #dee2e6;
            background: #f8f9fa;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$plugin_name</h1>
            <p>$plugin_description</p>
            <span class="info-badge">v$plugin_version</span>
        </div>
        <div class="content">
            <div class="status">
                <strong>✅ Estado:</strong> Plugin instalado y funcionando correctamente
            </div>
            
            <h2>🛠️ Herramientas Disponibles</h2>
            <div class="tools-grid">
                <div class="tool-card active" onclick="location.href='?action=hello_world'">
                    <h3>🚀 Hello World</h3>
                    <p>Prueba básica del plugin - Verifica que todo esté funcionando correctamente</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>📊 Análisis de Sistema</h3>
                    <p>Información detallada sobre el estado del servidor y recursos</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>🌐 Gestor de Dominios</h3>
                    <p>Administración avanzada de dominios y subdominios</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>📈 Monitor de Recursos</h3>
                    <p>Monitoreo en tiempo real de CPU, memoria y espacio en disco</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>💾 Backup Manager</h3>
                    <p>Herramientas avanzadas para gestión de respaldos automáticos</p>
                </div>
                <div class="tool-card" onclick="alert('Próximamente disponible')">
                    <h3>🔒 Security Scanner</h3>
                    <p>Escaneo de seguridad y detección de vulnerabilidades</p>
                </div>
            </div>
        </div>
        <div class="footer">
            <p>WHM Toolkit - Desarrollado para administradores de sistemas</p>
        </div>
    </div>
</body>
</html>
HTML
}

sub show_hello_world {
    print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World - $plugin_name</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
            line-height: 1.6;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .content {
            padding: 40px;
            text-align: center;
        }
        .hello-message {
            font-size: 3em;
            color: #28a745;
            margin: 30px 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        .success-message {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 20px;
            border-radius: 8px;
            margin: 20px 0;
            font-size: 1.1em;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
            font-weight: 500;
            margin: 10px;
        }
        .btn:hover {
            background: linear-gradient(135deg, #0056b3, #004085);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,123,255,0.3);
        }
        .info-box {
            background: linear-gradient(135deg, #e7f3ff, #b3d9ff);
            border: 1px solid #b3d9ff;
            border-radius: 8px;
            padding: 20px;
            margin: 25px 0;
            text-align: left;
        }
        .info-box h4 {
            margin: 0 0 10px 0;
            color: #0056b3;
        }
        .server-info {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }
        .server-info h4 {
            margin: 0 0 15px 0;
            color: #495057;
        }
        .server-info table {
            width: 100%;
            border-collapse: collapse;
        }
        .server-info td {
            padding: 8px;
            border-bottom: 1px solid #dee2e6;
        }
        .server-info td:first-child {
            font-weight: bold;
            color: #495057;
            width: 40%;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 Hello World</h1>
            <p>Prueba exitosa del plugin WHM Toolkit</p>
        </div>
        <div class="content">
            <div class="hello-message">
                ¡Hola Mundo!
            </div>
            
            <div class="success-message">
                <strong>🎉 ¡Felicidades!</strong> El plugin WHM Toolkit está funcionando perfectamente.
            </div>
            
            <div class="info-box">
                <h4>📋 Información del Plugin:</h4>
                <strong>Nombre:</strong> $plugin_name<br>
                <strong>Versión:</strong> $plugin_version<br>
                <strong>Descripción:</strong> $plugin_description<br>
                <strong>Estado:</strong> ✅ Operativo
            </div>
            
            <div class="server-info">
                <h4>🖥️ Información del Servidor:</h4>
                <table>
HTML

    # Obtener información del sistema usando comandos básicos
    my $hostname = `hostname 2>/dev/null` || 'No disponible';
    chomp($hostname);
    
    my $uptime = `uptime 2>/dev/null` || 'No disponible';
    chomp($uptime);
    
    my $date = `date 2>/dev/null` || 'No disponible';
    chomp($date);
    
    my $perl_version = $^V ? sprintf("v%vd", $^V) : 'No disponible';
    
    print <<HTML;
                    <tr><td>Hostname:</td><td>$hostname</td></tr>
                    <tr><td>Fecha y Hora:</td><td>$date</td></tr>
                    <tr><td>Uptime:</td><td>$uptime</td></tr>
                    <tr><td>Versión de Perl:</td><td>$perl_version</td></tr>
                    <tr><td>Método de Acceso:</td><td>$ENV{'REQUEST_METHOD'} $ENV{'REQUEST_URI'}</td></tr>
                    <tr><td>User Agent:</td><td>$ENV{'HTTP_USER_AGENT'}</td></tr>
                </table>
            </div>
            
            <a href="?action=main" class="btn">🏠 Volver al Menú Principal</a>
            <a href="javascript:location.reload()" class="btn">🔄 Recargar Página</a>
        </div>
    </div>
</body>
</html>
HTML
} 