# Inventario de Infraestructura

> **Fuente de Verdad Única**: Esta tabla define todos los recursos, IPs y configuraciones de la infraestructura. Todas las demás referencias deben coincidir con estos valores.

## Tabla Maestra de Servicios

| ID  | Nombre       | Tipo | Red                        | CPU | RAM  | Disco | Puertos        | Dominio Interno      | Descripción                    |
| --- | ------------ | ---- | -------------------------- | --: | ---: | ----: | -------------- | -------------------- | ------------------------------ |
| 100 | tailscale-gw | LXC  | 192.168.1.87 / 10.10.10.87 |   1 |  1GB |   8GB | -              | -                    | VPN Gateway y Subnet Router    |
| 101 | dashboard    | LXC  | 10.10.10.10                |   1 |  1GB |  12GB | 7575           | homarr.home.arpa     | Dashboard Homarr               |
| 102 | portainer    | LXC  | 10.10.10.20                |   1 |  1GB |  12GB | 9000/9443      | portainer.home.arpa  | Gestión de contenedores        |
| 103 | dns          | LXC  | 192.168.1.53               |   1 |  1GB |   8GB | 53             | -                    | Pi-hole DNS                    |
| 104 | casaos       | VM   | 10.10.10.25                |   2 |  4GB |  64GB | 80             | casaos.home.arpa     | Sistema de archivos CasaOS     |
| 105 | monitoring   | LXC  | 10.10.10.50                |   1 |  1GB |  16GB | 3001/3002/9090 | grafana.home.arpa    | Grafana + Prometheus           |
| 106 | vaultwarden  | LXC  | 10.10.10.60                |   1 |  1GB |  12GB | 8080           | vault.home.arpa      | Gestor de contraseñas          |
| 107 | paperless    | LXC  | 10.10.10.40                |   2 |  2GB |  24GB | 8000           | paperless.home.arpa  | Gestión documental             |
| 108 | nextcloud    | LXC  | 10.10.10.65                |   2 |  4GB |  32GB | 8088           | nextcloud.home.arpa  | Nube privada                   |
| 109 | immich       | VM   | 10.10.10.30                |   4 |  6GB |  64GB | 2283           | immich.home.arpa     | Gestión de fotos               |
| 110 | tools        | LXC  | 10.10.10.70                |   1 |  1GB |  16GB | 8096/8989/7878 | jellyfin.home.arpa   | Jellyfin + Sonarr + Radarr     |
| 111 | databases    | LXC  | 10.10.10.73                |   1 |  2GB |  24GB | 5432/3306      | -                    | PostgreSQL + MariaDB           |
| 112 | proxy        | LXC  | 10.10.10.80                |   1 |  1GB |  12GB | 80/443/81      | proxy.home.arpa      | Nginx Proxy Manager            |
| 113 | keycloak     | LXC  | 10.10.10.74                |   2 |  2GB |  24GB | 8080           | auth.home.arpa       | Identity Provider (SSO)        |
| 114 | music        | LXC  | 10.10.10.82                |   1 |  1GB |  12GB | 4533           | music.home.arpa      | Navidrome                      |
| 115 | downloads    | LXC  | 10.10.10.83                |   2 |  2GB |  24GB | 6595           | qbit.home.arpa       | qBittorrent + Prowlarr + Bazarr|

## Resumen de Recursos

### Total Asignado
- **LXC Containers**: 13
- **Virtual Machines**: 2
- **CPU Total**: 24 cores
- **RAM Total**: 32 GB
- **Almacenamiento Total**: 316 GB

### Distribución por Red
- **Red LAN (192.168.1.0/24)**: CT100 (dual), CT103
- **Red Privada (10.10.10.0/24)**: Todos los demás servicios

## Notas Importantes

### Convenciones de Nomenclatura
- **CTxxx**: LXC Container
- **VMxxx**: Virtual Machine
- **IDs 100-109**: Servicios core y gestión
- **IDs 110-119**: Aplicaciones y utilidades

### Acceso a Servicios
- **Servicios en red privada**: Solo accesibles vía Tailscale VPN
- **Servicios en red LAN**: Accesibles desde la red local
- **CT100**: Actúa como gateway entre ambas redes

### Dominios Internos
- Todos los dominios usan el TLD `.home.arpa` (RFC 8375)
- Resueltos por Pi-hole (CT103) en 192.168.1.53
- Configuración DNS local en `/etc/pihole/custom.list`

### Puertos
- Los puertos listados son los **puertos publicados** en el host
- Los puertos internos de Docker pueden ser diferentes
- Ver [ports.md](./ports.md) para mapeo detallado

## Actualización de este Documento

Este inventario debe actualizarse cuando:
- Se añade o elimina un servicio
- Se cambian recursos (CPU/RAM/Disco)
- Se modifican IPs o puertos
- Se actualizan dominios internos

**Última actualización**: 2026-01-18