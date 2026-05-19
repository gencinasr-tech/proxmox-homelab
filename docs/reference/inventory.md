# Inventario de Infraestructura

> **Fuente de Verdad Única**: Esta tabla define todos los recursos, IPs y configuraciones de la infraestructura. Todas las demás referencias deben coincidir con estos valores.

## Tabla Maestra de Servicios

| ID  | Nombre       | Tipo | Red            | CPU | RAM  | Disco | Puertos        | Dominio Interno      | Descripción                    |
| --- | ------------ | ---- | -------------- | --: | ---: | ----: | -------------- | -------------------- | ------------------------------ |
| 100 | tailscale-gw | LXC  | 192.168.1.87 / 10.10.10.87 | 1 | 1GB | 8GB | - | - | VPN Gateway y Subnet Router |
| 101 | dashboard    | LXC  | 192.168.1.79   |   1 |  1GB |  12GB | 3000/7575/8080/8081 | homarr.home.arpa | Homepage, Homarr, Homer, Heimdall |
| 102 | portainer    | LXC  | 192.168.1.80   |   1 |  1GB |  12GB | 9000/9443      | portainer.home.arpa  | Gestión de contenedores        |
| 103 | dns          | LXC  | 192.168.1.53   |   1 |  1GB |  12GB | 53/80          | adguard.home.arpa    | AdGuard Home DNS               |
| 104 | casaos       | VM   | 192.168.1.81   |   2 |  4GB |  32GB | 80/8384/8200   | casaos.home.arpa     | NAS: Samba, Syncthing, Duplicati |
| 105 | monitoring   | LXC  | 10.10.10.50    |   1 |  1GB |  16GB | 3001/3002/8085/8086/8090/9090 | grafana.home.arpa | Grafana, Prometheus, Kuma, Beszel |
| 106 | vaultwarden  | LXC  | 10.10.10.60    |   1 |  1GB |  12GB | 8080           | vault.home.arpa      | Gestor de contraseñas          |
| 107 | paperless    | LXC  | 10.10.10.40    |   1 |  1GB |  16GB | 8000           | paperless.home.arpa  | Gestión documental             |
| 108 | nextcloud    | LXC  | 10.10.10.65    |   2 |  2GB |  32GB | 8088           | nextcloud.home.arpa  | Nube privada                   |
| 109 | immich       | VM   | 10.10.10.30    |   4 |  6GB |  64GB | 2283           | immich.home.arpa     | Gestión de fotos con IA        |
| 110 | tools        | LXC  | 10.10.10.70    |   1 |  1GB |  16GB | 8080/8081      | tools.home.arpa      | IT-Tools, Stirling PDF         |
| 111 | databases    | LXC  | 10.10.10.73    |   1 |  2GB |  24GB | 5432/3306/8080/8082/8083 | - | PostgreSQL, MariaDB, Adminer, pgAdmin |
| 112 | proxy        | LXC  | 192.168.1.82   |   1 |  1GB |  12GB | 80/443/81      | npm.home.arpa        | Nginx Proxy Manager            |
| 113 | keycloak     | LXC  | 10.10.10.74    |   2 |  2GB |  24GB | 8080           | auth.home.arpa       | Identity Provider (SSO)        |
| 114 | music        | LXC  | 10.10.10.82    |   1 |  1GB |  12GB | 4533           | music.home.arpa      | Navidrome                      |
| 115 | downloads    | LXC  | 10.10.10.83    |   2 |  2GB |  12GB | 6595           | downloads.home.arpa  | Music Downloader               |

## Resumen de Recursos

### Total Asignado
- **LXC Containers**: 14
- **Virtual Machines**: 2
- **CPU Total**: 23 cores
- **RAM Total**: 28 GB
- **Almacenamiento Total**: 316 GB

### Distribución por Red
- **Red LAN (192.168.1.0/24)**: CT100 (dual), CT101, CT102, CT103, VM104, CT112
- **Red Privada (10.10.10.0/24)**: CT105, CT106, CT107, CT108, VM109, CT110, CT111, CT113, CT114, CT115

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