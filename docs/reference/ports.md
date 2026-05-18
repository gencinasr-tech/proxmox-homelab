# Mapeo de Puertos

> **Referencia completa** de puertos internos Docker vs puertos publicados en hosts

## Convenciones

- **Puerto Interno**: Puerto que usa la aplicación dentro del contenedor Docker
- **Puerto Publicado**: Puerto expuesto en el host LXC/VM
- **Acceso**: URL de acceso al servicio

## Servicios Core

### CT100 - Tailscale Gateway
| Servicio  | Puerto Interno | Puerto Publicado | Protocolo | Notas                    |
| --------- | -------------- | ---------------- | --------- | ------------------------ |
| Tailscale | -              | -                | UDP       | VPN mesh, no puertos fijos |

### CT101 - Dashboard (Homarr)
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| Homarr   | 7575           | 7575             | http://10.10.10.10:7575 |

### CT102 - Portainer
| Servicio  | Puerto Interno | Puerto Publicado | Acceso                   |
| --------- | -------------- | ---------------- | ------------------------ |
| Portainer | 9000           | 9000             | http://10.10.10.20:9000  |
| HTTPS     | 9443           | 9443             | https://10.10.10.20:9443 |

### CT103 - DNS (Pi-hole)
| Servicio | Puerto Interno | Puerto Publicado | Acceso                    |
| -------- | -------------- | ---------------- | ------------------------- |
| DNS      | 53             | 53               | 192.168.1.53              |
| Web UI   | 80             | 80               | http://192.168.1.53/admin |

### VM104 - CasaOS
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| Web UI   | 80             | 80               | http://10.10.10.25      |
| Files    | 8080           | 8080             | http://10.10.10.25:8080 |

## Servicios de Gestión

### CT105 - Monitoring
| Servicio   | Puerto Interno | Puerto Publicado | Acceso                   |
| ---------- | -------------- | ---------------- | ------------------------ |
| Grafana    | 3000           | 3002             | http://10.10.10.50:3002  |
| Prometheus | 9090           | 9090             | http://10.10.10.50:9090  |
| Loki       | 3100           | 3001             | http://10.10.10.50:3001  |

**Nota**: Grafana usa puerto interno 3000 pero se publica en 3002 para evitar conflictos.

### CT112 - Nginx Proxy Manager
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| HTTP     | 80             | 80               | http://10.10.10.80      |
| HTTPS    | 443            | 443              | https://10.10.10.80     |
| Admin UI | 81             | 81               | http://10.10.10.80:81   |

## Servicios de Productividad

### CT106 - Vaultwarden
| Servicio    | Puerto Interno | Puerto Publicado | Acceso                  |
| ----------- | -------------- | ---------------- | ----------------------- |
| Web Vault   | 80             | 8080             | http://10.10.10.60:8080 |
| WebSocket   | 3012           | 3012             | ws://10.10.10.60:3012   |

**Acceso Tailscale**: https://vaultwarden.tailXXXXXX.ts.net

### CT107 - Paperless-ngx
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| Web UI   | 8000           | 8000             | http://10.10.10.40:8000 |

### CT108 - Nextcloud
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| Web UI   | 80             | 8088             | http://10.10.10.65:8088 |

**Nota**: Puerto 8088 para evitar conflicto con otros servicios web.

### VM109 - Immich
| Servicio      | Puerto Interno | Puerto Publicado | Acceso                  |
| ------------- | -------------- | ---------------- | ----------------------- |
| Web UI        | 2283           | 2283             | http://10.10.10.30:2283 |
| Machine Learning | 3003        | 3003             | Interno                 |

## Servicios de Utilidades

### CT110 - Media Tools
| Servicio  | Puerto Interno | Puerto Publicado | Acceso                  |
| --------- | -------------- | ---------------- | ----------------------- |
| Jellyfin  | 8096           | 8096             | http://10.10.10.70:8096 |
| Sonarr    | 8989           | 8989             | http://10.10.10.70:8989 |
| Radarr    | 7878           | 7878             | http://10.10.10.70:7878 |

### CT111 - Databases
| Servicio   | Puerto Interno | Puerto Publicado | Acceso          |
| ---------- | -------------- | ---------------- | --------------- |
| PostgreSQL | 5432           | 5432             | 10.10.10.73:5432 |
| MariaDB    | 3306           | 3306             | 10.10.10.73:3306 |

**Nota**: Solo accesible desde otros contenedores, no expuesto públicamente.

### CT114 - Navidrome
| Servicio  | Puerto Interno | Puerto Publicado | Acceso                  |
| --------- | -------------- | ---------------- | ----------------------- |
| Web UI    | 4533           | 4533             | http://10.10.10.82:4533 |

### CT115 - Downloads
| Servicio    | Puerto Interno | Puerto Publicado | Acceso                  |
| ----------- | -------------- | ---------------- | ----------------------- |
| qBittorrent | 8080           | 6595             | http://10.10.10.83:6595 |
| Prowlarr    | 9696           | 9696             | http://10.10.10.83:9696 |
| Bazarr      | 6767           | 6767             | http://10.10.10.83:6767 |

**Nota**: qBittorrent usa puerto interno 8080 pero se publica en 6595 para evitar conflictos.

## Servicios de Autenticación

### CT113 - Keycloak
| Servicio | Puerto Interno | Puerto Publicado | Acceso                  |
| -------- | -------------- | ---------------- | ----------------------- |
| HTTP     | 8080           | 8080             | http://10.10.10.74:8080 |

## Rangos de Puertos Reservados

| Rango      | Uso                          |
| ---------- | ---------------------------- |
| 1-1024     | Puertos privilegiados (DNS, HTTP, HTTPS) |
| 3000-3999  | Servicios de monitorización  |
| 4000-4999  | Aplicaciones multimedia     |
| 5000-5999  | Bases de datos               |
| 6000-6999  | Utilidades y herramientas    |
| 7000-7999  | Dashboards y gestión         |
| 8000-8999  | Servicios web principales    |
| 9000-9999  | Gestión y administración     |

## Firewall y Seguridad

### Puertos Expuestos en LAN (192.168.1.0/24)
- **53** (DNS): CT103 Pi-hole
- **80** (HTTP): CT103 Pi-hole admin

### Puertos en Red Privada (10.10.10.0/24)
- Todos los demás servicios
- Solo accesibles vía Tailscale VPN
- CT100 actúa como gateway

## Notas de Configuración

### Docker Compose
Ejemplo de mapeo de puertos en `docker-compose.yml`:

```yaml
services:
  app:
    ports:
      - "8080:80"  # host:container
      # Puerto 8080 en host → Puerto 80 en contenedor
```

### Verificación de Puertos
```bash
# Ver puertos en uso en un contenedor
netstat -tulpn | grep LISTEN

# Ver puertos publicados por Docker
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

## Actualización

Este documento debe actualizarse cuando:
- Se añaden nuevos servicios
- Se cambian puertos publicados
- Se modifican configuraciones de red

**Última actualización**: 2026-01-18