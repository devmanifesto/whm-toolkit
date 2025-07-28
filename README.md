# WHM Toolkit v2

Plugin optimizado para WHM (cPanel) con estructura correcta y funcional.

## 🚀 **Instalación Rápida**

### **Instalar desde GitHub:**
```bash
wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/install-v2.sh | bash
```

### **Desinstalar:**
```bash
wget -qO- https://raw.githubusercontent.com/devmanifesto/whm-toolkit/main/uninstall-v2.sh | bash
```

## 🎯 **Características**

- ✅ **Estructura optimizada**: Usa la estructura `/docroot/cgi/` correcta
- ✅ **Configuración AppConfig**: Registro correcto en WHM
- ✅ **Interfaz moderna**: Diseño responsivo y profesional
- ✅ **Hello World**: Prueba básica de funcionamiento
- ✅ **Información del Sistema**: Datos del servidor en tiempo real
- ✅ **Sin dependencias**: Solo usa módulos base de WHM

## 📁 **Estructura del Plugin**

```
/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
/var/cpanel/apps/whm_toolkit_v2.conf
```

## 🌐 **Acceso**

- **Menú WHM**: Plugins → WHM_Toolkit_v2
- **URL Directa**: `https://tu-servidor:2087/cgi/addon_whm_toolkit.cgi`

## 🔧 **Herramientas Incluidas**

1. **🚀 Hello World** - Prueba básica del plugin
2. **📊 Información del Sistema** - Datos del servidor
3. **🌐 Gestor de Dominios** - (Próximamente)
4. **📈 Monitor de Recursos** - (Próximamente)
5. **💾 Backup Manager** - (Próximamente)
6. **🔒 Security Scanner** - (Próximamente)

## 📋 **Requisitos**

- WHM/cPanel 11.0 o superior
- Acceso root al servidor
- Perl con módulo CGI

## 🛠️ **Desarrollo**

### **Archivos del Proyecto:**
- `whm-toolkit-v2.cgi` - Plugin principal
- `whm-toolkit-v2.conf` - Configuración AppConfig
- `install-v2.sh` - Instalador
- `uninstall-v2.sh` - Desinstalador
- `analyze_real_plugins.md` - Análisis de plugins reales

### **Estructura de Desarrollo:**
```
whm-toolkit/
├── whm-toolkit-v2.cgi
├── whm-toolkit-v2.conf
├── install-v2.sh
├── uninstall-v2.sh
├── analyze_real_plugins.md
└── README.md
```

## 🔄 **Actualizaciones**

### **v2.0.0** - Refactory Completo
- ✅ Estructura `/docroot/cgi/` correcta
- ✅ Configuración AppConfig optimizada
- ✅ Plugin funcional con Hello World
- ✅ Interfaz moderna y responsiva
- ✅ Limpieza completa de versiones anteriores

## 📞 **Soporte**

- **GitHub**: https://github.com/devmanifesto/whm-toolkit
- **Issues**: https://github.com/devmanifesto/whm-toolkit/issues

## 📄 **Licencia**

Este proyecto es de código abierto y está disponible bajo la licencia MIT.