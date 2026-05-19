# Topología de Red

> **Arquitectura de red completa** del homelab con segmentación y routing

## Diagrama de Red

```
Internet
    │
    ├─── Router Principal (192.168.1.1)
    │
    └─── Red LAN (192.168.1.0/24)
            │
            ├─── Proxmox Host (192.168.1.200)
            │       │
            │       ├─── vmbr0 (Bridge LAN)
            │       │       │
            │       │       ├─── CT100 Tailscale (192.168.1.87)
            │       │       ├─── CT101 Dashboard (192.168.1.79)
            │       │       ├─── CT102 Portainer (192.168.1.80)
            │       │       ├─── CT103 DNS (192.168.1.53)
            │       │       ├─── VM104 CasaOS (192.168.1.81)
            │       │       └─── CT112 Nginx Proxy (192.168.1.82)
            │       │
            │       └─── vmbr10 (Bridge Privado)
            │               │
            │               └─── Red Privada (10.10.10.0/24)
            │                       │
            │                       ├─── CT100 Tailscale (10.10.10.87) [Gateway]
            │                       ├─── VM109 Immich (10.10.10.30)
            │                       ├─── CT107 Paperless (10.10.10.40)
            │                       ├─── CT105 Monitoring (10.10.10.50)
            │                       ├─── CT106 Vaultwarden (10.10.10.60)
            │                       ├─── CT108 Nextcloud (10.10.10.65)
            │                       ├─── CT110 Tools (10.10.10.70)
            │                       ├─── CT111 Databases (10.10.10.73)
            │                       ├─── CT113 Keycloak (10.10.10.74)
            │                       ├─── CT114 Music (10.10.10.82)
            │                       └─── CT115 Downloads (10.10.10.83)
            │
            └─── Tailscale VPN (100.x.x.x/32)
                    │
                    └─── Dispositivos Remotos
                            ├─── Laptop
                            ├─── Móvil
                            └─── Tablet
```

## Redes Definidas

### Red LAN (192.168.1.0/24)
- **Propósito**: Red local física, acceso desde casa
- **Gateway**: 192.168.1.1 (Router)
- **DNS**: 192.168.1.53 (AdGuard Home CT103)
- **DHCP**: 192.168.1.100-192.168.1.250 (Router)
- **Servicios Expuestos**:
  - CT100 Tailscale Gateway (192.168.1.87)
  - CT101 Dashboard (192.168.1.79)
  - CT102 Portainer (192.168.1.80)
  - CT103 DNS (192.168.1.53)
  - VM104 CasaOS (192.168.1.81)
  - CT112 Nginx Proxy (192.168.1.82)
  - Proxmox Host (192.168.1.200)

### Red Privada (10.10.10.0/24)
- **Propósito**: Red aislada para servicios sensibles
- **Gateway**: 10.10.10.87 (CT100 Tailscale)
- **DNS**: 192.168.1.53 (AdGuard vía routing)
- **Acceso**: Solo vía Tailscale VPN o desde LAN a través de CT100
- **Servicios**: Aplicaciones de productividad y utilidades

### Red Tailscale (100.x.x.x/32)
- **Propósito**: VPN mesh para acceso remoto
- **Subnet Router**: CT100 (anuncia 10.10.10.0/24 y 192.168.1.0/24)
- **Dominios**: *.tailXXXXXX.ts.net
- **Certificados**: Let's Encrypt automático

## Bridges de Proxmox

### vmbr0 - Bridge LAN
```bash
# /etc/network/interfaces
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.200/24
    gateway 192.168.1.1
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0
```

**Conectado a**:
- Interfaz física: `enp3s0`
- CT100 (interfaz eth0)
- CT101 Dashboard
- CT102 Portainer
- CT103 DNS
- VM104 CasaOS
- CT112 Nginx Proxy

### vmbr10 - Bridge Privado
```bash
# /etc/network/interfaces
auto vmbr10
iface vmbr10 inet manual
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward

# Nota: El gateway de la red privada es CT100 (10.10.10.87)
# CT100 realiza NAT y routing entre 10.10.10.0/24 y 192.168.1.0/24
# Proxmox vmbr10 es solo un bridge sin IP asignada
```

