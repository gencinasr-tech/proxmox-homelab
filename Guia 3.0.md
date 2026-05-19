# Guía Completa de Instalación del Homelab Proxmox (Réplica Exacta)

Esta guía reproduce **todos los pasos y comandos** ejecutados durante la construcción del servidor Proxmox, desde la instalación base hasta la configuración de backups en Google Drive. Está diseñada para copiar y pegar, y refleja fielmente las direcciones IP, rutas y configuraciones utilizadas.

> [!WARNING] Seguridad
> Las contraseñas, tokens y secretos reales han sido reemplazados por placeholders como `TU_PASSWORD_AQUI`. Debes sustituirlos por tus propias claves seguras.

---

## Índice

1. [Instalación y configuración inicial de Proxmox](#1-instalación-y-configuración-inicial-de-proxmox)
2. [Preparación del host PVE (repositorios, tapa, energía)](#2-preparación-del-host-pve)
3. [Configuración del HDD de backups](#3-configuración-del-hdd-de-backups)
4. [CT 100 - Tailscale Gateway (red y VPN)](#4-ct-100---tailscale-gateway)
5. [CT 101 - Dashboard (Homepage, Homarr, Homer, Heimdall)](#5-ct-101---dashboard)
6. [CT 102 - Portainer](#6-ct-102---portainer)
7. [CT 103 - DNS / AdGuard Home](#7-ct-103---dns--adguard-home)
8. [VM 104 - CasaOS / NAS (Samba, Syncthing, Duplicati)](#8-vm-104---casaos--nas)
9. [Red privada 10.10.10.0/24 y NAT en CT 100](#9-red-privada-101010024-y-nat-en-ct-100)
10. [CT 105 - Monitoring (Uptime Kuma, Grafana, Prometheus, Scrutiny, Speedtest)](#10-ct-105---monitoring)
11. [CT 106 - Vaultwarden con Tailscale Serve HTTPS](#11-ct-106---vaultwarden)
12. [CT 107 - Paperless-ngx](#12-ct-107---paperless-ngx)
13. [VM 109 - Immich](#13-vm-109---immich)
14. [CT 108 - Nextcloud ](#14-ct-108---nextcloud)
15. [Rutas estáticas para que LAN vea la red privada](#15-rutas-estáticas-para-que-lan-vea-la-red-privada)
16. [Scripts de rendimiento: modo-turbo y modo-noche-total](#16-scripts-de-rendimiento-modo-turbo-y-modo-noche-total)
17. [Backups locales en Proxmox](#17-backups-locales-en-proxmox)
18. [Backups externos cifrados con rclone a Google Drive](#18-backups-externos-cifrados-con-rclone-a-google-drive)
19. [Configuración de Duplicati en CasaOS](#19-configuración-de-duplicati-en-casaos)
20. [Ajustes finales en dashboards y monitoreo](#20-ajustes-finales-en-dashboards-y-monitoreo)
21. [Extensiones y servicios adicionales](#21-extensiones-y-servicios-adicionales)
22. [Estado actual resumido](#22-estado-actual-resumido)
23. [CT113 – Identity (SSO)](#23-ct113--identity-sso)
24. [SSO en Grafana](#24-sso-en-grafana)
25. [SSO en Homarr](#25-sso-en-homarr)
26. [SSO en Immich](#26-sso-en-immich)
27. [Notas finales SSO](#27-notas-finales-sso)
28. [CT114 - Music / Navidrome](#28-ct114---music--navidrome)
29. [CT115 - Downloads / Descargas de música hacia Navidrome](#29-ct115---downloads--descargas-de-música-hacia-navidrome)
30. [Autoarranque crítico de CT100 Tailscale](#30-autoarranque-crítico-de-ct100-tailscale)
31. [Beszel Agents en CT101, CT105, CT114 y CT115](#31-beszel-agents-en-ct101-ct105-ct114-y-ct115)
32. [Estado actualizado tras añadir Music y Downloads](#32-estado-actualizado-tras-añadir-music-y-downloads)

---

## 1. Instalación y configuración inicial de Proxmox

1. Descargar la ISO de Proxmox VE e instalarla en el portátil.
2. Una vez instalado, acceder al panel web desde un PC en la misma red:
   ```text
   https://192.168.1.200:8006
   ```
3. Iniciar sesión como `root`.

> **Nota:** La IP `192.168.1.200` se configura durante la instalación de Proxmox o mediante DHCP reservado. En este homelab, se asume que el servidor recibe esa IP fija.

---

## 2. Preparación del host PVE

### 2.1 Desactivar repositorios enterprise y añadir no-subscription

En la shell de Proxmox (`pve > Shell`), ejecutar:

```bash
# Desactivar repos enterprise
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pve-enterprise.sources 2>/dev/null
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/ceph.sources 2>/dev/null

# Crear repo Proxmox no-subscription
cat > /etc/apt/sources.list.d/proxmox-no-subscription.sources <<'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

apt update && apt upgrade -y
```

### 2.2 Ignorar el cierre de la tapa del portátil

Para que el servidor no se suspenda al cerrar la tapa:

```bash
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak

sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

grep -E "HandleLidSwitch" /etc/systemd/logind.conf
# Debe mostrar:
# HandleLidSwitch=ignore
# HandleLidSwitchExternalPower=ignore
# HandleLidSwitchDocked=ignore

systemctl restart systemd-logind
```

Comprobar que sigue vivo tras cerrar la tapa con `ping 192.168.1.200` desde otro PC.

---

## 3. Configuración del HDD de backups

### 3.1 Identificar y montar el disco

El disco adicional es un HDD de 250 GB detectado como `/dev/sda` modelo `WDC_WD2500BEVS`.

Verificar:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
```

Si ya tiene particiones o datos, desmontar cualquier montaje previo:

```bash
umount /mnt/check-hdd 2>/dev/null || true
```

### 3.2 Limpiar, particionar y formatear

```bash
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda
partprobe /dev/sda
# Si partprobe no existe: apt install -y parted, luego partprobe /dev/sda
```

Crear nueva partición:

```bash
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" /dev/sda
partprobe /dev/sda
```

Formatear en ext4 optimizado (sin reserva para root):

```bash
mkfs.ext4 -L hdd250-data -m 0 /dev/sda1
```

### 3.3 Montaje manual y automático

```bash
mkdir -p /mnt/hdd250
mount /dev/sda1 /mnt/hdd250
df -h /mnt/hdd250
```

Añadir a fstab usando el UUID:

```bash
UUID=$(blkid -s UUID -o value /dev/sda1)
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab
mount -a
```

Crear estructura de carpetas:

```bash
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
mkdir -p /mnt/hdd250/backups/dump
chmod -R 775 /mnt/hdd250
```

### 3.4 Añadir como almacenamiento en Proxmox

En la interfaz web: `Datacenter > Storage > Add > Directory`

- **ID:** `hdd250-backups`
- **Directory:** `/mnt/hdd250/backups`
- **Content:** `VZDump backup file` (Respaldo)
- **Shared:** `no`

---

## 4. CT 100 - Tailscale Gateway

### 4.1 Crear el contenedor

En Proxmox, `Crear CT` con:

- **CT ID:** `100`
- **Hostname:** `tailscale-gw`
- **Plantilla:** `debian-13-standard`
- **Disco:** 8 GB (local-lvm)
- **CPU:** 1 core
- **RAM:** 1024 MB / Swap: 512 MB
- **Red vmbr0 (eth0):** IP `192.168.1.87/24`, Gateway `192.168.1.1`
- **Red vmbr10 (eth1):** IP `10.10.10.87/24` (sin gateway en la creación inicial)
- **DNS:** `1.1.1.1`
- **Unprivileged:** marcado, **Nesting:** marcado, **Start at boot:** marcado

### 4.2 Conceder permisos TUN al CT

En la shell del host PVE:

```bash
cat >> /etc/pve/lxc/100.conf <<'EOF'
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF
```

### 4.3 Instalar Tailscale dentro del CT 100

Entrar en la consola del CT 100:

```bash
apt update
apt install -y curl gnupg ca-certificates
curl -fsSL https://tailscale.com/install.sh | sh
ls -l /dev/net/tun   # debe existir
systemctl restart tailscaled
systemctl status tailscaled --no-pager
```

Levantar Tailscale con las rutas y exit node:

```bash
tailscale up \
  --advertise-routes=10.10.10.0/24,192.168.1.0/24 \
  --advertise-exit-node \
  --ssh
```

Acceder a la web de Tailscale, autorizar el dispositivo y aprobar las rutas/subnet router/exit node.

### 4.4 Configurar NAT para que la red privada salga a Internet

Primero, comprobar que el reenvío de IP está activado:

```bash
cat > /etc/sysctl.d/99-private-router.conf <<'EOF'
net.ipv4.ip_forward=1
EOF
sysctl --system
```

Instalar iptables persistentes:

```bash
apt install -y iptables iptables-persistent
```

Añadir reglas de NAT:

```bash
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -s 10.10.10.0/24 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -d 10.10.10.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT

netfilter-persistent save
```

---

## 5. CT 101 - Dashboard

### 5.1 Crear el CT

- **CT ID:** `101`
- **Hostname:** `dashboard`
- **Red vmbr0:** IP `192.168.1.79/24`, Gateway `192.168.1.1`
- **Disco:** 12 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **DNS:** `1.1.1.1`
- **Unprivileged + Nesting**

### 5.2 Verificar red

```bash
ip a
ip route
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 5.3 Instalar Docker

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

cat > /etc/apt/sources.list.d/docker.sources <<'EOF'
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.gpg
EOF

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker
```

Verificar:

```bash
docker version
docker compose version
systemctl status docker --no-pager
```

### 5.4 Crear estructura de stacks

```bash
mkdir -p /opt/stacks/{homepage,homarr,homer,heimdall}
```

### 5.5 Instalar Homarr

```bash
cat > /opt/stacks/homarr/docker-compose.yml <<'EOF'
services:
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr
    restart: unless-stopped
    ports:
      - "7575:7575"
    volumes:
      - /opt/stacks/homarr/configs:/app/data/configs
      - /opt/stacks/homarr/icons:/app/public/icons
      - /opt/stacks/homarr/data:/data
EOF

cd /opt/stacks/homarr
docker compose up -d
docker ps
```

Acceso: `http://192.168.1.79:7575`

### 5.6 Instalar Homer

```bash
mkdir -p /opt/stacks/homer/assets

cat > /opt/stacks/homer/assets/config.yml <<'EOF'
title: "Homelab Guillermo"
subtitle: "Panel de servicios"
logo: "logo.png"
header: true
footer: false
columns: 3
connectivityCheck: true
theme: default

services:
  - name: "Proxmox"
    icon: "fas fa-server"
    items:
      - name: "Proxmox PVE"
        subtitle: "Servidor principal"
        url: "https://192.168.1.200:8006"
        target: "_blank"
  - name: "Dashboards"
    icon: "fas fa-th-large"
    items:
      - name: "Homarr"
        subtitle: "Dashboard visual"
        url: "http://192.168.1.79:7575"
        target: "_blank"
      - name: "Homer"
        subtitle: "Dashboard simple"
        url: "http://192.168.1.79:8080"
        target: "_blank"
  - name: "Red"
    icon: "fas fa-network-wired"
    items:
      - name: "Router"
        subtitle: "Gateway casa"
        url: "http://192.168.1.1"
        target: "_blank"
      - name: "Tailscale Gateway"
        subtitle: "CT 100"
        url: "http://192.168.1.87"
        target: "_blank"
EOF

cat > /opt/stacks/homer/docker-compose.yml <<'EOF'
services:
  homer:
    image: b4bz/homer:latest
    container_name: homer
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /opt/stacks/homer/assets:/www/assets
EOF

cd /opt/stacks/homer
docker compose up -d
```

Acceso: `http://192.168.1.79:8080`

### 5.7 Instalar Homepage

```bash
mkdir -p /opt/stacks/homepage/config

cat > /opt/stacks/homepage/docker-compose.yml <<'EOF'
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - HOMEPAGE_ALLOWED_HOSTS=homepage.home.arpa,homepage.home.arpa:443,192.168.1.79,192.168.1.79:3000,localhost:3000
    volumes:
      - /opt/stacks/homepage/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

cd /opt/stacks/homepage
docker compose up -d
```

Acceso: `http://192.168.1.79:3000`

### 5.8 Instalar Heimdall

```bash
cat > /opt/stacks/heimdall/docker-compose.yml <<'EOF'
services:
  heimdall:
    image: lscr.io/linuxserver/heimdall:latest
    container_name: heimdall
    restart: unless-stopped
    ports:
      - "8081:80"
      - "8443:443"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
    volumes:
      - /opt/stacks/heimdall/config:/config
EOF

chown -R 1000:1000 /opt/stacks/heimdall/config
cd /opt/stacks/heimdall
docker compose up -d
docker logs heimdall --tail=40
```

Acceso: `http://192.168.1.79:8081`

### 5.9 Portainer Agent en CT 101

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps
```

---

## 6. CT 102 - Portainer

### 6.1 Crear el CT

- **CT ID:** `102`
- **Hostname:** `portainer`
- **Red vmbr0:** IP `192.168.1.80/24`, Gateway `192.168.1.1`
- **Disco:** 12 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

### 6.2 Verificar red e instalar Docker

Repetir el bloque de instalación de Docker de la sección 5.3.

### 6.3 Instalar Portainer CE

```bash
mkdir -p /opt/stacks/portainer
cd /opt/stacks/portainer

cat > docker-compose.yml <<'EOF'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9443:9443"
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/stacks/portainer/data:/data
EOF

docker compose up -d
docker ps
```

Acceso: `https://192.168.1.80:9443` (crear usuario admin inicial).

Conectar el agente del CT 101:

1. En Portainer, ir a **Environments > Add environment**.
2. Elegir **Agent** (no Edge Agent).
3. **Name:** `CT101-dashboard`
4. **Environment URL:** `tcp://192.168.1.79:9001`
5. Crear.

---

## 7. CT 103 - DNS / AdGuard Home

### 7.1 Crear el CT

- **CT ID:** `103`
- **Hostname:** `dns`
- **Red vmbr0:** IP `192.168.1.53/24`, Gateway `192.168.1.1`
- **Disco:** 12 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

### 7.2 Verificar red e instalar Docker

Repetir el bloque de instalación de Docker de la sección 5.3.

### 7.3 Instalar AdGuard Home

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
      - "853:853/tcp"
    volumes:
      - /opt/stacks/adguard/work:/opt/adguardhome/work
      - /opt/stacks/adguard/conf:/opt/adguardhome/conf
EOF

docker compose up -d
docker ps
```

Acceder al asistente inicial en `http://192.168.1.53:3000` y configurar:
- Panel web en el puerto `80` (todas las interfaces).
- DNS server en el puerto `53` (todas las interfaces).

Tras finalizar, el panel queda en `http://192.168.1.53`.

---

## 8. VM 104 - CasaOS / NAS

### 8.1 Crear la VM

- **VM ID:** `104`
- **Nombre:** `casaos-nas`
- **ISO:** Debian 13 netinst (descargar desde `https://ftp.uvigo.es/debian-cd/current/amd64/iso-cd/debian-13.4.0-amd64-netinst.iso`)
- **Sistema:** Linux 6.x, **Machine:** q35, **BIOS:** OVMF (UEFI), añadir disco EFI
- **Disco:** 32 GB en local-lvm
- **CPU:** 2 cores (tipo `host`)
- **RAM:** 4096 MB
- **Red:** vmbr0, modelo VirtIO, sin IP fija en Proxmox (la configuramos dentro)

### 8.2 Instalar Debian

Arrancar la VM con la ISO. Durante la instalación:

- **Hostname:** `casaos-nas`
- **Dominio:** `local`
- **Usuario normal:** `guillermo`
- **Entorno de escritorio:** NO
- **SSH server:** SÍ
- **Utilidades estándar:** SÍ

Al reiniciar, entrar como `root` y configurar red estática:

```bash
nano /etc/network/interfaces
```

Dejar:

```
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
    address 192.168.1.81/24
    gateway 192.168.1.1
    dns-nameservers 1.1.1.1 192.168.1.53
```

Reiniciar red o la VM: `reboot`

### 8.3 Configurar sudo para guillermo

Desde `root`:

```bash
apt update
apt install -y sudo openssh-server qemu-guest-agent curl
usermod -aG sudo guillermo
systemctl enable --now ssh
systemctl enable --now qemu-guest-agent
reboot
```

### 8.4 Instalar Docker (desde usuario guillermo con sudo)

Igual que en los CTs, pero usando `sudo` donde sea necesario.

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release nano htop git

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

cat <<'EOF' | sudo tee /etc/apt/sources.list.d/docker.sources
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.gpg
EOF

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo usermod -aG docker guillermo
sudo systemctl enable --now docker
```

Cerrar sesión y volver a entrar para que el grupo `docker` tenga efecto.

### 8.5 Crear estructura de datos y Samba

```bash
sudo mkdir -p /data/{documents,obsidian,sync,downloads,backups,shared}
sudo mkdir -p /data/media/{movies,series,music,photos}
sudo chown -R guillermo:guillermo /data
sudo chmod -R 775 /data
```

Instalar Samba:

```bash
sudo apt install -y samba
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

cat <<'EOF' | sudo tee -a /etc/samba/smb.conf

[data]
   path = /data
   browseable = yes
   read only = no
   guest ok = no
   valid users = guillermo
   create mask = 0664
   directory mask = 0775
EOF

sudo smbpasswd -a guillermo   # Asignar contraseña para Samba
sudo systemctl restart smbd
sudo systemctl enable smbd
```

Acceso desde Windows: `\\192.168.1.81\data` con usuario `guillermo`.

### 8.6 Instalar CasaOS

Desde el usuario `guillermo`:

```bash
curl -fsSL https://get.casaos.io | sudo bash
```

Acceder a `http://192.168.1.81` y crear usuario.

### 8.7 Instalar Syncthing

Desde la interfaz de CasaOS, instalar Syncthing (o manualmente con Docker). Configurar la carpeta Obsidian:

- **Ruta en el servidor:** `/data/obsidian`
- **Carpeta en Windows:** `C:\Users\guill\Desktop\APPS\Cyber`

### 8.8 Portainer Agent en VM 104

```bash
sudo mkdir -p /opt/stacks/portainer-agent
sudo chown -R guillermo:guillermo /opt/stacks
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

sudo docker compose up -d
```

En Portainer, añadir environment `VM104-casaos-nas` a `tcp://192.168.1.81:9001`.

---

## 9. Red privada 10.10.10.0/24 y NAT en CT 100

Esta red se utiliza para los servicios que solo deben ser accesibles vía Tailscale. El bridge `vmbr10` ya existe en Proxmox con dirección `10.10.10.1/24` (creado previamente).

Todos los CT/VM en esta red deben tener:
- **Bridge:** `vmbr10`
- **Gateway:** `10.10.10.87`
- **DNS:** `1.1.1.1` (o `192.168.1.53` si se desea)

Las reglas NAT en el CT 100 ya se configuraron en la sección 4.4. Ahora se comprueba desde un CT privado (ej. CT 105) que hay salida a Internet:

```bash
ping -c 3 10.10.10.87  # gateway
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si falla, revisar que el CT tenga gateway `10.10.10.87`, que `ip_forward` esté activo en CT 100 y las reglas iptables.

Desde Proxmox podemos forzar el gateway en el CT si se olvidó durante la creación:

```bash
pct set <ID> -net0 name=eth0,bridge=vmbr10,firewall=1,ip=10.10.10.X/24,gw=10.10.10.87
pct reboot <ID>
```

---

## 10. CT 105 - Monitoring

### 10.1 Crear el CT

- **CT ID:** `105`
- **Hostname:** `monitoring`
- **Red vmbr10:** IP `10.10.10.50/24`, Gateway `10.10.10.87`
- **Disco:** 16 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

### 10.2 Verificar red e instalar Docker

Repetir el bloque de instalación de Docker de la sección 5.3.

### 10.3 Uptime Kuma

```bash
mkdir -p /opt/stacks/uptime-kuma
cd /opt/stacks/uptime-kuma

cat > docker-compose.yml <<'EOF'
services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    restart: unless-stopped
    ports:
      - "3001:3001"
    volumes:
      - /opt/stacks/uptime-kuma/data:/app/data
EOF

docker compose up -d
```

Acceso: `http://10.10.10.50:3001`

Monitores iniciales añadidos manualmente: Proxmox, Tailscale, Dashboard, Portainer, AdGuard, CasaOS, etc.

### 10.4 Grafana + Prometheus + Node Exporter

```bash
mkdir -p /opt/stacks/monitoring/{prometheus,grafana}
cd /opt/stacks/monitoring

# Prometheus config inicial
cat > /opt/stacks/monitoring/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["prometheus:9090"]

  - job_name: "monitoring-node"
    static_configs:
      - targets: ["10.10.10.50:9100"]
EOF

# Node Exporter
mkdir -p /opt/stacks/node-exporter
cd /opt/stacks/node-exporter

cat > docker-compose.yml <<'EOF'
services:
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    ports:
      - "9100:9100"
    command:
      - '--path.rootfs=/host'
    volumes:
      - '/:/host:ro,rslave'
EOF

docker compose up -d

# Volver a monitoring stack
cd /opt/stacks/monitoring

cat > docker-compose.yml <<'EOF'
services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - /opt/stacks/monitoring/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - /opt/stacks/monitoring/prometheus/data:/prometheus

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3002:3000"
    volumes:
      - /opt/stacks/monitoring/grafana:/var/lib/grafana
EOF

# Ajustar permisos
chown -R 65534:65534 /opt/stacks/monitoring/prometheus/data
chown -R 472:472 /opt/stacks/monitoring/grafana

docker compose up -d
docker ps
```

Acceso Grafana: `http://10.10.10.50:3002` (admin/admin). Añadir datasource Prometheus con URL `http://prometheus:9090`. Importar dashboard ID `1860`.

### 10.5 Speedtest Tracker

```bash
mkdir -p /opt/stacks/speedtest-tracker/{config,keys}
cd /opt/stacks/speedtest-tracker

APP_KEY="base64:$(openssl rand -base64 32)"
echo $APP_KEY

cat > docker-compose.yml <<EOF
services:
  speedtest-tracker:
    image: lscr.io/linuxserver/speedtest-tracker:latest
    container_name: speedtest-tracker
    restart: unless-stopped
    ports:
      - "8085:80"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
      - APP_KEY=$APP_KEY
      - DB_CONNECTION=sqlite
      - SPEEDTEST_SCHEDULE=0 */6 * * *
    volumes:
      - /opt/stacks/speedtest-tracker/config:/config
EOF

docker compose up -d
```

Acceso: `http://10.10.10.50:8085` (usuario: `admin@example.com`, contraseña: `password`).

### 10.6 Scrutiny (SMART)

#### 10.6.1 Web + InfluxDB en CT 105

```bash
mkdir -p /opt/stacks/scrutiny/{config,influxdb}
cd /opt/stacks/scrutiny

cat > docker-compose.yml <<'EOF'
services:
  influxdb:
    image: influxdb:2.8
    container_name: scrutiny-influxdb
    restart: unless-stopped
    volumes:
      - /opt/stacks/scrutiny/influxdb:/var/lib/influxdb2

  scrutiny:
    image: ghcr.io/analogj/scrutiny:latest-web
    container_name: scrutiny
    restart: unless-stopped
    ports:
      - "8086:8080"
    volumes:
      - /opt/stacks/scrutiny/config:/opt/scrutiny/config
    environment:
      - SCRUTINY_WEB_INFLUXDB_HOST=influxdb
      - SCRUTINY_WEB_INFLUXDB_PORT=8086
      - SCRUTINY_WEB_INFLUXDB_TOKEN=scrutiny-token
      - SCRUTINY_WEB_INFLUXDB_ORG=scrutiny
      - SCRUTINY_WEB_INFLUXDB_BUCKET=scrutiny
    depends_on:
      - influxdb
EOF

docker compose up -d
```

#### 10.6.2 Collector en PVE host

```bash
mkdir -p /opt/scrutiny/bin /opt/scrutiny/config

curl -L \
  https://github.com/AnalogJ/scrutiny/releases/latest/download/scrutiny-collector-metrics-linux-amd64 \
  -o /opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64

chmod +x /opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64

cat > /opt/scrutiny/config/collector.yaml <<'EOF'
version: 1
host:
  id: "pve"
api:
  endpoint: "http://10.10.10.50:8086"
commands:
  metrics_smartctl_bin: /usr/sbin/smartctl
devices:
  - device: /dev/sda
    type: sat
  - device: /dev/nvme0n1
    type: nvme
EOF

# Ejecutar manual
/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run \
  --config /opt/scrutiny/config/collector.yaml \
  --debug

# Programar cada hora
cat > /etc/systemd/system/scrutiny-collector.service <<'EOF'
[Unit]
Description=Scrutiny Collector for PVE disks
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run --config /opt/scrutiny/config/collector.yaml
EOF

cat > /etc/systemd/system/scrutiny-collector.timer <<'EOF'
[Unit]
Description=Run Scrutiny Collector every hour

[Timer]
OnBootSec=5min
OnUnitActiveSec=1h
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now scrutiny-collector.timer
systemctl start scrutiny-collector.service
```

Acceso Scrutiny: `http://10.10.10.50:8086`

### 10.7 Portainer Agent en CT 105

Repetir el bloque de creación del Portainer Agent (sección 5.9) dentro del CT 105 y luego en Portainer añadir:

- **Name:** `CT105-monitoring`
- **Environment URL:** `tcp://10.10.10.50:9001`

---

## 11. CT 106 - Vaultwarden

### 11.1 Crear el CT

- **CT ID:** `106`
- **Hostname:** `vaultwarden`
- **Red vmbr10:** IP `10.10.10.60/24`, Gateway `10.10.10.87`
- **Disco:** 12 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

### 11.2 Verificar red e instalar Docker

Repetir el bloque de instalación de Docker de la sección 5.3.

### 11.3 Instalar Vaultwarden y configurar HTTPS con Tailscale Serve

Primero, instalar Tailscale (mismo procedimiento que en CT 100, pero sin subnet routes):

```bash
# En PVE, añadir permisos TUN al CT 106
cat >> /etc/pve/lxc/106.conf <<'EOF'
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF
```

Dentro del CT 106:

```bash
apt update && apt install -y curl gnupg ca-certificates
curl -fsSL https://tailscale.com/install.sh | sh
systemctl restart tailscaled
tailscale up --hostname=vaultwarden
```

Autorizar en la web de Tailscale.

Generar token de admin:

```bash
openssl rand -base64 48
```

Crear stack de Vaultwarden (sustituir `PEGA_AQUI_TU_TOKEN`):

```bash
mkdir -p /opt/stacks/vaultwarden
cd /opt/stacks/vaultwarden

cat > docker-compose.yml <<'EOF'
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - TZ=Europe/Madrid
      - SIGNUPS_ALLOWED=false
      - INVITATIONS_ALLOWED=false
      - WEBSOCKET_ENABLED=true
      - ADMIN_TOKEN=PEGA_AQUI_TU_TOKEN
    volumes:
      - /opt/stacks/vaultwarden/data:/data
EOF

docker compose up -d
```

Activar Tailscale Serve para HTTPS:

```bash
tailscale serve --bg --https=443 127.0.0.1:8080
tailscale serve status
# Mostrará una URL tipo https://vaultwarden.tailXXXX.ts.net
```

Configurar el dominio en Vaultwarden:

```bash
cd /opt/stacks/vaultwarden
cp docker-compose.yml docker-compose.yml.bak
sed -i '/DOMAIN=/d' docker-compose.yml
sed -i '/TZ=Europe\/Madrid/a\      - DOMAIN=https://vaultwarden.tailfcb362.ts.net' docker-compose.yml
docker compose down && docker compose up -d
```

Para crear el primer usuario, abrir registros temporalmente:

```bash
sed -i 's/SIGNUPS_ALLOWED=false/SIGNUPS_ALLOWED=true/' docker-compose.yml
docker compose down && docker compose up -d
```

Acceder a `https://vaultwarden.tailfcb362.ts.net/#/register`, crear cuenta, y luego cerrar registros:

```bash
sed -i 's/SIGNUPS_ALLOWED=true/SIGNUPS_ALLOWED=false/' docker-compose.yml
docker compose down && docker compose up -d
```

Panel admin en `https://vaultwarden.tailfcb362.ts.net/admin` con el token.

---

## 12. CT 107 - Paperless-ngx

### 12.1 Crear el CT

- **CT ID:** `107`
- **Hostname:** `paperless`
- **Red vmbr10:** IP `10.10.10.40/24`, Gateway `10.10.10.87`
- **Disco:** 16 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

### 12.2 Verificar red e instalar Docker

Repetir el bloque de instalación de Docker de la sección 5.3.

### 12.3 Instalar Paperless-ngx

Generar contraseñas:

```bash
mkdir -p /opt/stacks/paperless
cd /opt/stacks/paperless

PAPERLESS_ADMIN_PASSWORD="$(openssl rand -base64 18)"
echo "PAPERLESS_ADMIN_PASSWORD=$PAPERLESS_ADMIN_PASSWORD"
```

Crear `docker-compose.yml`:

```bash
cat > docker-compose.yml <<EOF
services:
  broker:
    image: docker.io/library/redis:7
    container_name: paperless-redis
    restart: unless-stopped

  db:
    image: docker.io/library/postgres:15
    container_name: paperless-db
    restart: unless-stopped
    volumes:
      - /opt/stacks/paperless/postgres:/var/lib/postgresql/data
    environment:
      POSTGRES_DB: paperless
      POSTGRES_USER: paperless
      POSTGRES_PASSWORD: paperless

  webserver:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    container_name: paperless
    restart: unless-stopped
    ports:
      - "8000:8000"
    volumes:
      - /opt/stacks/paperless/data:/usr/src/paperless/data
      - /opt/stacks/paperless/media:/usr/src/paperless/media
      - /opt/stacks/paperless/export:/usr/src/paperless/export
      - /opt/stacks/paperless/consume:/usr/src/paperless/consume
    environment:
      PAPERLESS_REDIS: redis://broker:6379
      PAPERLESS_DBHOST: db
      PAPERLESS_DBUSER: paperless
      PAPERLESS_DBPASS: paperless
      PAPERLESS_DBNAME: paperless
      PAPERLESS_ADMIN_USER: root
      PAPERLESS_ADMIN_PASSWORD: $PAPERLESS_ADMIN_PASSWORD
      PAPERLESS_TIME_ZONE: Europe/Madrid
      PAPERLESS_SECRET_KEY: $(openssl rand -base64 42)
      PAPERLESS_OCR_LANGUAGES: spa eng
    depends_on:
      - broker
      - db
EOF

docker compose up -d
```

Acceso: `http://10.10.10.40:8000` (usuario `root`).

Añadir Portainer Agent:

Repetir el bloque de creación del Portainer Agent (sección 5.9). En Portainer añadir environment `CT107-paperless` a `tcp://10.10.10.40:9001`.

---

## 13. VM 109 - Immich

### 13.1 Crear la VM

- **VM ID:** `109`
- **Nombre:** `immich`
- **ISO:** Debian 13 netinst
- **Sistema:** Linux 6.x, **Machine:** q35, **BIOS:** OVMF (UEFI), disco EFI
- **Disco:** 64 GB
- **CPU:** 2 cores
- **RAM:** 4096 MB
- **Red:** vmbr10, modelo VirtIO

Configurar Debian como en la VM 104, con IP estática `10.10.10.30/24`, gateway `10.10.10.87`, DNS `1.1.1.1`. Usuario `guillermo`.

### 13.2 Instalar Docker

Repetir el bloque de instalación de Docker para VMs de la sección 8.4.

### 13.3 Instalar Immich

```bash
sudo mkdir -p /opt/stacks/immich/{library,postgres,model-cache}
sudo chown -R guillermo:guillermo /opt/stacks/immich
cd /opt/stacks/immich

DB_PASSWORD="$(openssl rand -base64 24)"
echo "DB_PASSWORD=$DB_PASSWORD"

cat > .env <<EOF
UPLOAD_LOCATION=/opt/stacks/immich/library
DB_DATA_LOCATION=/opt/stacks/immich/postgres
IMMICH_VERSION=release
DB_PASSWORD=$DB_PASSWORD
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
TZ=Europe/Madrid
EOF

cat > docker-compose.yml <<'EOF'
services:
  immich-server:
    container_name: immich-server
    image: ghcr.io/immich-app/immich-server:${IMMICH_VERSION}
    volumes:
      - ${UPLOAD_LOCATION}:/usr/src/app/upload
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    ports:
      - "2283:2283"
    depends_on:
      - redis
      - database
    restart: unless-stopped

  immich-machine-learning:
    container_name: immich-machine-learning
    image: ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION}
    volumes:
      - /opt/stacks/immich/model-cache:/cache
    env_file:
      - .env
    restart: unless-stopped

  redis:
    container_name: immich-redis
    image: docker.io/redis:7-alpine
    restart: unless-stopped

  database:
    container_name: immich-postgres
    image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_DB: ${DB_DATABASE_NAME}
      POSTGRES_INITDB_ARGS: '--data-checksums'
    volumes:
      - ${DB_DATA_LOCATION}:/var/lib/postgresql/data
    restart: unless-stopped
EOF

docker compose up -d
docker ps
```

Acceso: `http://10.10.10.30:2283`. Crear usuario admin desde la web.

Añadir Portainer Agent (repetir sección 5.9), conectar en Portainer `VM109-immich` a `tcp://10.10.10.30:9001`.

---
## 14. CT 108 - Nextcloud

### 14.1 Crear el CT

- **CT ID:** `108`
- **Hostname:** `nextcloud`
- **Red vmbr10:** IP `10.10.10.65/24`, Gateway `10.10.10.87`
- **Disco:** 32 GB, **CPU:** 2 cores, **RAM:** 2048 MB / Swap: 1024 MB
- **Unprivileged + Nesting**

### 14.2 Verificar red e instalar Docker

Comprobar conectividad:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Instalar Docker (repetir el bloque de la sección 5.3). Se confirma Docker 29.4.1 y Docker Compose v5.1.3.

### 14.3 Instalar Nextcloud

```bash
mkdir -p /opt/stacks/nextcloud/{nextcloud,db,redis}
cd /opt/stacks/nextcloud

# Generar contraseñas (guardar en Vaultwarden)
MYSQL_ROOT_PASSWORD="$(openssl rand -base64 24)"
MYSQL_PASSWORD="$(openssl rand -base64 24)"
NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 18)"

cat > docker-compose.yml <<EOF
services:
  db:
    image: mariadb:11
    container_name: nextcloud-db
    restart: unless-stopped
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
    environment:
      MYSQL_ROOT_PASSWORD: "$MYSQL_ROOT_PASSWORD"
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: "$MYSQL_PASSWORD"
    volumes:
      - /opt/stacks/nextcloud/db:/var/lib/mysql

  redis:
    image: redis:7-alpine
    container_name: nextcloud-redis
    restart: unless-stopped
    volumes:
      - /opt/stacks/nextcloud/redis:/data

  nextcloud:
    image: nextcloud:apache
    container_name: nextcloud
    restart: unless-stopped
    depends_on:
      - db
      - redis
    ports:
      - "8088:80"
    environment:
      MYSQL_HOST: db
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: "$MYSQL_PASSWORD"
      NEXTCLOUD_ADMIN_USER: guillermo
      NEXTCLOUD_ADMIN_PASSWORD: "$NEXTCLOUD_ADMIN_PASSWORD"
      NEXTCLOUD_TRUSTED_DOMAINS: "10.10.10.65 192.168.1.200 nextcloud"
      REDIS_HOST: redis
      PHP_MEMORY_LIMIT: 1024M
      PHP_UPLOAD_LIMIT: 10G
    volumes:
      - /opt/stacks/nextcloud/nextcloud:/var/www/html
EOF

docker compose up -d
docker ps
```

Acceso web: `http://10.10.10.65:8088`. Usa el usuario `guillermo` y la contraseña generada (`NEXTCLOUD_ADMIN_PASSWORD`). Al entrar redirige al login, indicando instalación completada.

### 14.4 Añadir Portainer Agent

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps | grep portainer-agent
```

En Portainer, añadir environment:
- **Name:** `CT108-nextcloud`
- **Environment URL:** `tcp://10.10.10.65:9001`

### 14.5 Añadir a Homarr y Uptime Kuma

- **Homarr:** Nombre `Nextcloud`, URL `http://10.10.10.65:8088`, Health check HTTP.
- **Uptime Kuma:** monitor HTTP(s) a `http://10.10.10.65:8088`.

### 14.6 Configurar Nextcloud para el proxy HTTPS

Ejecutar desde el host PVE (`pve > Shell`):

```bash
pct exec 108 -- bash -lc '
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 2 --value=10.10.10.65
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 3 --value=192.168.1.82

docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value=192.168.1.82
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.home.arpa
'
```

### 14.7 Estado confirmado

Verificación desde el host PVE:

```bash
pct exec 108 -- docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
```

Resultado:

```
NAMES             IMAGE                    STATUS        PORTS
portainer-agent   portainer/agent:latest   Up 10 hours   0.0.0.0:9001->9001/tcp
nextcloud         nextcloud:apache         Up 10 hours   0.0.0.0:8088->80/tcp
nextcloud-redis   redis:7-alpine           Up 10 hours   6379/tcp
nextcloud-db      mariadb:11               Up 10 hours   3306/tcp
```

Conectividad probada desde la LAN (CT 101 y CT 102) gracias a las rutas estáticas configuradas, y respuesta HTTP 302 correcta desde `curl -I http://10.10.10.65:8088`. ✅ **Nextcloud instalado y monitorizado.**

---

## 15. Rutas estáticas para que LAN vea la red privada

Algunos CT en LAN necesitan alcanzar la red `10.10.10.0/24` para monitorización o gestión.

### 15.1 En CT 101 dashboard

```bash
ip route add 10.10.10.0/24 via 192.168.1.87

# Hacer permanente:
cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF
```

### 15.2 En CT 102 portainer

```bash
ip route add 10.10.10.0/24 via 192.168.1.87

cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF
```

---

## 16. Scripts de rendimiento: modo-turbo y modo-noche-total

### 16.1 Instalar dependencias

En PVE Shell:

```bash
apt install -y linux-cpupower hdparm lm-sensors
```

### 16.2 Script modo-turbo

```bash
cat > /usr/local/sbin/modo-turbo <<'EOF'
#!/bin/bash
echo "Activando MODO TURBO..."

cpupower frequency-set -g performance
cpupower frequency-set -u 2.10GHz 2>/dev/null || true

systemctl set-property pveproxy.service CPUWeight=100
systemctl set-property pvedaemon.service CPUWeight=100
systemctl set-property pvestatd.service CPUWeight=100

hdparm -S 0 /dev/sda >/dev/null 2>&1 || true

echo "Modo turbo activado."
echo "Governor actual:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
EOF

chmod +x /usr/local/sbin/modo-turbo
```

### 16.3 Script modo-noche-total

```bash
cat > /usr/local/sbin/modo-noche-total <<'EOF'
#!/bin/bash
echo "Activando MODO NOCHE TOTAL..."

KEEP_IDS="100 103"

keep_vm() {
    local id="$1"
    for keep in $KEEP_IDS; do
        if [ "$id" = "$keep" ]; then
            return 0
        fi
    done
    return 1
}

cpupower frequency-set -g powersave
cpupower frequency-set -u 1.40GHz

echo ""
echo "Manteniendo vivos:"
for id in $KEEP_IDS; do
    echo "- $id"
done

echo ""
echo "Apagando CT no incluidos en lista blanca..."
pct list | awk 'NR>1 {print $1}' | while read -r id; do
    if keep_vm "$id"; then
        echo "CT $id protegido, no se apaga."
    else
        echo "Apagando CT $id..."
        pct shutdown "$id" --timeout 60 2>/dev/null || pct stop "$id" 2>/dev/null || true
    fi
done

echo ""
echo "Apagando VM no incluidas en lista blanca..."
qm list | awk 'NR>1 {print $1}' | while read -r id; do
    if keep_vm "$id"; then
        echo "VM $id protegida, no se apaga."
    else
        echo "Apagando VM $id..."
        qm shutdown "$id" --timeout 180 2>/dev/null || qm stop "$id" 2>/dev/null || true
    fi
done

hdparm -S 241 /dev/sda >/dev/null 2>&1 || true
hdparm -y /dev/sda >/dev/null 2>&1 || true

systemctl set-property pveproxy.service CPUWeight=30
systemctl set-property pvedaemon.service CPUWeight=30
systemctl set-property pvestatd.service CPUWeight=30

echo ""
echo "Modo noche total activado."
echo "Quedan vivos los IDs protegidos: $KEEP_IDS"
echo ""
echo "Governor actual:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || true
echo ""
echo "Estado CT:"
pct list
echo ""
echo "Estado VM:"
qm list
echo ""
echo "Temperaturas:"
sensors | grep -E "Tctl|edge|Composite|cpu_fan|gpu_fan" || true
EOF

chmod +x /usr/local/sbin/modo-noche-total
```

> Con `KEEP_IDS="100 103"` se apagan los CT de proxy, identity y dashboards. Si necesitas acceso por dominios o SSO de noche, cambia la lista a `KEEP_IDS="100 103 112 113"` o similar.
---

## 17. Backups locales en Proxmox

### 17.1 Configurar tarea de backup diaria

En la interfaz de Proxmox: `Datacenter > Backup > Add`

- **Storage:** `hdd250-backups`
- **Schedule:** `daily` a las `22:30`
- **Selection mode:** Include selected VMs
- **VMs:** 100,101,102,103,104,105,106,107,108,109,110,111,112,113
- **Mode:** Snapshot
- **Compression:** ZSTD
- **Retention:** Keep last 2 (así siempre tienes los dos backups más recientes)

Los backups diarios se almacenan en `/mnt/hdd250/backups/dump`.

### 17.2 Backup manual de prueba

Desde PVE Shell:

```bash
vzdump 100 --storage hdd250-backups --mode snapshot --compress zstd
ls -lh /mnt/hdd250/backups/dump
```

> **Nota:** Adicionalmente, el script `subir-backups-gdrive` se ejecuta los domingos a las 05:00 mediante systemd y sincroniza todo el directorio `/mnt/hdd250/backups/dump` de forma cifrada a Google Drive. Al mantener solo 2 backups locales, la subida refleja siempre el estado más actual.

---

## 18. Backups externos cifrados con rclone a Google Drive

### 18.1 Instalar rclone en PVE

```bash
apt install -y rclone
```

### 18.2 Configurar remote de Google Drive

```bash
rclone config
```

- `n` (new remote)
- name: `gdrive`
- type: `drive`
- client_id: (enter)
- client_secret: (enter)
- scope: `1`
- root_folder_id: (enter)
- service_account_file: (enter)
- advanced: `n`
- auto config: `n` → copiar URL y autorizar desde navegador, pegar código.
- shared drive: `n`
- `y` para guardar, luego `q`

### 18.3 Crear carpeta y remote cifrado

```bash
rclone mkdir gdrive:Homelab-Proxmox-Backups
rclone config
```

- `n`
- name: `gdrive-crypt`
- type: `crypt`
- remote: `gdrive:Homelab-Proxmox-Backups`
- filename encryption: `standard`
- directory encryption: `true`
- password: `g` (generate) `1024` → guardar en Vaultwarden
- salt: `y` (yes) `g` `1024` → guardar en Vaultwarden
- advanced: `n`
- `y` para guardar, `q`

Probar:

```bash
echo "prueba rclone $(date)" > /root/test-rclone.txt
rclone copy /root/test-rclone.txt gdrive-crypt:test
rclone ls gdrive-crypt:test
```

### 18.4 Script de subida programada

```bash
cat > /usr/local/sbin/subir-backups-gdrive <<'EOF'
#!/bin/bash
set -e
echo "Subiendo backups Proxmox a Google Drive cifrado..."
date
rclone sync /mnt/hdd250/backups/dump gdrive-crypt:proxmox-dump \
  --progress \
  --transfers=2 \
  --checkers=4 \
  --drive-chunk-size=64M \
  --log-file=/var/log/rclone-proxmox-backup.log \
  --log-level=INFO
echo "Subida completada."
date
EOF

chmod +x /usr/local/sbin/subir-backups-gdrive
chmod 600 /root/.config/rclone/rclone.conf
```

### 18.5 Timer systemd para domingos 05:00

```bash
cat > /etc/systemd/system/subir-backups-gdrive.service <<'EOF'
[Unit]
Description=Subir backups Proxmox a Google Drive cifrado con rclone
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/subir-backups-gdrive
EOF

cat > /etc/systemd/system/subir-backups-gdrive.timer <<'EOF'
[Unit]
Description=Ejecutar subida de backups Proxmox a Google Drive cada domingo

[Timer]
OnCalendar=Sun 05:00
Persistent=true
Unit=subir-backups-gdrive.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now subir-backups-gdrive.timer
systemctl start subir-backups-gdrive.service   # Primera subida manual
```

Verificar log y tamaño remoto:

```bash
tail -40 /var/log/rclone-proxmox-backup.log
rclone size gdrive-crypt:proxmox-dump
```

---

## 19. Configuración de Duplicati en CasaOS

En la VM 104, ya con Docker instalado:

```bash
sudo mkdir -p /opt/stacks/duplicati /data/backups/duplicati
sudo chown -R guillermo:guillermo /opt/stacks/duplicati /data/backups/duplicati
cd /opt/stacks/duplicati

WEBPASS='TU_PASSWORD_AQUI'
KEY=$(openssl rand -base64 32)

cat > docker-compose.yml <<EOF
services:
  duplicati:
    image: lscr.io/linuxserver/duplicati:latest
    container_name: duplicati
    restart: unless-stopped
    ports:
      - "8200:8200"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
      - SETTINGS_ENCRYPTION_KEY=$KEY
      - DUPLICATI__WEBSERVICE_PASSWORD=$WEBPASS
    volumes:
      - /opt/stacks/duplicati/config:/config
      - /data:/source
      - /data/backups/duplicati:/backups
EOF

sudo docker compose up -d
```

Acceder a `http://192.168.1.81:8200` con la contraseña definida. Configurar backups de `/source/documents`, `/source/obsidian`, `/source/sync`, `/source/shared`.

---

## 20. Ajustes finales en dashboards y monitoreo

### 20.1 Homarr

- Se migró el Homarr original a la versión 1.0 exportando la configuración desde `Management > Tools > Migrate to 1.0`.
- La nueva instancia (stack `homarr-v1`) se desplegó en el puerto `7576` para probarla en paralelo, y una vez validada se movió al puerto `7575` (o se cambió el proxy para apuntar a `7575`).
- **Instancia actual activa:**  
  - Stack: `homarr-v1` en `/opt/stacks/homarr-v1`  
  - Puerto: `7575`  
  - Base de datos: `/opt/stacks/homarr-v1/appdata/db/db.sqlite`
- El Homarr viejo (stack `homarr` en `/opt/stacks/homarr`) se puede detener o eliminar porque ya no se usa.

### 20.2 Uptime Kuma

Añadir monitores HTTP(s) para:

- Proxmox: `https://192.168.1.200:8006`
- Tailscale Gateway: ping a `10.10.10.87`
- Dashboard / Homarr: `https://homarr.home.arpa`
- Portainer: `https://portainer.home.arpa`
- AdGuard: `https://adguard.home.arpa`
- CasaOS: `https://casaos.home.arpa`
- Vaultwarden: `https://vaultwarden.tailfcb362.ts.net` o `http://10.10.10.60:8080`
- Paperless: `https://paperless.home.arpa`
- Nextcloud: `https://nextcloud.home.arpa`
- Immich: `https://immich.home.arpa`
- Navidrome: `https://navidrome.home.arpa` o `http://10.10.10.82:4533`
- Downloads: `http://10.10.10.83:6595`

### 20.3 Portainer Agents

Verificar que todos los environments estén conectados:

- `CT101-dashboard` → `tcp://192.168.1.79:9001`
- `VM104-casaos-nas` → `tcp://192.168.1.81:9001`
- `CT105-monitoring` → `tcp://10.10.10.50:9001`
- `CT106-vaultwarden` → `tcp://10.10.10.60:9001`
- `CT107-paperless` → `tcp://10.10.10.40:9001`
- `CT108-nextcloud` → `tcp://10.10.10.65:9001`
- `VM109-immich` → `tcp://10.10.10.30:9001`
- `CT110-tools` → `tcp://10.10.10.70:9001`
- `CT111-databases` → `tcp://10.10.10.73:9001`
- `CT112-proxy` → `tcp://192.168.1.82:9001`
- `CT113-identity` → `tcp://10.10.10.74:9001`
- `CT114-music` → `tcp://10.10.10.82:9001`
- `CT115-downloads` → `tcp://10.10.10.83:9001`
---

## 21. Extensiones y servicios adicionales

### 21.1 Portainer Agent en CT106 Vaultwarden

Entrar en la consola del CT 106 (`vaultwarden`) y ejecutar:

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps | grep portainer-agent
```

Luego, en Portainer añadir el entorno:
- **Name:** `CT106-vaultwarden`
- **Environment URL:** `tcp://10.10.10.60:9001`
- **Tipo:** Agent

### 21.2 Corrección de gateway en CT105 (solo si es necesario)

Si el CT 105 se creó sin gateway, se puede forzar desde el host PVE:

```bash
pct set 105 -net0 name=eth0,bridge=vmbr10,firewall=1,ip=10.10.10.50/24,gw=10.10.10.87
pct reboot 105
```

En la guía actual el CT105 ya se crea con gateway, por lo que este paso suele ser innecesario.

### 21.3 cAdvisor en todos los entornos Docker y Prometheus

#### 21.3.1 Instalar cAdvisor en cada entorno

En todos los entornos Docker (excepto CT100 y CT103) desplegar el stack `cadvisor` desde Portainer o consola.  
**Compose estándar para todos:**

```yaml
services:
  cadvisor:
    image: ghcr.io/google/cadvisor:0.56.2
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8089:8080"
    command:
      - --docker_only=true
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

Los entornos son:

* CT101-dashboard (`192.168.1.79`)
* CT102-portainer (`192.168.1.80`)
* VM104-casaos-nas (`192.168.1.81`)
* CT105-monitoring (`10.10.10.50`)
* CT106-vaultwarden (`10.10.10.60`)
* CT107-paperless (`10.10.10.40`)
* CT108-nextcloud (`10.10.10.65`)
* VM109-immich (`10.10.10.30`)
* CT110-tools (`10.10.10.70`)
* CT111-databases (`10.10.10.73`)
* CT112-proxy: `192.168.1.82`
* CT113-identity (`10.10.10.74`)
* CT114-music (`10.10.10.82`)
* CT115-downloads (`10.10.10.83`)

#### 21.3.2 Verificar cAdvisor en cada host

Desde el CT101 dashboard (o cualquier máquina con acceso a esas IPs):

```bash
for ip in 192.168.1.79 192.168.1.80 192.168.1.81 10.10.10.50 10.10.10.60 10.10.10.40 10.10.10.65 10.10.10.30 10.10.10.70 10.10.10.73 192.168.1.82 10.10.10.74 10.10.10.82 10.10.10.83; do
  echo "===== $ip cAdvisor ====="
  curl -s --max-time 5 "http://$ip:8089/metrics" | head -2 || echo "NO RESPONDE"
  echo
done
```

#### 21.3.3 Actualizar Prometheus con todos los cAdvisor

En el **CT105 monitoring**:

```bash
cp /opt/stacks/monitoring/prometheus/prometheus.yml /opt/stacks/monitoring/prometheus/prometheus.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

p = Path("/opt/stacks/monitoring/prometheus/prometheus.yml")
text = p.read_text()

marker = '  - job_name: "cadvisor"'
if marker in text:
    before = text.split(marker)[0].rstrip()
else:
    before = text.rstrip()

cadvisor_block = '''
  - job_name: "cadvisor"
    scrape_interval: 15s
    static_configs:
      - targets:
          - "10.10.10.50:8089"
        labels:
          host: "CT105-monitoring"

      - targets:
          - "192.168.1.79:8089"
        labels:
          host: "CT101-dashboard"

      - targets:
          - "192.168.1.80:8089"
        labels:
          host: "CT102-portainer"

      - targets:
          - "192.168.1.81:8089"
        labels:
          host: "VM104-casaos-nas"

      - targets:
          - "10.10.10.60:8089"
        labels:
          host: "CT106-vaultwarden"

      - targets:
          - "10.10.10.40:8089"
        labels:
          host: "CT107-paperless"

      - targets:
          - "10.10.10.65:8089"
        labels:
          host: "CT108-nextcloud"

      - targets:
          - "10.10.10.30:8089"
        labels:
          host: "VM109-immich"

      - targets:
          - "10.10.10.70:8089"
        labels:
          host: "CT110-tools"

      - targets:
          - "10.10.10.73:8089"
        labels:
          host: "CT111-databases"

      - targets:
          - "192.168.1.82:8089"
        labels:
          host: "CT112-proxy"   
          
      - targets:
          - "10.10.10.74:8089"
        labels:
          host: "CT113-identity"    
          
      - targets:
          - "10.10.10.82:8089"
        labels:
          host: "CT114-music"

      - targets:
          - "10.10.10.83:8089"
        labels:
          host: "CT115-downloads"   
'''

p.write_text(before + "\n\n" + cadvisor_block + "\n")
PY

echo "===== CONFIG PROMETHEUS ====="
cat /opt/stacks/monitoring/prometheus/prometheus.yml

echo
echo "===== VALIDAR CONFIG ====="
docker exec prometheus promtool check config /etc/prometheus/prometheus.yml

echo
echo "===== REINICIAR PROMETHEUS ====="
docker restart prometheus
sleep 15

echo "===== HEALTH ====="
curl -I http://127.0.0.1:9090/-/healthy
```

Comprobar en `http://10.10.10.50:9090/targets` que todos los `cadvisor` aparecen **UP**.

### 21.4 Socket‑proxy para Homarr en todos los entornos

Homarr utilizará un socket‑proxy en cada host Docker para mostrar el estado de los contenedores. Con `POST=0` queda en modo solo lectura.

#### 21.4.1 Desplegar socket‑proxy en cada entorno

En Portainer (o consola) crear un stack llamado `socket-proxy` en cada uno de los siguientes entornos con el compose adecuado.  
**Compose tipo (cambiar la IP según el host):**

```yaml
services:
  socket-proxy:
    image: lscr.io/linuxserver/socket-proxy:latest
    container_name: socket-proxy
    restart: unless-stopped
    read_only: true
    tmpfs:
      - /run
    ports:
      - "IP.DEL.HOST:2375:2375"
    environment:
      - CONTAINERS=1
      - IMAGES=1
      - INFO=1
      - PING=1
      - VERSION=1
      - ALLOW_START=1
      - ALLOW_STOP=1
      - ALLOW_RESTARTS=1
      - POST=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
```

> Con `POST=0` el proxy solo permite leer contenedores. Si quisieras que Homarr pudiera hacer start/stop/restart, cambia a `POST=1` (más riesgo).

Lista de hosts e IPs para el puerto `2375`:

- CT101-dashboard: `192.168.1.79`
- CT102-portainer: `192.168.1.80`
- VM104-casaos-nas: `192.168.1.81`
- CT105-monitoring: `10.10.10.50`
- CT106-vaultwarden: `10.10.10.60`
- CT107-paperless: `10.10.10.40`
- CT108-nextcloud: `10.10.10.65`
- VM109-immich: `10.10.10.30`
- CT110-tools: `10.10.10.70`
- CT111-databases: `10.10.10.73`
- CT112-proxy: `192.168.1.82`
- CT113-identity: `10.10.10.74`
- CT114-music: `10.10.10.82`
- CT115-downloads: `10.10.10.83`

#### 21.4.2 Verificar socket‑proxy desde CT101

```bash
for ip in 192.168.1.79 192.168.1.80 192.168.1.81 10.10.10.50 10.10.10.60 10.10.10.40 10.10.10.65 10.10.10.30 10.10.10.70 10.10.10.73 192.168.1.82 10.10.10.74 10.10.10.82 10.10.10.83; do
  echo "===== $ip ====="
  curl -s --max-time 5 "http://$ip:2375/_ping" || echo "NO RESPONDE"
  echo
done
```

Esperar `OK` en todos.

#### 21.4.3 Actualizar Homarr con todos los Dockers remotos

En el CT101 dashboard, dentro del stack `homarr-v1`:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

hosts = "192.168.1.79,192.168.1.80,192.168.1.81,10.10.10.50,10.10.10.60,10.10.10.40,10.10.10.65,10.10.10.30,10.10.10.70,10.10.10.73,192.168.1.82,10.10.10.74,10.10.10.82,10.10.10.83"
ports = "2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375"

p = Path("docker-compose.yml")
text = p.read_text()

lines = [
    line for line in text.splitlines()
    if "DOCKER_HOSTNAMES=" not in line and "DOCKER_PORTS=" not in line
]

out = []
inserted = False

for line in lines:
    out.append(line)
    if line.strip().startswith("- SECRET_ENCRYPTION_KEY="):
        out.append(f"      - DOCKER_HOSTNAMES={hosts}")
        out.append(f"      - DOCKER_PORTS={ports}")
        inserted = True

if not inserted:
    raise SystemExit("ERROR: No encontré SECRET_ENCRYPTION_KEY en el compose de Homarr.")

p.write_text("\n".join(out) + "\n")
PY

cat docker-compose.yml

docker compose up -d
docker logs homarr-v1 --tail=80
```

Tras reiniciar, el widget de Docker en Homarr mostrará los contenedores de todos los entornos.

### 21.5 CT110 – Tools (IT‑Tools + Stirling PDF)

#### 21.5.1 Crear el CT

En Proxmox:

- **CT ID:** `110`
- **Hostname:** `tools`
- **Red vmbr10:** IP `10.10.10.70/24`, Gateway `10.10.10.87`
- **Disco:** 16 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

Comprobar conectividad e instalar Docker (repetir bloque de la sección 5.3).

#### 21.5.2 Instalar Portainer Agent, socket‑proxy y cAdvisor

Crear las tres stacks directamente en el CT110 o desde Portainer:

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent
# Repetir bloque del Portainer Agent (sección 5.9)
docker compose up -d
```

Desplegar `socket-proxy` y `cadvisor` desde Portainer (o consola) con los compose vistos en las secciones 21.4.1 y 21.3.1, usando las IPs correspondientes del CT110.

#### 21.5.3 Stack principal de herramientas

Desde Portainer en el entorno `CT110-tools`, crear el stack `tools`:

```yaml
services:
  it-tools:
    image: corentinth/it-tools:latest
    container_name: it-tools
    restart: unless-stopped
    ports:
      - "8080:80"

  stirling-pdf:
    image: stirlingtools/stirling-pdf:latest
    container_name: stirling-pdf
    restart: unless-stopped
    ports:
      - "8081:8080"
    environment:
      - TZ=Europe/Madrid
      - SECURITY_ENABLELOGIN=false
      - LANGS=es_ES,en_GB
    volumes:
      - /opt/stacks/tools/stirling-pdf/configs:/configs
      - /opt/stacks/tools/stirling-pdf/logs:/logs
      - /opt/stacks/tools/stirling-pdf/pipeline:/pipeline
      - /opt/stacks/tools/stirling-pdf/tessdata:/usr/share/tessdata
```

Accesos:
- IT‑Tools: `http://10.10.10.70:8080`
- Stirling PDF: `http://10.10.10.70:8081`

#### 21.5.4 Integración con Homarr y Prometheus

- **Añadir a Homarr** (manualmente): `IT-Tools` y `Stirling PDF` con sus URLs.
- **Añadir a Uptime Kuma** monitores HTTP para ambas.
- **Añadir a Prometheus**: en el CT105, agregar el target `10.10.10.70:8089` al job `cadvisor`.  
  Para ello, editar `/opt/stacks/monitoring/prometheus/prometheus.yml` y añadir:

```yaml
      - targets:
          - "10.10.10.70:8089"
        labels:
          host: "CT110-tools"
```

Luego validar y reiniciar Prometheus.

- **Actualizar Homarr remoto**: en el CT101, volver a ejecutar el script de la sección 21.4.3 pero añadiendo `10.10.10.70` a la lista de hosts y `2375` al puerto.  
  O bien editar manualmente el `docker-compose.yml` de Homarr para que `DOCKER_HOSTNAMES` y `DOCKER_PORTS` incluyan `10.10.10.70` y `2375`.

### 21.6 CT111 – Databases (PostgreSQL, MariaDB, Redis, Adminer, pgAdmin)

#### 21.6.1 Crear el CT

Nota: El ID final usado es `111`, con IP `10.10.10.73`.

- **CT ID:** `111`
- **Hostname:** `databases`
- **Red vmbr10:** IP `10.10.10.73/24`, Gateway `10.10.10.87`
- **Disco:** 24 GB, **CPU:** 1 core, **RAM:** 2048 MB / Swap: 1024 MB
- **Unprivileged + Nesting**

Instalar Docker (bloque sección 5.3) y Portainer Agent.

#### 21.6.2 Crear archivo `.env` con contraseñas

```bash
mkdir -p /opt/stacks/databases/{postgres,mariadb,redis,pgadmin,backups}
chmod 700 /opt/stacks/databases

POSTGRES_PASSWORD="$(openssl rand -hex 24)"
MARIADB_ROOT_PASSWORD="$(openssl rand -hex 24)"
MARIADB_PASSWORD="$(openssl rand -hex 24)"
REDIS_PASSWORD="$(openssl rand -hex 24)"
PGADMIN_PASSWORD="$(openssl rand -hex 24)"

cat > /opt/stacks/databases/.env <<EOF
POSTGRES_DB=labdb
POSTGRES_USER=guillermo
POSTGRES_PASSWORD=$POSTGRES_PASSWORD

MARIADB_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD
MARIADB_DATABASE=labdb
MARIADB_USER=guillermo
MARIADB_PASSWORD=$MARIADB_PASSWORD

REDIS_PASSWORD=$REDIS_PASSWORD

PGADMIN_DEFAULT_EMAIL=TU_CORREO@example.com
PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/databases/.env
cp /opt/stacks/databases/.env /root/CT111-databases-passwords.txt
```

**Guarda las contraseñas en Vaultwarden.**

#### 21.6.3 Stack de bases de datos (desplegar desde Portainer)

Usar el siguiente compose en el entorno `CT111-databases` como stack `databases`.  
*Importante: no usar `env_file`, sino copiar el contenido del `.env` en las variables de entorno del stack en Portainer.*

```yaml
services:
  postgres:
    image: postgres:17
    container_name: lab-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${POSTGRES_DB}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    ports:
      - "10.10.10.73:5432:5432"
    volumes:
      - /opt/stacks/databases/postgres:/var/lib/postgresql/data

  mariadb:
    image: mariadb:11
    container_name: lab-mariadb
    restart: unless-stopped
    environment:
      MARIADB_ROOT_PASSWORD: ${MARIADB_ROOT_PASSWORD}
      MARIADB_DATABASE: ${MARIADB_DATABASE}
      MARIADB_USER: ${MARIADB_USER}
      MARIADB_PASSWORD: ${MARIADB_PASSWORD}
    ports:
      - "10.10.10.73:3306:3306"
    volumes:
      - /opt/stacks/databases/mariadb:/var/lib/mysql

  redis:
    image: redis:7-alpine
    container_name: lab-redis
    restart: unless-stopped
    command: sh -c 'redis-server --appendonly yes --requirepass "$$REDIS_PASSWORD"'
    environment:
      REDIS_PASSWORD: ${REDIS_PASSWORD}
    ports:
      - "10.10.10.73:6379:6379"
    volumes:
      - /opt/stacks/databases/redis:/data

  adminer:
    image: adminer:latest
    container_name: adminer
    restart: unless-stopped
    ports:
      - "8080:8080"
    environment:
      ADMINER_DEFAULT_SERVER: postgres

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin
    restart: unless-stopped
    environment:
      PGADMIN_DEFAULT_EMAIL: ${PGADMIN_DEFAULT_EMAIL}
      PGADMIN_DEFAULT_PASSWORD: ${PGADMIN_DEFAULT_PASSWORD}
      TZ: Europe/Madrid
    ports:
      - "8082:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin

volumes:
  pgadmin-data:
```

Después del despliegue, forzar permisos para pgAdmin si fuera necesario:

```bash
docker stop pgadmin
mkdir -p /opt/stacks/databases/pgadmin
chown -R 5050:5050 /opt/stacks/databases/pgadmin
chmod -R 750 /opt/stacks/databases/pgadmin
docker start pgadmin
```

#### 21.6.4 Comprobación del stack

Ejecutar este bloque en el CT111 para verificar que todos los servicios están funcionando:

```bash
source /opt/stacks/databases/.env

echo "===== CONTENEDORES CT111 ====="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
echo "===== POSTGRESQL - CONEXION ====="
docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" lab-postgres \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -c "SELECT current_user, current_database(), version();"

echo
echo "===== POSTGRESQL - TABLA DE PRUEBA ====="
docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" lab-postgres \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -c "CREATE TABLE IF NOT EXISTS prueba_postgres (
        id SERIAL PRIMARY KEY,
        nombre TEXT NOT NULL,
        creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      INSERT INTO prueba_postgres (nombre) VALUES ('PostgreSQL funciona desde CT111');
      SELECT * FROM prueba_postgres ORDER BY id DESC LIMIT 5;"

echo
echo "===== MARIADB - CONEXION ====="
docker exec lab-mariadb mariadb \
  -u"$MARIADB_USER" \
  -p"$MARIADB_PASSWORD" \
  "$MARIADB_DATABASE" \
  -e "SELECT USER(), DATABASE(), VERSION();"

echo
echo "===== MARIADB - TABLA DE PRUEBA ====="
docker exec lab-mariadb mariadb \
  -u"$MARIADB_USER" \
  -p"$MARIADB_PASSWORD" \
  "$MARIADB_DATABASE" \
  -e "CREATE TABLE IF NOT EXISTS prueba_mariadb (
        id INT AUTO_INCREMENT PRIMARY KEY,
        nombre VARCHAR(150) NOT NULL,
        creado_en TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
      INSERT INTO prueba_mariadb (nombre) VALUES ('MariaDB funciona desde CT111');
      SELECT * FROM prueba_mariadb ORDER BY id DESC LIMIT 5;"

echo
echo "===== REDIS - PING ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" ping

echo
echo "===== REDIS - SET / GET ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" SET prueba_redis "Redis funciona desde CT111"
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" GET prueba_redis

echo
echo "===== WEB ====="
curl -I http://127.0.0.1:8080
curl -I http://127.0.0.1:8082
```

Si todo responde correctamente, los servicios están listos.

#### 21.6.5 Integración con socket‑proxy, cAdvisor, Prometheus y Homarr

- **socket‑proxy** y **cAdvisor**: desplegar los stacks correspondientes en el CT111 (con IP `10.10.10.73`), usando los compose de 21.4.1 y 21.3.1.
- **Prometheus**: añadir el target `10.10.10.73:8089` al job `cadvisor`.
- **Homarr remoto**: añadir `10.10.10.73` a la lista de `DOCKER_HOSTNAMES` y `2375` a `DOCKER_PORTS` en el stack `homarr-v1` (como se explicó en 21.4.3).
- **Apps en Homarr y Uptime Kuma**: añadir Adminer (`https://adminer.home.arpa`), pgAdmin (`https://pgadmin.home.arpa`), y monitores TCP para PostgreSQL (5432), MariaDB (3306) y Redis (6379).

### 21.7 CT112 – Reverse Proxy con Nginx Proxy Manager

El proxy se sitúa en la LAN para que todos los dispositivos de casa puedan usar los dominios `*.home.arpa`.

#### 21.7.1 Crear el CT

- **CT ID:** `112`
- **Hostname:** `proxy`
- **Red vmbr0:** IP `192.168.1.82/24`, Gateway `192.168.1.1`
- **Disco:** 12 GB, **CPU:** 1 core, **RAM:** 1024 MB / Swap: 512 MB
- **Unprivileged + Nesting**

Instalar Docker (sección 5.3) y Portainer Agent.

#### 21.7.2 Conectar con la red privada

Para que el proxy llegue a los servicios en `10.10.10.0/24`:

```bash
ip route add 10.10.10.0/24 via 192.168.1.87

cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF
```

Comprobar:

```bash
ping -c 2 10.10.10.50
ping -c 2 10.10.10.73
```

#### 21.7.3 Instalar Nginx Proxy Manager

Crear el stack `nginx-proxy-manager` en Portainer (entorno `CT112-proxy`):

```yaml
services:
  npm:
    image: jc21/nginx-proxy-manager:latest
    container_name: nginx-proxy-manager
    restart: unless-stopped
    ports:
      - "80:80"
      - "81:81"
      - "443:443"
    environment:
      - TZ=Europe/Madrid
      - DISABLE_IPV6=true
    volumes:
      - /opt/stacks/nginx-proxy-manager/data:/data
      - /opt/stacks/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
```

Acceso inicial: `http://192.168.1.82:81`  
Credenciales por defecto:  
- Email: `admin@example.com`  
- Password: `changeme`  

Cambiar inmediatamente el email y la contraseña.  
Si las credenciales por defecto no funcionan, restablecerlas desde el CT112:

```bash
apt install -y apache2-utils sqlite3
NEWPASS='TU_NUEVA_CONTRASEÑA'
DB="/opt/stacks/nginx-proxy-manager/data/database.sqlite"
USER_ID=$(sqlite3 "$DB" "SELECT id FROM user WHERE is_deleted=0 ORDER BY id LIMIT 1;")
HASH=$(htpasswd -bnBC 10 "" "$NEWPASS" | tr -d ':\n' | sed 's/^\$2y\$/\$2b\$/')
sqlite3 "$DB" "UPDATE auth SET secret='$HASH' WHERE user_id=$USER_ID AND type='password';"
docker restart nginx-proxy-manager
```

#### 21.7.4 Generar certificado autofirmado wildcard

Crear el certificado para `*.home.arpa`:

```bash
mkdir -p /opt/stacks/nginx-proxy-manager/certs/home-arpa

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /opt/stacks/nginx-proxy-manager/certs/home-arpa/home.arpa.key \
  -out /opt/stacks/nginx-proxy-manager/certs/home-arpa/home.arpa.crt \
  -subj "/CN=*.home.arpa" \
  -addext "subjectAltName=DNS:*.home.arpa,DNS:home.arpa"
```

En NPM, ir a `SSL Certificates > Add SSL Certificate > Custom Certificate` y seleccionar los archivos generados. Darle un nombre como `home-arpa-local`.

#### 21.7.5 Configurar DNS rewrites en AdGuard

Crear registros DNS para todos los servicios, apuntando a la IP del proxy (`192.168.1.82`).  
Lista completa (puede usarse el script de la sección 21.8.1 para automatizarlo):

```
npm.home.arpa
proxmox.home.arpa
homepage.home.arpa
homarr.home.arpa
homer.home.arpa
heimdall.home.arpa
portainer.home.arpa
adguard.home.arpa
casaos.home.arpa
syncthing.home.arpa
duplicati.home.arpa
kuma.home.arpa
beszel.home.arpa
grafana.home.arpa
prometheus.home.arpa
speedtest.home.arpa
scrutiny.home.arpa
adminer.home.arpa
pgadmin.home.arpa
chartdb.home.arpa
tools.home.arpa
pdf.home.arpa
vault.home.arpa
paperless.home.arpa
nextcloud.home.arpa
immich.home.arpa
auth.home.arpa
navidrome.home.arpa
downloads.home.arpa
```

#### 21.7.6 Crear Proxy Hosts básicos (sin SSL)

Desde la interfaz de NPM, crear los Proxy Hosts con los datos de la lista anterior, o bien ejecutar el script de la sección 21.8.1.

Parámetros base para cada host:

- **Domain Names:** `servicio.home.arpa`
- **Scheme:** `http`
- **Forward Hostname / IP:** IP real del servicio
- **Forward Port:** puerto real

Tras crearlos todos, aplicar SSL masivamente con el script de la sección 21.8.2.

#### 21.7.7 Desplegar socket‑proxy y cAdvisor en CT112

Como en los demás servicios, añadir los stacks `socket-proxy` (IP `192.168.1.82`) y `cadvisor`, usando los compose de las secciones 21.4.1 y 21.3.1.  
El proxy también debe integrarse en Homarr y Prometheus.

### 21.8 Scripts de automatización para el proxy

Los siguientes scripts se ejecutan desde el **CT112 proxy** y requieren las credenciales de AdGuard y de NPM.

#### 21.8.1 Crear todos los DNS rewrites y Proxy Hosts de una vez

```bash
cat > /root/scripts/crear-dns-y-proxy.py <<'PY'
#!/usr/bin/env python3
import base64, getpass, json, urllib.error, urllib.request

ADGUARD_URL = "http://192.168.1.53"
NPM_URL = "http://127.0.0.1:81"
PROXY_IP = "192.168.1.82"

SERVICES = [
    # Dashboard / LAN
    {"domain": "npm.home.arpa", "scheme": "http", "host": "192.168.1.82", "port": 81},
    {"domain": "proxmox.home.arpa", "scheme": "https", "host": "192.168.1.200", "port": 8006},
    {"domain": "homepage.home.arpa", "scheme": "http", "host": "192.168.1.79", "port": 3000},
    {"domain": "homarr.home.arpa", "scheme": "http", "host": "192.168.1.79", "port": 7575},
    {"domain": "homer.home.arpa", "scheme": "http", "host": "192.168.1.79", "port": 8080},
    {"domain": "heimdall.home.arpa", "scheme": "http", "host": "192.168.1.79", "port": 8081},
    {"domain": "portainer.home.arpa", "scheme": "https", "host": "192.168.1.80", "port": 9443},
    {"domain": "adguard.home.arpa", "scheme": "http", "host": "192.168.1.53", "port": 80},

    # CasaOS / NAS
    {"domain": "casaos.home.arpa", "scheme": "http", "host": "192.168.1.81", "port": 80},
    {"domain": "syncthing.home.arpa", "scheme": "http", "host": "192.168.1.81", "port": 8384},
    {"domain": "duplicati.home.arpa", "scheme": "http", "host": "192.168.1.81", "port": 8200},

    # Monitoring
    {"domain": "kuma.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 3001},
    {"domain": "beszel.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 8090},
    {"domain": "grafana.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 3002},
    {"domain": "prometheus.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 9090},
    {"domain": "speedtest.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 8085},
    {"domain": "scrutiny.home.arpa", "scheme": "http", "host": "10.10.10.50", "port": 8086},

    # Databases
    {"domain": "adminer.home.arpa", "scheme": "http", "host": "10.10.10.73", "port": 8080},
    {"domain": "pgadmin.home.arpa", "scheme": "http", "host": "10.10.10.73", "port": 8082},
    {"domain": "chartdb.home.arpa", "scheme": "http", "host": "10.10.10.73", "port": 8083},

    # Tools
    {"domain": "tools.home.arpa", "scheme": "http", "host": "10.10.10.70", "port": 8080},
    {"domain": "pdf.home.arpa", "scheme": "http", "host": "10.10.10.70", "port": 8081},

    # Apps privadas
    {"domain": "vault.home.arpa", "scheme": "http", "host": "10.10.10.60", "port": 8080},
    {"domain": "paperless.home.arpa", "scheme": "http", "host": "10.10.10.40", "port": 8000},
    {"domain": "nextcloud.home.arpa", "scheme": "http", "host": "10.10.10.65", "port": 8088},
    {"domain": "immich.home.arpa", "scheme": "http", "host": "10.10.10.30", "port": 2283},
    {"domain": "navidrome.home.arpa", "scheme": "http", "host": "10.10.10.82", "port": 4533},
	{"domain": "downloads.home.arpa", "scheme": "http", "host": "10.10.10.83", "port": 6595},
]

DNS_ONLY = [
    "auth.home.arpa",
]

def request_json(method, url, data=None, headers=None):
    body = None
    if data is not None:
        body = json.dumps(data).encode("utf-8")

    req = urllib.request.Request(url, data=body, method=method)
    req.add_header("Content-Type", "application/json")

    if headers:
        for k, v in headers.items():
            req.add_header(k, v)

    try:
        with urllib.request.urlopen(req, timeout=15) as resp:
            raw = resp.read().decode("utf-8")
            if not raw:
                return None
            return json.loads(raw)
    except urllib.error.HTTPError as e:
        raw = e.read().decode("utf-8", errors="ignore")
        raise RuntimeError(f"{method} {url} -> HTTP {e.code}: {raw}") from e

def adguard_headers(user, password):
    token = base64.b64encode(f"{user}:{password}".encode()).decode()
    return {"Authorization": f"Basic {token}"}

def adguard_add_rewrite(user, password, domain, answer):
    headers = adguard_headers(user, password)

    try:
        rewrites = request_json("GET", f"{ADGUARD_URL}/control/rewrite/list", headers=headers)
    except Exception as e:
        raise RuntimeError(f"No pude leer rewrites de AdGuard: {e}")

    if rewrites is None:
        rewrites = []

    for item in rewrites:
        if item.get("domain") == domain:
            if item.get("answer") == answer:
                print(f"[AdGuard] SKIP  {domain} ya apunta a {answer}")
                return
            print(f"[AdGuard] AVISO {domain} ya existe apuntando a {item.get('answer')}, no lo toco.")
            return

    request_json(
        "POST",
        f"{ADGUARD_URL}/control/rewrite/add",
        data={"domain": domain, "answer": answer},
        headers=headers,
    )
    print(f"[AdGuard] OK    {domain} -> {answer}")

def npm_login(email, password):
    data = request_json(
        "POST",
        f"{NPM_URL}/api/tokens",
        data={"identity": email, "secret": password},
    )
    token = data.get("token")
    if not token:
        raise RuntimeError("NPM no devolvió token.")
    return {"Authorization": f"Bearer {token}"}

def npm_existing_hosts(headers):
    data = request_json("GET", f"{NPM_URL}/api/nginx/proxy-hosts", headers=headers)
    existing = set()
    for host in data:
        for domain in host.get("domain_names", []):
            existing.add(domain)
    return existing

def npm_add_proxy(headers, item):
    domain = item["domain"]

    payload = {
        "domain_names": [domain],
        "forward_scheme": item["scheme"],
        "forward_host": item["host"],
        "forward_port": item["port"],
        "access_list_id": 0,
        "certificate_id": 0,
        "ssl_forced": False,
        "caching_enabled": False,
        "block_exploits": True,
        "allow_websocket_upgrade": True,
        "http2_support": False,
        "hsts_enabled": False,
        "hsts_subdomains": False,
        "advanced_config": "",
        "locations": [],
        "enabled": True,
        "meta": {
            "letsencrypt_agree": False,
            "dns_challenge": False,
        },
    }

    request_json("POST", f"{NPM_URL}/api/nginx/proxy-hosts", data=payload, headers=headers)
    print(f"[NPM]     OK    {domain} -> {item['scheme']}://{item['host']}:{item['port']}")

def main():
    print("=== Automatizar AdGuard + Nginx Proxy Manager ===")
    print("Esto creará DNS rewrites en AdGuard y Proxy Hosts en NPM.")
    print()

    adg_user = input("Usuario AdGuard: ").strip()
    adg_pass = getpass.getpass("Contraseña AdGuard: ")

    npm_email = input("Email NPM: ").strip()
    npm_pass = getpass.getpass("Contraseña NPM: ")

    print()
    print("===== Probando login NPM =====")
    npm_headers = npm_login(npm_email, npm_pass)
    print("[NPM] Login OK")

    print()
    print("===== Leyendo hosts existentes NPM =====")
    existing_npm = npm_existing_hosts(npm_headers)
    print(f"[NPM] Hosts existentes: {len(existing_npm)}")

    print()
    print("===== Creando DNS rewrites en AdGuard =====")
    for item in SERVICES:
        adguard_add_rewrite(adg_user, adg_pass, item["domain"], PROXY_IP)

    for domain in DNS_ONLY:
        adguard_add_rewrite(adg_user, adg_pass, domain, PROXY_IP)

    print()
    print("===== Creando Proxy Hosts en NPM =====")
    for item in SERVICES:
        if item["domain"] in existing_npm:
            print(f"[NPM]     SKIP  {item['domain']} ya existe")
            continue
        npm_add_proxy(npm_headers, item)

    print()
    print("===== TERMINADO =====")
    print("Ahora prueba por ejemplo:")
    print("http://adminer.home.arpa")
    print("http://grafana.home.arpa")
    print("http://homarr.home.arpa")
    print("http://nextcloud.home.arpa")

if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/crear-dns-y-proxy.py
```

Ejecutar con `python3 /root/scripts/crear-dns-y-proxy.py`.  
Se solicitarán usuario y contraseña de AdGuard y NPM.

#### 21.8.2 Aplicar SSL a todos los `.home.arpa` (incluyendo correcciones especiales)

```bash
cat > /root/scripts/aplicar-ssl-home-arpa.py <<'PY'
#!/usr/bin/env python3
import json, getpass, urllib.request, urllib.error

NPM_URL = "http://127.0.0.1:81"
CERT_NAME = "home-arpa-local"

ADMIN_DOMAINS = {
    "proxmox.home.arpa",
    "portainer.home.arpa",
    "npm.home.arpa",
    "adguard.home.arpa",
}

BIG_UPLOAD_DOMAINS = {
    "immich.home.arpa",
    "nextcloud.home.arpa",
    "paperless.home.arpa",
}

SPECIAL_ADVANCED = {
    "proxmox.home.arpa": """proxy_ssl_verify off;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;
""",

    "portainer.home.arpa": """proxy_ssl_verify off;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;

proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Proto https;
""",

    "npm.home.arpa": """client_max_body_size 0;
""",

    "adguard.home.arpa": """client_max_body_size 0;
""",
}

BIG_UPLOAD_ADVANCED = """client_max_body_size 0;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
"""

def req(method, path, data=None, token=None):
    body = None
    if data is not None:
        body = json.dumps(data).encode("utf-8")

    r = urllib.request.Request(NPM_URL + path, data=body, method=method)
    r.add_header("Content-Type", "application/json")

    if token:
        r.add_header("Authorization", f"Bearer {token}")

    try:
        with urllib.request.urlopen(r, timeout=30) as resp:
            raw = resp.read().decode("utf-8")
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        raw = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR {method} {path}: HTTP {e.code}\n{raw}")

def main():
    print("===== APLICAR SSL A TODOS LOS *.home.arpa =====")

    email = input("Email NPM: ").strip()
    password = getpass.getpass("Password NPM: ")

    print("\n===== LOGIN NPM =====")
    token = req("POST", "/api/tokens", {
        "identity": email,
        "secret": password
    })["token"]
    print("Login OK")

    print("\n===== BUSCANDO CERTIFICADO =====")
    certs = req("GET", "/api/nginx/certificates", token=token)

    cert_id = None
    for c in certs:
        name = c.get("nice_name") or c.get("name") or ""
        print(f"Certificado ID={c.get('id')} Name={name}")
        if name == CERT_NAME:
            cert_id = c.get("id")

    if not cert_id:
        raise SystemExit(f"ERROR: No encontré el certificado {CERT_NAME}")

    print(f"Usando certificado: {CERT_NAME} ID={cert_id}")

    print("\n===== LEYENDO PROXY HOSTS =====")
    hosts = req("GET", "/api/nginx/proxy-hosts", token=token)

    updated_count = 0
    skipped_count = 0

    for h in hosts:
        domains = h.get("domain_names", [])
        if not domains:
            skipped_count += 1
            continue

        main_domain = domains[0]

        if not any(d.endswith(".home.arpa") for d in domains):
            print(f"SKIP {domains} no es home.arpa")
            skipped_count += 1
            continue

        if main_domain in SPECIAL_ADVANCED:
            advanced = SPECIAL_ADVANCED[main_domain]
        elif main_domain in BIG_UPLOAD_DOMAINS:
            advanced = BIG_UPLOAD_ADVANCED
        else:
            advanced = h.get("advanced_config") or ""

        block_exploits = False if main_domain in ADMIN_DOMAINS else True

        payload = {
            "domain_names": domains,
            "forward_scheme": h.get("forward_scheme"),
            "forward_host": h.get("forward_host"),
            "forward_port": h.get("forward_port"),
            "access_list_id": h.get("access_list_id") or 0,
            "certificate_id": cert_id,
            "ssl_forced": True,
            "caching_enabled": False,
            "block_exploits": block_exploits,
            "allow_websocket_upgrade": True,
            "http2_support": False,
            "hsts_enabled": False,
            "hsts_subdomains": False,
            "advanced_config": advanced,
            "locations": h.get("locations") or [],
            "enabled": True,
            "meta": {
                "letsencrypt_agree": False,
                "dns_challenge": False
            }
        }

        print(f"UPDATE {main_domain} -> SSL ON | Block Exploits: {block_exploits}")
        updated = req("PUT", f"/api/nginx/proxy-hosts/{h['id']}", data=payload, token=token)

        nginx_err = updated.get("meta", {}).get("nginx_err")
        if nginx_err:
            print(f"  AVISO NGINX ERROR en {main_domain}: {nginx_err}")
        else:
            print(f"  OK {main_domain}")

        updated_count += 1

    print("\n===== RESUMEN =====")
    print(f"Actualizados: {updated_count}")
    print(f"Saltados: {skipped_count}")
    print("Terminado.")

if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/aplicar-ssl-home-arpa.py
python3 /root/scripts/aplicar-ssl-home-arpa.py
```

Tras ejecutar, reiniciar NPM:

```bash
docker restart nginx-proxy-manager
sleep 10
docker exec nginx-proxy-manager nginx -t
```

### 21.8.3 Arreglos específicos para apps problemáticas

Se incluyen scripts para Proxmox (`arreglar-proxmox-ssl-minimo.py`), Portainer y Vaultwarden (`arreglar-vault-npm.py`) que aplican la configuración avanzada exacta que necesitan. Se deben ejecutar si después de la aplicación masiva algún servicio sigue fallando. Los contenidos son los mismos que aparecen en el registro, solo recordar sustituir las contraseñas reales por las variables adecuadas.

Para Nextcloud, además, hay que añadir los dominios de confianza y el proxy desde el CT108:

**Ejecutar desde el host PVE (`pve > Shell`):**

```bash
pct exec 108 -- bash -lc '
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 2 --value=10.10.10.65
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 3 --value=192.168.1.82
docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value=192.168.1.82
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.home.arpa
'
```

### 21.9 Actualización de Homarr: dominios bonitos y ping interno

Para que Homarr use las URLs `https://*.home.arpa` al hacer clic, pero siga comprobando salud con las IPs reales, se aplican los siguientes scripts en el CT101.

#### 21.9.1 Cambiar href de las apps a dominios

```bash
pct exec 101 -- bash -lc '
cat > /root/actualizar-homarr-href.py <<'"'"'PY'"'"'
import sqlite3, shutil
from pathlib import Path
from datetime import datetime

db = Path("/opt/stacks/homarr-v1/appdata/db/db.sqlite")

replacements = {
    "http://192.168.1.79:8080": "https://homer.home.arpa",
    "http://10.10.10.50:8090": "https://beszel.home.arpa",
    "http://192.168.1.53": "https://adguard.home.arpa",
    "http://192.168.1.53:80": "https://adguard.home.arpa",
    "http://10.10.10.50:3002": "https://grafana.home.arpa",
    "https://192.168.1.80:9443": "https://portainer.home.arpa",
    "http://10.10.10.50:9090": "https://prometheus.home.arpa",
    "http://192.168.1.81": "https://casaos.home.arpa",
    "http://192.168.1.81:80": "https://casaos.home.arpa",
    "http://10.10.10.50:8085": "https://speedtest.home.arpa",
    "http://192.168.1.79:3000": "https://homepage.home.arpa",
    "http://10.10.10.50:8086": "https://scrutiny.home.arpa",
    "http://192.168.1.81:8384": "https://syncthing.home.arpa",
    "http://192.168.1.79:8081": "https://heimdall.home.arpa",
    "http://192.168.1.81:8200": "https://duplicati.home.arpa",
    "https://192.168.1.200:8006": "https://proxmox.home.arpa",
    "http://10.10.10.50:3001": "https://kuma.home.arpa",
    "http://10.10.10.40:8000/dashboard": "https://paperless.home.arpa/dashboard",
    "http://10.10.10.40:8000": "https://paperless.home.arpa",
    "http://10.10.10.65:8088": "https://nextcloud.home.arpa",
    "http://10.10.10.30:2283": "https://immich.home.arpa",
    "http://10.10.10.70:8080": "https://tools.home.arpa",
    "http://10.10.10.70:8081": "https://pdf.home.arpa",
    "http://10.10.10.73:8080": "https://adminer.home.arpa",
    "http://10.10.10.73:8082": "https://pgadmin.home.arpa",
    "http://10.10.10.73:8083": "https://chartdb.home.arpa",
    "http://192.168.1.82:81": "https://npm.home.arpa",
    "http://10.10.10.60:8080": "https://vault.home.arpa",
}

backup = db.with_name(db.name + ".bak-" + datetime.now().strftime("%Y%m%d-%H%M%S"))
shutil.copy2(db, backup)

print(f"DB: {db}")
print(f"Backup: {backup}")
print()
print("IMPORTANTE: solo se modifica app.href. No se toca app.ping_url.")
print()

con = sqlite3.connect(db)
cur = con.cursor()

rows = cur.execute("SELECT rowid, href FROM app WHERE href IS NOT NULL").fetchall()

changes = 0
for rowid, href in rows:
    if not isinstance(href, str):
        continue

    new_href = href
    for old, new in replacements.items():
        if old in new_href:   # reemplazo seguro
            new_href = new_href.replace(old, new)

    if new_href != href:
        cur.execute("UPDATE app SET href = ? WHERE rowid = ?", (new_href, rowid))
        print(f"UPDATED rowid={rowid}")
        print(f"  OLD: {href}")
        print(f"  NEW: {new_href}")
        changes += 1

con.commit()
con.close()

print()
print(f"Total cambios en app.href: {changes}")
print("Backup creado correctamente.")
PY
docker stop homarr-v1
python3 /root/actualizar-homarr-href.py
docker start homarr-v1
'
```

#### 21.9.2 Corregir ping_url para que apunten a IP:puerto

```bash
pct exec 101 -- bash -lc '
cat > /root/arreglar-homarr-ping-url.py <<'"'"'PY'"'"'
import sqlite3, shutil
from pathlib import Path
from datetime import datetime

db = Path("/opt/stacks/homarr-v1/appdata/db/db.sqlite")

ping_by_href = {
    "https://homer.home.arpa": "http://192.168.1.79:8080",
    "https://beszel.home.arpa": "http://10.10.10.50:8090",
    "https://adguard.home.arpa": "http://192.168.1.53",
    "https://grafana.home.arpa": "http://10.10.10.50:3002",
    "https://portainer.home.arpa": "https://192.168.1.80:9443",
    "https://prometheus.home.arpa": "http://10.10.10.50:9090",
    "https://casaos.home.arpa": "http://192.168.1.81",
    "https://speedtest.home.arpa": "http://10.10.10.50:8085",
    "https://homepage.home.arpa": "http://192.168.1.79:3000",
    "https://scrutiny.home.arpa": "http://10.10.10.50:8086",
    "https://syncthing.home.arpa": "http://192.168.1.81:8384",
    "https://heimdall.home.arpa": "http://192.168.1.79:8081",
    "https://duplicati.home.arpa": "http://192.168.1.81:8200",
    "https://proxmox.home.arpa": "https://192.168.1.200:8006",
    "https://kuma.home.arpa": "http://10.10.10.50:3001",
    "https://paperless.home.arpa": "http://10.10.10.40:8000",
    "https://paperless.home.arpa/dashboard": "http://10.10.10.40:8000/dashboard",
    "https://nextcloud.home.arpa": "http://10.10.10.65:8088",
    "https://immich.home.arpa": "http://10.10.10.30:2283",
    "https://tools.home.arpa": "http://10.10.10.70:8080",
    "https://pdf.home.arpa": "http://10.10.10.70:8081",
    "https://adminer.home.arpa": "http://10.10.10.73:8080",
    "https://pgadmin.home.arpa": "http://10.10.10.73:8082",
    "https://chartdb.home.arpa": "http://10.10.10.73:8083",
    "https://npm.home.arpa": "http://192.168.1.82:81",
    "https://vault.home.arpa": "http://10.10.10.60:8080",
	"https://navidrome.home.arpa": "http://10.10.10.82:4533",
	"https://downloads.home.arpa": "http://10.10.10.83:6595",
}

backup = db.with_name(db.name + ".bak-ping-" + datetime.now().strftime("%Y%m%d-%H%M%S"))
shutil.copy2(db, backup)

print(f"DB: {db}")
print(f"Backup: {backup}")
print()

con = sqlite3.connect(db)
cur = con.cursor()

changes = 0

rows = cur.execute("SELECT rowid, name, href, ping_url FROM app ORDER BY rowid").fetchall()

for rowid, name, href, old_ping in rows:
    if href in ping_by_href:
        new_ping = ping_by_href[href]
        if old_ping != new_ping:
            cur.execute("UPDATE app SET ping_url = ? WHERE rowid = ?", (new_ping, rowid))
            print(f"UPDATED {rowid} - {name}")
            print(f"  href: {href}")
            print(f"  old ping: {old_ping}")
            print(f"  new ping: {new_ping}")
            changes += 1

con.commit()
con.close()

print()
print(f"Total ping_url actualizados: {changes}")
PY
docker stop homarr-v1
python3 /root/arreglar-homarr-ping-url.py
docker start homarr-v1
'
```

Tras ejecutar ambos, Homarr mostrará los nombres bonitos y la comprobación de estado será fiable.

---

## 22. Estado actual resumido

| CT/VM | Nombre       | IP                         | Dominio             | Puerto real  | Estado |     |
| ----- | ------------ | -------------------------- | ------------------- | ------------ | ------ | --- |
| PVE   | Proxmox      | 192.168.1.200              | proxmox.home.arpa   | 8006 (https) | ✅      |     |
| 100   | tailscale-gw | 192.168.1.87 / 10.10.10.87 | —                   | —            | ✅      |     |
| 101   | dashboard    | 192.168.1.79               | homarr.home.arpa    | 7575         | ✅      |     |
| 102   | portainer    | 192.168.1.80               | portainer.home.arpa | 9443 (https) | ✅      |     |
| 103   | dns          | 192.168.1.53               | adguard.home.arpa   | 80           | ✅      |     |
| 104   | casaos-nas   | 192.168.1.81               | casaos.home.arpa    | 80           | ✅      |     |
| 105   | monitoring   | 10.10.10.50                | grafana.home.arpa   | 3002         | ✅      |     |
| 106   | vaultwarden  | 10.10.10.60                | vault.home.arpa     | 8080 (http)  | ✅      |     |
| 107   | paperless    | 10.10.10.40                | paperless.home.arpa | 8000         | ✅      |     |
| 108   | nextcloud    | 10.10.10.65                | nextcloud.home.arpa | 8088         | ✅      |     |
| 109   | immich       | 10.10.10.30                | immich.home.arpa    | 2283         | ✅      |     |
| 110   | tools        | 10.10.10.70                | tools.home.arpa     | 8080         | ✅      |     |
| 111   | databases    | 10.10.10.73                | adminer.home.arpa   | 8080         | ✅      |     |
| 112   | proxy        | 192.168.1.82               | npm.home.arpa       | 81           | ✅      |     |
| 113   | identity     | 10.10.10.74                | auth.home.arpa      | 8080 (http)  | ✅      |     |
| 114   | music        | 10.10.10.82                | navidrome.home.arpa | 4533         | ✅      |     |
| 115   | downloads    | 10.10.10.83                | downloads.home.arpa | 6595         | ✅      |     |
|       |              |                            |                     |              |        |     |
> **Nota:** Todos los servicios internos usan certificado local `home-arpa-local`, y Homarr está configurado con `href` de dominio y `ping_url` con IP:puerto real para comprobaciones de salud.

> **Nota:** El script `subir-backups-gdrive` se ejecuta los domingos a las 05:00 mediante systemd y sincroniza todo el directorio `/mnt/hdd250/backups/dump` de forma cifrada. Al mantener solo 2 backups locales, la subida refleja siempre el estado más actual.

> **Nota:** CT114 y CT115 no guardan la música dentro del backup del CT, porque `/data` se pasa desde VM104 CasaOS/NAS con `backup=0`. La música real vive en `/data/media/music` dentro de VM104.

---

## 23. CT113 – Identity (Keycloak + Google OAuth + SSO)

### 23.1 Crear el CT

- **CT ID:** `113`
- **Hostname:** `identity`
- **Red vmbr10:** IP `10.10.10.74/24`, Gateway `10.10.10.87`
- **Disco:** 24 GB, **CPU:** 2 cores, **RAM:** 2048 MB / Swap: 1024 MB
- **Unprivileged + Nesting**

Comprobar conectividad e instalar Docker (bloque estándar de la sección 5.3).

### 23.2 Instalar Portainer Agent

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps | grep portainer-agent
```

Añadir en Portainer: `CT113-identity` → `tcp://10.10.10.74:9001`.

### 23.3 Preparar contraseñas y stack de Keycloak

Dentro del CT113, generar contraseñas y guardarlas en Vaultwarden:

```bash
mkdir -p /opt/stacks/identity/{postgres,keycloak}
chmod 700 /opt/stacks/identity

KC_DB_PASSWORD="$(openssl rand -hex 24)"
KC_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '\n')"

cat > /opt/stacks/identity/.env <<EOF
KC_DB_PASSWORD=$KC_DB_PASSWORD
KC_ADMIN_USER=guillermo
KC_ADMIN_PASSWORD=$KC_ADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/identity/.env
cp /opt/stacks/identity/.env /root/CT113-identity-passwords.txt
```

Desplegar el stack desde Portainer (CT113-identity, stack `identity`). Usar el siguiente compose, **reemplazando** los valores de `KC_DB_PASSWORD` y `KC_ADMIN_PASSWORD` por los reales:

```yaml
services:
  keycloak-db:
    image: postgres:17-alpine
    container_name: keycloak-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak
      POSTGRES_PASSWORD: CAMBIA_ESTO_POR_KC_DB_PASSWORD
    volumes:
      - /opt/stacks/identity/postgres:/var/lib/postgresql/data

  keycloak:
    image: quay.io/keycloak/keycloak:26.6.1
    container_name: keycloak
    restart: unless-stopped
    depends_on:
      - keycloak-db
    command: start
    ports:
      - "10.10.10.74:8080:8080"
      - "10.10.10.74:9000:9000"
    environment:
      KC_DB: postgres
      KC_DB_URL: jdbc:postgresql://keycloak-db:5432/keycloak
      KC_DB_USERNAME: keycloak
      KC_DB_PASSWORD: CAMBIA_ESTO_POR_KC_DB_PASSWORD

      KC_BOOTSTRAP_ADMIN_USERNAME: guillermo
      KC_BOOTSTRAP_ADMIN_PASSWORD: CAMBIA_ESTO_POR_KC_ADMIN_PASSWORD

      KC_HTTP_ENABLED: "true"
      KC_HOSTNAME: "https://auth.home.arpa"
      KC_PROXY_HEADERS: "xforwarded"
      KC_PROXY_TRUSTED_ADDRESSES: "192.168.1.82"

      KC_HEALTH_ENABLED: "true"
      KC_METRICS_ENABLED: "true"
      KC_LOG_LEVEL: "info"

      JAVA_OPTS_KC_HEAP: "-XX:MaxRAMPercentage=65 -XX:InitialRAMPercentage=40"
    volumes:
      - /opt/stacks/identity/keycloak:/opt/keycloak/data
```

Acceso interno provisional: `http://10.10.10.74:8080`. Usar usuario `guillermo` y la contraseña de `KC_ADMIN_PASSWORD`.

### 23.4 DNS y proxy para `auth.home.arpa`

Asegurar que `auth.home.arpa` apunta a `192.168.1.82` en AdGuard (ya debería estar en la lista de rewrites). En NPM, crear el Proxy Host:

- **Domain:** `auth.home.arpa`
- **Scheme:** `http`
- **Forward IP:** `10.10.10.74`
- **Forward Port:** `8080`
- **Websockets Support:** ON
- **Block Common Exploits:** OFF (para evitar bloqueos de login)
- **SSL:** certificado `home-arpa-local`, Force SSL ON.

En el campo Advanced poner:

```nginx
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header Host $host;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;
```

Reiniciar NPM: `docker restart nginx-proxy-manager`.

Ahora `https://auth.home.arpa` debe mostrar el panel de administración de Keycloak.

### 23.5 Configuración inicial de Keycloak

1. Entrar en `https://auth.home.arpa/admin/` con `guillermo` y su contraseña temporal.
2. Cambiar a **realm `master`** si no está ya.
3. Crear un nuevo realm: `homelab`.
4. Crear el usuario administrador permanente `admin-guillermo` en el realm **master**, sin OTP y con permisos para administrar el realm `homelab`. Este usuario será el que usen los scripts de administración de Keycloak.
5. Borrar el usuario temporal `guillermo`.
6. En el stack de Portainer, eliminar las variables `KC_BOOTSTRAP_ADMIN_USERNAME` y `KC_BOOTSTRAP_ADMIN_PASSWORD`, luego actualizar el stack para que Keycloak las olvide.

### 23.6 Conectar Google como proveedor de identidad

En Google Cloud Console, crear un proyecto y configurar la pantalla de consentimiento OAuth. Crear credenciales OAuth 2.0 de tipo "Aplicación web" con la URI de redirección:

```text
https://auth.home.arpa/realms/homelab/broker/google/endpoint
```

Copiar el **Client ID** y **Client Secret**.

En Keycloak, dentro del realm `homelab`:

1. `Identity providers` → `Add provider` → `Google`.
2. Rellenar: `Client ID`, `Client Secret`, `Default scopes: openid email profile`, `Trust email: ON`, `Enabled: ON`.
3. Guardar.

**Importante:** Al estar en modo "testing", añadir los correos de los usuarios que podrán usar Google como "test users" en la consola de Google.

### 23.7 Crear grupos base

En el realm `homelab`, crear los grupos:

- `homelab-admins`
- `homelab-users`
- `familia`
- `invitados`

Establecer `homelab-users` como grupo por defecto para nuevos usuarios.

### 23.8 Script de fábrica de clientes OIDC (usando `admin-guillermo`)

Este script se ejecuta en **CT113 identity** y crea/actualiza los clientes OIDC de las aplicaciones que usarán SSO. Utiliza el usuario administrador `admin-guillermo` (sin OTP) para autenticarse contra Keycloak.

Antes de ejecutarlo, asegúrate de que el realm `homelab` existe y de que `admin-guillermo` tiene permisos de administración en el realm `master` (para poder usar la API REST).

**El script completo es el siguiente:**

```bash
mkdir -p /root/scripts /root/secrets
cat > /root/scripts/keycloak-oidc-factory.py <<'PY'
#!/usr/bin/env python3
import json, getpass, urllib.parse, urllib.request, urllib.error, time
from pathlib import Path

# ---- CONFIGURACIÓN ----
KEYCLOAK_URL     = "http://10.10.10.74:8080"
KEYCLOAK_PUBLIC  = "https://auth.home.arpa"
REALM            = "homelab"
ADMIN_REALM      = "master"
ADMIN_USERNAME   = "admin-guillermo"

OUTPUT_FILE      = Path("/root/secrets/keycloak-oidc-client-secrets.env")

APPS = [
    {
        "client_id": "grafana",
        "name": "Grafana",
        "root_url": "https://grafana.home.arpa",
        "redirect_uris": [
            "https://grafana.home.arpa/login/generic_oauth"
        ],
        "web_origins": [
            "https://grafana.home.arpa"
        ]
    },
    {
        "client_id": "homarr",
        "name": "Homarr",
        "root_url": "https://homarr.home.arpa",
        "redirect_uris": [
            "https://homarr.home.arpa/api/auth/callback/oidc"
        ],
        "web_origins": [
            "https://homarr.home.arpa"
        ]
    },
    {
        "client_id": "immich",
        "name": "Immich",
        "root_url": "https://immich.home.arpa",
        "redirect_uris": [
            "https://immich.home.arpa/auth/login",
            "https://immich.home.arpa/user-settings",
            "app.immich:///oauth-callback"
        ],
        "web_origins": [
            "https://immich.home.arpa"
        ]
    },
    {
        "client_id": "nextcloud",
        "name": "Nextcloud",
        "root_url": "https://nextcloud.home.arpa",
        "redirect_uris": [
            "https://nextcloud.home.arpa/*"
        ],
        "web_origins": [
            "https://nextcloud.home.arpa"
        ]
    },
    {
        "client_id": "paperless",
        "name": "Paperless",
        "root_url": "https://paperless.home.arpa",
        "redirect_uris": [
            "https://paperless.home.arpa/accounts/oidc/keycloak/login/callback/",
            "https://paperless.home.arpa/*"
        ],
        "web_origins": [
            "https://paperless.home.arpa"
        ]
    },
    {
        "client_id": "portainer",
        "name": "Portainer",
        "root_url": "https://portainer.home.arpa",
        "redirect_uris": [
            "https://portainer.home.arpa/*"
        ],
        "web_origins": [
            "https://portainer.home.arpa"
        ]
    }
]

GROUPS = ["homelab-admins", "homelab-users", "familia", "invitados"]

# ---- FUNCIONES AUXILIARES ----
def http_form(url, form):
    data = urllib.parse.urlencode(form).encode()
    req = urllib.request.Request(url, data=data, headers={"Content-Type": "application/x-www-form-urlencoded"}, method="POST")
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read().decode())

def http_json(method, url, token=None, data=None, expected=(200,201,204)):
    headers = {}
    body = None
    if token:
        headers["Authorization"] = f"Bearer {token}"
    if data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            raw = r.read().decode()
            if not raw:
                return None
            return json.loads(raw)
    except urllib.error.HTTPError as e:
        if e.code in expected:
            return None
        raise

def get_token():
    pwd = getpass.getpass(f"Contraseña de {ADMIN_USERNAME} en realm {ADMIN_REALM}: ")
    res = http_form(
        f"{KEYCLOAK_URL}/realms/{ADMIN_REALM}/protocol/openid-connect/token",
        {"grant_type": "password", "client_id": "admin-cli", "username": ADMIN_USERNAME, "password": pwd}
    )
    return res["access_token"]

def get_group(token, name):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/groups?search={urllib.parse.quote(name)}"
    for g in http_json("GET", url, token=token) or []:
        if g["name"] == name:
            return g
    return None

def ensure_group(token, name):
    g = get_group(token, name)
    if g:
        print(f"Grupo existe: {name}")
        return g
    http_json("POST", f"{KEYCLOAK_URL}/admin/realms/{REALM}/groups", token=token, data={"name": name})
    time.sleep(0.5)
    return get_group(token, name)

def get_client(token, client_id):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients?clientId={client_id}"
    clients = http_json("GET", url, token=token) or []
    return clients[0] if clients else None

def ensure_client(token, app):
    existing = get_client(token, app["client_id"])
    payload = {
        "clientId": app["client_id"],
        "name": app["name"],
        "enabled": True,
        "protocol": "openid-connect",
        "publicClient": False,
        "clientAuthenticatorType": "client-secret",
        "standardFlowEnabled": True,
        "implicitFlowEnabled": False,
        "directAccessGrantsEnabled": False,
        "serviceAccountsEnabled": False,
        "rootUrl": app["root_url"],
        "baseUrl": app["root_url"],
        "redirectUris": app["redirect_uris"],
        "webOrigins": app["web_origins"],
        "attributes": {"pkce.code.challenge.method": "S256", "post.logout.redirect.uris": app["root_url"]+"/*"}
    }
    if existing:
        http_json("PUT", f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{existing['id']}", token=token, data=payload)
        print(f"Client actualizado: {app['client_id']}")
    else:
        http_json("POST", f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients", token=token, data=payload)
        time.sleep(0.5)
        print(f"Client creado: {app['client_id']}")
    return get_client(token, app["client_id"])["id"]

def ensure_group_mapper(token, client_uuid):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{client_uuid}/protocol-mappers/models"
    for m in http_json("GET", url, token=token) or []:
        if m["name"] == "groups":
            print("  Mapper groups ya existe, no se toca")
            return
    payload = {
        "name": "groups",
        "protocol": "openid-connect",
        "protocolMapper": "oidc-group-membership-mapper",
        "config": {
            "full.path": "true",
            "id.token.claim": "true",
            "access.token.claim": "true",
            "userinfo.token.claim": "true",
            "claim.name": "groups"
        }
    }
    http_json("POST", url, token=token, data=payload)
    print("  Mapper groups creado")

def get_secret(token, client_uuid):
    res = http_json("GET", f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{client_uuid}/client-secret", token=token)
    return res["value"]

# ---- PROGRAMA PRINCIPAL ----
print("===== PREFLIGHT =====")
try:
    with urllib.request.urlopen("http://10.10.10.74:9000/health/ready", timeout=20) as r:
        print("Health endpoint OK")
except Exception as e:
    print(f"AVISO: no se pudo comprobar health endpoint: {e}") # descartamos health, usamos el endpoint real
try:
    http_json("GET", f"{KEYCLOAK_URL}/realms/{REALM}/.well-known/openid-configuration")
    print("Realm homelab OK")
except:
    raise SystemExit("ERROR: No se pudo contactar con el realm homelab. Asegúrate de que Keycloak esté funcionando.")

token = get_token()
print("Login OK")

print("\n===== GRUPOS =====")
for gname in GROUPS:
    ensure_group(token, gname)

# Establecer homelab-users como grupo por defecto (opcional, puedes hacerlo manual)
try:
    group_users = get_group(token, "homelab-users")
    http_json("PUT", f"{KEYCLOAK_URL}/admin/realms/{REALM}/default-groups/{group_users['id']}", token=token)
    print("Grupo por defecto: homelab-users")
except:
    print("No se pudo establecer grupo por defecto automáticamente.")

print("\n===== CLIENTES OIDC =====")
output_lines = [
    f"KEYCLOAK_ISSUER={KEYCLOAK_PUBLIC}/realms/{REALM}",
    f"KEYCLOAK_DISCOVERY={KEYCLOAK_PUBLIC}/realms/{REALM}/.well-known/openid-configuration",
    ""
]
for app in APPS:
    uuid = ensure_client(token, app)
    ensure_group_mapper(token, uuid)
    secret = get_secret(token, uuid)
    key = app["client_id"].upper().replace("-", "_")
    output_lines.append(f"{key}_CLIENT_ID={app['client_id']}")
    output_lines.append(f"{key}_CLIENT_SECRET={secret}")
    output_lines.append("")

OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
OUTPUT_FILE.write_text("\n".join(output_lines))
OUTPUT_FILE.chmod(0o600)

print(f"\nSecrets guardados en: {OUTPUT_FILE}")
print("¡No compartas este archivo! Guárdalo en Vaultwarden.")
PY

chmod +x /root/scripts/keycloak-oidc-factory.py
```

Para ejecutarlo:

```
python3 /root/scripts/keycloak-oidc-factory.py
```

Introduce la contraseña de `admin-guillermo` cuando te la pida. Al terminar, tendrás todos los clientes y secretos en `/root/secrets/keycloak-oidc-client-secrets.env`.

### 23.9 Comprobar Keycloak

```bash
curl -s http://10.10.10.74:9000/health/ready
curl -k -I https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
```

Ambos deben devolver éxito.

### 23.10 Añadir a monitorización y backup

- **socket‑proxy** y **cAdvisor** en CT113 (stacks estándar, secciones 21.4.1 y 21.3.1).
- **Prometheus**: añadir target `10.10.10.74:8089`.
- **Homarr remoto**: añadir `10.10.10.74` a `DOCKER_HOSTNAMES` y `2375` a `DOCKER_PORTS` en `homarr-v1`.
- **Uptime Kuma**: monitor HTTP(s) a `https://auth.home.arpa`.
- **Backup Proxmox**: incluir CT 113.
- **Modo noche**: ajustar `KEEP_IDS` si se desea.

---

## 24. Integración SSO en Grafana

Grafana ya estaba configurado con OAuth genérico apuntando a `auth.home.arpa/realms/homelab` (sección 10.4). Con el nuevo client `grafana` creado por la fábrica, se debe actualizar el `GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET` en el `docker-compose.override.yml` con el valor correspondiente del archivo de secretos.

Una vez actualizado, reiniciar Grafana. Para forzar el login directo con Google sin pasar por Keycloak visiblemente, se dejó `GF_AUTH_OAUTH_AUTO_LOGIN: "true"` (opcional). Se mantuvo login local y OAuth como backup.

---

## 25. Integración SSO en Homarr

Homarr (`homarr-v1`, CT101) se configuró para permitir **login local + Google OIDC**, con grupos y boards familiares.

### 25.1 Configuración final de Homarr

Archivo `.env` en `/opt/stacks/homarr-v1`:

```bash
HOMARR_CLIENT_SECRET=<valor de HOMARR_CLIENT_SECRET del archivo de secretos>
```

`docker-compose.yml` resultante (se muestran solo las variables relevantes):

```yaml
services:
  homarr-v1:
    # ... resto igual
    environment:
      - SECRET_ENCRYPTION_KEY=...
      - BASE_URL=https://homarr.home.arpa
      - NEXTAUTH_URL=https://homarr.home.arpa
      - AUTH_PROVIDERS=credentials,oidc
      - AUTH_OIDC_CLIENT_ID=homarr
      - AUTH_OIDC_CLIENT_SECRET=${HOMARR_CLIENT_SECRET}
      - AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab
      - AUTH_OIDC_CLIENT_NAME=Google
      - AUTH_OIDC_SCOPE_OVERWRITE=openid email profile groups
      - AUTH_OIDC_GROUPS_ATTRIBUTE=groups
      - AUTH_OIDC_AUTO_LOGIN=false
      - AUTH_OIDC_FORCE_USERINFO=true
      - AUTH_LOGOUT_REDIRECT_URL=https://homarr.home.arpa
      # ... DOCKER_HOSTNAMES, etc.
```

### 25.2 Sincronización de grupos y boards

Se crearon los grupos `homelab-admins`, `familia` e `invitados` tanto en Keycloak como en Homarr (vía SQL o manual). Los usuarios administradores conservan el board `default`. Los usuarios de `familia` reciben automáticamente un board personal clonado a partir de `familia-base` gracias al **provisioner** (script `homarr-family-provisioner.py` activado por systemd timer).

El board `familia-base` tiene permisos:
- `familia` → View
- `homelab-admins` → Full access

Los boards personales `personal-*` quedan con:
- Usuario dueño → Full access
- `homelab-admins` → Full access

## Apéndice A - homarr-family-provisioner.py

```bash
#!/usr/bin/env python3
import argparse
import datetime
import secrets
import shutil
import sqlite3
import sys
from pathlib import Path

DB = Path("/opt/stacks/homarr-v1/appdata/db/db.sqlite")

TEMPLATE_BOARD_NAME = "familia-base"

FAMILY_GROUP_ID = "familia"
FAMILY_GROUP_NAME = "familia"

ADMIN_GROUP_ID = "homelab-admins"
ADMIN_GROUP_NAME = "homelab-admins"

PERSONAL_PREFIX = "personal-"

AUTO_ADD_OIDC_USERS_TO_FAMILIA = True
SKIP_ADMIN_USERS = True

STRUCTURE_TABLE_ORDER = [
    "layout",
    "section",
    "item",
    "section_layout",
    "item_layout",
]

SKIP_TABLES = {
    "board",
    "boardGroupPermission",
    "boardUserPermission",
    "groupPermission",
    "groupMember",
    "session",
    "verificationToken",
    "account",
    "user",
    "apiKey",
    "__drizzle_migrations",
}


def qi(name):
    return '"' + name.replace('"', '""') + '"'


def new_id():
    return secrets.token_hex(12)


def now():
    return datetime.datetime.now().strftime("%Y%m%d-%H%M%S")


def backup_db():
    backup = DB.with_name(DB.name + f".bak-personal-boards-{now()}")
    shutil.copy2(DB, backup)
    return backup


def q1(cur, sql, params=()):
    return cur.execute(sql, params).fetchone()


def qall(cur, sql, params=()):
    return cur.execute(sql, params).fetchall()


def table_exists(cur, table):
    row = q1(
        cur,
        "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
        (table,),
    )
    return row is not None


def columns(cur, table):
    return [dict(r) for r in cur.execute(f"PRAGMA table_info({qi(table)})").fetchall()]


def column_names(cur, table):
    return [c["name"] for c in columns(cur, table)]


def pk_columns(cur, table):
    cols = columns(cur, table)
    return [c["name"] for c in sorted(cols, key=lambda x: x["pk"]) if c["pk"]]


def insert_row(cur, table, data):
    cols = list(data.keys())
    sql = (
        f"INSERT OR IGNORE INTO {qi(table)} "
        f"({', '.join(qi(c) for c in cols)}) "
        f"VALUES ({', '.join(['?'] * len(cols))})"
    )
    cur.execute(sql, [data[c] for c in cols])


def select_rows(cur, table, conditions):
    if not conditions:
        return []

    parts = []
    params = []

    for sql, p in conditions:
        parts.append(f"({sql})")
        params.extend(p)

    query = f"SELECT * FROM {qi(table)} WHERE " + " OR ".join(parts)
    return [dict(r) for r in cur.execute(query, params).fetchall()]


def in_condition(col, values):
    values = list(values)
    if not values:
        return None
    return f"{qi(col)} IN ({', '.join(['?'] * len(values))})", values


def ensure_group(cur, group_id, name, position):
    row = q1(
        cur,
        'SELECT id FROM "group" WHERE id=? OR name=? LIMIT 1',
        (group_id, name),
    )
    if row:
        return row["id"]

    cur.execute(
        '''
        INSERT INTO "group" (
          id,
          name,
          owner_id,
          home_board_id,
          mobile_home_board_id,
          position
        )
        VALUES (?, ?, NULL, NULL, NULL, ?)
        ''',
        (group_id, name, position),
    )
    return group_id


def ensure_group_member(cur, group_id, user_id):
    cur.execute(
        "INSERT OR IGNORE INTO groupMember (group_id, user_id) VALUES (?, ?)",
        (group_id, user_id),
    )


def ensure_board_group_perm(cur, board_id, group_id, permission):
    cur.execute(
        '''
        INSERT OR IGNORE INTO boardGroupPermission (
          board_id,
          group_id,
          permission
        )
        VALUES (?, ?, ?)
        ''',
        (board_id, group_id, permission),
    )


def ensure_board_user_perm(cur, board_id, user_id, permission):
    cur.execute(
        '''
        INSERT OR IGNORE INTO boardUserPermission (
          board_id,
          user_id,
          permission
        )
        VALUES (?, ?, ?)
        ''',
        (board_id, user_id, permission),
    )


def is_user_in_group(cur, user_id, group_id):
    return q1(
        cur,
        "SELECT 1 FROM groupMember WHERE user_id=? AND group_id=? LIMIT 1",
        (user_id, group_id),
    ) is not None


def user_has_global_admin(cur, user_id):
    return q1(
        cur,
        '''
        SELECT 1
        FROM groupMember gm
        JOIN groupPermission gp ON gp.group_id = gm.group_id
        WHERE gm.user_id = ?
          AND gp.permission = 'admin'
        LIMIT 1
        ''',
        (user_id,),
    ) is not None


def personal_board_name(user):
    email = user["email"] or ""
    name = user["name"] or ""
    base = email.split("@")[0] if email else name if name else user["id"][:8]
    safe = "".join(c.lower() if c.isalnum() else "-" for c in base).strip("-")
    while "--" in safe:
        safe = safe.replace("--", "-")
    return PERSONAL_PREFIX + (safe or user["id"][:8])


def board_by_name(cur, name):
    return q1(cur, "SELECT * FROM board WHERE name=? LIMIT 1", (name,))


def board_exists(cur, board_id):
    return q1(cur, "SELECT 1 FROM board WHERE id=? LIMIT 1", (board_id,)) is not None


def board_has_direct_structure(cur, board_id):
    total = 0
    for table in STRUCTURE_TABLE_ORDER:
        if not table_exists(cur, table):
            continue
        cols = column_names(cur, table)
        if "board_id" in cols:
            total += q1(
                cur,
                f"SELECT COUNT(*) AS c FROM {qi(table)} WHERE board_id=?",
                (board_id,),
            )["c"]
    return total > 0


def remove_personal_board(cur, board_id):
    for table in ["boardUserPermission", "boardGroupPermission"]:
        if table_exists(cur, table):
            cur.execute(f"DELETE FROM {qi(table)} WHERE board_id=?", (board_id,))

    if table_exists(cur, "board"):
        cur.execute("DELETE FROM board WHERE id=?", (board_id,))


def copy_rows(cur, table, rows, source_board_id, dest_board_id, id_map, copied):
    if not rows:
        return 0

    cols = column_names(cur, table)
    pks = pk_columns(cur, table)
    single_id_pk = len(pks) == 1 and pks[0] == "id"

    count = 0

    for row in rows:
        if single_id_pk:
            row_key = (table, row["id"])
        elif pks:
            row_key = (table, tuple(row[p] for p in pks))
        else:
            row_key = (table, tuple((k, row[k]) for k in cols))

        if row_key in copied:
            continue

        new = dict(row)

        if single_id_pk:
            old_id = new["id"]
            new_generated_id = new_id()
            id_map[old_id] = new_generated_id
            new["id"] = new_generated_id

        for col in cols:
            val = new.get(col)

            if val is None:
                continue

            if col == "board_id" and val == source_board_id:
                new[col] = dest_board_id
                continue

            if val in id_map:
                new[col] = id_map[val]

        insert_row(cur, table, new)
        copied.add(row_key)
        count += 1

    return count


def rows_for_table(cur, table, source_board_id, id_map, old_layout_ids, old_section_ids, old_item_ids):
    cols = column_names(cur, table)
    conditions = []

    if "board_id" in cols:
        conditions.append((f"{qi('board_id')}=?", [source_board_id]))

    if "layout_id" in cols and old_layout_ids:
        cond = in_condition("layout_id", old_layout_ids)
        if cond:
            conditions.append(cond)

    if "section_id" in cols and old_section_ids:
        cond = in_condition("section_id", old_section_ids)
        if cond:
            conditions.append(cond)

    if "item_id" in cols and old_item_ids:
        cond = in_condition("item_id", old_item_ids)
        if cond:
            conditions.append(cond)

    return select_rows(cur, table, conditions)


def collect_old_ids_from_rows(rows):
    return {r["id"] for r in rows if "id" in r and r["id"]}



def get_root_user_id(cur):
    row = q1(
        cur,
        "SELECT id FROM user WHERE name='root' AND provider='credentials' LIMIT 1"
    )
    if not row:
        raise RuntimeError("No encuentro el usuario root local de Homarr")
    return row["id"]

def clone_board_from_template(cur, template_board, user):
    source_board_id = template_board["id"]
    new_board_name = personal_board_name(user)

    existing = board_by_name(cur, new_board_name)
    if existing:
        existing_id = existing["id"]
        print(f"  Board personal ya existe: {new_board_name} ({existing_id})")
        return existing_id, new_board_name, False

    dest_board_id = new_id()
    id_map = {
        source_board_id: dest_board_id,
    }
    copied = set()

    board_data = dict(template_board)
    board_data["id"] = dest_board_id
    board_data["name"] = new_board_name
    board_data["is_public"] = 0
    board_data["creator_id"] = get_root_user_id(cur)
    board_data["page_title"] = f"Homarr - {user['name'] or user['email'] or 'usuario'}"

    insert_row(cur, "board", board_data)

    copied_counts = {}

    old_layout_ids = set()
    old_section_ids = set()
    old_item_ids = set()

    if table_exists(cur, "layout"):
        layout_rows = rows_for_table(cur, "layout", source_board_id, id_map, set(), set(), set())
        old_layout_ids = collect_old_ids_from_rows(layout_rows)
        copied_counts["layout"] = copy_rows(cur, "layout", layout_rows, source_board_id, dest_board_id, id_map, copied)

    if table_exists(cur, "section"):
        section_rows = rows_for_table(cur, "section", source_board_id, id_map, old_layout_ids, set(), set())
        old_section_ids = collect_old_ids_from_rows(section_rows)
        copied_counts["section"] = copy_rows(cur, "section", section_rows, source_board_id, dest_board_id, id_map, copied)

    if table_exists(cur, "item_layout"):
        item_layout_probe = rows_for_table(cur, "item_layout", source_board_id, id_map, old_layout_ids, old_section_ids, set())
        for r in item_layout_probe:
            if "item_id" in r and r["item_id"]:
                old_item_ids.add(r["item_id"])

    if table_exists(cur, "item"):
        item_rows = rows_for_table(cur, "item", source_board_id, id_map, old_layout_ids, old_section_ids, old_item_ids)

        if old_item_ids and "id" in column_names(cur, "item"):
            extra = select_rows(
                cur,
                "item",
                [in_condition("id", old_item_ids)],
            )
            existing_keys = {r.get("id") for r in item_rows}
            for r in extra:
                if r.get("id") not in existing_keys:
                    item_rows.append(r)

        old_item_ids.update(collect_old_ids_from_rows(item_rows))
        copied_counts["item"] = copy_rows(cur, "item", item_rows, source_board_id, dest_board_id, id_map, copied)

    for table in ["section_layout", "item_layout"]:
        if not table_exists(cur, table):
            continue
        rows = rows_for_table(cur, table, source_board_id, id_map, old_layout_ids, old_section_ids, old_item_ids)
        copied_counts[table] = copy_rows(cur, table, rows, source_board_id, dest_board_id, id_map, copied)

    print(f"  Clonado {TEMPLATE_BOARD_NAME} -> {new_board_name}")
    for table, count in copied_counts.items():
        print(f"    {table}: {count}")

    return dest_board_id, new_board_name, True


def needs_personal_board(cur, user):
    if SKIP_ADMIN_USERS and user_has_global_admin(cur, user["id"]):
        return False

    personal_name = personal_board_name(user)
    personal = board_by_name(cur, personal_name)

    if not personal:
        return True

    if user["home_board_id"] != personal["id"]:
        return True

    has_full = q1(
        cur,
        '''
        SELECT 1
        FROM boardUserPermission
        WHERE board_id=? AND user_id=? AND permission='full'
        LIMIT 1
        ''',
        (personal["id"], user["id"]),
    ) is not None

    return not has_full


def fix_permissions_and_home(cur, user, board_id):
    user_id = user["id"]

    # El board personal solo tiene:
    # - dueño: full
    # - homelab-admins: full
    cur.execute(
        "DELETE FROM boardUserPermission WHERE board_id=?",
        (board_id,),
    )

    cur.execute(
        "DELETE FROM boardGroupPermission WHERE board_id=?",
        (board_id,),
    )

    ensure_board_user_perm(cur, board_id, user_id, "full")
    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "full")

    cur.execute(
        """
        UPDATE user
        SET home_board_id=?,
            mobile_home_board_id=?
        WHERE id=?
        """,
        (board_id, board_id, user_id),
    )

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    if not DB.exists():
        print(f"ERROR: no existe DB: {DB}")
        sys.exit(1)

    con = sqlite3.connect(DB, timeout=30)
    con.row_factory = sqlite3.Row
    cur = con.cursor()
    cur.execute("PRAGMA busy_timeout=30000;")

    print("===== HOMARR PERSONAL BOARD PROVISIONER =====")
    print(f"DB: {DB}")
    print(f"Modo: {'APPLY' if args.apply else 'DRY-RUN'}")
    print()

    template = board_by_name(cur, TEMPLATE_BOARD_NAME)
    if not template:
        print(f"ERROR: no existe el board plantilla: {TEMPLATE_BOARD_NAME}")
        sys.exit(1)

    print(f"Template encontrado: {TEMPLATE_BOARD_NAME} ({template['id']})")

    users = qall(
        cur,
        "SELECT * FROM user WHERE provider='oidc' ORDER BY name, email",
    )

    pending = []

    print()
    print("Usuarios OIDC:")
    for u in users:
        admin = user_has_global_admin(cur, u["id"])
        in_family = is_user_in_group(cur, u["id"], FAMILY_GROUP_ID)
        needs = needs_personal_board(cur, u)

        print(
            f"- {u['name']} | {u['email']} | "
            f"admin={admin} | familia={in_family} | "
            f"home_board={u['home_board_id']} | needs={needs}"
        )

        if needs:
            pending.append(u)

    if not pending:
        print()
        print("No hay cambios pendientes.")
        con.close()
        return

    if not args.apply:
        print()
        print("DRY-RUN: hay usuarios pendientes. Ejecuta con --apply para aplicar.")
        con.close()
        return

    backup = backup_db()
    print()
    print(f"Backup creado: {backup}")

    try:
        cur.execute("BEGIN TRANSACTION")

        ensure_group(cur, FAMILY_GROUP_ID, FAMILY_GROUP_NAME, 3)
        ensure_group(cur, ADMIN_GROUP_ID, ADMIN_GROUP_NAME, 2)

        cur.execute(
            "DELETE FROM boardGroupPermission WHERE board_id=?",
            (template["id"],),
        )

        ensure_board_group_perm(cur, template["id"], FAMILY_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "full")

        cur.execute(
            '''
            UPDATE "group"
            SET home_board_id=?,
                mobile_home_board_id=?
            WHERE id=? OR name=?
            ''',
            (template["id"], template["id"], FAMILY_GROUP_ID, FAMILY_GROUP_NAME),
        )

        print()
        print("Provisionando:")

        for u in pending:
            user_id = u["id"]
            label = u["name"] or u["email"] or user_id

            if SKIP_ADMIN_USERS and user_has_global_admin(cur, user_id):
                print(f"- SKIP admin: {label}")
                continue

            if AUTO_ADD_OIDC_USERS_TO_FAMILIA:
                ensure_group_member(cur, FAMILY_GROUP_ID, user_id)

            board_id, board_name, created = clone_board_from_template(cur, template, u)
            fix_permissions_and_home(cur, u, board_id)

            print(f"- OK: {label} -> {board_name} ({board_id})")

        con.commit()

    except Exception as e:
        con.rollback()
        print(f"ERROR: rollback aplicado: {e}")
        sys.exit(1)

    finally:
        con.close()

    print()
    print("===== LISTO =====")
    print("Usuarios OIDC no admin tienen board personal clonado y permisos propios.")


if __name__ == "__main__":
    main()
```

### 25.3 Limpieza final

Se eliminaron usuarios de prueba y se dejaron solo `root` (local) y los administradores OIDC. Tras una configuración errónea inicial, se restauró un backup y se aplicaron las correcciones de ACL. El logout de Homarr redirige ahora a `https://auth.home.arpa/realms/homelab/protocol/openid-connect/logout?client_id=homarr&post_logout_redirect_uri=https://homarr.home.arpa`.

Está configurado el `AUTH_LOGOUT_REDIRECT_URL`. Si tras cerrar sesión te quedas en la pantalla de Keycloak, no es grave: la sesión se ha cerrado.

---

## 26. Integración SSO en Immich

### 26.1 Preparación del entorno de Immich

Immich está en la VM109, IP `10.10.10.30`. Se verificó que resolvía `auth.home.arpa` internamente. Para ello:

```bash
# En root@immich
cat > /etc/resolv.conf <<'EOF'
search home.arpa
nameserver 192.168.1.53
nameserver 1.1.1.1
EOF

# Recrear contenedores para que Docker coja el nuevo DNS
cd /opt/stacks/immich
docker compose up -d --force-recreate
```

> Este cambio puede perderse al reiniciar si la VM regenera `resolv.conf`. Si ocurre, configura el DNS de forma permanente en `/etc/network/interfaces` o en el gestor de red.

### 26.2 Configuración OAuth en Immich

Con el client `immich` ya creado en Keycloak (secret en `/root/secrets/keycloak-oidc-client-secrets.env`), en la interfaz de Immich → Administration → OAuth Authentication:

- **Enabled:** ON
- **Issuer URL:** `https://auth.home.arpa/realms/homelab`
- **Client ID:** `immich`
- **Client Secret:** (el valor de `IMMICH_CLIENT_SECRET`)
- **Scope:** `openid email profile`
- **Signing Algorithm:** RS256
- **Storage Label Claim:** `preferred_username`
- **Role Claim:** `immich_role` (opcional, si se desea asignar roles por claim)
- **Button Text:** `Login with Google`
- **Auto Register:** ON
- **Auto Launch:** OFF (inicialmente)

### 26.3 Solución al problema del certificado autofirmado

Como Immich no acepta el certificado local de `home-arpa`, se añadió la variable de entorno `NODE_TLS_REJECT_UNAUTHORIZED=0` al contenedor `immich-server`. Esto se hizo editando el `docker-compose.yml`:

```bash
cd /opt/stacks/immich
cp docker-compose.yml docker-compose.yml.bak.oauth-tls

python3 - <<'PY'
from pathlib import Path
p = Path("docker-compose.yml")
text = p.read_text()
line = "      - NODE_TLS_REJECT_UNAUTHORIZED=0"
if line not in text:
    text = text.replace(
        "    env_file:\n      - .env\n",
        "    env_file:\n      - .env\n    environment:\n" + line + "\n",
        1
    )
    p.write_text(text)
    print("NODE_TLS_REJECT_UNAUTHORIZED añadido.")
else:
    print("Ya estaba presente.")
PY

docker compose up -d --force-recreate immich-server
```

Alternativamente, se puede montar el certificado CA y usar `NODE_EXTRA_CA_CERTS`. Pero para simplificar, esta solución es suficiente en un entorno de laboratorio.

### 26.4 Prueba y logout

Tras guardar la configuración, desde un navegador nuevo, abrir `https://immich.home.arpa`. Debería aparecer el botón "Login with Google", que redirige a Keycloak/Google y completa el inicio de sesión.

El logout desde Immich actualmente solo cierra la sesión en Immich y Keycloak, quedando en la página de "You are logged out" de Keycloak. No es grave, ya que la sesión se ha cerrado. Se puede mejorar más adelante.

### 26.5 Backup final

```bash
# En PVE
qm snapshot 109 immich-sso-ok-$(date +%F-%H%M)

# En root@immich
cd /opt/stacks/immich
BACKUP_DIR="/opt/backups/immich/sso-ok-$(date +%F-%H%M)"
mkdir -p "$BACKUP_DIR"
cp docker-compose.yml "$BACKUP_DIR/"
cp .env "$BACKUP_DIR/"
docker exec immich-postgres pg_dumpall -U postgres > "$BACKUP_DIR/immich-postgres-dump.sql"
```

## 27. Notas finales sobre SSO

- `auth.home.arpa` apunta al proxy `192.168.1.82` y redirige a Keycloak en `10.10.10.74:8080`.
- Homarr permite login local (`root`) y login Google/OIDC.
- Grafana usa SSO con Keycloak.
- Immich usa OAuth con Keycloak/Google.
- El logout de Immich puede quedarse momentáneamente en la pantalla de Keycloak, pero la sesión se cierra correctamente.
- Vaultwarden queda fuera del SSO por ahora (por seguridad).


## 28. CT114 - Music / Navidrome

El servicio de música se separa en un contenedor propio para mantener la arquitectura limpia. La música no se guarda dentro del CT, sino en la VM104 CasaOS/NAS, dentro de `/data/media/music`. Proxmox monta esa carpeta por NFS en `/mnt/casaos-data` y después se la pasa al CT114 como `/data`.

```text
VM104 CasaOS/NAS
└── /data/media/music

PVE host
└── /mnt/casaos-data/media/music

CT114 music
└── /data/media/music

Navidrome container
└── /music
```

El CT120 queda descartado. El contenedor definitivo es:

```text
CT114 music - 10.10.10.82
```

### 28.1 Activar NFS en VM104 CasaOS/NAS

Entrar por SSH a la VM104:

```powershell
ssh guillermo@192.168.1.81
```

Comprobar si NFS ya está instalado:

```bash
dpkg -l | grep nfs-kernel-server || echo "NFS server NO instalado"
systemctl status nfs-server --no-pager || true
exportfs -v || true
```

Si no está instalado:

```bash
sudo apt update
sudo apt install -y nfs-kernel-server
```

Crear las carpetas de música:

```bash
sudo mkdir -p /data/media/music
sudo mkdir -p /data/downloads/music

sudo chown -R guillermo:guillermo /data/media/music /data/downloads/music
sudo chmod -R 775 /data/media/music /data/downloads/music
```

Exportar `/data` solo hacia el host Proxmox:

```bash
sudo cp /etc/exports /etc/exports.bak.$(date +%F-%H%M)

cat <<'EOF' | sudo tee /etc/exports
/data 192.168.1.200(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
EOF

sudo exportfs -ra
sudo systemctl enable --now nfs-server
sudo exportfs -v
```

Resultado esperado:

```text
/data 192.168.1.200(...)
```

### 28.2 Montar NFS de CasaOS en Proxmox

En `pve > Shell`:

```bash
apt update
apt install -y nfs-common

mkdir -p /mnt/casaos-data
mount -t nfs4 192.168.1.81:/data /mnt/casaos-data
```

Comprobar:

```bash
ls -la /mnt/casaos-data
ls -la /mnt/casaos-data/media
ls -la /mnt/casaos-data/media/music
```

Prueba de escritura desde Proxmox:

```bash
touch /mnt/casaos-data/media/music/test-desde-pve.txt
ls -la /mnt/casaos-data/media/music/test-desde-pve.txt
```

En VM104 debe aparecer:

```bash
ls -la /data/media/music/test-desde-pve.txt
```

Hacer el montaje permanente en Proxmox:

```bash
grep -q "192.168.1.81:/data /mnt/casaos-data" /etc/fstab || cat >> /etc/fstab <<'EOF'
192.168.1.81:/data /mnt/casaos-data nfs4 rw,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60 0 0
EOF

systemctl daemon-reload
mount -a
findmnt /mnt/casaos-data
```

### 28.3 Crear CT114 music

Crear en Proxmox:

```text
CT ID: 114
Hostname: music
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Plantilla: debian-13-standard
Disco: 8 GB o 12 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.82/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Comprobar red dentro del CT:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 28.4 Pasar `/data` al CT114

En `pve > Shell`:

```bash
pct shutdown 114 --timeout 60 || pct stop 114

pct set 114 -mp0 /mnt/casaos-data,mp=/data,backup=0

pct start 114
```

Comprobar dentro del CT114:

```bash
ls -la /data
ls -la /data/media
ls -la /data/media/music

touch /data/media/music/test-desde-ct114.txt
ls -la /data/media/music/test-desde-ct114.txt
```

Comprobar en VM104:

```bash
ls -la /data/media/music/test-desde-ct114.txt
```

Resultado final esperado:

```text
VM104: /data/media/music
PVE:   /mnt/casaos-data/media/music
CT114: /data/media/music
```

Si dentro del CT aparece `nobody:nogroup`, es normal por ser un CT unprivileged con NFS y `all_squash`. Lo importante es que en VM104 aparezca como `guillermo:guillermo`.

### 28.5 Instalar Docker en CT114

Dentro del CT114:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

cat > /etc/apt/sources.list.d/docker.sources <<'EOF'
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.gpg
EOF

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

docker version
docker compose version
systemctl status docker --no-pager
```

### 28.6 Instalar Navidrome

Dentro del CT114:

```bash
mkdir -p /opt/stacks/navidrome
cd /opt/stacks/navidrome

cat > docker-compose.yml <<'EOF'
services:
  navidrome:
    image: deluan/navidrome:latest
    container_name: navidrome
    restart: unless-stopped
    ports:
      - "4533:4533"
    environment:
      - ND_SCANSCHEDULE=1h
      - ND_LOGLEVEL=info
      - ND_SESSIONTIMEOUT=24h
      - ND_ENABLESHARING=true
    volumes:
      - /opt/stacks/navidrome/data:/data
      - /data/media/music:/music:ro
EOF

docker compose up -d
docker ps
docker logs navidrome --tail=50
```

Acceso directo:

```text
http://10.10.10.82:4533
```

Desde Windows se mete música en:

```text
\\192.168.1.81\data\media\music
```

Navidrome la verá dentro del contenedor como:

```text
/music
```

### 28.7 Portainer Agent en CT114

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps | grep portainer-agent
```

En Portainer:

```text
Name: CT114-music
Environment URL: tcp://10.10.10.82:9001
Tipo: Agent
```

### 28.8 cAdvisor en CT114

```bash
mkdir -p /opt/stacks/cadvisor
cd /opt/stacks/cadvisor

cat > docker-compose.yml <<'EOF'
services:
  cadvisor:
    image: ghcr.io/google/cadvisor:0.56.2
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8089:8080"
    command:
      - --docker_only=true
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

docker compose up -d
curl -s http://127.0.0.1:8089/metrics | head
```

### 28.9 socket-proxy en CT114

```bash
mkdir -p /opt/stacks/socket-proxy
cd /opt/stacks/socket-proxy

cat > docker-compose.yml <<'EOF'
services:
  socket-proxy:
    image: lscr.io/linuxserver/socket-proxy:latest
    container_name: socket-proxy
    restart: unless-stopped
    read_only: true
    tmpfs:
      - /run
    ports:
      - "10.10.10.82:2375:2375"
    environment:
      - CONTAINERS=1
      - IMAGES=1
      - INFO=1
      - PING=1
      - VERSION=1
      - ALLOW_START=1
      - ALLOW_STOP=1
      - ALLOW_RESTARTS=1
      - POST=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

docker compose up -d
curl -s http://10.10.10.82:2375/version | head
```

### 28.10 DNS rewrite y proxy HTTPS para Navidrome

En AdGuard:

```text
Domain:
navidrome.home.arpa

Answer/IP:
192.168.1.82
```

Comprobar:

```bash
nslookup navidrome.home.arpa 192.168.1.53
```

Debe responder:

```text
192.168.1.82
```

En Nginx Proxy Manager:

```text
Domain Names: navidrome.home.arpa
Scheme: http
Forward Hostname / IP: 10.10.10.82
Forward Port: 4533
Access List: Publicly Accessible
Block Common Exploits: ON
Websockets Support: ON
SSL Certificate: home-arpa-local
Force SSL: ON
HTTP/2 Support: ON
HSTS: OFF
```

Acceso final:

```text
https://navidrome.home.arpa
```

### 28.11 Añadir CT114 a Prometheus, Homarr, Kuma y backups

En Prometheus, dentro del job `cadvisor`, añadir:

```yaml
      - targets:
          - "10.10.10.82:8089"
        labels:
          host: "CT114-music"
```

Reiniciar Prometheus:

```bash
pct enter 105
cd /opt/stacks/monitoring
docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
```

En Homarr, añadir app:

```text
Nombre: Navidrome
URL: https://navidrome.home.arpa
Health check: HTTP
Health check URL: http://10.10.10.82:4533
```

En Homarr Docker widget, añadir CT114 al `DOCKER_HOSTNAMES`:

```text
10.10.10.82
```

Y otro puerto en `DOCKER_PORTS`:

```text
2375
```

En Uptime Kuma:

```text
Tipo: HTTP(s)
Nombre: Navidrome
URL: https://navidrome.home.arpa
```

Si falla por certificado local:

```text
URL alternativa: http://10.10.10.82:4533
```

En backups Proxmox, añadir CT114 a la tarea diaria:

```text
Datacenter > Backup > tarea diaria > Edit > añadir 114
```

Importante:

```text
/data va con backup=0, por lo que la música no se guarda dentro del backup del CT114.
La música vive realmente en VM104 CasaOS/NAS.
```

---

## 29. CT115 - Downloads / Descargas de música hacia Navidrome

El CT115 se crea para separar las descargas musicales del servidor Navidrome. La idea es que cualquier herramienta de descarga guarde directamente en `/data/media/music`, que es la misma ruta que lee Navidrome desde CT114.

Uso previsto:

```text
CT115 downloads - 10.10.10.83
└── Descargas musicales permitidas/legalmente disponibles
    └── /data/media/music

CT114 music - 10.10.10.82
└── Navidrome lee:
    └── /data/media/music
```

> Nota: este CT debe usarse solo con música propia, libre o con permiso. No se documentan tokens reales ni credenciales externas.

### 29.1 Crear CT115 downloads

En Proxmox:

```text
CT ID: 115
Hostname: downloads
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Plantilla: debian-13-standard
Disco: 12 GB
CPU: 2 cores
RAM: 2048 MB
Swap: 1024 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.83/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Comprobar red:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 29.2 Pasar `/data` al CT115

En `pve > Shell`:

```bash
pct shutdown 115 --timeout 60 || pct stop 115

pct set 115 -mp0 /mnt/casaos-data,mp=/data,backup=0

pct start 115
```

Comprobar dentro del CT115:

```bash
ls -la /data
ls -la /data/media/music

touch /data/media/music/test-desde-ct115.txt
ls -la /data/media/music/test-desde-ct115.txt
```

Comprobar en VM104:

```bash
ls -la /data/media/music/test-desde-ct115.txt
```

### 29.3 Instalar Docker en CT115

Dentro del CT115:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git

install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

chmod a+r /etc/apt/keyrings/docker.gpg

cat > /etc/apt/sources.list.d/docker.sources <<'EOF'
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.gpg
EOF

apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

systemctl enable --now docker

docker version
docker compose version
```

### 29.4 Stack de descargas musicales

Crear el stack:

```bash
mkdir -p /opt/stacks/music-downloader/config
cd /opt/stacks/music-downloader
```

Compose:

```bash
cat > docker-compose.yml <<'EOF'
services:
  music-downloader:
    image: registry.gitlab.com/bockiii/deemix-docker:latest
    container_name: music-downloader
    restart: unless-stopped
    ports:
      - "6595:6595"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
    volumes:
      - /opt/stacks/music-downloader/config:/config
      - /data/media/music:/downloads
EOF

docker compose up -d
docker ps
```

Acceso directo:

```text
http://10.10.10.83:6595
```

La ruta de descarga dentro de la aplicación debe quedar en:

```text
/downloads
```

Esa ruta equivale realmente a:

```text
/data/media/music
```

Por tanto, Navidrome verá automáticamente la música desde CT114.

### 29.5 Portainer Agent en CT115

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent

cat > docker-compose.yml <<'EOF'
services:
  portainer-agent:
    image: portainer/agent:latest
    container_name: portainer-agent
    restart: unless-stopped
    ports:
      - "9001:9001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /var/lib/docker/volumes:/var/lib/docker/volumes
EOF

docker compose up -d
docker ps | grep portainer-agent
```

En Portainer:

```text
Name: CT115-downloads
Environment URL: tcp://10.10.10.83:9001
Tipo: Agent
```

### 29.6 cAdvisor en CT115

```bash
mkdir -p /opt/stacks/cadvisor
cd /opt/stacks/cadvisor

cat > docker-compose.yml <<'EOF'
services:
  cadvisor:
    image: ghcr.io/google/cadvisor:0.56.2
    container_name: cadvisor
    restart: unless-stopped
    ports:
      - "8089:8080"
    command:
      - --docker_only=true
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:rw
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

docker compose up -d
curl -s http://127.0.0.1:8089/metrics | head
```

En Prometheus, dentro del job `cadvisor`, añadir:

```yaml
      - targets:
          - "10.10.10.83:8089"
        labels:
          host: "CT115-downloads"
```

### 29.7 socket-proxy en CT115

```bash
mkdir -p /opt/stacks/socket-proxy
cd /opt/stacks/socket-proxy

cat > docker-compose.yml <<'EOF'
services:
  socket-proxy:
    image: lscr.io/linuxserver/socket-proxy:latest
    container_name: socket-proxy
    restart: unless-stopped
    read_only: true
    tmpfs:
      - /run
    ports:
      - "10.10.10.83:2375:2375"
    environment:
      - CONTAINERS=1
      - IMAGES=1
      - INFO=1
      - PING=1
      - VERSION=1
      - ALLOW_START=1
      - ALLOW_STOP=1
      - ALLOW_RESTARTS=1
      - POST=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

docker compose up -d
curl -s http://10.10.10.83:2375/version | head
```

En Homarr Docker widget, añadir:

```text
DOCKER_HOSTNAMES: añadir 10.10.10.83
DOCKER_PORTS: añadir otro 2375
```

### 29.8 DNS/proxy opcional para CT115

Si se quiere acceso bonito por dominio:

En AdGuard:

```text
Domain:
downloads.home.arpa

Answer/IP:
192.168.1.82
```

En Nginx Proxy Manager:

```text
Domain Names: downloads.home.arpa
Scheme: http
Forward Hostname / IP: 10.10.10.83
Forward Port: 6595
Block Common Exploits: ON
Websockets Support: ON
SSL Certificate: home-arpa-local
Force SSL: ON
```

Acceso final:

```text
https://downloads.home.arpa
```

### 29.9 Añadir CT115 a Uptime Kuma y backups

En Uptime Kuma:

```text
Tipo: HTTP(s)
Nombre: Downloads
URL: http://10.10.10.83:6595
```

En backups Proxmox, añadir CT115:

```text
Datacenter > Backup > tarea diaria > Edit > añadir 115
```

Importante:

```text
/data va con backup=0.
El backup del CT115 guarda el sistema y la configuración, no la música.
```

---

## 30. Autoarranque crítico de CT100 Tailscale

Para no perder acceso por VPN después de reiniciar el servidor, el CT100 debe arrancar automáticamente antes que el resto de servicios.

En `pve > Shell`:

```bash
pct set 100 --onboot 1
pct set 100 --startup order=1,up=30

systemctl enable pve-guests.service

pct config 100 | grep -E "onboot|startup"
systemctl is-enabled pve-guests.service
```

Resultado esperado:

```text
onboot: 1
startup: order=1,up=30
enabled
```

Esto asegura que, al encender Proxmox, arranque primero el gateway Tailscale:

```text
CT100 tailscale-gw
├── VPN Tailscale
├── Subnet router
├── Exit node
└── Gateway 10.10.10.87
```

Así se mantiene el acceso remoto al homelab incluso tras reinicio.

---

## 31. Beszel Agents en CT101, CT105, CT114 y CT115

Beszel Hub se mantiene en CT105 monitoring:

```text
Beszel Hub:
http://10.10.10.50:8090
```

Los agentes deben desplegarse en cada entorno correcto. No se debe meter el agente de un CT dentro de otro.

```text
CT101-dashboard  → stack beszel-agent en CT101
CT105-monitoring → stack beszel-agent en CT105
CT114-music      → stack beszel-agent en CT114
CT115-downloads  → stack beszel-agent en CT115
```

### 31.1 Limpiar agentes Beszel mal creados

Desde `pve > Shell`, comprobar:

```bash
for id in 101 105 114 115; do
  echo "================ CT $id ================"
  pct exec $id -- bash -lc '
    echo "HOST: $(hostname)"
    docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -i beszel || echo "No hay contenedores Beszel"
    echo
    find /opt/stacks -maxdepth 2 -iname "*beszel*" 2>/dev/null || true
  ' 2>/dev/null || echo "CT $id no existe o no está arrancado"
  echo
done
```

Borrar solo los agentes incorrectos:

```bash
for id in 101 105 114 115; do
  echo "================ LIMPIANDO CT $id ================"
  pct exec $id -- bash -lc '
    echo "Parando y borrando contenedor beszel-agent..."
    docker rm -f beszel-agent 2>/dev/null || true

    echo "Borrando stack antiguo si existe..."
    rm -rf /opt/stacks/beszel-agent
    rm -rf /opt/stacks/beszel-agent-old
    rm -rf /opt/stacks/beszel-agent-bak

    echo "Estado Beszel restante:"
    docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -i beszel || echo "No queda Beszel agent"
  ' 2>/dev/null || echo "CT $id no existe o no está arrancado"
  echo
done
```

En CT105 esto no borra Beszel Hub, solo el contenedor `beszel-agent`.

Comprobar CT105:

```bash
pct exec 105 -- bash -lc 'docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -i beszel'
```

Debe quedar algo tipo:

```text
beszel       henrygd/beszel       Up...
```

### 31.2 Forma recomendada: generar agente desde Beszel

Entrar en Beszel:

```text
http://10.10.10.50:8090
```

Ir a:

```text
Beszel > + Agregar Sistema
```

Crear cada sistema:

```text
CT101-dashboard
CT105-monitoring
CT114-music
CT115-downloads
```

Beszel generará un compose para cada agente. Ese compose se debe pegar en Portainer como stack nuevo en el environment correcto.

### 31.3 Compose fallback de Beszel Agent

Si el compose generado falla o ya existía un agente creado por consola, borrar primero:

```bash
docker rm -f beszel-agent
```

Después crear stack `beszel-agent` en Portainer con este compose, cambiando los placeholders por los valores reales que dé Beszel:

```yaml
services:
  beszel-agent:
    image: henrygd/beszel-agent:latest
    container_name: beszel-agent
    restart: unless-stopped
    network_mode: host
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - beszel_agent_data:/var/lib/beszel-agent
    environment:
      LISTEN: 45876
      KEY: 'PEGA_AQUI_LA_KEY_DE_BESZEL'
      TOKEN: 'PEGA_AQUI_EL_TOKEN_DE_BESZEL'
      HUB_URL: http://10.10.10.50:8090

volumes:
  beszel_agent_data:
```

### 31.4 Verificación de agentes Beszel

Desde `pve > Shell`:

```bash
for id in 101 105 114 115; do
  echo "================ CT $id ================"
  pct exec $id -- bash -lc '
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -i beszel || echo "Beszel agent no encontrado"
  ' 2>/dev/null || echo "CT $id no existe o no está arrancado"
  echo
done
```

En la interfaz de Beszel deben quedar en verde:

```text
CT101-dashboard
CT105-monitoring
CT114-music
CT115-downloads
```

> [!WARNING] Seguridad
> No pegar claves reales de Beszel en la guía ni en GitHub.  
> Los valores `KEY` y `TOKEN` deben quedar como placeholders y copiarse desde la interfaz de Beszel en cada instalación real.


---

## 32. Estado actualizado tras añadir Music y Downloads

```text
CT114 music - 10.10.10.82
├── Navidrome
│   ├── Directo: http://10.10.10.82:4533
│   └── Dominio: https://navidrome.home.arpa
├── /data montado desde VM104 CasaOS
│   └── /data/media/music
├── Portainer Agent
│   └── tcp://10.10.10.82:9001
├── cAdvisor
│   └── http://10.10.10.82:8089
├── socket-proxy
│   └── tcp://10.10.10.82:2375
├── Beszel Agent
│   └── http://10.10.10.50:8090
├── Prometheus/Grafana
│   └── CT114-music UP
├── Homarr
│   └── app + Docker containers
├── Uptime Kuma
│   └── monitor Navidrome
└── Backup Proxmox
    └── CT114 incluido, /data excluido
```

```text
CT115 downloads - 10.10.10.83
├── Music downloader
│   ├── Directo: http://10.10.10.83:6595
│   └── Opcional: https://downloads.home.arpa
├── /data montado desde VM104 CasaOS
│   └── /data/media/music
├── Portainer Agent
│   └── tcp://10.10.10.83:9001
├── cAdvisor
│   └── http://10.10.10.83:8089
├── socket-proxy
│   └── tcp://10.10.10.83:2375
├── Beszel Agent
│   └── http://10.10.10.50:8090
├── Homarr
│   └── app + Docker containers
├── Uptime Kuma
│   └── monitor downloads
└── Backup Proxmox
    └── CT115 incluido, /data excluido
```

La lista de backups Proxmox queda actualizada:

```text
100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115
```



## 2. Añadirlo a tu guía 3.0

Apunta esto como estado final:

```
Nextcloud SSO:Proveedor: Keycloak / GoogleClient ID: nextcloudDiscovery endpoint: https://auth.home.arpa/realms/homelab/.well-known/openid-configurationCallback: https://nextcloud.home.arpa/apps/user_oidc/codeScope: openid email profileUID mapping: subCertificado local: importado/permitido en NextcloudEstado: funcionando
```



