# Red Privada

Configuración y gestión de la red privada aislada (10.10.10.0/24).

## 📋 Índice

- [Propósito](#propósito)
- [Configuración](#configuración)
- [Servicios en Red Privada](#servicios-en-red-privada)
- [Acceso y Seguridad](#acceso-y-seguridad)

## Propósito

La red privada (10.10.10.0/24) está diseñada para:

- 🔒 **Aislar servicios sensibles** de la red LAN principal
- 🛡️ **Añadir capa extra de seguridad** mediante segmentación
- 🚫 **Prevenir acceso directo** desde dispositivos LAN
- 🔐 **Centralizar autenticación** a través de proxy

### Ventajas

- Servicios críticos no expuestos directamente
- Control granular de acceso
- Facilita implementación de SSO
- Mejor auditoría y logging
- Reducción de superficie de ataque

## Configuración

### Bridge Privado (vmbr10)

```bash
# /etc/network/interfaces en Proxmox Host

auto vmbr10
iface vmbr10 inet static
    address 10.10.10.87/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    # Habilitar forwarding
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    # NAT para acceso a internet
    post-up iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
```

### Aplicar Configuración

```bash
# Reiniciar networking
systemctl restart networking

# Verificar bridge
ip addr show vmbr10
brctl show vmbr10

# Verificar NAT
iptables -t nat -L -n -v | grep 10.10.10.0
```

### Configurar Contenedor en Red Privada

```bash
# Crear contenedor con red privada
pct create 106 local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst \
  --hostname vaultwarden \
  --net0 name=eth0,bridge=vmbr10,ip=10.10.10.60/24,gw=10.10.10.87 \
  --nameserver 192.168.1.53 \
  --cores 2 \
  --memory 2048 \
  --rootfs local-lvm:8

# O editar contenedor existente
pct set 106 -net0 name=eth0,bridge=vmbr10,ip=10.10.10.60/24,gw=10.10.10.87
```

## Servicios en Red Privada

### Tabla de Servicios

| IP | ID | Servicio | Puerto | Criticidad |
|----|-------|----------|--------|------------|
| 10.10.10.50 | CT105 | Grafana/Prometheus | 3000/9090 | Alta |
| 10.10.10.60 | CT106 | Vaultwarden | 80 | Crítica |
| 10.10.10.40 | CT107 | Paperless-ngx | 8000 | Media |
| 10.10.10.65 | CT108 | Nextcloud | 80 | Alta |
| 10.10.10.30 | VM109 | Immich | 2283 | Media |
| 10.10.10.70 | CT110 | Herramientas | Varios | Baja |
| 10.10.10.73 | CT111 | Bases de Datos | 5432/3306 | Crítica |
| 10.10.10.74 | CT113 | Keycloak | 8080 | Crítica |
| 10.10.10.82 | CT114 | Navidrome | 4533 | Baja |
| 10.10.10.83 | CT115 | Music Downloader | 6595 | Baja |

### CT105 - Monitoring (Grafana/Prometheus)

```yaml
# Configuración de red
IP: 10.10.10.50/24
Gateway: 10.10.10.87
DNS: 192.168.1.53

# Acceso
Interno: http://10.10.10.50:3002
Externo: https://grafana.home.arpa (vía proxy)
```

### CT106 - Vaultwarden

```yaml
# Configuración de red
IP: 10.10.10.60/24
Gateway: 10.10.10.87
DNS: 192.168.1.53

# Acceso
Interno: http://10.10.10.60:8080
Externo: https://vault.home.arpa (vía proxy)

# Seguridad
- Solo accesible vía proxy
- 2FA obligatorio
- Backups cifrados diarios
```

### CT108 - Nextcloud

```yaml
# Configuración de red
IP: 10.10.10.65/24
Gateway: 10.10.10.87
DNS: 192.168.1.53

# Acceso
Interno: http://10.10.10.65:8088
Externo: https://nextcloud.home.arpa (vía proxy)

# Características
- Almacenamiento en /mnt/nextcloud
- Base de datos en CT111
- Redis para caché
```

### CT111 - Bases de Datos

```yaml
# Configuración de red
IP: 10.10.10.73/24
Gateway: 10.10.10.87
DNS: 192.168.1.53

# Servicios
PostgreSQL: 5432
MariaDB: 3306

# Seguridad
- Solo accesible desde red privada
- Backups automáticos
- Replicación configurada
```

### CT113 - Keycloak (SSO)

```yaml
# Configuración de red
IP: 10.10.10.74/24
Gateway: 10.10.10.87
DNS: 192.168.1.53

# Acceso
Interno: http://10.10.10.74:8080
Externo: https://auth.home.arpa (vía proxy)

# Función
- Autenticación centralizada
- SSO para todos los servicios
- Gestión de usuarios
```

## Acceso y Seguridad

### Acceso desde LAN

Los servicios en red privada NO son accesibles directamente desde LAN. El acceso se realiza a través de:

#### 1. Nginx Proxy Manager (CT112)

```nginx
# Configuración de proxy para Vaultwarden
server {
    listen 443 ssl http2;
    server_name vault.home.arpa;

    location / {
        proxy_pass http://10.10.10.60:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

#### 2. Tailscale VPN

```bash
# Acceso directo vía Tailscale
# Una vez conectado a Tailscale, puedes acceder directamente:
http://10.10.10.60  # Vaultwarden
http://10.10.10.65  # Nextcloud
http://10.10.10.50:3000  # Grafana
```

### Reglas de Firewall

```bash
# En Proxmox Firewall

# Permitir desde proxy a servicios privados
IN ACCEPT -source 192.168.1.112 -dest 10.10.10.0/24

# Permitir desde Tailscale a servicios privados
IN ACCEPT -source 192.168.1.87 -dest 10.10.10.0/24

# Bloquear acceso directo desde LAN
IN DROP -source 192.168.1.0/24 -dest 10.10.10.0/24

# Permitir comunicación entre servicios privados
IN ACCEPT -source 10.10.10.0/24 -dest 10.10.10.0/24
```

### NAT y Routing

```bash
# Verificar NAT está activo
iptables -t nat -L POSTROUTING -n -v | grep 10.10.10.0

# Verificar forwarding
cat /proc/sys/net/ipv4/ip_forward  # Debe ser 1

# Ver rutas
ip route show | grep 10.10.10.0
```

## Comunicación entre Servicios

### Nextcloud → PostgreSQL

```yaml
# En Nextcloud config.php
'dbtype' => 'pgsql',
'dbhost' => '10.10.10.73:5432',
'dbname' => 'nextcloud',
'dbuser' => 'nextcloud',
'dbpassword' => 'password',
```

### Grafana → Prometheus

```yaml
# En Grafana datasources
datasources:
  - name: Prometheus
    type: prometheus
    url: http://10.10.10.50:9090
    access: proxy
```

### Aplicaciones → Keycloak

```yaml
# Configuración OIDC
issuer: https://auth.tu-dominio.com/realms/homelab
client_id: nextcloud
client_secret: secret
redirect_uri: https://cloud.tu-dominio.com/apps/oidc/redirect
```

## Troubleshooting

### No hay conectividad a Internet

```bash
# Verificar NAT
iptables -t nat -L -n -v | grep 10.10.10.0

# Verificar forwarding
sysctl net.ipv4.ip_forward

# Habilitar si está desactivado
echo 1 > /proc/sys/net/ipv4/ip_forward

# Hacer permanente
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
```

### No se puede acceder a servicios

```bash
# Desde Proxmox, probar conectividad
ping 10.10.10.60

# Verificar servicio está escuchando
nmap -p 80 10.10.10.60

# Verificar firewall
iptables -L -n -v | grep 10.0.0
```

### DNS no resuelve

```bash
# Dentro del contenedor
cat /etc/resolv.conf

# Debe tener:
nameserver 192.168.1.103
nameserver 1.1.1.1

# Probar resolución
nslookup google.com
dig google.com
```

## Monitoreo

### Métricas a Monitorear

```yaml
# Prometheus metrics
- Latencia entre redes
- Ancho de banda usado
- Conexiones activas
- Errores de red
- Estado de servicios
```

### Alertas Recomendadas

```yaml
# Servicio caído
- alert: PrivateServiceDown
  expr: up{network="private"} == 0
  for: 2m

# Alta latencia
- alert: HighLatencyPrivateNetwork
  expr: probe_duration_seconds{network="private"} > 0.5
  for: 5m

# Sin conectividad
- alert: PrivateNetworkUnreachable
  expr: probe_success{network="private"} == 0
  for: 2m
```

## Mejores Prácticas

### Seguridad

- ✅ Nunca exponer servicios privados directamente a LAN
- ✅ Usar proxy reverso con SSL
- ✅ Implementar autenticación fuerte
- ✅ Habilitar 2FA donde sea posible
- ✅ Auditar logs regularmente

### Rendimiento

- ✅ Usar MTU apropiado (1500 o 9000)
- ✅ Monitorear latencia entre redes
- ✅ Optimizar configuración de proxy
- ✅ Usar caché cuando sea posible

### Mantenimiento

- ✅ Documentar todos los servicios
- ✅ Mantener tabla de IPs actualizada
- ✅ Backups regulares de configuración
- ✅ Probar recuperación periódicamente

## 📚 Recursos Relacionados

- [Diseño de Red](network-design.md)
- [Red LAN](lan-network.md)
- [Firewall](firewall.md)
- [CT112 - Nginx Proxy Manager](../04-core-services/ct112-proxy.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
