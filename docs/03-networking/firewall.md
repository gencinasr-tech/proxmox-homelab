# Configuración del Firewall

Guía para configurar el firewall de Proxmox y proteger tu homelab.

## 📋 Índice

- [Firewall de Proxmox](#firewall-de-proxmox)
- [Reglas Básicas](#reglas-básicas)
- [Firewall por Contenedor](#firewall-por-contenedor)
- [Mejores Prácticas](#mejores-prácticas)

## Firewall de Proxmox

### Activar Firewall

```bash
# Activar firewall a nivel de datacenter
pvesh set /cluster/firewall/options --enable 1

# Activar firewall a nivel de nodo
pvesh set /nodes/$(hostname)/firewall/options --enable 1
```

### Configuración Básica

En la interfaz web de Proxmox:

1. **Datacenter → Firewall → Options**
   - Enable: Yes
   - Input Policy: DROP
   - Output Policy: ACCEPT
   - Forward Policy: DROP

2. **Datacenter → Firewall → Rules**
   - Añadir reglas necesarias

## Reglas Básicas

### Permitir SSH

```bash
# Regla para SSH
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 22
Source: 192.168.1.0/24
Comment: Allow SSH from LAN
```

### Permitir Web UI de Proxmox

```bash
# Regla para Proxmox Web
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 8006
Source: 192.168.1.0/24
Comment: Allow Proxmox Web UI
```

### Permitir Ping

```bash
# Regla para ICMP
Direction: IN
Action: ACCEPT
Protocol: icmp
Source: 192.168.1.0/24
Comment: Allow ping from LAN
```

### Permitir DNS

```bash
# Regla para DNS
Direction: IN
Action: ACCEPT
Protocol: udp
Dest. port: 53
Comment: Allow DNS queries
```

## Firewall por Contenedor

### CT103 - DNS (AdGuard/Pi-hole)

```bash
# Permitir DNS
Direction: IN
Action: ACCEPT
Protocol: udp
Dest. port: 53
Comment: DNS queries

# Permitir Web UI
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 80,443
Source: 192.168.1.0/24
Comment: Web UI access
```

### CT112 - Nginx Proxy Manager

```bash
# Permitir HTTP/HTTPS
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 80,443
Comment: Web traffic

# Permitir Admin UI
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 81
Source: 192.168.1.0/24
Comment: Admin interface
```

### CT100 - Tailscale

```bash
# Permitir Tailscale
Direction: IN
Action: ACCEPT
Protocol: udp
Dest. port: 41641
Comment: Tailscale VPN

# Permitir tráfico de subnet router
Direction: FORWARD
Action: ACCEPT
Source: 100.64.0.0/10
Comment: Tailscale subnet
```

## Configuración Avanzada

### Grupos de IP

Crear grupos para facilitar la gestión:

```bash
# Grupo: LAN
192.168.1.0/24

# Grupo: Trusted
192.168.1.10
192.168.1.20
192.168.1.30

# Grupo: DMZ
192.168.2.0/24
```

### Grupos de Servicios

```bash
# Grupo: Web Services
tcp/80
tcp/443

# Grupo: Management
tcp/22
tcp/8006

# Grupo: DNS
udp/53
tcp/53
```

### Macros Útiles

Proxmox incluye macros predefinidas:

- **SSH**: tcp/22
- **HTTP**: tcp/80
- **HTTPS**: tcp/443
- **DNS**: udp/53, tcp/53
- **SMTP**: tcp/25
- **NTP**: udp/123

## Reglas de Seguridad

### Bloquear Países

```bash
# Bloquear IPs de países específicos
# Usar ipset con listas de GeoIP

# Crear ipset
ipset create blocked_countries hash:net

# Añadir rangos (ejemplo)
ipset add blocked_countries 1.2.3.0/24

# Regla de firewall
Direction: IN
Action: DROP
Source: +blocked_countries
Comment: Block specific countries
```

### Rate Limiting

```bash
# Limitar conexiones SSH
Direction: IN
Action: ACCEPT
Protocol: tcp
Dest. port: 22
Rate limit: 5/minute
Comment: SSH rate limit
```

### Protección DDoS Básica

```bash
# Limitar conexiones simultáneas
Direction: IN
Action: DROP
Protocol: tcp
Dest. port: 80,443
Connlimit: 50
Comment: Limit concurrent connections
```

## Logging

### Activar Logs

```bash
# En Options
Log level: info
Log ratelimit: 1/second
```

### Ver Logs

```bash
# Ver logs del firewall
journalctl -u pve-firewall -f

# Ver logs de iptables
tail -f /var/log/syslog | grep -i firewall
```

## Troubleshooting

### Verificar Reglas Activas

```bash
# Ver reglas de iptables
iptables -L -n -v

# Ver reglas de Proxmox
pvesh get /cluster/firewall/rules
```

### Probar Conectividad

```bash
# Desde otro equipo
telnet <IP> <PORT>
nc -zv <IP> <PORT>

# Verificar puerto abierto
nmap -p <PORT> <IP>
```

### Desactivar Temporalmente

```bash
# Desactivar firewall (emergencia)
pvesh set /cluster/firewall/options --enable 0

# Reactivar
pvesh set /cluster/firewall/options --enable 1
```

## Mejores Prácticas

### Principio de Mínimo Privilegio

- ✅ Denegar todo por defecto
- ✅ Permitir solo lo necesario
- ✅ Especificar origen cuando sea posible
- ✅ Usar grupos para organizar

### Documentación

- 📝 Comentar todas las reglas
- 📝 Documentar cambios
- 📝 Mantener diagrama de red actualizado

### Monitoreo

- 🔍 Revisar logs regularmente
- 🔍 Alertas para intentos de acceso
- 🔍 Auditoría periódica de reglas

### Testing

- 🧪 Probar reglas antes de aplicar
- 🧪 Verificar acceso después de cambios
- 🧪 Tener plan de rollback

## Ejemplo de Configuración Completa

```bash
# /etc/pve/firewall/cluster.fw

[OPTIONS]
enable: 1
policy_in: DROP
policy_out: ACCEPT

[RULES]
# Management
IN ACCEPT -p tcp -dport 22 -source 192.168.1.0/24 -log nolog # SSH
IN ACCEPT -p tcp -dport 8006 -source 192.168.1.0/24 -log nolog # Proxmox UI

# ICMP
IN ACCEPT -p icmp -source 192.168.1.0/24 -log nolog # Ping

# DNS
IN ACCEPT -p udp -dport 53 -log nolog # DNS queries

# Drop everything else
IN DROP -log warning # Log dropped packets
```

## 📚 Recursos Relacionados

- [Diseño de Red](network-design.md)
- [Red LAN](lan-network.md)
- [Red Privada](private-network.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
