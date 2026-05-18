# Red LAN Principal

Configuración de la red LAN principal del homelab.

## 📋 Índice

- [Diseño de Red](#diseño-de-red)
- [Configuración de Interfaces](#configuración-de-interfaces)
- [VLAN Configuration](#vlan-configuration)
- [DHCP y DNS](#dhcp-y-dns)

## Diseño de Red

### Topología

```
Internet
   │
   ├─ Router (192.168.1.1)
   │
   ├─ Switch Principal
   │  │
   │  ├─ Proxmox Host (192.168.1.10)
   │  │  │
   │  │  ├─ vmbr0 (Bridge LAN)
   │  │  │  ├─ CT100 - Tailscale (192.168.1.87)
   │  │  │  ├─ CT101 - Dashboards (192.168.1.101)
   │  │  │  ├─ CT102 - Portainer (192.168.1.102)
   │  │  │  ├─ CT103 - DNS (192.168.1.103)
   │  │  │  └─ CT112 - Proxy (192.168.1.112)
   │  │  │
   │  │  └─ vmbr1 (Bridge Privada)
   │  │     ├─ CT105 - Monitoring (10.10.10.105)
   │  │     ├─ CT106 - Vaultwarden (10.10.10.106)
   │  │     └─ CT108 - Nextcloud (10.10.10.108)
   │  │
   │  ├─ Dispositivos LAN
   │  └─ WiFi Access Points
```

### Rangos de IP

| Red | Rango | Uso |
|-----|-------|-----|
| LAN Principal | 192.168.1.0/24 | Dispositivos generales |
| Red Privada | 10.10.10.0/24 | Servicios internos |
| Tailscale | 100.64.0.0/10 | VPN mesh |
| Docker | 172.16.0.0/12 | Redes Docker |

### Asignaciones Estáticas

#### Infraestructura
- `192.168.1.1` - Router/Gateway
- `192.168.1.10` - Proxmox Host
- `192.168.1.103` - DNS Server (AdGuard/Pi-hole)

#### Servicios Públicos (LAN)
- `192.168.1.87` - Tailscale
- `192.168.1.101` - Homarr Dashboard
- `192.168.1.102` - Portainer
- `192.168.1.112` - Nginx Proxy Manager

#### Servicios Privados (10.10.10.0/24)
- `10.10.10.105` - Grafana/Prometheus
- `10.10.10.106` - Vaultwarden
- `10.10.10.107` - Paperless-ngx
- `10.10.10.108` - Nextcloud
- `10.10.10.113` - Keycloak

## Configuración de Interfaces

### Bridge Principal (vmbr0)

```bash
# /etc/network/interfaces

auto vmbr0
iface vmbr0 inet static
    address 192.168.1.10/24
    gateway 192.168.1.1
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0
    # DNS
    dns-nameservers 192.168.1.103 1.1.1.1
```

### Bridge Privado (vmbr1)

```bash
# /etc/network/interfaces

auto vmbr1
iface vmbr1 inet static
    address 10.10.10.1/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    # NAT para acceso a internet
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
```

### Aplicar Cambios

```bash
# Reiniciar networking
systemctl restart networking

# O reiniciar interfaz específica
ifdown vmbr0 && ifup vmbr0

# Verificar configuración
ip addr show
ip route show
```

## VLAN Configuration

### Crear VLAN

```bash
# VLAN 10 para IoT
auto vmbr0.10
iface vmbr0.10 inet static
    address 192.168.10.1/24
    vlan-raw-device vmbr0

# VLAN 20 para Invitados
auto vmbr0.20
iface vmbr0.20 inet static
    address 192.168.20.1/24
    vlan-raw-device vmbr0
```

### Asignar VLAN a Contenedor

En la configuración del contenedor:

```bash
# /etc/pve/lxc/100.conf
net0: name=eth0,bridge=vmbr0,tag=10,firewall=1,hwaddr=XX:XX:XX:XX:XX:XX,ip=dhcp,type=veth
```

## DHCP y DNS

### Configuración de DNS

El servidor DNS (CT103) maneja:
- Resolución de nombres locales
- Bloqueo de publicidad
- DNS sobre HTTPS (DoH)

```bash
# Configurar DNS en Proxmox
echo "nameserver 192.168.1.103" > /etc/resolv.conf
echo "nameserver 1.1.1.1" >> /etc/resolv.conf
```

### Reservas DHCP

En tu router o servidor DHCP:

```
# Servicios críticos
192.168.1.10 - proxmox.local (MAC: XX:XX:XX:XX:XX:XX)
192.168.1.103 - dns.local (MAC: XX:XX:XX:XX:XX:XX)
192.168.1.112 - proxy.local (MAC: XX:XX:XX:XX:XX:XX)
```

## Routing

### Rutas Estáticas

```bash
# Ruta a red privada desde LAN
ip route add 10.10.10.0/24 via 192.168.1.10

# Ruta a Tailscale
ip route add 100.64.0.0/10 via 192.168.1.87
```

### NAT para Red Privada

```bash
# Habilitar IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Configurar NAT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE

# Hacer permanente
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```

## Troubleshooting

### Verificar Conectividad

```bash
# Ping a gateway
ping 192.168.1.1

# Ping a DNS
ping 192.168.1.103

# Ping a internet
ping 8.8.8.8
ping google.com

# Verificar rutas
ip route show

# Verificar interfaces
ip addr show
```

### Problemas Comunes

#### No hay conectividad

```bash
# Verificar estado de interfaces
ip link show

# Levantar interfaz
ip link set vmbr0 up

# Reiniciar networking
systemctl restart networking
```

#### DNS no resuelve

```bash
# Verificar DNS configurado
cat /etc/resolv.conf

# Probar resolución
nslookup google.com
dig google.com

# Cambiar DNS temporalmente
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

#### Bridge no funciona

```bash
# Verificar bridge
brctl show

# Ver estado
ip link show vmbr0

# Recrear bridge
ifdown vmbr0
ifup vmbr0
```

## Monitoreo de Red

### Tráfico de Red

```bash
# Ver tráfico en tiempo real
iftop -i vmbr0

# Estadísticas de red
nload vmbr0

# Conexiones activas
netstat -tulpn
ss -tulpn
```

### Logs de Red

```bash
# Ver logs de networking
journalctl -u networking -f

# Ver logs de firewall
tail -f /var/log/syslog | grep -i firewall
```

## Optimización

### Jumbo Frames

```bash
# Habilitar jumbo frames (MTU 9000)
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.10/24
    gateway 192.168.1.1
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0
    mtu 9000
```

### TCP Tuning

```bash
# /etc/sysctl.conf

# Aumentar buffers
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864

# Aplicar
sysctl -p
```

## Seguridad

### Mejores Prácticas

- ✅ Usar IPs estáticas para servicios críticos
- ✅ Segmentar redes con VLANs
- ✅ Configurar firewall en cada nivel
- ✅ Monitorear tráfico anómalo
- ✅ Mantener DNS actualizado

### Aislamiento de Redes

```bash
# Bloquear tráfico entre VLANs
iptables -A FORWARD -i vmbr0.10 -o vmbr0.20 -j DROP
iptables -A FORWARD -i vmbr0.20 -o vmbr0.10 -j DROP
```

## 📚 Recursos Relacionados

- [Diseño de Red](network-design.md)
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