**Conectado a**:
- Sin interfaz física (virtual)
- CT100 (interfaz eth1)
- CT105 Monitoring
- CT106 Vaultwarden
- CT107 Paperless
- CT108 Nextcloud
- VM109 Immich
- CT110 Tools
- CT111 Databases
- CT113 Keycloak
- CT114 Music
- CT115 Downloads

## Routing y NAT

### CT100 - Subnet Router

#### Configuración de Red
```bash
# /etc/network/interfaces en CT100
auto eth0
iface eth0 inet static
    address 192.168.1.87/24
    gateway 192.168.1.1

auto eth1
iface eth1 inet static
    address 10.10.10.87/24
```

#### IP Forwarding
```bash
# /etc/sysctl.conf
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
```

#### Tailscale Subnet Router
```bash
# Anunciar ambas redes
tailscale up --advertise-routes=10.10.10.0/24,192.168.1.0/24 --accept-routes
```

### Flujo de Tráfico

#### Acceso Local (desde LAN)
```
Cliente LAN (192.168.1.x)
    ↓
DNS AdGuard (192.168.1.53)
    ↓
Resuelve vault.home.arpa → 10.10.10.60
    ↓
Router a través de CT100 (192.168.1.87)
    ↓
CT100 enruta a red privada (10.10.10.87)
    ↓
Servicio en red privada (10.10.10.60)
```

#### Acceso Remoto (vía Tailscale)
```
Cliente Remoto (100.x.x.x)
    ↓
Tailscale VPN
    ↓
CT100 Subnet Router (100.x.x.x)
    ↓
Red Privada (10.10.10.0/24)
    ↓
Servicio (10.10.10.60)
```

## Firewall

### Proxmox Host
```bash
# Permitir tráfico entre bridges
iptables -A FORWARD -i vmbr0 -o vmbr10 -j ACCEPT
iptables -A FORWARD -i vmbr10 -o vmbr0 -j ACCEPT

# NAT para red privada
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
```

### CT100 Tailscale
```bash
# Permitir forwarding entre interfaces
iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT
iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
iptables -A FORWARD -i tailscale0 -j ACCEPT

# NAT para Tailscale
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
```

### Reglas de Seguridad
1. **Red privada no accesible desde Internet**: Solo vía Tailscale
2. **DNS solo desde LAN**: AdGuard no expuesto externamente
3. **Proxmox solo desde LAN**: Puerto 8006 no accesible remotamente
4. **SSH solo con clave**: Contraseñas deshabilitadas

## Asignación de IPs

### Estáticas en Red LAN
| IP            | Dispositivo      | Notas                    |
| ------------- | ---------------- | ------------------------ |
| 192.168.1.1   | Router           | Gateway principal        |
| 192.168.1.53  | CT103 DNS        | AdGuard Home             |
| 192.168.1.79  | CT101 Dashboard  | Homarr/Homer/Heimdall    |
| 192.168.1.80  | CT102 Portainer  | Gestión Docker           |
| 192.168.1.81  | VM104 CasaOS     | NAS + Backups            |
| 192.168.1.82  | CT112 Proxy      | Nginx Proxy Manager      |
| 192.168.1.87  | CT100 Tailscale  | Gateway VPN              |
| 192.168.1.200 | Proxmox Host     | Servidor físico          |

### Estáticas en Red Privada
Ver [inventory.md](./inventory.md) para lista completa.

**Rangos**:
- `10.10.10.1-10.10.10.9`: Infraestructura (Proxmox gateway)
- `10.10.10.30-10.10.10.49`: Servicios de productividad
- `10.10.10.50-10.10.10.69`: Monitorización y gestión
- `10.10.10.70-10.10.10.89`: Utilidades y herramientas
- `10.10.10.90-10.10.10.99`: Reservado para expansión

## DNS y Resolución

### Flujo de Resolución DNS
```
Cliente solicita vault.home.arpa
    ↓
DNS configurado: 192.168.1.53 (AdGuard)
    ↓
AdGuard consulta DNS Rewrites
    ↓
Encuentra: vault.home.arpa → 10.10.10.60
    ↓
Devuelve IP al cliente
    ↓
Cliente conecta a 10.10.10.60:8080
```

### Dominios Tailscale
```
Cliente solicita vaultwarden.tailXXXXXX.ts.net
    ↓
Tailscale DNS (100.100.100.100)
    ↓
Resuelve a IP Tailscale de CT100
    ↓
Tailscale Serve redirige a 10.10.10.60:8080
    ↓
Servicio responde con certificado Let's Encrypt
```

