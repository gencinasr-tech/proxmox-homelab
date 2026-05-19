# ⚡ Quick Start

Esta guía te llevará desde cero hasta tener tu homelab Proxmox funcionando en menos de 2 horas.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener:

- Hardware compatible (ver [Prerequisites](prerequisites.md))
- ISO de Proxmox VE descargada
- USB booteable creado
- Acceso a tu router para configurar DHCP/DNS
- Conexión a internet estable

## 🚀 Instalación Rápida (30 minutos)

### Paso 1: Instalar Proxmox VE

1. **Bootear desde USB**
   - Inserta el USB con Proxmox VE
   - Arranca desde USB (F12/F2 según tu hardware)
   - Selecciona "Install Proxmox VE (Graphical)"

2. **Configuración Básica**
   ```
   Disco: Selecciona tu SSD principal
   País: Spain
   Zona horaria: Europe/Madrid
   Teclado: Spanish
   ```

3. **Configuración de Red**
   ```
   Hostname: pve.local
   IP Address: 192.168.1.200/24
   Gateway: 192.168.1.1
   DNS: 1.1.1.1
   ```

4. **Credenciales Root**
   - Establece una contraseña segura
   - Guárdala en tu gestor de contraseñas

5. **Finalizar Instalación**
   - Espera a que termine (5-10 minutos)
   - Retira el USB
   - Reinicia el sistema

### Paso 2: Acceso Inicial

1. **Acceder a la Web UI**
   ```
   https://192.168.1.200:8006
   ```
   - Usuario: `root`
   - Contraseña: la que estableciste

2. **Aceptar Certificado**
   - El navegador mostrará advertencia de seguridad
   - Es normal, acepta y continúa

### Paso 3: Configuración Inicial del Host

Ejecuta estos comandos en `pve > Shell`:

```bash
# Desactivar repositorios enterprise
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pve-enterprise.sources 2>/dev/null
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/ceph.sources 2>/dev/null

# Añadir repositorio no-subscription
cat > /etc/apt/sources.list.d/proxmox-no-subscription.sources <<'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

# Actualizar sistema
apt update && apt upgrade -y
```

### Paso 4: Configurar Portátil (Opcional)

Si instalaste en un portátil, evita que se suspenda al cerrar la tapa:

```bash
# Backup de configuración
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak

# Configurar para ignorar tapa
sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

# Aplicar cambios
systemctl restart systemd-logind
```

Verifica con `ping 192.168.1.200` desde otro PC después de cerrar la tapa.

## 🎯 Primeros Contenedores (1 hora)

### CT 100 - Tailscale Gateway

Tu primera puerta de entrada VPN:

```bash
# En Proxmox Web UI: Create CT
CT ID: 100
Hostname: tailscale-gw
Template: debian-13-standard
Disk: 8 GB
CPU: 1 core
RAM: 1024 MB
Network: vmbr0 + vmbr10 (dual network)
IP: 192.168.1.87/24
Gateway: 192.168.1.1
DNS: 1.1.1.1

# Marcar: Unprivileged + Nesting + Start at boot
```

Dentro del CT:

```bash
# Instalar Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Anunciar ambas redes (LAN y Privada)
tailscale up --advertise-routes=192.168.1.0/24,10.10.10.0/24 --accept-routes

# Nota: Debes aprobar las rutas en el panel de Tailscale (https://login.tailscale.com)
```

### CT 101 - Dashboard

Tu centro de control visual:

```bash
# Crear CT
CT ID: 101
Hostname: dashboard
IP: 192.168.1.79/24
Disk: 12 GB
CPU: 1 core
RAM: 1024 MB
```

Instalar Docker y Homarr:

```bash
# Instalar Docker (ver docs/02-proxmox-base/initial-config.md)
# Luego:
mkdir -p /opt/stacks/homarr-v1
cd /opt/stacks/homarr-v1

cat > docker-compose.yml <<'EOF'
services:
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr-v1
    restart: unless-stopped
    ports:
      - "7575:7575"
    volumes:
      - /opt/stacks/homarr-v1/appdata:/app/data/configs
      - /opt/stacks/homarr-v1/appdata/db:/data
      - /opt/stacks/homarr-v1/icons:/app/public/icons
    environment:
      - TZ=Europe/Madrid
EOF

docker compose up -d
```

Accede a `http://192.168.1.79:7575`

### CT 103 - DNS / AdGuard

Tu servidor DNS local con bloqueo de anuncios:

```bash
# Crear CT
CT ID: 103
Hostname: dns
IP: 192.168.1.53/24
Disk: 12 GB
CPU: 1 core
RAM: 1024 MB
```

Instalar AdGuard Home:

```bash
mkdir -p /opt/stacks/adguard/{work,conf}
cd /opt/stacks/adguard

cat > docker-compose.yml <<'EOF'
services:
  adguard:
    image: adguard/adguardhome:latest
    container_name: adguard
    restart: unless-stopped
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
      - "3000:3000/tcp"
    volumes:
      - /opt/stacks/adguard/work:/opt/adguardhome/work
      - /opt/stacks/adguard/conf:/opt/adguardhome/conf
EOF

docker compose up -d
```

Configuración inicial en `http://192.168.1.53:3000`

## 📚 Próximos Pasos

Ahora que tienes lo básico funcionando:

1. **Configura la Red Privada** → [Network Design](../03-networking/network-design.md)
2. **Añade Más Servicios** → [Core Services](../04-core-services/)
3. **Configura Backups** → [Local Backups](../06-storage-backup/local-backups.md)
4. **Monitoreo** → [CT105 Monitoring](../05-management/ct105-monitoring.md)

## 🆘 Solución de Problemas

### No puedo acceder a la Web UI

```bash
# Verificar que Proxmox está corriendo
systemctl status pveproxy
systemctl status pvedaemon

# Reiniciar servicios si es necesario
systemctl restart pveproxy pvedaemon
```

### Los contenedores no tienen internet

```bash
# Verificar gateway en el CT
ip route

# Debe mostrar: default via 192.168.1.1 dev eth0
# Si no, editar /etc/network/interfaces
```

### Error de repositorios

```bash
# Limpiar cache
apt clean
apt update

# Si persiste, verificar /etc/apt/sources.list.d/
```

## 💡 Consejos

- **Snapshots**: Crea snapshots antes de cambios importantes
- **Documentación**: Anota las IPs y contraseñas en tu gestor
- **Backups**: Configura backups automáticos desde el día 1
- **Actualizaciones**: Mantén Proxmox y los CTs actualizados

## 🔗 Enlaces Útiles

- [Documentación Oficial Proxmox](https://pve.proxmox.com/pve-docs/)
- [Foro Proxmox](https://forum.proxmox.com/)
- [Tailscale Docs](https://tailscale.com/kb/)
- [Docker Compose Reference](https://docs.docker.com/compose/)

---

**¿Listo para más?** Continúa con la [Guía de Arquitectura](architecture.md) para entender cómo está diseñado todo el sistema.