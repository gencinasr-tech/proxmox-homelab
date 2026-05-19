# 🏠 Proxmox Homelab - Self-Hosted Infrastructure

<div align="center">

![Proxmox Version](https://img.shields.io/badge/Proxmox-9.1.9-orange)
![Services](https://img.shields.io/badge/Services-15-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Production-success)

**Un homelab completo y replicable con 15 bloques principales y 40+ servicios Docker**

[📖 Documentación](#-documentación) • [🚀 Quick Start](#-quick-start) • [🏗️ Arquitectura](#️-arquitectura) • [💬 Feedback](#-feedback-y-mejoras)

</div>

---

## ✨ Características

- 🔐 **Autenticación centralizada** con Keycloak (SSO con Google OAuth)
- 🌐 **VPN segura** con Tailscale (acceso remoto desde cualquier lugar)
- 📊 **Monitoring completo** (Grafana, Prometheus, Uptime Kuma, Beszel)
- 💾 **Backups automáticos** (local + Google Drive cifrado)
- 🎨 **Múltiples dashboards** (Homepage, Homarr, Homer, Heimdall)
- 📁 **NAS personal** con Samba y Syncthing
- 🔒 **Password manager** (Vaultwarden con HTTPS público)
- 📄 **Gestión documental** (Paperless-ngx)
- ☁️ **Cloud personal** (Nextcloud)
- 📷 **Galería de fotos** con IA (Immich)
- 🎵 **Servidor de música** (Navidrome)
- 🛠️ **Herramientas útiles** (IT-Tools, Stirling PDF)
- 🗄️ **Bases de datos** centralizadas (PostgreSQL, MariaDB, Redis)
- 🔄 **Gestión de contenedores** (Portainer con múltiples agentes)
- 🌍 **DNS local** con AdGuard Home y dominios .home.arpa

## ⚠️ Aviso Importante

> **Esta documentación está basada en una infraestructura real**, pero todos los valores sensibles han sido sustituidos por placeholders para seguridad:
>
> - **Dominios Tailscale**: `tailXXXXXX.ts.net` (reemplaza con tu dominio real)
> - **IPs de ejemplo**: Las IPs mostradas corresponden a la arquitectura real pero debes adaptarlas a tu red
> - **Credenciales**: Todos los passwords y tokens son placeholders (`your_*_here`)
> - **Archivos sensibles**: `.env`, backups reales y exports de producción están en `.gitignore`
>
> **Para replicar este homelab**: Copia `.env.example` a `.env` y personaliza todos los valores según tu infraestructura.

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────────┐
│                      PROXMOX HOST                               │
│                     192.168.1.200                               │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  🌐 LAN Network (192.168.1.0/24)                               │
│  ├─ CT100: Tailscale Gateway (VPN + NAT)                       │
│  ├─ CT101: Dashboards (Homepage, Homarr, Homer, Heimdall)      │
│  ├─ CT102: Portainer (Gestión de contenedores)                 │
│  ├─ CT103: DNS (AdGuard Home)                                  │
│  ├─ VM104: CasaOS/NAS (Samba, Syncthing, Duplicati)           │
│  └─ CT112: Nginx Proxy Manager (Reverse proxy + SSL)           │
│                                                                 │
│  🔒 Private Network (10.10.10.0/24)                            │
│  ├─ CT105: Monitoring (Grafana, Prometheus, Kuma, Beszel)     │
│  ├─ CT106: Vaultwarden (Password manager)                      │
│  ├─ CT107: Paperless-ngx (Gestión documental)                  │
│  ├─ CT108: Nextcloud (Cloud personal)                          │
│  ├─ VM109: Immich (Galería de fotos con IA)                   │
│  ├─ CT110: Tools (IT-Tools, Stirling PDF)                      │
│  ├─ CT111: Databases (PostgreSQL, MariaDB, Redis + Admin)      │
│  ├─ CT113: Keycloak (SSO/Identity Provider)                    │
│  ├─ CT114: Navidrome (Servidor de música)                      │
│  └─ CT115: Downloads (Descargador de música)                   │
│                                                                 │
│  💾 Backups                                                     │
│  ├─ Local: SSD 250GB (/mnt/hdd250) - Crucial MX500           │
│  ├─ Remoto: Google Drive (cifrado con rclone)                  │
│  └─ Duplicati: Backups selectivos de datos                     │
└─────────────────────────────────────────────────────────────────┘
```

[Ver topología detallada →](docs/reference/topology.md)

## 📋 Servicios Disponibles

### 🌐 Acceso Público (LAN)

| Servicio | IP | Puerto | Dominio | Estado |
|----------|-----|--------|---------|--------|
| Proxmox Web UI | 192.168.1.200 | 8006 | proxmox.home.arpa | ✅ |
| Homepage | 192.168.1.79 | 3000 | homepage.home.arpa | ✅ |
| Homarr | 192.168.1.79 | 7575 | homarr.home.arpa | ✅ |
| Homer | 192.168.1.79 | 8080 | homer.home.arpa | ✅ |
| Heimdall | 192.168.1.79 | 8081 | heimdall.home.arpa | ✅ |
| Portainer | 192.168.1.80 | 9443 | portainer.home.arpa | ✅ |
| AdGuard Home | 192.168.1.53 | 80 | adguard.home.arpa | ✅ |
| CasaOS | 192.168.1.81 | 80 | casaos.home.arpa | ✅ |
| Syncthing | 192.168.1.81 | 8384 | syncthing.home.arpa | ✅ |
| Duplicati | 192.168.1.81 | 8200 | duplicati.home.arpa | ✅ |
| Nginx Proxy Manager | 192.168.1.82 | 81 | npm.home.arpa | ✅ |

### 🔒 Red Privada (Solo Tailscale/Proxy)

| Servicio | IP | Puerto | Dominio | Estado |
|----------|-----|--------|---------|--------|
| Uptime Kuma | 10.10.10.50 | 3001 | kuma.home.arpa | ✅ |
| Beszel | 10.10.10.50 | 8090 | beszel.home.arpa | ✅ |
| Grafana | 10.10.10.50 | 3002 | grafana.home.arpa | ✅ |
| Prometheus | 10.10.10.50 | 9090 | prometheus.home.arpa | ✅ |
| Speedtest Tracker | 10.10.10.50 | 8085 | speedtest.home.arpa | ✅ |
| Scrutiny | 10.10.10.50 | 8086 | scrutiny.home.arpa | ✅ |
| Vaultwarden | 10.10.10.60 | 8080 | vault.home.arpa | ✅ |
| Vaultwarden (Público) | - | 443 | vaultwarden.tailXXXXXX.ts.net | ✅ |
| Paperless-ngx | 10.10.10.40 | 8000 | paperless.home.arpa | ✅ |
| Nextcloud | 10.10.10.65 | 8088 | nextcloud.home.arpa | ✅ |
| Immich | 10.10.10.30 | 2283 | immich.home.arpa | ✅ |
| IT-Tools | 10.10.10.70 | 8080 | tools.home.arpa | ✅ |
| Stirling PDF | 10.10.10.70 | 8081 | pdf.home.arpa | ✅ |
| Adminer | 10.10.10.73 | 8080 | adminer.home.arpa | ✅ |
| pgAdmin | 10.10.10.73 | 8082 | pgadmin.home.arpa | ✅ |
| ChartDB | 10.10.10.73 | 8083 | chartdb.home.arpa | ✅ |
| Keycloak | 10.10.10.74 | 8080 | auth.home.arpa | ✅ |
| Navidrome | 10.10.10.82 | 4533 | music.home.arpa | ✅ |
| Music Downloader | 10.10.10.83 | 6595 | downloads.home.arpa | ✅ |

## 🚀 Quick Start

### Requisitos Previos

- **Hardware mínimo**: Portátil/PC con al menos 8GB RAM, 100GB disco SSD + SSD/HDD adicional para backups
- **Este proyecto**: ASUS TUF Gaming FX505DY
  - CPU: AMD Ryzen 5 3550H (4 cores / 8 threads)
  - RAM: 16GB DDR4 (15 GiB disponibles para Proxmox)
  - Disco principal: Micron 2200V NVMe 500GB
  - Disco backups: Crucial MX500 SSD 250GB
- **Software**: Proxmox VE 9.1.9 instalado
- **Red**: Acceso a router para configurar IPs estáticas o DHCP reservado
- **Conocimientos**: Básicos de Linux, Docker y redes

### Instalación Rápida (30 minutos)

```bash
# 1. Clonar el repositorio en tu PC
git clone https://github.com/tu-usuario/proxmox-homelab.git
cd proxmox-homelab

# 2. En Proxmox, preparar el host (ejecutar en Shell de Proxmox)
# Copiar y pegar el contenido de cada script:
# - scripts/proxmox-host/01-prepare-repos.sh
# - scripts/proxmox-host/02-configure-lid.sh
# - scripts/proxmox-host/03-setup-hdd.sh

# 3. Descargar plantilla Debian
# En Proxmox Web UI: local > CT Templates > Templates > debian-13-standard

# 4. Crear contenedores base usando los scripts en:
# scripts/container-creation/

# 5. Configurar servicios individuales
# Seguir las guías en docs/ y usar los docker-compose.yml en services/
```

[📖 Guía completa de instalación paso a paso →](docs/01-getting-started/quick-start.md)

## 📖 Documentación

### 🎯 Para Empezar
- [📋 Overview del Proyecto](docs/01-getting-started/overview.md) - Qué es y qué incluye
- [✅ Requisitos Previos](docs/01-getting-started/prerequisites.md) - Hardware, software y conocimientos
- [🏗️ Arquitectura Completa](docs/01-getting-started/architecture.md) - Diseño del sistema
- [⚡ Quick Start](docs/01-getting-started/quick-start.md) - Instalación rápida

### 💿 Instalación Base
- [Instalar Proxmox](docs/02-proxmox-base/installation.md) - Desde ISO hasta primer acceso
- [Configuración Inicial](docs/02-proxmox-base/initial-config.md) - Repos, tapa portátil, updates
- [Configurar HDD Backups](docs/02-proxmox-base/storage-setup.md) - Disco adicional para backups
- [Scripts de Rendimiento](docs/02-proxmox-base/performance-scripts.md) - Modo turbo y modo noche

### 🌐 Redes
- [Diseño de Red](docs/03-networking/network-design.md) - Arquitectura de 2 redes
- [Red LAN](docs/03-networking/lan-network.md) - 192.168.1.0/24 setup
- [Red Privada](docs/03-networking/private-network.md) - 10.10.10.0/24 setup
- [Rutas Estáticas](docs/03-networking/static-routes.md) - Acceso LAN → red privada
- [Firewall](docs/03-networking/firewall.md) - Reglas de seguridad

### 🔧 Servicios Core
- [CT100: Tailscale Gateway](docs/04-core-services/ct100-tailscale.md) - VPN + Subnet Router + NAT
- [CT103: DNS (AdGuard)](docs/04-core-services/ct103-dns.md) - DNS local con bloqueo de ads
- [CT112: Nginx Proxy Manager](docs/04-core-services/ct112-proxy.md) - Reverse proxy + SSL

### 📊 Gestión y Monitoring
- [CT101: Dashboards](docs/05-management/ct101-dashboards.md) - Homepage, Homarr, Homer, Heimdall
- [CT102: Portainer](docs/05-management/ct102-portainer.md) - Gestión de contenedores
- [CT105: Monitoring](docs/05-management/ct105-monitoring.md) - Grafana, Prometheus, Kuma, Beszel

### 💾 Storage y Backups
- [VM104: CasaOS/NAS](docs/06-storage-backup/vm104-casaos.md) - Samba, Syncthing, estructura de datos
- [Backups Locales](docs/06-storage-backup/local-backups.md) - Backups diarios en Proxmox
- [Backups Remotos](docs/06-storage-backup/remote-backups.md) - rclone a Google Drive cifrado
- [Duplicati](docs/06-storage-backup/duplicati.md) - Backups selectivos de carpetas

### 📝 Productividad
- [CT106: Vaultwarden](docs/07-productivity/ct106-vaultwarden.md) - Password manager
- [CT107: Paperless-ngx](docs/07-productivity/ct107-paperless.md) - Gestión documental
- [CT108: Nextcloud](docs/07-productivity/ct108-nextcloud.md) - Cloud personal
- [VM109: Immich](docs/07-productivity/vm109-immich.md) - Galería de fotos con IA

### 🛠️ Utilidades
- [CT110: Tools](docs/08-utilities/ct110-tools.md) - IT-Tools, Stirling PDF
- [CT111: Databases](docs/08-utilities/ct111-databases.md) - PostgreSQL, MariaDB, Redis
- [CT114: Navidrome](docs/08-utilities/ct114-music.md) - Servidor de música
- [CT115: Downloads](docs/08-utilities/ct115-downloads.md) - Descargador de música

### 🔐 Autenticación SSO
- [CT113: Keycloak](docs/09-authentication/ct113-keycloak.md) - Identity Provider
- [SSO en Grafana](docs/09-authentication/sso-grafana.md) - Integración con Keycloak
- [SSO en Homarr](docs/09-authentication/sso-homarr.md) - Integración con Keycloak
- [SSO en Immich](docs/09-authentication/sso-immich.md) - Integración con Keycloak
- [SSO en Nextcloud](docs/09-authentication/sso-nextcloud.md) - Integración con Keycloak

### 🔒 Avanzado
- [Docker Best Practices](docs/10-advanced/docker-best-practices.md) - Patrones y buenas prácticas
- [Seguridad](docs/10-advanced/security-hardening.md) - Hardening del sistema
- [Optimización](docs/10-advanced/performance-tuning.md) - Mejorar rendimiento
- [Escalabilidad](docs/10-advanced/scaling.md) - Cómo crecer el homelab

### 🔧 Mantenimiento
- [Actualizaciones](docs/11-maintenance/updates.md) - Actualizar servicios
- [Troubleshooting](docs/11-maintenance/troubleshooting.md) - Solución de problemas comunes
- [Alertas](docs/11-maintenance/monitoring-alerts.md) - Configurar notificaciones
- [Disaster Recovery](docs/11-maintenance/disaster-recovery.md) - Restaurar desde backups

## 🛠️ Tecnologías Utilizadas

### Virtualización y Contenedores
- **Proxmox VE 9.1.9** - Plataforma de virtualización
- **LXC** - Contenedores Linux ligeros (14 contenedores)
- **Docker** - Contenedores de aplicaciones
- **Docker Compose** - Orquestación de servicios

### Networking
- **Tailscale** - VPN mesh moderna y segura
- **Nginx Proxy Manager** - Reverse proxy con UI
- **AdGuard Home** - DNS con bloqueo de ads

### Gestión
- **Portainer** - Gestión visual de Docker
- **Homepage** - Dashboard principal
- **Homarr** - Dashboard alternativo con widgets

### Monitoring
- **Grafana** - Visualización de métricas
- **Prometheus** - Recolección de métricas
- **Uptime Kuma** - Monitoring de uptime
- **Beszel** - Monitoring ligero de recursos
- **Scrutiny** - Monitoring de discos SMART

### Productividad
- **Vaultwarden** - Password manager (Bitwarden compatible)
- **Paperless-ngx** - Gestión documental DMS
- **Nextcloud** - Suite de productividad cloud
- **Immich** - Galería de fotos con IA

### Storage y Backups
- **CasaOS** - Sistema operativo para NAS
- **Samba** - Compartir archivos en red
- **Syncthing** - Sincronización P2P
- **rclone** - Backups a cloud cifrados
- **Duplicati** - Backups incrementales

### Bases de Datos
- **PostgreSQL** - Base de datos relacional
- **MariaDB** - Base de datos MySQL compatible
- **Redis** - Cache y base de datos en memoria

### Autenticación
- **Keycloak** - Identity Provider (SSO)
- **OAuth 2.0 / OpenID Connect** - Protocolos de autenticación

## 📊 Estadísticas del Proyecto

### Infraestructura Virtual
- **Contenedores LXC**: 14 (100, 101, 102, 103, 105, 106, 107, 108, 110, 111, 112, 113, 114, 115)
- **Máquinas Virtuales**: 2 (104 CasaOS, 109 Immich)
- **Servicios Docker**: 40+
- **Dominios internos**: 25+
- **Redes configuradas**: 2 (vmbr0 LAN + vmbr10 Privada)

### Recursos Asignados (Virtual)
- **CPU Total Asignada**: 23 vCPU
- **RAM Total Asignada**: 28 GB
- **Almacenamiento Total Asignado**: 316 GB

> **⚠️ Nota sobre Overcommit**: Los recursos asignados usan overcommit de virtualización. El host físico tiene **4 cores / 8 threads** y **16 GB de RAM física**, pero la suma de recursos virtuales asignados es superior porque no todos los servicios consumen su máximo simultáneamente. Proxmox gestiona esto eficientemente mediante balanceo dinámico de recursos.

### Documentación y Automatización
- **Backups automáticos**: 3 niveles (local, remoto, selectivo)
- **Líneas de documentación**: 5500+
- **Scripts de automatización**: 20+

## 🎯 Casos de Uso

Este homelab es perfecto para:

- 🏠 **Hogar**: Reemplazar servicios cloud por alternativas self-hosted
- 📚 **Aprendizaje**: Practicar con tecnologías enterprise
- 💼 **Desarrollo**: Entorno de pruebas local
- 🔒 **Privacidad**: Control total sobre tus datos
- 💰 **Ahorro**: Evitar suscripciones mensuales a servicios cloud

## 🗺️ Roadmap

### ✅ Completado
- [x] Infraestructura base Proxmox
- [x] Redes LAN y privada
- [x] VPN con Tailscale
- [x] Dashboards múltiples
- [x] Monitoring completo
- [x] Backups automáticos
- [x] SSO con Keycloak
- [x] 15 bloques principales y 40+ servicios Docker funcionando

### 🚧 En Progreso
- [ ] Documentación completa de todos los servicios
- [ ] Scripts de automatización mejorados
- [ ] Diagramas visuales actualizados

### 📋 Futuro
- [ ] Jellyfin (Media server)
- [ ] Arr stack (Radarr, Sonarr, etc.)
- [ ] n8n (Automatización)
- [ ] Guacamole (Acceso remoto)
- [ ] Ollama + Open WebUI (IA local)
- [ ] Minecraft Server

## 🤝 Feedback y Mejoras

Este repositorio documenta una implementación real de homelab. Si encuentras errores, contradicciones o tienes sugerencias:

- 📝 [Reportar error en documentación](../../issues/new?template=bug_report.md)
- 💡 [Sugerir mejora](../../issues/new?template=feature_request.md)
- ❓ [Hacer una pregunta](../../discussions)

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles sobre cómo contribuir.

### Qué puedes reportar

- Errores en comandos o configuraciones
- Contradicciones de IPs/puertos
- Enlaces rotos
- Mejoras de seguridad
- Sugerencias de servicios adicionales
- Formas más claras de documentar

## 📝 Licencia

Este proyecto está bajo la licencia MIT. Ver [LICENSE](LICENSE) para más detalles.

## 🙏 Agradecimientos

Este proyecto no sería posible sin:

- La comunidad de **Proxmox**
- La comunidad de **r/selfhosted**
- Todos los proyectos open-source utilizados
- Los desarrolladores de cada servicio incluido

## 📸 Screenshots

> Pendiente de añadir capturas anonimizadas de dashboards y servicios principales

---

<div align="center">

**Construido con ❤️ para la comunidad self-hosted**

[⬆ Volver arriba](#-proxmox-homelab---self-hosted-infrastructure)

</div>