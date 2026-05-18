# CT101 - Dashboard

Dashboard principal del homelab con múltiples opciones de visualización.

## 📋 Servicios Incluidos

- **Homepage** - Dashboard principal personalizable
- **Homarr** - Dashboard con widgets y integraciones
- **Homer** - Dashboard minimalista basado en YAML
- **Heimdall** - Dashboard tipo app launcher

## 🔧 Especificaciones del Contenedor

- **ID**: CT101
- **Hostname**: dashboard
- **OS**: Debian 13 (LXC)
- **CPU**: 1 core
- **RAM**: 1024 MB
- **Swap**: 512 MB
- **Disco**: 12 GB
- **Red**: vmbr0 (LAN)
- **IP**: 192.168.1.79
- **Gateway**: 192.168.1.1

## 🌐 Acceso a los Servicios

| Servicio | Puerto | URL Directa | Dominio |
|----------|--------|-------------|---------|
| Homepage | 3000 | http://192.168.1.79:3000 | https://homepage.home.arpa |
| Homarr | 7575 | http://192.168.1.79:7575 | https://homarr.home.arpa |
| Homer | 8080 | http://192.168.1.79:8080 | https://homer.home.arpa |
| Heimdall | 8081 | http://192.168.1.79:8081 | https://heimdall.home.arpa |
| Portainer Agent | 9001 | tcp://192.168.1.79:9001 | - |
| cAdvisor | 8089 | http://192.168.1.79:8089 | - |
| Socket Proxy | 2375 | tcp://192.168.1.79:2375 | - |

## 📦 Instalación

### 1. Crear el Contenedor en Proxmox

```bash
# En Proxmox Web UI: Crear CT
# O usar el script de creación:
# scripts/container-creation/create-ct101.sh
```

Configuración:
- CT ID: 101
- Hostname: dashboard
- Template: debian-13-standard
- Disco: 12 GB (local-lvm)
- CPU: 1 core
- RAM: 1024 MB / Swap: 512 MB
- Red: vmbr0, IP: 192.168.1.79/24, Gateway: 192.168.1.1
- DNS: 1.1.1.1
- Unprivileged: ✓
- Nesting: ✓
- Start at boot: ✓

### 2. Instalar Docker en el Contenedor

```bash
# Entrar al contenedor
pct enter 101

# Actualizar sistema
apt update && apt upgrade -y

# Instalar dependencias
apt install -y curl gnupg ca-certificates

# Instalar Docker
curl -fsSL https://get.docker.com | sh

# Instalar Docker Compose
apt install -y docker-compose-plugin

# Verificar instalación
docker --version
docker compose version
```

### 3. Desplegar los Servicios

```bash
# Crear directorio de trabajo
mkdir -p /opt/dashboard
cd /opt/dashboard

# Copiar docker-compose.yml
# (Copiar el contenido del archivo docker-compose.yml de este directorio)

# Crear estructura de carpetas para configuraciones
mkdir -p configs/{homepage,homarr/{configs,icons,data},homer,heimdall}

# Iniciar servicios
docker compose up -d

# Ver logs
docker compose logs -f

# Verificar estado
docker compose ps
```

## ⚙️ Configuración

### Homepage

Editar `configs/homepage/services.yaml`:

```yaml
---
# Ejemplo de configuración
- Infraestructura:
    - Proxmox:
        icon: proxmox.png
        href: https://proxmox.home.arpa
        description: Hypervisor
        
    - Portainer:
        icon: portainer.png
        href: https://portainer.home.arpa
        description: Container Management

- Servicios:
    - Nextcloud:
        icon: nextcloud.png
        href: https://nextcloud.home.arpa
        description: Cloud Personal
```

### Homarr

Configuración vía interfaz web en http://192.168.1.79:7575

Características:
- Widgets personalizables
- Integración con servicios
- Temas personalizados
- Búsqueda integrada

### Homer

Editar `configs/homer/config.yml`:

