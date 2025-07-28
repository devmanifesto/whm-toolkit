# Configuración de Git para WHM Toolkit

## 🚀 Subir el proyecto a GitHub

### 1. Inicializar repositorio local
```bash
git init
git add .
git commit -m "Initial commit: WHM Toolkit v3.0 - Plugin completo y funcional"
```

### 2. Crear repositorio en GitHub
1. Ve a https://github.com/new
2. Nombre del repositorio: `whm-toolkit`
3. Descripción: `Plugin completo y funcional para WHM con interfaz moderna`
4. Público/Privado según prefieras
5. NO inicializar con README (ya tenemos uno)

### 3. Conectar con GitHub
```bash
git remote add origin https://github.com/TU-USUARIO/whm-toolkit.git
git branch -M main
git push -u origin main
```

### 4. Verificar subida
- Ve a tu repositorio en GitHub
- Verifica que todos los archivos estén presentes
- Comprueba que el README.md se muestre correctamente

## 📋 Archivos incluidos en el repositorio

✅ **Archivos principales:**
- `whm-toolkit-final.cgi` - Plugin Perl/CGI
- `whm-toolkit-final.conf` - Configuración AppConfig
- `install-whm-toolkit-final.sh` - Instalador principal
- `install-from-git.sh` - Instalador desde Git
- `diagnose-whm-toolkit-final.sh` - Diagnóstico
- `uninstall-whm-toolkit-final.sh` - Desinstalador

✅ **Documentación:**
- `README.md` - Documentación principal
- `README-FINAL.md` - Documentación técnica
- `LICENSE` - Licencia MIT

✅ **Configuración Git:**
- `.gitignore` - Archivos ignorados

## 🔧 Comandos útiles para mantenimiento

### Actualizar repositorio
```bash
git add .
git commit -m "Descripción de los cambios"
git push
```

### Crear nueva versión/tag
```bash
git tag -a v3.0.0 -m "WHM Toolkit v3.0.0 - Versión estable"
git push origin v3.0.0
```

### Clonar en servidor (para usuarios)
```bash
# Método automático
curl -sSL https://raw.githubusercontent.com/TU-USUARIO/whm-toolkit/main/install-from-git.sh | bash

# Método manual
git clone https://github.com/TU-USUARIO/whm-toolkit.git
cd whm-toolkit
chmod +x install-whm-toolkit-final.sh
./install-whm-toolkit-final.sh
```

## 📞 URLs importantes

Una vez subido a GitHub:
- **Repositorio**: `https://github.com/TU-USUARIO/whm-toolkit`
- **Issues**: `https://github.com/TU-USUARIO/whm-toolkit/issues`
- **Releases**: `https://github.com/TU-USUARIO/whm-toolkit/releases`
- **Instalación directa**: `curl -sSL https://raw.githubusercontent.com/TU-USUARIO/whm-toolkit/main/install-from-git.sh | bash`

## 🎯 Próximos pasos

1. **Subir a GitHub** usando los comandos de arriba
2. **Probar instalación** desde Git en un servidor de prueba
3. **Crear release v3.0.0** para marcar la versión estable
4. **Documentar issues** si encuentras problemas
5. **Compartir** con la comunidad de administradores WHM

¡Tu plugin WHM está listo para ser compartido con el mundo! 🎉