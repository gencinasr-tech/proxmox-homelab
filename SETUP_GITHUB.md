# 🚀 Guía para Subir a GitHub

Este documento explica cómo subir este repositorio a GitHub.

## ✅ Estado Actual

El repositorio Git ya está inicializado y tiene el commit inicial con toda la estructura.

## 📋 Archivos Creados

### Archivos Principales
- ✅ `README.md` - Portada principal del proyecto
- ✅ `LICENSE` - Licencia MIT
- ✅ `CHANGELOG.md` - Historial de cambios
- ✅ `CONTRIBUTING.md` - Guía de contribución
- ✅ `.gitignore` - Archivos a ignorar

### Documentación (`/docs`)
- ✅ `docs/README.md` - Índice de documentación
- ✅ `docs/01-getting-started/overview.md` - Overview del proyecto
- ✅ `docs/01-getting-started/prerequisites.md` - Requisitos previos
- ✅ `docs/01-getting-started/architecture.md` - Arquitectura completa

### Scripts (`/scripts`)
- ✅ `scripts/proxmox-host/01-prepare-repos.sh` - Preparar repositorios
- ✅ `scripts/proxmox-host/02-configure-lid.sh` - Configurar tapa portátil
- ✅ `scripts/proxmox-host/03-setup-hdd.sh` - Configurar HDD backups

### Servicios (`/services`)
- ✅ `services/README.md` - Índice de servicios
- ✅ `services/ct101-dashboard/` - Dashboard completo con docker-compose

### GitHub (`/.github`)
- ✅ `.github/ISSUE_TEMPLATE/bug_report.md` - Template para bugs
- ✅ `.github/ISSUE_TEMPLATE/feature_request.md` - Template para features
- ✅ `.github/ISSUE_TEMPLATE/question.md` - Template para preguntas

### Estructura de Carpetas
```
✅ configs/network/
✅ configs/dns/
✅ configs/ssl/
✅ configs/templates/
✅ diagrams/source/
✅ examples/
✅ scripts/container-creation/
✅ scripts/automation/
✅ scripts/maintenance/
```

## 🔧 Pasos para Subir a GitHub

### 1. Crear Repositorio en GitHub