```yaml
---
title: "Homelab Dashboard"
subtitle: "Homer"
logo: "assets/logo.png"

services:
  - name: "Aplicaciones"
    icon: "fas fa-cloud"
    items:
      - name: "Nextcloud"
        logo: "assets/tools/nextcloud.png"
        url: "https://nextcloud.home.arpa"
        target: "_blank"
```

### Heimdall

Configuración vía interfaz web en http://192.168.1.79:8081

## 🔄 Gestión

### Comandos Útiles

```bash
# Ver estado de servicios
docker compose ps

# Ver logs
docker compose logs -f [servicio]

# Reiniciar un servicio
docker compose restart [servicio]

# Reiniciar todos
docker compose restart

# Detener todos
docker compose down

# Actualizar imágenes
docker compose pull
docker compose up -d

# Ver uso de recursos
docker stats
```

### Backups

Los datos se guardan en:
- `configs/homepage/` - Configuración de Homepage
- `configs/homarr/` - Configuración de Homarr
- `configs/homer/` - Configuración de Homer
- `configs/heimdall/` - Configuración de Heimdall

Hacer backup:
```bash
tar -czf dashboard-configs-$(date +%Y%m%d).tar.gz configs/
```

## 🔍 Troubleshooting

### Servicio no inicia

```bash
# Ver logs del servicio
docker compose logs [servicio]

# Verificar permisos
ls -la configs/

# Recrear contenedor
docker compose up -d --force-recreate [servicio]
```

### No se puede acceder

```bash
# Verificar que el contenedor está corriendo
docker compose ps

# Verificar puertos
ss -tlnp | grep -E '3000|7575|8080|8081'

# Verificar firewall (si aplica)
iptables -L -n
```

### Problemas de permisos

```bash
# Ajustar permisos de carpetas
chown -R 1000:1000 configs/
chmod -R 755 configs/
```

## 📊 Monitoring

Este contenedor incluye:

- **Portainer Agent**: Gestión remota desde CT102
- **cAdvisor**: Métricas para Prometheus
- **Socket Proxy**: Acceso seguro a Docker socket

Métricas disponibles en:
- cAdvisor: http://192.168.1.79:8089
- Prometheus scrape: http://192.168.1.79:8089/metrics

## 🔐 Seguridad

### Recomendaciones

1. **No exponer directamente a internet**
2. **Usar Nginx Proxy Manager** para acceso HTTPS
3. **Configurar autenticación** en cada dashboard
4. **Mantener actualizado** con `docker compose pull`

### Autenticación

Algunos dashboards soportan autenticación:
- **Heimdall**: Configurar en Settings
- **Homarr**: Configurar en Settings > Authentication
- **Homepage**: Sin autenticación nativa (usar proxy)

## 🔗 Integración con Otros Servicios

### Nginx Proxy Manager (CT112)

Crear proxy hosts para cada dashboard:
- homepage.home.arpa → http://192.168.1.79:3000
- homarr.home.arpa → http://192.168.1.79:7575
- homer.home.arpa → http://192.168.1.79:8080
- heimdall.home.arpa → http://192.168.1.79:8081

### Portainer (CT102)

Añadir este agente en Portainer:
- Environment type: Docker
- URL: 192.168.1.79:9001

### Prometheus (CT105)

Añadir scrape config:
```yaml
scrape_configs:
  - job_name: 'dashboard-cadvisor'
    static_configs:
      - targets: ['192.168.1.79:8089']
```

## 📚 Recursos

- [Homepage Docs](https://gethomepage.dev/)
- [Homarr Docs](https://homarr.dev/)
- [Homer Docs](https://github.com/bastienwirtz/homer)
- [Heimdall Docs](https://heimdall.site/)

## 🆘 Soporte

Si tienes problemas:
1. Revisa los logs: `docker compose logs`
2. Consulta la [guía de troubleshooting](../../docs/11-maintenance/troubleshooting.md)
3. Abre un issue en GitHub

---

[⬅️ Volver a servicios](../README.md)