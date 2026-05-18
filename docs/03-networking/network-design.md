# Diseño de Red

Arquitectura y diseño de la red del homelab.

## 📋 Índice

- [Visión General](#visión-general)
- [Arquitectura de Red](#arquitectura-de-red)
- [Segmentación](#segmentación)
- [Flujo de Tráfico](#flujo-de-tráfico)

## Visión General

### Principios de Diseño

1. **Seguridad por Capas**
   - Separación de redes públicas y privadas
   - Firewall en múltiples niveles
   - Acceso basado en principio de mínimo privilegio

2. **Alta Disponibilidad**
   - Servicios críticos redundantes
   - Backups automáticos
   - Monitoreo continuo

3. **Escalabilidad**
   - Diseño modular
   - Fácil adición de servicios
   - Recursos asignados dinámicamente

4. **Simplicidad**
   - Configuración clara y documentada
   - Mantenimiento sencillo
   - Troubleshooting facilitado

## Arquitectura de Red

### Diagrama de Red Completo

```
                    Internet
                       │
                       │
                  [Router/Modem]
                  192.168.1.1
                       │
                       │
              ┌────────┴────────┐
              │                 │
         [Switch]          [WiFi AP]
              │                 │
              │                 │
      ┌───────┴───────┐        │
      │               │        │
[Proxmox Host]   [Dispositivos LAN]
192.168.1.10     192.168.1.x
      │
      │
      ├─── vmbr0 (LAN Bridge) ───────────────┐
      │    192.168.1.0/24                    │
      │                                      │
      │    ┌─────────────────────────────────┤
      │    │ Servicios Públicos (LAN)       │
      │    ├─────────────────────────────────┤
      │    │ CT100 - Tailscale (VPN)        │
      │    │ CT101 - Homarr (Dashboard)     │
      │    │ CT102 - Portainer (Docker Mgmt)│
      │    │ CT103 - AdGuard (DNS)          │
      │    │ CT112 - Nginx Proxy Manager    │
      │    └─────────────────────────────────┘
      │
      │
      └─── vmbr1 (Private Bridge) ───────────┐
           10.0.0.0/24                       │
                                             │
           ┌─────────────────────────────────┤
           │ Servicios Privados             │
           ├─────────────────────────────────┤
           │ CT105 - Grafana/Prometheus     │
           │ CT106 - Vaultwarden            │
           │ CT107 - Paperless-ngx          │
           │ CT108 - Nextcloud              │
           │ VM109 - Immich                 │
           │ CT110 - Herramientas           │
           │ CT111 - Bases de Datos         │
           │ CT113 - Keycloak (SSO)         │
           │ CT114 - Navidrome (Música)     │
           │ CT115 - qBittorrent            │
           └─────────────────────────────────┘
```

### Capas de Red

#### Capa 1: Internet y Gateway
- Router/Modem ISP
- Firewall del router
- NAT principal

#### Capa 2: Red LAN
- Switch principal
- WiFi Access Points
- Dispositivos de usuario

#### Capa 3: Hypervisor
- Proxmox Host
- Bridges de red
- Firewall de Proxmox

#### Capa 4: Servicios
- Contenedores LXC
- Máquinas virtuales
- Redes Docker internas

## Segmentación

### Red LAN (192.168.1.0/24)

**Propósito:** Servicios accesibles desde la red local

**Servicios:**
- Gestión de Proxmox
- Dashboard principal
- Proxy reverso
- DNS local
- VPN (Tailscale)

**Acceso:**
- Desde LAN: ✅ Directo
- Desde Internet: ❌ Bloqueado (excepto VPN)
- A Internet: ✅ Permitido

### Red Privada (10.0.0.0/24)

**Propósito:** Servicios sensibles aislados

**Servicios:**
- Vaultwarden (contraseñas)
- Nextcloud (archivos)
- Bases de datos
- Keycloak (autenticación)
- Monitoreo

**Acceso:**
- Desde LAN: ⚠️ A través de proxy
- Desde Internet: ❌ Bloqueado
- A Internet: ✅ Permitido (NAT)

### Red Tailscale (100.64.0.0/10)

**Propósito:** Acceso remoto seguro

**Características:**
- VPN mesh peer-to-peer
- Cifrado end-to-end
- Acceso desde cualquier lugar
- Sin abrir puertos

**Acceso:**
- A LAN: ✅ Subnet routing
- A Privada: ✅ A través de proxy
- Desde Internet: ✅ Autenticado

### Redes Docker (172.16.0.0/12)

**Propósito:** Comunicación entre contenedores Docker

**Características:**
- Redes aisladas por stack
- Bridge interno
- DNS automático

## Flujo de Tráfico

### Acceso Local (LAN)

```
Usuario LAN → Router → Switch → Proxmox Host
                                      │
                                      ├─→ vmbr0 → Servicios LAN
                                      └─→ vmbr1 → Proxy → Servicios Privados
```

### Acceso Remoto (Tailscale)

```
Usuario Remoto → Tailscale VPN → CT100 (Subnet Router)
                                      │
                                      ├─→ vmbr0 → Servicios LAN
                                      └─→ vmbr1 → Proxy → Servicios Privados
```

### Acceso a Internet desde Servicios

```
Servicio Privado (10.0.0.x) → vmbr1 → NAT → vmbr0 → Router → Internet
```

### Proxy Reverso

```
Cliente → Nginx Proxy Manager (CT112)
              │
              ├─→ homarr.local → CT101 (192.168.1.101)
              ├─→ vault.local → CT106 (10.0.0.106)
              ├─→ cloud.local → CT108 (10.0.0.108)
              └─→ grafana.local → CT105 (10.0.0.105)
```

## Direccionamiento IP

### Esquema de IPs

| Rango | Uso | Ejemplo |
|-------|-----|---------|
| .1-.9 | Infraestructura | Router, Proxmox |
| .10-.99 | Dispositivos | PCs, móviles |
| .100-.199 | Servicios LAN | Contenedores públicos |
| .200-.254 | Reservado | Futuro uso |

### Tabla de Asignaciones

#### Infraestructura
| IP | Hostname | Servicio |
|----|----------|----------|
| 192.168.1.1 | router | Gateway |
| 192.168.1.10 | proxmox | Hypervisor |

#### Servicios LAN (192.168.1.x)
| IP | ID | Hostname | Servicio |
|----|-------|----------|----------|
| 192.168.1.100 | CT100 | tailscale | VPN |
| 192.168.1.101 | CT101 | homarr | Dashboard |
| 192.168.1.102 | CT102 | portainer | Docker Mgmt |
| 192.168.1.103 | CT103 | adguard | DNS |
| 192.168.1.104 | VM104 | casaos | Storage |
| 192.168.1.112 | CT112 | proxy | Nginx PM |

#### Servicios Privados (10.0.0.x)
| IP | ID | Hostname | Servicio |
|----|-------|----------|----------|
| 10.0.0.105 | CT105 | monitoring | Grafana |
| 10.0.0.106 | CT106 | vault | Vaultwarden |
| 10.0.0.107 | CT107 | paperless | Paperless |
| 10.0.0.108 | CT108 | cloud | Nextcloud |
| 10.0.0.109 | VM109 | photos | Immich |
| 10.0.0.110 | CT110 | tools | Utilidades |
| 10.0.0.111 | CT111 | databases | PostgreSQL/MariaDB |
| 10.0.0.113 | CT113 | keycloak | SSO |
| 10.0.0.114 | CT114 | music | Navidrome |
| 10.0.0.115 | CT115 | downloads | qBittorrent |

## Puertos y Servicios

### Puertos Estándar

| Puerto | Servicio | Acceso |
|--------|----------|--------|
| 22 | SSH | LAN only |
| 53 | DNS | LAN + Privada |
| 80 | HTTP | Proxy |
| 443 | HTTPS | Proxy |
| 8006 | Proxmox UI | LAN only |
| 9090 | Portainer | LAN only |
| 41641 | Tailscale | Internet |

### Mapeo de Puertos

```
Cliente:443 → Nginx Proxy Manager:443
                    ↓
    ┌───────────────┼───────────────┐
    │               │               │
vault.local    cloud.local    grafana.local
    ↓               ↓               ↓
CT106:80       CT108:80       CT105:3000
```

## Seguridad

### Firewall por Capas

1. **Router:** Bloquea todo excepto VPN
2. **Proxmox:** Reglas por contenedor
3. **Contenedor:** iptables local
4. **Aplicación:** Autenticación propia

### Políticas de Acceso

```
┌─────────────────────────────────────────┐
│ Nivel de Acceso                         │
├─────────────────────────────────────────┤
│ 🔴 Crítico (Vaultwarden, Keycloak)     │
│    - Solo desde Tailscale               │
│    - 2FA obligatorio                    │
│    - Logs de auditoría                  │
├─────────────────────────────────────────┤
│ 🟡 Importante (Nextcloud, Paperless)   │
│    - LAN + Tailscale                    │
│    - Autenticación fuerte               │
│    - Backups diarios                    │
├─────────────────────────────────────────┤
│ 🟢 Normal (Immich, Navidrome)          │
│    - LAN + Tailscale                    │
│    - Autenticación básica               │
│    - Backups semanales                  │
└─────────────────────────────────────────┘
```

## Escalabilidad

### Añadir Nuevo Servicio

1. **Determinar criticidad**
   - ¿Crítico? → Red privada
   - ¿Normal? → Red LAN

2. **Asignar IP**
   - Seguir esquema de numeración
   - Documentar en tabla

3. **Configurar firewall**
   - Reglas específicas
   - Logging apropiado

4. **Configurar proxy**
   - Subdominio si es necesario
   - Certificado SSL

5. **Configurar backup**
   - Según criticidad
   - Verificar restauración

## Monitoreo

### Métricas de Red

- Ancho de banda por interfaz
- Latencia entre redes
- Paquetes perdidos
- Conexiones activas

### Alertas

- Interfaz caída
- Alta latencia (>100ms)
- Pérdida de paquetes (>1%)
- Ancho de banda saturado (>80%)

## 📚 Recursos Relacionados

- [Red LAN](lan-network.md)
- [Red Privada](private-network.md)
- [Firewall](firewall.md)
- [Rutas Estáticas](static-routes.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
