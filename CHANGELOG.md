# Changelog

Todos los cambios notables en este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/lang/es/).

## [1.0.0] - 2026-05-18

### Añadido
- Infraestructura completa de Proxmox homelab
- 13 contenedores LXC configurados
- 2 máquinas virtuales (CasaOS y Immich)
- Red LAN (192.168.1.0/24) y red privada (10.10.10.0/24)
- Tailscale como VPN y gateway entre redes
- Sistema de backups triple: local, remoto cifrado y selectivo
- SSO con Keycloak integrado en múltiples servicios
- Monitoring completo con Grafana, Prometheus, Uptime Kuma y Beszel
- 4 dashboards diferentes (Homepage, Homarr, Homer, Heimdall)
- Gestión centralizada con Portainer
- DNS local con AdGuard Home
- Reverse proxy con Nginx Proxy Manager
- Password manager con Vaultwarden (acceso público HTTPS)
- Gestión documental con Paperless-ngx
- Cloud personal con Nextcloud
- Galería de fotos con IA usando Immich
- NAS con CasaOS, Samba y Syncthing
- Servidor de música con Navidrome
- Herramientas útiles (IT-Tools, Stirling PDF)
- Bases de datos centralizadas (PostgreSQL, MariaDB, Redis)
- Scripts de automatización para instalación
- Documentación completa paso a paso
- 25+ dominios .home.arpa configurados

### Servicios Implementados

#### Core (LAN)
- CT100: Tailscale Gateway
- CT101: Dashboards
- CT102: Portainer
- CT103: DNS (AdGuard Home)
- VM104: CasaOS/NAS
- CT112: Nginx Proxy Manager

#### Privados (10.10.10.0/24)
- CT105: Monitoring Stack
- CT106: Vaultwarden
- CT107: Paperless-ngx
- CT108: Nextcloud
- VM109: Immich
- CT110: Tools
- CT111: Databases
- CT113: Keycloak (SSO)
- CT114: Navidrome
- CT115: Music Downloader

### Características Técnicas
- Proxmox VE 8.x como base
- Docker y Docker Compose para servicios
- LXC para contenedores ligeros
- Backups automáticos diarios a las 22:30
- Backups remotos semanales a Google Drive (cifrados)
- Rutas estáticas para acceso LAN → red privada
- Scripts de rendimiento (modo turbo y modo noche)
- Configuración de portátil (ignorar cierre de tapa)
- SSD 250GB (Crucial MX500) dedicado para backups locales
- Certificados SSL locales para dominios .home.arpa
- OAuth 2.0 / OpenID Connect para SSO
- Monitoring de discos con Scrutiny
- cAdvisor y socket-proxy en cada contenedor con Docker
- Beszel agents distribuidos para monitoring ligero

### Documentación
- README principal con overview completo
- Guía de instalación paso a paso (5500+ líneas)
- Arquitectura de red documentada
- Configuraciones de cada servicio
- Scripts de automatización
- Troubleshooting y solución de problemas

## [Unreleased]

### Planeado
- Diagramas visuales actualizados
- Screenshots de servicios
- Jellyfin para media streaming
- Arr stack (Radarr, Sonarr, Prowlarr, etc.)
- n8n para automatización
- Guacamole para acceso remoto
- Ollama + Open WebUI para IA local
- Minecraft Server
- Documentación en inglés
- Videos tutoriales
- Scripts de actualización automática
- Health checks automatizados
- Alertas por Telegram/Discord
- Backup físico externo

---

## Tipos de Cambios

- `Añadido` para nuevas características
- `Cambiado` para cambios en funcionalidad existente
- `Obsoleto` para características que serán removidas
- `Eliminado` para características removidas
- `Corregido` para corrección de bugs
- `Seguridad` para vulnerabilidades

[1.0.0]: https://github.com/tu-usuario/proxmox-homelab/releases/tag/v1.0.0