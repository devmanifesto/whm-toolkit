# WHM Toolkit v3.0 - Plugin Completo para WHM

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![WHM Compatible](https://img.shields.io/badge/WHM-Compatible-green.svg)](https://cpanel.net/)
[![Perl](https://img.shields.io/badge/Perl-5.8%2B-blue.svg)](https://www.perl.org/)

Plugin completamente optimizado para WHM (Web Host Manager) que aparece correctamente en el menú de plugins. Incluye interfaz moderna, sistema de diagnóstico integrado y funcionalidades básicas.

## 🚀 Instalación Rápida desde Git

### Método 1: Script automático (Recomendado)
```bash
# En tu servidor WHM (como root)
curl -sSL https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install-from-git.sh | bash
```

### Método 2: Clonar manualmente
```bash
# En tu servidor WHM (como root)
cd /tmp
git clone https://github.com/devmanifesto/whm-toolkit.git
cd whm-toolkit
chmod +x install-whm-toolkit-final.sh
./install-whm-toolkit-final.sh
```

### Método 3: Descargar ZIP
```bash
# Si no tienes Git instalado
cd /tmp
wget https://github.com/devmanifesto/whm-toolkit/archive/main.zip
unzip main.zip
cd whm-toolkit-main
chmod +x install-whm-toolkit-final.sh
./install-whm-toolkit-final.sh
```

## ✅ Características

- ✅ **Estructura Optimizada**: Usa la ruta `/docroot/cgi/` estándar
- ✅ **Configuración AppConfig Correcta**: Registro limpio en WHM
- ✅ **Interfaz Moderna**: Diseño responsivo y profesional
- ✅ **Hello World Funcional**: Prueba básica con información del sistema
- ✅ **Sistema de Diagnóstico**: Herramientas integradas de troubleshooting
- ✅ **Scripts Automatizados**: Instalación, diagnóstico y desinstalación
- ✅ **Compatibilidad Total**: Funciona con todas las versiones de WHM

## 📁 Estructura del Repositorio

```
whm-toolkit/
├── whm-toolkit-final.cgi          # Plugin principal (Perl/CGI)
├── whm-toolkit-final.conf         # Configuración AppConfig optimizada
├── install-whm-toolkit-final.sh   # Script de instalación principal
├── install-from-git.sh            # Script de instalación desde Git
├── diagnose-whm-toolkit-final.sh  # Script de diagnóstico avanzado
├── uninstall-whm-toolkit-final.sh # Script de desinstalación limpia
├── README.md                      # Documentación principal
├── README-FINAL.md                # Documentación técnica detallada
├── LICENSE                        # Licencia MIT
└── .gitignore                     # Archivos ignorados por Git
```

## 🎯 Acceso al Plugin

Una vez instalado:

- **Menú WHM**: WHM → Plugins → WHM_Toolkit
- **URL Directa**: `https://tu-servidor:2087/cgi/addon_whm_toolkit.cgi`

## 🛠️ Scripts Disponibles

### Instalación
```bash
chmod +x install-whm-toolkit-final.sh
./install-whm-toolkit-final.sh
```

### Diagnóstico
```bash
chmod +x diagnose-whm-toolkit-final.sh
./diagnose-whm-toolkit-final.sh
```

### Desinstalación
```bash
chmod +x uninstall-whm-toolkit-final.sh
./uninstall-whm-toolkit-final.sh
```

## 🔧 Troubleshooting Rápido

### Plugin no aparece en el menú
```bash
# Re-registrar y reconstruir menú
/usr/local/cpanel/bin/register_appconfig /var/cpanel/apps/whm_toolkit.conf
/usr/local/cpanel/bin/rebuild_whm_menu
systemctl restart cpanel httpd
```

### Error 500
```bash
# Verificar sintaxis y permisos
perl -c /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
chmod 755 /usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
```

## 📋 Requisitos

- **WHM/cPanel**: 11.0 o superior
- **Perl**: 5.8+ con módulo CGI
- **Acceso root**: Requerido para instalación
- **Git**: Para clonar el repositorio

## 🏗️ Desarrollo

### Clonar para desarrollo
```bash
git clone https://github.com/devmanifesto/whm-toolkit.git
cd whm-toolkit
```

### Estructura técnica
- **Plugin**: `/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi`
- **Config**: `/var/cpanel/apps/whm_toolkit.conf`
- **Permisos**: 755 para CGI, 644 para configuración

## 📞 Soporte

- **Issues**: [GitHub Issues](https://github.com/devmanifesto/whm-toolkit/issues)
- **Documentación**: [`README-FINAL.md`](README-FINAL.md)
- **Diagnóstico**: Script incluido para identificar problemas

## 📄 Licencia

MIT License - Ver [LICENSE](LICENSE) para más detalles.

## 🎉 ¡Listo para Usar!

Este plugin ha sido probado y optimizado para funcionar correctamente en WHM. Incluye todo lo necesario para una instalación exitosa y aparición en el menú.

**¡Tu plugin WHM estará funcionando en menos de 5 minutos!**

---

*Desarrollado con ❤️ para la comunidad de administradores de sistemas*