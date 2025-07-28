# Análisis de Plugins Reales de WHM

## 🔍 **INVESTIGACIÓN DE PLUGINS FUNCIONALES**

### **1. Estructura de Directorios Real**

Los plugins de WHM que funcionan usan diferentes estructuras:

**Opción A: `/usr/local/cpanel/whostmgr/addonfeatures/`**
```
/usr/local/cpanel/whostmgr/addonfeatures/plugin_name/
├── plugin.cgi
├── plugin.conf
└── icons/
```

**Opción B: `/usr/local/cpanel/whostmgr/docroot/cgi/`**
```
/usr/local/cpanel/whostmgr/docroot/cgi/addon_plugin_name.cgi
```

**Opción C: `/usr/local/cpanel/whostmgr/addon_plugins/`**
```
/usr/local/cpanel/whostmgr/addon_plugins/plugin_name/
```

### **2. Configuración AppConfig Real**

Los plugins que funcionan usan configuraciones específicas:

```ini
name=Plugin_Name
version=1.0.0
vendor=Vendor_Name
summary=Plugin description
description=Detailed description
url=https://plugin-url.com
support=https://support-url.com
service=whostmgr
url=cgi/addon_plugin_name.cgi

[app]
name=Plugin_Name
version=1.0.0
vendor=Vendor_Name
summary=Plugin description
description=Detailed description
url=https://plugin-url.com
support=https://support-url.com
service=whostmgr
url=cgi/addon_plugin_name.cgi

[script]
type=whm
target=/usr/local/cpanel/whostmgr/docroot/cgi/addon_plugin_name.cgi
url=cgi/addon_plugin_name.cgi

[acl]
reseller=1
all=1

[features]
plugin_name=1

[group]
Plugins

[category]
system_administration
```

### **3. Problemas Identificados**

1. **Estructura incorrecta**: Usamos `/addonfeatures/` pero debería ser `/docroot/cgi/`
2. **URL incorrecta**: Debería ser `cgi/addon_plugin_name.cgi`
3. **Target incorrecto**: Debería apuntar a `/docroot/cgi/`

### **4. Solución Propuesta**

Crear un plugin usando la estructura `/docroot/cgi/` que es la más común y funcional.

## 🎯 **PLAN DE REFACTORY COMPLETO**

### **Paso 1: Estructura Correcta**
```
/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi
/var/cpanel/apps/whm_toolkit.conf
```

### **Paso 2: Configuración AppConfig Correcta**
- `service=whostmgr`
- `url=cgi/addon_whm_toolkit.cgi`
- `target=/usr/local/cpanel/whostmgr/docroot/cgi/addon_whm_toolkit.cgi`

### **Paso 3: Plugin CGI Simplificado**
- Sin dependencias complejas
- Solo CGI.pm
- Estructura básica y funcional

### **Paso 4: Instalador Robusto**
- Limpieza completa
- Verificación paso a paso
- Manejo de errores 