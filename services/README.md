# 📦 Servicios del Homelab

Este directorio contiene las configuraciones de todos los servicios del homelab, organizados por contenedor.

## 📋 Índice de Servicios

### 🌐 Red LAN (192.168.1.0/24)

| ID | Nombre | IP | Servicios | Estado |
|----|--------|-----|-----------|--------|
| [CT100](ct100-tailscale/) | Tailscale Gateway | 192.168.1.87 | Tailscale, VPN, NAT | 📝 Pendiente |
| [CT101](ct101-dashboard/) | Dashboards | 192.168.1.79 | Homepage, Homarr, Homer, Heimdall | ✅ Documentado |
| [CT102](ct102-portainer/) | Portainer | 192.168.1.80 | Portainer CE | 📝 Pendiente |
| [CT103](ct103-dns/) | DNS | 192.168.1.53 | AdGuard Home | 📝 Pendiente |
| [VM104](vm104-casaos/) | CasaOS/NAS | 192.168.1.81 | CasaOS, Samba, Syncthing, Duplicati | 📝 Pendiente |
| [CT112](ct112-proxy/) | Proxy | 192.168.1.82 | Nginx Proxy Manager | 📝 Pendiente |

### 🔒 Red Privada (10.10.10.0/24)

| ID | Nombre | IP | Servicios | Estado |
|----|--------|-----|-----------|--------|
| [CT105](ct105-monitoring/) | Monitoring | 10.10.10.50 | Grafana, Prometheus, Uptime Kuma, Beszel, Scrutiny | 📝 Pendiente |
| [CT106](ct106-vaultwarden/) | Vaultwarden | 10.10.10.60 | Vaultwarden | 📝 Pendiente |
| [CT107](ct107-paperless/) | Paperless | 10.10.10.40 | Paperless-ngx | 📝 Pendiente |
| [CT108](ct108-nextcloud/) | Nextcloud | 10.10.10.65 | Nextcloud | 📝 Pendiente |
| [VM109](vm109-immich/) | Immich | 10.10.10.30 | Immich | 📝 Pendiente |
| [CT110](ct110-tools/) | Tools | 10.10.10.70 | IT-Tools, Stirling PDF | 📝 Pendiente |
| [CT111](ct111-databases/) | Databases | 10.10.10.73 | PostgreSQL, MariaDB, Redis, Adminer, pgAdmin | 📝 Pendiente |
| [CT113](ct113-identity/) | Identity/SSO | 10.10.10.74 | Keycloak | 📝 Pendiente |
| [CT114](ct114-music/) | Music | 10.10.10.82 | Navidrome | 📝 Pendiente |
| [CT115](ct115-downloads/) | Downloads | 10.10.10.83 | Music Downloader | 📝 Pendiente |

## 📁 Estructura de Cada Servicio

Cada carpeta de servicio contiene:

```
ctXXX-nombre/
├── README.md              # Documentación completa del servicio
├── docker-compose.yml     # Stack de Docker Compose
├── configs/               # Configuraciones de ejemplo
│   └── servicio/
├── setup.sh              # Script de instalación (opcional)
└── .env.example          # Variables de entorno de ejemplo
```

## 🚀 Cómo Usar

### 1. Crear el Contenedor en Proxmox

Cada servicio tiene su propio script de creación en `/scripts/container-creation/`:

```bash
# Ejemplo para CT101
bash scripts/container-creation/create-ct101.sh
```

O crear manualmente siguiendo las especificaciones en el README del servicio.

### 2. Instalar Docker (si aplica)

La mayoría de servicios usan Docker:

```bash
# Entrar al contenedor
pct enter XXX

# Instalar Docker
curl -fsSL https://get.docker.com | sh
apt install -y docker-compose-plugin
```

### 3. Desplegar el Servicio

```bash
# Copiar archivos del servicio
cd /opt/
mkdir nombre-servicio
cd nombre-servicio

# Copiar docker-compose.yml y configs
# Luego iniciar
docker compose up -d
```

## 📊 Recursos por Servicio

### Resumen de Recursos

| Servicio | CPU | RAM | Disco | Prioridad |
|----------|-----|-----|-------|-----------|
| CT100 Tailscale | 1 | 1GB | 8GB | Alta |
| CT101 Dashboards | 1 | 1GB | 12GB | Media |
| CT102 Portainer | 1 | 1GB | 8GB | Alta |
| CT103 DNS | 1 | 512MB | 4GB | Crítica |
| VM104 CasaOS | 2 | 4GB | 32GB | Alta |
| CT105 Monitoring | 2 | 2GB | 16GB | Alta |
| CT106 Vaultwarden | 1 | 512MB | 4GB | Crítica |
| CT107 Paperless | 2 | 2GB | 16GB | Media |
| CT108 Nextcloud | 2 | 2GB | 16GB | Alta |
| VM109 Immich | 4 | 6GB | 64GB | Media |
| CT110 Tools | 1 | 1GB | 8GB | Baja |
| CT111 Databases | 2 | 4GB | 32GB | Alta |
| CT112 Proxy | 1 | 1GB | 8GB | Crítica |
| CT113 Keycloak | 2 | 2GB | 8GB | Alta |
| CT114 Navidrome | 1 | 1GB | 8GB | Baja |
| CT115 Downloads | 1 | 1GB | 8GB | Baja |

**Total**: ~8 CPU cores, ~28GB RAM, ~250GB disco

## 🔗 Dependencias Entre Servicios

### Servicios Core (Instalar Primero)

1. **CT100 - Tailscale**: VPN y gateway
2. **CT103 - DNS**: Resolución de dominios .home.arpa
3. **CT112 - Proxy**: Reverse proxy y SSL

### Servicios de Gestión

4. **CT101 - Dashboards**: Visualización
5. **CT102 - Portainer**: Gestión de contenedores
6. **CT105 - Monitoring**: Métricas y alertas

### Servicios de Datos

7. **VM104 - CasaOS**: NAS y almacenamiento
8. **CT111 - Databases**: Bases de datos centralizadas

### Servicios de Aplicación

9. **CT113 - Keycloak**: SSO (si quieres autenticación centralizada)
10. Resto de servicios según necesidad

## 🔐 Seguridad

### Servicios en Red LAN
- Accesibles desde red local
- Usar autenticación fuerte
- Considerar proxy reverso

### Servicios en Red Privada
- Solo accesibles vía Tailscale o proxy
- Datos sensibles aislados
- Autenticación adicional recomendada

## 📚 Documentación Adicional

- [Arquitectura General](../docs/01-getting-started/architecture.md)
- [Guía de Redes](../docs/03-networking/)
- [Troubleshooting](../docs/11-maintenance/troubleshooting.md)

## 🆘 Soporte

Si tienes problemas con algún servicio:

1. Revisa el README del servicio específico
2. Consulta los logs: `docker compose logs`
3. Revisa la [guía de troubleshooting](../docs/11-maintenance/troubleshooting.md)
4. Abre un [issue en GitHub](../../issues)

## 🤝 Contribuir

¿Quieres añadir un nuevo servicio? Consulta la [guía de contribución](../CONTRIBUTING.md).

---

[⬅️ Volver al inicio](../README.md)