1. Ve a [GitHub](https://github.com)
2. Click en el botón **"+"** → **"New repository"**
3. Configura:
   - **Repository name**: `proxmox-homelab` (o el nombre que prefieras)
   - **Description**: "Complete Proxmox homelab with 15+ self-hosted services"
   - **Visibility**: Public (o Private si prefieres)
   - **NO marques**: "Initialize with README" (ya lo tenemos)
4. Click en **"Create repository"**

### 2. Conectar Repositorio Local con GitHub

Copia los comandos que GitHub te muestra, o usa estos (reemplaza `tu-usuario`):

```bash
# Añadir remote
git remote add origin https://github.com/tu-usuario/proxmox-homelab.git

# Renombrar rama a main (opcional, GitHub usa 'main' por defecto)
git branch -M main

# Subir a GitHub
git push -u origin main
```

### 3. Verificar en GitHub

1. Refresca la página de tu repositorio
2. Deberías ver todos los archivos
3. El README.md se mostrará automáticamente

## 🎨 Configuración Adicional en GitHub

### Habilitar GitHub Pages (Opcional)

Para documentación web:

1. Ve a **Settings** → **Pages**
2. Source: **Deploy from a branch**
3. Branch: **main** → **/docs**
4. Save

### Configurar Topics

Añade topics relevantes para que otros encuentren tu proyecto:

1. Ve a tu repositorio
2. Click en el ⚙️ junto a "About"
3. Añade topics:
   - `proxmox`
   - `homelab`
   - `self-hosted`
   - `docker`
   - `docker-compose`
   - `tailscale`
   - `monitoring`
   - `automation`

### Configurar Descripción

En "About":
- **Description**: "Complete Proxmox homelab with 15+ self-hosted services including Nextcloud, Vaultwarden, Immich, and more"
- **Website**: (si tienes)
- **Topics**: (añadidos arriba)

### Habilitar Discussions (Opcional)

Para comunidad:

1. Ve a **Settings** → **General**
2. Scroll a **Features**
3. Marca **Discussions**

### Habilitar Issues

Ya debería estar habilitado por defecto, pero verifica:

1. Ve a **Settings** → **General**
2. Scroll a **Features**
3. Marca **Issues**

## 📝 Próximos Pasos Después de Subir

### 1. Añadir Badges al README

Edita `README.md` y actualiza los badges con tu información:

```markdown
![GitHub stars](https://img.shields.io/github/stars/tu-usuario/proxmox-homelab)
![GitHub forks](https://img.shields.io/github/forks/tu-usuario/proxmox-homelab)
![GitHub issues](https://img.shields.io/github/issues/tu-usuario/proxmox-homelab)
```

### 2. Crear Release v1.0.0

1. Ve a **Releases** → **Create a new release**
2. Tag: `v1.0.0`
3. Title: `v1.0.0 - Initial Release`
4. Description: Copia el contenido de CHANGELOG.md
5. Publish release

### 3. Añadir Screenshots

1. Toma capturas de tus dashboards
2. Súbelas a `/diagrams/screenshots/`
3. Actualiza README.md con las imágenes

### 4. Crear Diagramas

Usa herramientas como:
- [draw.io](https://app.diagrams.net/)
- [Excalidraw](https://excalidraw.com/)

Guarda en `/diagrams/source/` y exporta PNG a `/diagrams/`

### 5. Completar Documentación Faltante

Aún faltan documentos en `/docs`:
- Quick Start completo
- Guías de instalación de cada servicio
- Troubleshooting detallado
- Etc.

## 🔄 Workflow de Trabajo

### Para Hacer Cambios

```bash
# 1. Hacer cambios en archivos

# 2. Ver cambios
git status

# 3. Añadir cambios
git add .

# 4. Commit con mensaje descriptivo
git commit -m "Add: Nueva documentación de CT102"

# 5. Subir a GitHub
git push
```

### Para Crear Ramas

```bash
# Crear y cambiar a nueva rama
git checkout -b feature/nueva-caracteristica

# Hacer cambios y commits

# Subir rama
git push -u origin feature/nueva-caracteristica

# Luego crear Pull Request en GitHub
```

## 🎯 Checklist Final

Antes de hacer público:

- [ ] Repositorio creado en GitHub
- [ ] Código subido correctamente
- [ ] README se ve bien en GitHub
- [ ] Links funcionan correctamente
- [ ] Topics añadidos
- [ ] Descripción configurada
- [ ] Issues habilitados
- [ ] License visible
- [ ] .gitignore funcionando
- [ ] No hay información sensible (contraseñas, tokens, etc.)

## 🔐 Seguridad

### Antes de Subir

Verifica que NO has incluido:
- ❌ Contraseñas reales
- ❌ Tokens de API
- ❌ Claves privadas
- ❌ Información personal sensible
- ❌ IPs públicas reales (si aplica)

### Archivos Sensibles

El `.gitignore` ya está configurado para ignorar:
- `*.env` - Variables de entorno
- `secrets/` - Carpeta de secretos
- `*.key`, `*.pem` - Claves privadas
- Etc.

## 📢 Promoción (Opcional)

Una vez público, puedes compartir en:

- [r/selfhosted](https://reddit.com/r/selfhosted)
- [r/homelab](https://reddit.com/r/homelab)
- [r/Proxmox](https://reddit.com/r/Proxmox)
- Twitter/X con hashtags: #homelab #selfhosted #proxmox
- LinkedIn
- Foros de tecnología

## 🆘 Problemas Comunes

### Error: remote origin already exists

```bash
git remote remove origin
git remote add origin https://github.com/tu-usuario/proxmox-homelab.git
```

### Error: failed to push

```bash
# Si el repositorio remoto tiene commits que no tienes localmente
git pull origin main --rebase
git push
```

### Cambiar URL del remote

```bash
git remote set-url origin https://github.com/tu-usuario/nuevo-nombre.git
```

## 📚 Recursos

- [GitHub Docs](https://docs.github.com/)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)
- [Markdown Guide](https://www.markdownguide.org/)

---

¡Listo para subir a GitHub! 🚀