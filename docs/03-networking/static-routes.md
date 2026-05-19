# Rutas Estáticas

Configuración de rutas estáticas para el homelab.

## 📋 Índice

- [Conceptos Básicos](#conceptos-básicos)
- [Rutas en Proxmox](#rutas-en-proxmox)
- [Rutas para Tailscale](#rutas-para-tailscale)
- [Troubleshooting](#troubleshooting)

## Conceptos Básicos

### ¿Qué son las Rutas Estáticas?

Las rutas estáticas son reglas que indican al sistema operativo cómo llegar a una red específica. Son necesarias cuando:

- Tienes múltiples redes (LAN, Privada, VPN)
- Necesitas acceso entre redes aisladas
- Quieres controlar el flujo de tráfico

### Tabla de Rutas

```bash
# Ver tabla de rutas actual
ip route show

# Salida típica en Proxmox Host:
default via 192.168.1.1 dev vmbr0
192.168.1.0/24 dev vmbr0 proto kernel scope link src 192.168.1.200
100.64.0.0/10 via 192.168.1.87 dev vmbr0

# Nota:
# Proxmox tiene IP auxiliar 10.10.10.1 en vmbr10 para gestión del bridge.
# El gateway real de los contenedores privados es CT100 (10.10.10.87).
# La ruta desde LAN a la red privada debe ir vía 192.168.1.87.
```

### Componentes de una Ruta

```
ip route add <red_destino> via <gateway> dev <interfaz>
              ↓              ↓            ↓
         10.10.10.0/24   192.168.1.87    vmbr0
```

## Rutas en Proxmox

### Configuración Permanente

```bash
# /etc/network/interfaces

# Bridge LAN
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.200/24
    gateway 192.168.1.1
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0

# Bridge Privado
auto vmbr10
iface vmbr10 inet static
    address 10.10.10.1/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    # Ruta a Tailscale
    post-up ip route add 100.64.0.0/10 via 192.168.1.87 dev vmbr0
    post-down ip route del 100.64.0.0/10 via 192.168.1.87 dev vmbr0

# Nota: Proxmox tiene IP auxiliar 10.10.10.1 para gestión del bridge.
# El gateway real de los contenedores privados es CT100 (10.10.10.87).
```

### Rutas Temporales

```bash
# Añadir ruta temporal (se pierde al reiniciar)
ip route add 10.10.10.0/24 via 192.168.1.87

# Eliminar ruta
ip route del 10.10.10.0/24 via 192.168.1.87

# Cambiar ruta por defecto
ip route change default via 192.168.1.1
```

### Rutas Específicas

#### Ruta a Red Privada

```bash
# Desde dispositivos LAN a red privada
# (Configurar en router o dispositivos)
ip route add 10.10.10.0/24 via 192.168.1.87

# Verificar
ping 10.10.10.60  # Vaultwarden
```

#### Ruta a Tailscale

```bash
# Desde Proxmox a red Tailscale
ip route add 100.64.0.0/10 via 192.168.1.87 dev vmbr0

# Verificar
ping 100.64.0.1  # Tailscale coordination server
```

## Rutas para Tailscale

### Subnet Router

Tailscale CT100 actúa como subnet router para permitir acceso a las redes locales:

```bash
# En CT100 (Tailscale)
# Habilitar IP forwarding
echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
echo 'net.ipv6.conf.all.forwarding = 1' >> /etc/sysctl.conf
sysctl -p

# Anunciar subnets
tailscale up --advertise-routes=192.168.1.0/24,10.10.10.0/24 --accept-routes
```

### Aprobar Rutas en Tailscale

```bash
# En el panel de Tailscale (https://login.tailscale.com)
1. Ir a Machines
2. Seleccionar CT100
3. Edit route settings
4. Aprobar: 192.168.1.0/24 y 10.10.10.0/24
```

### Acceso desde Dispositivos Remotos

Una vez configurado el subnet router:

```bash
# Desde cualquier dispositivo con Tailscale
ping 192.168.1.200  # Proxmox
ping 10.10.10.60    # Vaultwarden
ssh user@192.168.1.200  # SSH a Proxmox
```

## Rutas en Contenedores

### Configuración en LXC

```bash
# /etc/network/interfaces dentro del contenedor

auto eth0
iface eth0 inet static
    address 10.10.10.60/24
    gateway 10.10.10.87
    # Ruta específica si es necesaria
    post-up ip route add 192.168.1.0/24 via 10.10.10.87
```

### Rutas Dinámicas

```bash
# Añadir ruta desde Proxmox al contenedor
pct exec 106 -- ip route add 192.168.1.0/24 via 10.10.10.87

# Verificar rutas en contenedor
pct exec 106 -- ip route show
```

## Rutas en Router

### Configurar en Router Principal

Para que dispositivos LAN puedan acceder a la red privada:

```
# En configuración del router (ejemplo genérico)
Red de destino: 10.10.10.0
Máscara: 255.255.255.0
Gateway: 192.168.1.87
Interfaz: LAN
```

### Ejemplo: Router Mikrotik

```bash
/ip route add dst-address=10.10.10.0/24 gateway=192.168.1.87
```

### Ejemplo: pfSense/OPNsense

```
System → Routing → Static Routes
- Destination network: 10.10.10.0/24
- Gateway: 192.168.1.87
- Description: Proxmox Private Network
```

### Ejemplo: Router Doméstico

La mayoría de routers domésticos tienen una sección de "Rutas Estáticas" o "Static Routes":

```
Destino: 10.10.10.0
Máscara: 255.255.255.0
Gateway: 192.168.1.87
```

## Políticas de Routing

### Policy-Based Routing

Para routing más avanzado basado en origen:

```bash
# Crear tabla de routing personalizada
echo "200 custom" >> /etc/iproute2/rt_tables

# Añadir regla
ip rule add from 10.10.10.0/24 table custom

# Añadir ruta a la tabla
ip route add default via 192.168.1.1 table custom
```

### Routing por Servicio

```bash
# Forzar tráfico de un servicio por una ruta específica
ip rule add from 10.10.10.60 table vpn
ip route add default via 192.168.1.87 table vpn
```

## Troubleshooting

### Verificar Rutas

```bash
# Ver todas las rutas
ip route show

# Ver ruta a destino específico
ip route get 10.10.10.60

# Ver tabla de routing completa
route -n

# Ver rutas con más detalle
netstat -rn
```

### Probar Conectividad

```bash
# Ping a través de ruta
ping -c 4 10.10.10.60

# Traceroute para ver el camino
traceroute 10.10.10.60
mtr 10.10.10.60

# Probar desde interfaz específica
ping -I vmbr0 10.10.10.60
```

### Problemas Comunes

#### No se puede alcanzar red privada

```bash
# Verificar ruta existe
ip route show | grep 10.10.10.0

# Añadir si falta
ip route add 10.10.10.0/24 via 192.168.1.87

# Verificar forwarding
cat /proc/sys/net/ipv4/ip_forward  # Debe ser 1
```

#### Ruta no persiste después de reinicio

```bash
# Añadir a /etc/network/interfaces
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.200/24
    gateway 192.168.1.1
    post-up ip route add 10.10.10.0/24 via 192.168.1.87
```

#### Conflicto de rutas

```bash
# Ver rutas duplicadas
ip route show | sort

# Eliminar ruta incorrecta
ip route del 10.10.10.0/24 via <gateway_incorrecto>

# Añadir ruta correcta
ip route add 10.10.10.0/24 via <gateway_correcto>
```

### Debug de Routing

```bash
# Habilitar logging de routing
echo 1 > /proc/sys/net/ipv4/conf/all/log_martians

# Ver logs
dmesg | grep -i route
journalctl -k | grep -i route

# Capturar tráfico
tcpdump -i vmbr0 host 10.10.10.60
```

## Monitoreo

### Scripts de Verificación

```bash
#!/bin/bash
# check-routes.sh

echo "=== Verificación de Rutas ==="

# Ruta por defecto
echo "Ruta por defecto:"
ip route show default

# Ruta a red privada
echo -e "\nRuta a red privada:"
ip route show 10.10.10.0/24

# Ruta a Tailscale
echo -e "\nRuta a Tailscale:"
ip route show 100.64.0.0/10

# Probar conectividad
echo -e "\nProbando conectividad:"
ping -c 1 -W 1 10.10.10.1 && echo "✓ Red privada OK" || echo "✗ Red privada FAIL"
ping -c 1 -W 1 192.168.1.1 && echo "✓ Gateway OK" || echo "✗ Gateway FAIL"
```

### Alertas

```yaml
# Prometheus alert
- alert: RouteNotConfigured
  expr: probe_success{job="route_check"} == 0
  for: 5m
  annotations:
    summary: "Ruta crítica no configurada"
```

## Mejores Prácticas

### Documentación

- 📝 Documentar todas las rutas estáticas
- 📝 Mantener diagrama de red actualizado
- 📝 Comentar configuraciones

### Seguridad

- 🔒 Limitar rutas solo a lo necesario
- 🔒 No anunciar rutas innecesarias
- 🔒 Verificar rutas regularmente

### Mantenimiento

- 🔧 Probar rutas después de cambios
- 🔧 Backup de configuración de red
- 🔧 Monitorear conectividad

### Testing

```bash
# Script de test completo
#!/bin/bash
ROUTES=(
    "10.10.10.0/24"
    "100.64.0.0/10"
)

for route in "${ROUTES[@]}"; do
    if ip route show | grep -q "$route"; then
        echo "✓ Ruta $route configurada"
    else
        echo "✗ Ruta $route NO configurada"
    fi
done
```

## Ejemplos Completos

### Configuración Completa de Proxmox

```bash
# /etc/network/interfaces

auto lo
iface lo inet loopback

# Interfaz física
auto enp3s0
iface enp3s0 inet manual

# Bridge LAN
auto vmbr0
iface vmbr0 inet static
    address 192.168.1.200/24
    gateway 192.168.1.1
    bridge-ports enp3s0
    bridge-stp off
    bridge-fd 0
    dns-nameservers 192.168.1.53 1.1.1.1

# Bridge Privado
auto vmbr10
iface vmbr10 inet static
    address 10.10.10.87/24
    bridge-ports none
    bridge-stp off
    bridge-fd 0
    post-up echo 1 > /proc/sys/net/ipv4/ip_forward
    post-up iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
    post-down iptables -t nat -D POSTROUTING -s 10.10.10.0/24 -o vmbr0 -j MASQUERADE
    # Ruta a Tailscale
    post-up ip route add 100.64.0.0/10 via 192.168.1.87 dev vmbr0 || true
    post-down ip route del 100.64.0.0/10 via 192.168.1.87 dev vmbr0 || true
```

## 📚 Recursos Relacionados

- [Diseño de Red](network-design.md)
- [Red LAN](lan-network.md)
- [Red Privada](private-network.md)
- [CT100 - Tailscale](../04-core-services/ct100-tailscale.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
