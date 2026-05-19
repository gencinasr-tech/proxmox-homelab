# Mapeo de Puertos

> **Referencia completa** de puertos internos Docker vs puertos publicados en hosts

## Convenciones

- **Puerto Interno**: Puerto que usa la aplicación dentro del contenedor Docker
- **Puerto Publicado**: Puerto expuesto en el host LXC/VM
- **Acceso**: URL de acceso al servicio

## 🌐 Servicios en Red LAN (192.168.1.0/24)

### CT100 - Tailscale Gateway
| Servicio  | Puerto Interno | Puerto Publicado | Protocolo | Notas                    |
| --------- | -------------- | ---------------- | --------- | ------------------------ |
| Tailscale | -              | -                | UDP       | VPN mesh, no puertos fijos |

**IPs**: 192.168.1.87 (LAN) / 10.10.10.87 (Privada)

### CT101 - Dashboards
| Servicio | Puerto Interno | Puerto Publicado | Acceso                      |
| -------- | -------------- | ---------------- | --------------------------- |
| Homepage | 3000           | 3000             | http://192.168.1.79:3000    |
| Homarr   | 7575           | 7575             | http://192.168.1.79:7575    |
| Homer    | 8080           | 8080             | http://192.168.1.79:8080    |
| Heimdall | 8081           | 8081             | http://192.168.1.79:8081    |

### CT102 - Portainer
| Servicio  | Puerto Interno | Puerto Publicado | Acceso                       |
| --------- | -------------- | ---------------- | ---------------------------- |
| Portainer | 9000           | 9000             | http://192.168.1.80:9000     |
| HTTPS     | 9443           | 9443             | https://192.168.1.80:9443    |

### CT103 - DNS (AdGuard Home)
| Servicio | Puerto Interno | Puerto Publicado | Acceso                    |
| -------- | -------------- | ---------------- | ------------------------- |
| DNS      | 53             | 53               | 192.168.1.53              |
| Web UI   | 80             | 80               | http://192.168.1.53       |

### VM104 - CasaOS/NAS
| Servicio   | Puerto Interno | Puerto Publicado | Acceso                      |
| ---------- | -------------- | ---------------- | --------------------------- |
| CasaOS     | 80             | 80               | http://192.168.1.81         |
| Syncthing  | 8384           | 8384             | http://192.168.1.81:8384    |
| Duplicati  | 8200           | 8200             | http://192.168.1.81:8200    |

### CT112 - Nginx Proxy Manager
| Servicio | Puerto Interno | Puerto Publicado | Acceso                      |
| -------- | -------------- | ---------------- | --------------------------- |
| HTTP     | 80             | 80               | http://192.168.1.82         |
| HTTPS    | 443            | 443              | https://192.168.1.82        |
| Admin UI | 81             | 81               | http://192.168.1.82:81      |

## 🔒 Servicios en Red Privada (10.10.10.0/24)

### CT105 - Monitoring
| Servicio          | Puerto Interno | Puerto Publicado | Acceso                      |
| ----------------- | -------------- | ---------------- | --------------------------- |
| Uptime Kuma       | 3001           | 3001             | http://10.10.10.50:3001     |
| Grafana           | 3000           | 3002             | http://10.10.10.50:3002     |
| Speedtest Tracker | 80             | 8085             | http://10.10.10.50:8085     |
| Scrutiny          | 8080           | 8086             | http://10.10.10.50:8086     |
| Beszel            | 8090           | 8090             | http://10.10.10.50:8090     |
| Prometheus        | 9090           | 9090             | http://10.10.10.50:9090     |

**Nota**: Grafana usa puerto interno 3000 pero se publica en 3002 para evitar conflictos.

### CT106 - Vaultwarden
| Servicio    | Puerto Interno | Puerto Publicado | Acceso                      |
| ----------- | -------------- | ---------------- | --------------------------- |
| Web Vault   | 80             | 8080             | http://10.10.10.60:8080     |
| WebSocket   | 3012           | 3012             | ws://10.10.10.60:3012       |

**Acceso Tailscale**: https://vaultwarden.tailXXXXXX.ts.net

### CT107 - Paperless-ngx
| Servicio | Puerto Interno | Puerto Publicado | Acceso                      |
| -------- | -------------- | ---------------- | --------------------------- |
| Web UI   | 8000           | 8000             | http://10.10.10.40:8000     |

### CT108 - Nextcloud
| Servicio | Puerto Interno | Puerto Publicado | Acceso                      |
| -------- | -------------- | ---------------- | --------------------------- |
| Web UI   | 80             | 8088             | http://10.10.10.65:8088     |

**Nota**: Puerto 8088 para evitar conflicto con otros servicios web.

### VM109 - Immich
| Servicio         | Puerto Interno | Puerto Publicado | Acceso                      |
| ---------------- | -------------- | ---------------- | --------------------------- |
| Web UI           | 2283           | 2283             | http://10.10.10.30:2283     |
| Machine Learning | 3003           | 3003             | Interno                     |

### CT110 - Tools
| Servicio     | Puerto Interno | Puerto Publicado | Acceso                      |
| ------------ | -------------- | ---------------- | --------------------------- |
| IT-Tools     | 8080           | 8080             | http://10.10.10.70:8080     |
| Stirling PDF | 8081           | 8081             | http://10.10.10.70:8081     |

### CT111 - Databases
| Servicio   | Puerto Interno | Puerto Publicado | Acceso               |
| ---------- | -------------- | ---------------- | -------------------- |
| PostgreSQL | 5432           | 5432             | 10.10.10.73:5432     |
| MariaDB    | 3306           | 3306             | 10.10.10.73:3306     |
| Adminer    | 8080           | 8080             | http://10.10.10.73:8080 |
| pgAdmin    | 80             | 8082             | http://10.10.10.73:8082 |
| ChartDB    | 3000           | 8083             | http://10.10.10.73:8083 |

**Nota**: Bases de datos solo accesibles desde otros contenedores en red privada.

### CT113 - Keycloak
| Servicio | Puerto Interno | Puerto Publicado | Acceso                      |
| -------- | -------------- | ---------------- | --------------------------- |
| HTTP     | 8080           | 8080             | http://10.10.10.74:8080     |

### CT114 - Navidrome
| Servicio  | Puerto Interno | Puerto Publicado | Acceso                      |
| --------- | -------------- | ---------------- | --------------------------- |
| Web UI    | 4533           | 4533             | http://10.10.10.82:4533     |

### CT115 - Music Downloader
| Servicio         | Puerto Interno | Puerto Publicado | Acceso                      |
| ---------------- | -------------- | ---------------- | --------------------------- |
| Music Downloader | 8080           | 6595             | http://10.10.10.83:6595     |

**Nota**: Usa puerto interno 8080 pero se publica en 6595 para evitar conflictos.

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
- **53** (DNS): CT103 AdGuard Home
- **80** (HTTP): CT103 AdGuard, VM104 CasaOS, CT112 Nginx PM
- **443** (HTTPS): CT112 Nginx Proxy Manager
- **81** (Admin): CT112 Nginx Proxy Manager
- **3000-8384**: Dashboards y servicios de gestión

### Puertos en Red Privada (10.10.10.0/24)
- Todos los servicios de productividad y datos
- Solo accesibles vía Tailscale VPN o ruta estática
- CT100 actúa como gateway NAT

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

# Verificar puerto específico
ss -tulpn | grep :8080
```

## Actualización

Este documento debe actualizarse cuando:
- Se añaden nuevos servicios
- Se cambian puertos publicados
- Se modifican configuraciones de red

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](inventory.md) | [🌐 Ver Dominios](domains.md)