## Almacenamiento

### Montajes de Red
```
Proxmox Host
    │
    ├─── /mnt/hdd250 (SSD Crucial MX500 250GB)
    │       └─── Backups locales
    │
    └─── Bind mounts a contenedores
            ├─── CT107 Paperless → /mnt/hdd250/paperless
            ├─── CT108 Nextcloud → /mnt/hdd250/nextcloud
            └─── VM109 Immich → /mnt/hdd250/immich
```

## Monitorización

### Puntos de Observabilidad
- **Prometheus**: Métricas de todos los servicios
- **Grafana**: Dashboards de red, CPU, RAM, disco
- **Loki**: Logs centralizados
- **Uptime Kuma**: Monitorización de disponibilidad
- **Beszel**: Monitoring ligero de recursos

### Métricas de Red
```bash
# Tráfico entre bridges
iftop -i vmbr0
iftop -i vmbr10

# Conexiones activas
netstat -an | grep ESTABLISHED

# Estadísticas de Tailscale
tailscale status
tailscale netcheck
```

## Troubleshooting

### Verificar Conectividad

#### Desde Proxmox Host
```bash
# Ping a red LAN
ping 192.168.1.53

# Ping a red privada
ping 10.10.10.60

# Verificar routing
ip route show
```

#### Desde CT100
```bash
# Verificar interfaces
ip addr show

# Verificar forwarding
cat /proc/sys/net/ipv4/ip_forward

# Verificar Tailscale
tailscale status
```

#### Desde Contenedor en Red Privada
```bash
# Verificar gateway
ip route show default

# Ping a gateway
ping 10.10.10.87

# Ping a Internet
ping 1.1.1.1

# Verificar DNS
nslookup vault.home.arpa 192.168.1.53
```

### Problemas Comunes

#### No hay conectividad a Internet desde red privada
```bash
# Verificar NAT en Proxmox
iptables -t nat -L POSTROUTING -v

# Verificar forwarding
sysctl net.ipv4.ip_forward
```

#### DNS no resuelve dominios .home.arpa
```bash
# Verificar AdGuard Home
docker ps | grep adguard

# Verificar DNS Rewrites en la UI
# http://192.168.1.53 → Filters → DNS rewrites

# Reiniciar AdGuard
docker restart adguardhome
```

#### Tailscale no puede acceder a red privada
```bash
# Verificar subnet routes
tailscale status | grep "subnet routes"

# Verificar en admin console
# https://login.tailscale.com/admin/machines
# Aprobar rutas anunciadas
```

## Seguridad

### Principios
1. **Defensa en profundidad**: Múltiples capas de seguridad
2. **Mínimo privilegio**: Solo acceso necesario
3. **Segmentación**: Servicios críticos en red privada
4. **Cifrado**: TLS/SSL para todo el tráfico
5. **Autenticación**: SSO con Keycloak

### Zonas de Seguridad
- **Zona Pública (LAN)**: DNS, dashboards, gestión básica
- **Zona Privada**: Servicios de aplicaciones sensibles
- **Zona VPN**: Acceso remoto controlado
- **Zona Gestión**: Proxmox, Portainer (solo LAN)

## Escalabilidad

### Añadir Nuevo Servicio

#### En Red LAN
1. Crear contenedor conectado a vmbr0
2. Asignar IP estática en rango 192.168.1.x
3. Añadir DNS Rewrite en AdGuard
4. Documentar en inventory.md

#### En Red Privada
1. Crear contenedor conectado a vmbr10
2. Asignar IP estática en rango 10.10.10.x
3. Configurar gateway: 10.10.10.87
4. Añadir DNS Rewrite en AdGuard
5. Configurar en Nginx Proxy Manager (opcional)
6. Documentar en inventory.md
7. Añadir monitorización en Grafana

### Añadir Nueva Red
1. Crear nuevo bridge en Proxmox (vmbr11)
2. Configurar routing en CT100
3. Actualizar firewall
4. Documentar topología

## Referencias

- [Proxmox Network Configuration](https://pve.proxmox.com/wiki/Network_Configuration)
- [Tailscale Subnet Routers](https://tailscale.com/kb/1019/subnets/)
- [Linux IP Forwarding](https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](inventory.md) | [🌐 Ver Dominios](domains.md)