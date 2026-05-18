PROXMOX PVE - 192.168.1.200
│
├── HOST / SISTEMA BASE
│   │
│   ├── Proxmox Web UI
│   │   ├── Directo: https://192.168.1.200:8006
│   │   └── Dominio: https://proxmox.home.arpa
│   │
│   ├── Repositorios Proxmox corregidos
│   │   ├── Enterprise desactivado
│   │   └── No-subscription activado
│   │
│   ├── Configuración portátil
│   │   ├── Cierre de tapa ignorado
│   │   ├── Modo turbo
│   │   └── Modo noche total
│   │
│   ├── HDD 250 GB backups Proxmox
│   │   ├── Disco físico: /dev/sda
│   │   ├── Modelo: WDC_WD2500BEVS
│   │   ├── Montaje: /mnt/hdd250
│   │   ├── Storage Proxmox: hdd250-backups
│   │   └── Ruta backups: /mnt/hdd250/backups/dump
│   │
│   ├── Backups Proxmox diarios
│   │   ├── Horario: 22:30
│   │   ├── Retención: keep-last 2
│   │   ├── Modo: snapshot
│   │   ├── Compresión: ZSTD
│   │   └── Incluye: CT/VM 100-113
│   │
│   ├── Backup externo cifrado
│   │   ├── Herramienta: rclone
│   │   ├── Destino: Google Drive cifrado
│   │   ├── Remote: gdrive-crypt
│   │   └── Subida programada: domingos 05:00
│   │
│   └── SMART / Scrutiny collector
│       ├── smartmontools en PVE
│       ├── Collector systemd
│       └── Web Scrutiny en CT105
│
├── LAN / VISIBLE DESDE CASA - 192.168.1.0/24
│   │
│   ├── CT 100 tailscale-gw - 192.168.1.87 / 10.10.10.87
│   │   ├── Tailscale
│   │   ├── Subnet Router
│   │   │   ├── 192.168.1.0/24
│   │   │   └── 10.10.10.0/24
│   │   ├── Exit Node
│   │   ├── SSH por Tailscale
│   │   └── Gateway/NAT para red privada 10.10.10.0/24
│   │
│   ├── CT 101 dashboard - 192.168.1.79
│   │   ├── Homepage
│   │   │   ├── Directo: http://192.168.1.79:3000
│   │   │   └── Dominio: https://homepage.home.arpa
│   │   ├── Homarr v1
│   │   │   ├── Directo: http://192.168.1.79:7575
│   │   │   └── Dominio: https://homarr.home.arpa
│   │   ├── Homer
│   │   │   ├── Directo: http://192.168.1.79:8080
│   │   │   └── Dominio: https://homer.home.arpa
│   │   ├── Heimdall
│   │   │   ├── Directo: http://192.168.1.79:8081
│   │   │   └── Dominio: https://heimdall.home.arpa
│   │   ├── Portainer Agent
│   │   │   └── tcp://192.168.1.79:9001
│   │   ├── cAdvisor
│   │   │   └── http://192.168.1.79:8089
│   │   ├── socket-proxy
│   │   │   └── tcp://192.168.1.79:2375
│   │   └── Ruta estática a 10.10.10.0/24 vía 192.168.1.87
│   │
│   ├── CT 102 portainer - 192.168.1.80
│   │   ├── Portainer CE
│   │   │   ├── Directo: https://192.168.1.80:9443
│   │   │   └── Dominio: https://portainer.home.arpa
│   │   ├── Portainer Agents conectados
│   │   │   ├── CT101 dashboard
│   │   │   ├── VM104 casaos-nas
│   │   │   ├── CT105 monitoring
│   │   │   ├── CT106 vaultwarden
│   │   │   ├── CT107 paperless
│   │   │   ├── CT108 nextcloud
│   │   │   ├── VM109 immich
│   │   │   ├── CT110 tools
│   │   │   ├── CT111 databases
│   │   │   ├── CT112 proxy
│   │   │   └── CT113 identity
│   │   ├── cAdvisor
│   │   ├── socket-proxy
│   │   └── Ruta estática a 10.10.10.0/24 vía 192.168.1.87
│   │
│   ├── CT 103 dns - 192.168.1.53
│   │   ├── AdGuard Home
│   │   │   ├── Directo: http://192.168.1.53
│   │   │   └── Dominio: https://adguard.home.arpa
│   │   ├── DNS para LAN/VPN/Tailscale
│   │   ├── DNS rewrites *.home.arpa
│   │   └── Pi-hole pendiente/opcional
│   │
│   ├── VM 104 casaos-nas - 192.168.1.81
│   │   ├── CasaOS
│   │   │   ├── Directo: http://192.168.1.81
│   │   │   └── Dominio: https://casaos.home.arpa
│   │   ├── Samba
│   │   │   └── \\192.168.1.81\data
│   │   ├── Syncthing
│   │   │   ├── Directo: http://192.168.1.81:8384
│   │   │   └── Dominio: https://syncthing.home.arpa
│   │   ├── Duplicati
│   │   │   ├── Directo: http://192.168.1.81:8200
│   │   │   └── Dominio: https://duplicati.home.arpa
│   │   ├── Portainer Agent
│   │   │   └── tcp://192.168.1.81:9001
│   │   ├── cAdvisor
│   │   ├── socket-proxy
│   │   └── Datos
│   │       ├── /data/backups
│   │       ├── /data/documents
│   │       ├── /data/downloads
│   │       ├── /data/media
│   │       ├── /data/obsidian
│   │       ├── /data/shared
│   │       └── /data/sync
│   │
│   └── CT 112 proxy - 192.168.1.82
│       ├── Nginx Proxy Manager
│       │   ├── Directo: http://192.168.1.82:81
│       │   └── Dominio: https://npm.home.arpa
│       ├── HTTP: 80
│       ├── HTTPS: 443
│       ├── Certificado local: home-arpa-local
│       ├── Proxy Hosts para servicios *.home.arpa
│       ├── Ruta estática a 10.10.10.0/24 vía 192.168.1.87
│       ├── Portainer Agent
│       │   └── tcp://192.168.1.82:9001
│       ├── cAdvisor
│       └── socket-proxy
│
├── PRIVADO / SOLO TAILSCALE + PROXY INTERNO - 10.10.10.0/24
│   │
│   ├── CT 105 monitoring - 10.10.10.50
│   │   ├── Gateway: 10.10.10.87
│   │   ├── Uptime Kuma
│   │   │   ├── Directo: http://10.10.10.50:3001
│   │   │   └── Dominio: https://kuma.home.arpa
│   │   ├── Beszel
│   │   │   ├── Directo: http://10.10.10.50:8090
│   │   │   └── Dominio: https://beszel.home.arpa
│   │   ├── Grafana
│   │   │   ├── Directo: http://10.10.10.50:3002
│   │   │   └── Dominio: https://grafana.home.arpa
│   │   ├── Prometheus
│   │   │   ├── Directo: http://10.10.10.50:9090
│   │   │   └── Dominio: https://prometheus.home.arpa
│   │   ├── Node Exporter
│   │   │   └── http://10.10.10.50:9100/metrics
│   │   ├── Speedtest Tracker
│   │   │   ├── Directo: http://10.10.10.50:8085
│   │   │   └── Dominio: https://speedtest.home.arpa
│   │   ├── Scrutiny
│   │   │   ├── Directo: http://10.10.10.50:8086
│   │   │   └── Dominio: https://scrutiny.home.arpa
│   │   ├── Portainer Agent
│   │   │   └── tcp://10.10.10.50:9001
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── CT 106 vaultwarden - 10.10.10.60
│   │   ├── Vaultwarden
│   │   │   ├── Principal seguro: https://vaultwarden.tailfcb362.ts.net
│   │   │   ├── Interno/proxy: https://vault.home.arpa
│   │   │   └── Directo interno: http://10.10.10.60:8080
│   │   ├── Vaultwarden Admin
│   │   │   └── https://vaultwarden.tailfcb362.ts.net/admin
│   │   ├── Tailscale Serve HTTPS
│   │   ├── Registros cerrados
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── CT 107 paperless - 10.10.10.40
│   │   ├── Paperless-ngx
│   │   │   ├── Directo: http://10.10.10.40:8000
│   │   │   └── Dominio: https://paperless.home.arpa
│   │   ├── Postgres
│   │   ├── Redis
│   │   ├── Consume/export/media/data
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── CT 108 nextcloud - 10.10.10.65
│   │   ├── Nextcloud
│   │   │   ├── Directo: http://10.10.10.65:8088
│   │   │   └── Dominio: https://nextcloud.home.arpa
│   │   ├── MariaDB
│   │   ├── Redis
│   │   ├── Configurado para proxy HTTPS
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── VM 109 immich - 10.10.10.30
│   │   ├── Immich Server
│   │   │   ├── Directo: http://10.10.10.30:2283
│   │   │   └── Dominio: https://immich.home.arpa
│   │   ├── Immich Machine Learning
│   │   ├── Postgres
│   │   ├── Redis
│   │   ├── NODE_TLS_REJECT_UNAUTHORIZED=0 para SSO/lab
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── CT 110 tools - 10.10.10.70
│   │   ├── IT-Tools
│   │   │   ├── Directo: http://10.10.10.70:8080
│   │   │   └── Dominio: https://tools.home.arpa
│   │   ├── Stirling PDF
│   │   │   ├── Directo: http://10.10.10.70:8081
│   │   │   └── Dominio: https://pdf.home.arpa
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   ├── CT 111 databases - 10.10.10.73
│   │   ├── PostgreSQL
│   │   │   └── 10.10.10.73:5432
│   │   ├── MariaDB
│   │   │   └── 10.10.10.73:3306
│   │   ├── Redis
│   │   ├── Adminer
│   │   │   ├── Directo: http://10.10.10.73:8080
│   │   │   └── Dominio: https://adminer.home.arpa
│   │   ├── pgAdmin
│   │   │   ├── Directo: http://10.10.10.73:8082
│   │   │   └── Dominio: https://pgadmin.home.arpa
│   │   ├── ChartDB
│   │   │   ├── Directo: http://10.10.10.73:8083
│   │   │   └── Dominio: https://chartdb.home.arpa
│   │   ├── Portainer Agent
│   │   ├── cAdvisor
│   │   └── socket-proxy
│   │
│   └── CT 113 identity - 10.10.10.74
│       ├── Keycloak
│       │   ├── Directo: http://10.10.10.74:8080
│       │   └── Dominio: https://auth.home.arpa
│       ├── Health
│       │   └── http://10.10.10.74:9000/health/ready
│       ├── Realm: homelab
│       ├── Google OAuth
│       ├── OpenID Connect
│       ├── SSO para Grafana
│       ├── SSO para Homarr
│       ├── SSO para Immich
│       ├── Clientes OIDC preparados para más apps
│       ├── Portainer Agent
│       ├── cAdvisor
│       └── socket-proxy
│
├── DOMINIOS INTERNOS .home.arpa
│   │
│   ├── npm.home.arpa
│   ├── proxmox.home.arpa
│   ├── homepage.home.arpa
│   ├── homarr.home.arpa
│   ├── homer.home.arpa
│   ├── heimdall.home.arpa
│   ├── portainer.home.arpa
│   ├── adguard.home.arpa
│   ├── casaos.home.arpa
│   ├── syncthing.home.arpa
│   ├── duplicati.home.arpa
│   ├── kuma.home.arpa
│   ├── beszel.home.arpa
│   ├── grafana.home.arpa
│   ├── prometheus.home.arpa
│   ├── speedtest.home.arpa
│   ├── scrutiny.home.arpa
│   ├── tools.home.arpa
│   ├── pdf.home.arpa
│   ├── adminer.home.arpa
│   ├── pgadmin.home.arpa
│   ├── chartdb.home.arpa
│   ├── vault.home.arpa
│   ├── paperless.home.arpa
│   ├── nextcloud.home.arpa
│   ├── immich.home.arpa
│   └── auth.home.arpa
│
└── BACKUPS / PROTECCIÓN DE DATOS
    │
    ├── Backups Proxmox locales
    │   ├── Storage: hdd250-backups
    │   ├── Ruta: /mnt/hdd250/backups/dump
    │   ├── Retención: últimos 2 backups
    │   ├── Frecuencia: diaria
    │   ├── Hora: 22:30
    │   └── Uso: restaurar CT/VM completas
    │
    ├── Backups Proxmox externos
    │   ├── Herramienta: rclone
    │   ├── Destino: Google Drive cifrado
    │   ├── Remote: gdrive-crypt
    │   ├── Ruta remota: proxmox-dump
    │   └── Frecuencia: domingos 05:00
    │
    ├── Duplicati
    │   ├── URL directa: http://192.168.1.81:8200
    │   ├── Dominio: https://duplicati.home.arpa
    │   ├── Origen:
    │   │   ├── /source/documents
    │   │   ├── /source/obsidian
    │   │   ├── /source/sync
    │   │   └── /source/shared
    │   ├── Destino:
    │   │   └── /data/backups/duplicati
    │   └── Uso: restaurar carpetas concretas de /data
    │
    ├── Syncthing
    │   ├── URL directa: http://192.168.1.81:8384
    │   ├── Dominio: https://syncthing.home.arpa
    │   ├── Windows ↔ CasaOS
    │   └── Uso: sincronización de Obsidian
    │
    └── Pendiente futuro
        ├── Backup físico externo fuera del portátil
        ├── Segundo disco/NAS externo real
        └── Prueba periódica de restauración

## Lo que todavía falta 


```text
PENDIENTE / FUTURO
│
├── Pi-hole
│   └── Opcional, porque AdGuard ya cubre DNS principal
│
├── NUT / PeaNUT
│   └── Solo si compras un SAI/UPS
│
├── Jellyfin / media server
│   └── Pendiente
│
├── Media automation
│   ├── Jellyseerr
│   ├── Radarr
│   ├── Sonarr
│   ├── Bazarr
│   ├── Prowlarr
│   ├── Jackett
│   └── Lidarr
│
├── Downloads
│   ├── Transmission
│   ├── FlareSolverr
│   ├── slskd
│   ├── Deemix
│   └── SpotiFLAC
│
├── Music
│   ├── Navidrome
│   ├── Lidarr
│   └── slskd
│
├── Automation
│   └── n8n
│
├── Remote access lab
│   └── Guacamole
│
├── Web lab
│   ├── Apache
│   ├── WordPress
│   ├── PHP
│   └── Roundcube
│
├── Dev lab
│   ├── Java
│   ├── Maven
│   ├── Spring Boot
│   ├── Node.js
│   └── Express API
│
├── Render worker
│   ├── FFmpeg
│   ├── HandBrake
│   ├── Tdarr
│   └── Unmanic
│
├── Lab ciber
│   ├── Kali
│   ├── HTB/TryHackMe
│   └── bb-labs
│
├── AI local
│   ├── Ollama
│   └── Open WebUI
│
└── Gaming
    └── Minecraft Server
```



Descargamos la iso de proxmox y configuramos todo y luego desde el pc nos metemos directamtne aqui:

https://192.168.1.200:8006

Quitamos todas las repos:
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
actualizamos:
	apt update && apt upgrade -y 
al ser un portatil vamos a combiar la configuracino de que si le cerramos la tapa se apague, asi puede estar funcinoando con la tapa apagada incluso:
Sí, eso hay que hacerlo **en Proxmox**, no en Windows. Como tu servidor es un portátil, vamos a decirle a Debian/Proxmox que **ignore la tapa**.

Entra en:

```text
pve > Shell
```

Y pega esto:

```bash
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak

sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

grep -E "HandleLidSwitch" /etc/systemd/logind.conf
```

Tiene que salir algo así:

```text
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

Luego aplica el cambio:

```bash
systemctl restart systemd-logind
```

Después ya puedes cerrar la tapa y debería seguir encendido.

Para comprobar que sigue vivo, desde tu PC abre:

```text
https://192.168.1.200:8006
```

o haz ping:

```powershell
ping 192.168.1.200
```

También recomiendo dejarlo **siempre enchufado a corriente** y revisar en la BIOS si hay opciones tipo “sleep on lid close” o “power management”, pero normalmente con esto basta.
primero hay que meterse en templade e instalar la de debian la mas reciente y luego crear un ct100 con 8gb memoria 1024 de rap y 512 de sawp, luego le metemos la ip fija de las rutas externas y luego le agregamos una vez creada las rutas internas del mismo modo: 
	192.168.1.eth0: 192.168.1.87/24
	eth1: 10.10.10.87/24
	default via 192.168.1.1/24


creacion de CT100 y dentro tailscale: 

	
	hay que darle permisos primeros:
	cat >> /etc/pve/lxc/100.conf <<'EOF'
	
	lxc.cgroup2.devices.allow: c 10:200 rwm
	lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
	EOF
	
	ahora dentro de la CT100
	apt update
	apt install -y curl gnupg ca-certificates
	curl -fsSL https://tailscale.com/install.sh | sh
	ls -l /dev/net/tun
	systemctl restart tailscaled
	systemctl status tailscaled --no-pager
	
	tailscale up \
	  --advertise-routes=10.10.10.0/24,192.168.1.0/24 \
	  --advertise-exit-node \
	  --ssh
	te metes en la web, inicias sesion con l que quieras y luego activas todo desde la web, todo lo q quieas:

Creacion de CT101 con homepage:
Perfecto, cambiamos la numeración y dejamos el esquema limpio así:

```text
CT 100 tailscale-gw  - 192.168.1.87 / 10.10.10.87
CT 101 dashboard     - 192.168.1.79
CT 102 portainer     - 192.168.1.80
VM 103 casaos-nas    - 192.168.1.81
CT 104 dns           - 192.168.1.53
```

Vamos **uno por uno**. Empezamos por:

```text
CT 101 dashboard - 192.168.1.79
```

Aquí meteremos después:

```text
Homepage
Homarr
Homer
Heimdall
```

---

# 1. Crear CT 101 dashboard

En Proxmox dale a:

```text
Crear CT
```

## General

Pon:

```text
CT ID: 101
Hostname: dashboard
Password: la que quieras
Unprivileged container: marcado
Nesting: marcado
Start at boot: marcado
```

---

## Plantilla

Usa la misma que antes:

```text
debian-13-standard
```

---

## Disco

```text
Storage: local-lvm
Disk size: 12 GB
```

Con 8 GB podría valer, pero como vamos a meter varias cosillas, mejor:

```text
12 GB
```

---

## CPU

```text
Cores: 1
```

---

## Memoria

```text
Memory: 1024 MB
Swap: 512 MB
```

---

## Red

Aquí solo va en LAN, no en `vmbr10`.

```text
Nombre: eth0
Puente: vmbr0
IPv4: Estático
IPv4/CIDR: 192.168.1.79/24
Puerta de enlace: 192.168.1.1
Firewall: marcado
```

IPv6 puedes dejarlo como venga o desactivado.

---

## DNS

Pon:

```text
DNS domain: local
DNS server: 1.1.1.1
```

Luego ya cuando tengamos Pi-hole lo cambiamos.

---

## Confirmar

Comprueba que quede algo así:

```text
vmid: 101
hostname: dashboard
memory: 1024
swap: 512
rootfs: local-lvm:12
net0: name=eth0,bridge=vmbr0,firewall=1,ip=192.168.1.79/24,gw=192.168.1.1
unprivileged: 1
features: nesting=1
```

Marca:

```text
Iniciar después de la creación
```

Y dale a:

```text
Finalizar
```

---

# 2. Primera comprobación del CT 101

Cuando arranque, entra en:

```text
CT 101 dashboard > Consola
```

Login:

```text
root
```

Y pega:

```bash
ip a
ip route
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Tiene que salir:

```text
eth0 → 192.168.1.79/24
default via 192.168.1.1
ping a 1.1.1.1 OK
ping a google.com OK
```

Cuando tengas eso, me pasas la salida y seguimos con **instalar Docker dentro del CT 101** para montar los dashboards.

vamos a agregar despues mas repositoios :
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


pegas eso talcual y luego instaklamos docker :

docker version
docker compose version
systemctl status docker --no-pager

y a descargar los hompage todos para ver cual mola mas: 

y vas quitanto el q no te mole

vamos a dejar todo separado pero facil:

mkdir -p /opt/stacks/{homepage,homarr,homer,heimdall}

Sí, perfecto ✅

Ahora ya tienes:

```text
/opt/dashboard   ← stack antiguo
/opt/stacks      ← estructura nueva separada
```

Ahora vamos a parar el stack antiguo para que no choque con los puertos.

Pega esto:

```bash
cd /opt/dashboard
docker compose down
```

Luego seguimos creando los stacks separados. Primero mete **Homarr**:

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
```

Y levántalo:

```bash
cd /opt/stacks/homarr
docker compose up -d
```

Comprueba:

```bash
docker ps
```

Luego abre:

```text
http://192.168.1.79:7575
```



homer:
Perfecto ✅ Homarr queda como **stack separado**.

Ahora vamos con el siguiente: **Homer** en el puerto `8080`.

## 1. Crear configuración básica de Homer

Pega en el **CT 101**:

```bash
mkdir -p /opt/stacks/homer/assets
```

```bash
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
```

## 2. Crear stack de Homer

```bash
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
```

## 3. Levantar Homer

```bash
cd /opt/stacks/homer
docker compose up -d
```

## 4. Comprobar

```bash
docker ps
```

Abre:

```text
http://192.168.1.79:8080
```

Cuando veas que carga Homer con los enlaces, pasamos al siguiente: **Homepage**.


hompage: 
Perfecto, Homer funciona. Lo de `192.168.1.87` es normal que dé conexión rechazada: ese CT es Tailscale gateway y **no tiene web en el puerto 80**, solo sirve como router/VPN.

Vamos con el siguiente: **Homepage** en `3000`.

## 1. Crear stack de Homepage

En el **CT 101**, pega:

```bash
mkdir -p /opt/stacks/homepage/config
```

```bash
cat > /opt/stacks/homepage/docker-compose.yml <<'EOF'
services:
  homepage:
    image: ghcr.io/gethomepage/homepage:latest
    container_name: homepage
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - HOMEPAGE_ALLOWED_HOSTS=192.168.1.79:3000,localhost:3000
    volumes:
      - /opt/stacks/homepage/config:/app/config
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF
```

## 2. Levantar Homepage

```bash
cd /opt/stacks/homepage
docker compose up -d
```

## 3. Comprobar

```bash
docker ps
```

Abre:

```text
http://192.168.1.79:3000
```

Si sigue saliendo **Host validation failed**, pega:

```bash
docker logs homepage --tail=80
```

Cuando cargue, seguimos con el último de este CT: **Heimdall**.



Ese error es porque pusimos:

```text
PUID=0
PGID=0
```

Y Heimdall no quiere correr PHP-FPM como root. Lo arreglamos con un usuario normal.

En el **CT 101**, pega esto:

```bash
cd /opt/stacks/heimdall
docker compose down
```

Ahora cambia el compose:

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
```

Dale permisos a la carpeta:

```bash
chown -R 1000:1000 /opt/stacks/heimdall/config
```

Levántalo otra vez:

```bash
cd /opt/stacks/heimdall
docker compose up -d
```

Comprueba:

```bash
docker logs heimdall --tail=40
docker ps
```

Y abre:

```text
http://192.168.1.79:8081
```

Si tarda un poco, espera 30–60 segundos y recarga.


Sí, seguimos con el siguiente:

```text
CT 102 portainer - 192.168.1.80
```

## 1. Crear CT 102 en Proxmox

En Proxmox pulsa:

```text
Crear CT
```

Ponlo así:

|Apartado|Valor|
|---|---|
|CT ID|`102`|
|Hostname|`portainer`|
|Unprivileged|marcado|
|Nesting|marcado|
|Start at boot|marcado|
|Plantilla|`debian-13-standard`|
|Disco|`12 GB` en `local-lvm`|
|CPU|`1 core`|
|RAM|`1024 MB`|
|Swap|`512 MB`|
|Bridge|`vmbr0`|
|IPv4/CIDR|`192.168.1.80/24`|
|Gateway|`192.168.1.1`|
|DNS|`1.1.1.1`|

En confirmar tiene que verse algo parecido a:

```text
vmid: 102
hostname: portainer
memory: 1024
swap: 512
rootfs: local-lvm:12
net0: name=eth0,bridge=vmbr0,firewall=1,ip=192.168.1.80/24,gw=192.168.1.1
unprivileged: 1
features: nesting=1
```

Dale a **Finalizar**.

---

## 2. Comprobar red del CT 102

Cuando arranque:

```text
CT 102 portainer > Consola
```

Entra como `root` y pega:

```bash
ip a
ip route
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si eso da OK, instalamos Docker + Portainer.

Perfecto ✅ CT 102 tiene red e Internet bien.

Ahora instalamos **Docker + Portainer CE**.

## 1. Instalar Docker

Pega en el CT 102:

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

## 2. Comprobar Docker

```bash
docker version
docker compose version
systemctl status docker --no-pager
```

Tiene que salir:

```text
Active: active (running)
```

## 3. Crear Portainer

```bash
mkdir -p /opt/stacks/portainer
cd /opt/stacks/portainer
```

```bash
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
```

## 4. Levantar Portainer

```bash
docker compose up -d
docker ps
```

Luego abre:

```text
https://192.168.1.80:9443
```

Te saldrá aviso de certificado. Dale a continuar.

Crea el usuario admin y elige:

```text
Get Started / Local environment
```

Con eso Portainer gestionará el Docker de este CT 102.

Primero dale a:

```text
Get Started
```

Eso añade el **Docker local del CT 102**, donde está instalado Portainer.

Para administrar los Dockers de otros CTs, necesitas instalar **Portainer Agent** en cada CT que tenga Docker.

Ejemplo ahora mismo tienes Docker en:

```text
CT 101 dashboard - 192.168.1.79
CT 102 portainer - 192.168.1.80
```

## En CT 101 dashboard instala el Agent

Entra en la consola del **CT 101** y pega:

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

## Luego en Portainer

Sí, ahí está bien.

Deja marcado:

```text
Docker Standalone
```

Y dale a:

```text
Start Wizard
```

En la siguiente pantalla deberías elegir el método de conexión. Para el CT 101 queremos:

```text
Agent
```

No, ahí has seleccionado **Edge Agent Standard**. Para tu caso ahora es más simple usar **Agent normal**.

Haz esto:

1. En esa pantalla baja a **More options**.
    
2. Marca:
    

```text
Agent
```

3. En **Name**, pon sin barras ni espacios raros:
    

```text
CT101-dashboard
```

4. Te saldrá un campo de URL/address. Pon:
    

```text
192.168.1.79:9001
```

No pongas:

```text
https://192.168.1.80:9443
```

Eso es la URL del propio Portainer, no del CT 101.

Antes de darle a Create, confirma que en el **CT 101** el agente está levantado:

```bash
docker ps | grep portainer-agent
```

Cuando veas `portainer-agent` corriendo, en Portainer le das a **Create** con:

```text
Tipo: Agent
Name: CT101-dashboard
Address: 192.168.1.79:9001
```

Perfecto, queda así entonces:

```text
CT 100 tailscale-gw  - 192.168.1.87 / 10.10.10.87
CT 101 dashboard     - 192.168.1.79
CT 102 portainer     - 192.168.1.80
CT 103 dns           - 192.168.1.53
VM 104 casaos-nas    - 192.168.1.81
```

Vamos ahora con **CT 103 DNS**.

## Crear CT 103

En Proxmox dale a:

```text
Crear CT
```

Pon esto:

|Campo|Valor|
|---|---|
|CT ID|`103`|
|Hostname|`dns`|
|Unprivileged|Marcado|
|Nesting|Marcado|
|Start at boot|Marcado|
|Plantilla|`debian-13-standard`|
|Disco|`12 GB`|
|CPU|`1 core`|
|RAM|`1024 MB`|
|Swap|`512 MB`|
|Bridge|`vmbr0`|
|IPv4/CIDR|`192.168.1.53/24`|
|Gateway|`192.168.1.1`|
|DNS|`1.1.1.1`|

En la pantalla de confirmar debe quedar algo parecido a:

```text
vmid: 103
hostname: dns
memory: 1024
swap: 512
rootfs: local-lvm:12
net0: name=eth0,bridge=vmbr0,firewall=1,ip=192.168.1.53/24,gw=192.168.1.1
unprivileged: 1
features: nesting=1
```

Dale a **Finalizar**.

Cuando arranque, entra en:

```text
CT 103 > Consola
```

Y pega:

```bash
ip a
ip route
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si eso sale bien, montamos **AdGuard Home primero** como DNS principal en `192.168.1.53`.

Perfecto ✅ CT 103 DNS está bien:

```text
IP: 192.168.1.53
Gateway: 192.168.1.1
Internet: OK
DNS actual: OK
```

Ahora instalamos Docker y montamos **AdGuard Home**.

## 1. Instalar Docker en CT 103

Pega esto:

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

## 2. Comprobar Docker

```bash
docker version
docker compose version
systemctl status docker --no-pager
```

Tiene que salir:

```text
Active: active (running)
```

## 3. Crear AdGuard Home

```bash
mkdir -p /opt/stacks/adguard/{work,conf}
cd /opt/stacks/adguard
```

```bash
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
```

## 4. Levantar AdGuard

```bash
docker compose up -d
docker ps
```

Luego abre:

```text
http://192.168.1.53:3000
```

En el asistente inicial pon:

```text
Panel web:
Interface: All interfaces
Port: 80

DNS server:
Interface: All interfaces
Port: 53
```

Después crea usuario y contraseña.

Cuando termines, AdGuard quedará en:

```text
http://192.168.1.53
```

Pásame captura de la pantalla inicial de AdGuard antes de cambiar nada raro.



vamos a instalar vm104: casaOS
: decargamos la templelade iso desde url: https://ftp.uvigo.es/debian-cd/current/amd64/iso-cd/debian-13.4.0-amd64-netinst.iso

Yo la configuraría así para **CasaOS/NAS**:

```text
VM ID: 104
Nombre: casaos-nas
IP: 192.168.1.81
Uso: CasaOS + Samba + Filebrowser + Syncthing + Navidrome opcional
```

## General

```text
Nodo: pve
VM ID: 104
Nombre: casaos-nas
Iniciar al arrancar: luego lo activamos
```

## SO

```text
Usar imagen ISO: Sí
Almacenamiento: local
ISO: debian-13.4.0-amd64-netinst.iso
Tipo: Linux
Versión: 6.x - 2.6 Kernel
```

## Sistema

Aquí pondría:

```text
Tarjeta gráfica: Predeterminado
Máquina: q35
BIOS: OVMF (UEFI)
Añadir disco EFI: Sí
Almacenamiento EFI: local-lvm
Controlador SCSI: VirtIO SCSI single
Qemu Agent: marcado
TPM: No hace falta
```

Si te lías con UEFI, también vale BIOS SeaBIOS, pero yo usaría **OVMF UEFI + q35**.

## Discos

```text
Bus/Dispositivo: SCSI
Almacenamiento: local-lvm
Tamaño disco: 32 GB
Cache: Default / No cache
Discard: marcado si aparece
IO thread: marcado si aparece
SSD emulation: marcado si aparece
```

Ese disco es solo para el sistema. Para datos grandes ya añadiremos otro disco o almacenamiento aparte.

## CPU

```text
Sockets: 1
Cores: 2
Tipo: host
```

## Memoria

```text
Memoria: 4096 MB
Ballooning: puedes dejarlo activado
```

## Red

```text
Bridge: vmbr0
Modelo: VirtIO paravirtualized
Firewall: marcado
```

Luego dentro de Debian pondremos:

```text
IP: 192.168.1.81/24
Gateway: 192.168.1.1
DNS: 1.1.1.1 primero
```

Más adelante podemos cambiar DNS a:

```text
192.168.1.53
```

## Confirmar

Resumen esperado:

```text
VM ID: 104
Name: casaos-nas
BIOS: OVMF
Machine: q35
SCSI Controller: VirtIO SCSI single
Disk: local-lvm:32
CPU: 2 cores, type host
Memory: 4096
Network: vmbr0, VirtIO
ISO: Debian 13.4 netinst
```

Cuando llegues a la pestaña **Sistema**, mándame captura antes de seguir, porque ahí es donde más fácil es elegir mal.
No, para **CasaOS/NAS** yo instalaría **sin entorno gráfico**.

El NAS se va a manejar por web:

```text
CasaOS web
Filebrowser web
Syncthing web
Proxmox web
SSH
```

Así ahorras RAM, CPU y disco.

En el instalador de Debian, cuando salga **Selección de programas/software**, deja marcado solo:

```text
SSH server
standard system utilities
```

Y desmarca:

```text
Debian desktop environment
GNOME
Xfce
KDE
Cinnamon
MATE
LXDE
LXQt
```

Resumen:

```text
❌ Entorno gráfico: NO
✅ SSH server: SÍ
✅ Utilidades estándar del sistema: SÍ
```

Luego instalamos CasaOS y ya tendrás panel web bonito.

Es normal. En Debian se crea:

```text
root       → administrador total
guillermo  → usuario normal
```

El usuario normal se crea por seguridad: para no trabajar siempre como `root` y evitar romper el sistema por accidente.

Ahora mismo `guillermo` no puede usar `sudo` porque no está metido en el grupo de administradores. Arreglamos eso.

En esa misma terminal pon:

```bash
su -
```

Te pedirá la contraseña de **root**, no la de guillermo.

Luego pega:

```bash
apt update
apt install -y sudo openssh-server qemu-guest-agent curl
usermod -aG sudo guillermo
systemctl enable --now ssh
systemctl enable --now qemu-guest-agent
reboot
```

Después de reiniciar, entras otra vez como `guillermo` y ya debería funcionar:

```bash
sudo apt update && sudo apt upgrade -y
```

Resumen sencillo:

```text
root = jefe máximo
guillermo = usuario diario
sudo = permiso para que guillermo pueda hacer cosas de root cuando haga falta
```


Está claro el problema: la VM **no tiene la IP 192.168.1.81**, tiene esta por DHCP:

```text
192.168.1.75
```

Y SSH está bien:

```text
ssh.service active (running)
```

Prueba desde Windows:

```powershell
ssh guillermo@192.168.1.75
```

---

Luego dejamos la IP fija en `192.168.1.81`.

En la VM, como `root`, pega:

```bash
nano /etc/network/interfaces
```

Déjalo así:

```text
auto lo
iface lo inet loopback

auto ens18
iface ens18 inet static
    address 192.168.1.81/24
    gateway 192.168.1.1
    dns-nameservers 1.1.1.1 192.168.1.53
```

Guarda:

```text
Ctrl + O
Enter
Ctrl + X
```

Reinicia red/VM:

```bash
reboot
```

Después de reiniciar, desde Windows:

```powershell
ping 192.168.1.81
ssh guillermo@192.168.1.81
```

Si conecta, ya seguimos con **instalar CasaOS**.


Estás como usuario normal `guillermo`, por eso no te deja. Hazlo así:

```bash
su -
```

Mete la contraseña de **root**.

Luego pega esto:

```bash
apt update
apt install -y sudo
usermod -aG sudo guillermo
reboot
```

Cuando reinicie, vuelve a entrar:

```powershell
ssh guillermo@192.168.1.81
```

Y comprueba:

```bash
sudo whoami
```

Si responde:

```text
root
```

ya está perfecto.







Perfecto. Vamos **solo con Samba** en la VM `casaos-nas`.

## 1. Crear carpetas base

Entra por SSH:

```powershell
ssh guillermo@192.168.1.81
```

Pega:

```bash
sudo mkdir -p /data/{documents,obsidian,sync,downloads,backups,shared}
sudo mkdir -p /data/media/{movies,series,music,photos}

sudo chown -R guillermo:guillermo /data
sudo chmod -R 775 /data

ls -la /data
ls -la /data/media
```

---

## 2. Instalar Samba

```bash
sudo apt update
sudo apt install -y samba
```

---

## 3. Configurar recurso compartido `/data`

Haz copia de seguridad:

```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

Añade el recurso:

```bash
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
```

---

## 4. Crear contraseña Samba

```bash
sudo smbpasswd -a guillermo
```

Te pedirá una contraseña. Esa será la contraseña para entrar desde Windows al recurso compartido.

---

## 5. Reiniciar Samba

```bash
sudo systemctl restart smbd
sudo systemctl enable smbd
sudo systemctl status smbd --no-pager
```

Tiene que salir:

```text
active (running)
```

---

## 6. Probar desde Windows

En el explorador de archivos de Windows, arriba en la barra de dirección, pon:

```text
\\192.168.1.81\data
```

Usuario:

```text
guillermo
```

Contraseña:

```text
la que pusiste en smbpasswd
```

Si quieres mapearlo como unidad fija:

```text
Este equipo > Conectar a unidad de red
Unidad: Z:
Carpeta: \\192.168.1.81\data
Marcar: Conectar de nuevo al iniciar sesión
```

Cuando te abra la carpeta desde Windows, Samba queda listo.




le doy a instalar Syncthing: 

En el **Syncthing del servidor/CasaOS**, esa carpeta tiene que apuntar a la ruta del NAS.

Pon en **Ruta de la carpeta**:

```text
/data/obsidian
```

Déjalo así:

```text
Etiqueta de la carpeta: Obsidian
ID de la carpeta: mk3af-mgmcb
Ruta de la carpeta: /data/obsidian
Tipo de carpeta: Enviar y recibir
```

Luego dale a:

```text
Guardar
```

Después revisa en la VM CasaOS que existe la carpeta:

```bash
ls -la /data/obsidian
```

Si te da problema de permisos, en la VM ejecuta:

```bash
sudo mkdir -p /data/obsidian
sudo chown -R guillermo:guillermo /data/obsidian
sudo chmod -R 775 /data/obsidian
```

Y en Syncthing vuelve a guardar con:

```text
/data/obsidian
```

Así queda:

```text
Windows Obsidian:
C:\Users\guill\Desktop\APPS\Cyber

Servidor CasaOS:
/data/obsidian
```

Tu PC y el NAS sincronizarán esa carpeta.



Te falta hacerlo con permisos. En la VM `casaos-nas` pega esto:

```bash
sudo mkdir -p /opt/stacks/portainer-agent
sudo chown -R guillermo:guillermo /opt/stacks
cd /opt/stacks/portainer-agent
```

Ahora crea el compose:

```bash
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
```

Y levántalo con `sudo`:

```bash
sudo docker compose up -d
sudo docker ps | grep portainer-agent
```

Si quieres que `guillermo` pueda usar Docker sin `sudo`, luego hacemos esto:

```bash
sudo usermod -aG docker guillermo
```

Después cierras sesión SSH y vuelves a entrar:

```powershell
ssh guillermo@192.168.1.81
```

Y ya debería funcionar:

```bash
docker ps
```

Cuando el agent esté arriba, en Portainer añades:

```text
Name: VM104-casaos-nas
Environment URL: 192.168.1.81:9001
```


No lo detecta. Ahora mismo Proxmox **solo ve el NVMe de 512 GB**:

```text
/dev/nvme0n1
```

Y además:

```text
ls /dev/sd* → No such file or directory
```

Eso confirma que **no hay ningún HDD SATA/USB detectado**.

Haz esto:

## 1. Apaga y revisa físico

```bash
shutdown now
```

Cuando se apague:

1. Quita corriente.
    
2. Revisa que el HDD esté bien encajado.
    
3. Si va en caddy/adaptador, sácalo y vuelve a meterlo.
    
4. Si puedes, prueba ese HDD en otro PC/adaptador USB para confirmar que funciona.
    

## 2. Mira en BIOS

Al encender, entra a BIOS/UEFI y busca si aparece algo tipo:

```text
SATA HDD
Storage
Hard Disk
250GB
```

Si **la BIOS no lo ve**, Proxmox tampoco lo verá.

## 3. Si es un HDD de 2.5" interno

Algunos portátiles tienen el hueco, pero necesitan:

```text
cable flex SATA específico
caddy compatible
o que el puerto SATA esté habilitado físicamente
```

En algunos ASUS el hueco existe, pero si falta el flex/caddy correcto, el disco no aparece.

## 4. Si quieres seguir sin liarnos

Podemos seguir con el NVMe de 512 GB por ahora. Tienes `local-lvm` casi “asignado” al 97%, pero eso no significa que esté lleno real; es thin provisioning. Libre real tienes que mirarlo en:

```bash
lvs
df -h
```

Pega eso si quieres y vemos si puedes seguir creando CTs/VMs sin meter el HDD todavía.Perfecto, ahora sí lo detecta ✅

El disco nuevo es este:

```text
/dev/sda       250.06 GB
/dev/sda1      ext4
Modelo: WDC_WD2500BEVS
SMART: PASSED
```

No toques **Limpiar disco** ni **Inicializar con GPT** todavía.

## Paso seguro: mirar si tiene datos

En Proxmox > Shell pega:

```bash
mkdir -p /mnt/check-hdd
mount -o ro /dev/sda1 /mnt/check-hdd
ls -lah /mnt/check-hdd
```

Eso lo monta en **solo lectura**, así no rompemos nada.

Cuando veas qué hay dentro, desmonta:

```bash
umount /mnt/check-hdd
```

Si no hay nada importante, lo usaremos para una de estas dos cosas:

```text
Opción A: disco de datos para CasaOS/NAS
Opción B: disco de backups de Proxmox
```

Para tu caso, yo lo usaría como:

```text
/data del NAS CasaOS
```

Así la VM `casaos-nas` no depende solo del disco de 32 GB.

---

Sobre los ventiladores, sí, luego podemos hacer algo tipo:

```text
Modo noche  → CPU limitada, menos temperatura, menos ventilador
Modo turbo  → máximo rendimiento
```

Primero dejamos el HDD bien montado y después hacemos los perfiles de energía/ventilador.
Perfecto, ahora sí lo detecta ✅

El disco nuevo es este:

```text
/dev/sda       250.06 GB
/dev/sda1      ext4
Modelo: WDC_WD2500BEVS
SMART: PASSED
```

No toques **Limpiar disco** ni **Inicializar con GPT** todavía.

## Paso seguro: mirar si tiene datos

En Proxmox > Shell pega:

```bash
mkdir -p /mnt/check-hdd
mount -o ro /dev/sda1 /mnt/check-hdd
ls -lah /mnt/check-hdd
```

Eso lo monta en **solo lectura**, así no rompemos nada.

Cuando veas qué hay dentro, desmonta:

```bash
umount /mnt/check-hdd
```

Si no hay nada importante, lo usaremos para una de estas dos cosas:

```text
Opción A: disco de datos para CasaOS/NAS
Opción B: disco de backups de Proxmox
```

Para tu caso, yo lo usaría como:

```text
/data del NAS CasaOS
```

Así la VM `casaos-nas` no depende solo del disco de 32 GB.

---

Sobre los ventiladores, sí, luego podemos hacer algo tipo:

```text
Modo noche  → CPU limitada, menos temperatura, menos ventilador
Modo turbo  → máximo rendimiento
```

Primero dejamos el HDD bien montado y después hacemos los perfiles de energía/ventilador.Vale. Vamos a dejar **/dev/sda** limpio desde Proxmox.

⚠️ **MUY IMPORTANTE:** el disco correcto es:

```text
/dev/sda
Modelo: WDC_WD2500BEVS
Tamaño: 250 GB
```

NO toques:

```text
/dev/nvme0n1
```

ese es el disco principal de Proxmox.

---

## 1. Comprueba una vez más

En **pve > Shell**, pega:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
```

Tiene que salir algo como:

```text
sda    250G disk WDC_WD2500BEVS
└─sda1 250G part ext4
```

---

## 2. Desmontar por si está montado

Pega:

```bash
umount /dev/sda1 2>/dev/null || true
```

---

## 3. Borrar firmas, particiones y tabla antigua

Este comando **borra el disco /dev/sda**:

```bash
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda
partprobe /dev/sda
```

---

## 4. Crear tabla GPT nueva y partición limpia

```bash
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" /dev/sda
partprobe /dev/sda
```

---

## 5. Formatear en ext4 optimizado

```bash
mkfs.ext4 -L hdd250-data -m 0 /dev/sda1
```

Explicación rápida:

```text
-L hdd250-data → nombre del disco
-m 0           → no reserva espacio para root, así aprovechas más los 250 GB
```

---

## 6. Crear punto de montaje

```bash
mkdir -p /mnt/hdd250
```

---

## 7. Montarlo manualmente para probar

```bash
mount /dev/sda1 /mnt/hdd250
df -h /mnt/hdd250
```

Deberías ver algo como:

```text
/dev/sda1   246G   ...
```

---

## 8. Hacer que se monte solo al arrancar

Saca el UUID:

```bash
blkid /dev/sda1
```

Te saldrá algo como:

```text
/dev/sda1: LABEL="hdd250-data" UUID="xxxx-xxxx..." TYPE="ext4"
```

Ahora pega este comando automático para meterlo en `fstab`:

```bash
UUID=$(blkid -s UUID -o value /dev/sda1)

echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab

mount -a
df -h /mnt/hdd250
```

---

## 9. Dar permisos útiles

```bash
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}

chmod -R 775 /mnt/hdd250
```

---

Cuando termines, pásame la salida de:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL,MODEL
df -h /mnt/hdd250
```

Y decidimos si lo añadimos a Proxmox como **almacenamiento de backups** o si se lo pasamos a **CasaOS/NAS** como disco de datos.Perfecto, está clarísimo:

```text
/dev/sda  = HDD 250 GB
/dev/sda1 = partición antigua montada en /mnt/check-hdd
```

Primero hay que desmontarlo. Pega esto en **Shell de Proxmox**:

```bash
umount /mnt/check-hdd
```

Ahora borra y deja el HDD limpio:

```bash
wipefs -a /dev/sda
sgdisk --zap-all /dev/sda
partprobe /dev/sda
```

Crea partición nueva:

```bash
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" /dev/sda
partprobe /dev/sda
```

Formatea en ext4:

```bash
mkfs.ext4 -L hdd250-data -m 0 /dev/sda1
```

Móntalo:

```bash
mkdir -p /mnt/hdd250
mount /dev/sda1 /mnt/hdd250
df -h /mnt/hdd250
```

Haz montaje automático al arrancar:

```bash
UUID=$(blkid -s UUID -o value /dev/sda1)
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab
mount -a
```

Crea carpetas base:

```bash
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
chmod -R 775 /mnt/hdd250
```

Y pásame la salida de:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL,MODEL
df -h /mnt/hdd250
```

Luego decidimos si lo dejamos como almacenamiento de Proxmox para backups o si se lo pasamos a la VM CasaOS como disco de datos.Bien, se ha borrado correctamente. Solo falta instalar `partprobe` o usar alternativa. Haz esto:

```bash
apt update
apt install -y parted
```

Luego seguimos desde aquí:

```bash
partprobe /dev/sda
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" /dev/sda
partprobe /dev/sda
mkfs.ext4 -L hdd250-data -m 0 /dev/sda1
```

Ahora móntalo:

```bash
mkdir -p /mnt/hdd250
mount /dev/sda1 /mnt/hdd250
df -h /mnt/hdd250
```

Y montaje automático:

```bash
UUID=$(blkid -s UUID -o value /dev/sda1)
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab
mount -a
```

Carpetas base:

```bash
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
chmod -R 775 /mnt/hdd250
```

Comprobación final:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL,MODEL
df -h /mnt/hdd250
```
Va bien. Ese formateo está terminando de crear el sistema de archivos. Espera a que vuelva al prompt:

```text
root@pve:~#
```

Cuando vuelva, pega esto:

```bash
mkdir -p /mnt/hdd250
mount /dev/sda1 /mnt/hdd250
df -h /mnt/hdd250
```

Luego haz el montaje automático:

```bash
UUID=$(blkid -s UUID -o value /dev/sda1)
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab
mount -a
```

Y crea carpetas base:

```bash
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
chmod -R 775 /mnt/hdd250
```

Comprobación final:

```bash
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL,MODEL
df -h /mnt/hdd250
```

Pásame esa salida y lo dejamos preparado para usarlo en Proxmox o pasarlo a CasaOS.
Sí, buena decisión. Ese HDD de 250 GB es perfecto para **backups de Proxmox**, no para VMs principales.

Ahora añádelo a Proxmox como almacenamiento de backups.

## 1. Crear carpeta de backups

En Shell de Proxmox:

```bash
mkdir -p /mnt/hdd250/backups/dump
chmod -R 775 /mnt/hdd250/backups
```

## 2. Añadirlo en la interfaz de Proxmox

Ve a:

```text
Datacenter > Storage > Add > Directory
```

Pon:

```text
ID: hdd250-backups
Directory: /mnt/hdd250/backups
Content: VZDump backup file
Shared: no
```

Dale a **Add**.

## 3. Crear tarea de backup

Ve a:

```text
Datacenter > Backup > Add
```

Pon algo así:

```text
Node: pve
Storage: hdd250-backups
Schedule: semanal
Selection mode: Include selected VMs
Mode: Snapshot
Compression: ZSTD
```

Selecciona:

```text
100 tailscale
101 dashboard
102 portainer
103 dns
104 casaos-nas
```

En **Retention** pon algo ligero, por ejemplo:

```text
Keep last: 2
```

Así solo guarda los 2 últimos backups y no llena el HDD.

## 4. Hacer un backup manual de prueba

Cuando esté creado, selecciona la tarea y dale a:

```text
Run now
```

O desde Proxmox, puedes probar primero con uno pequeño, por ejemplo CT 100:

```bash
vzdump 100 --storage hdd250-backups --mode snapshot --compress zstd
```

Cuando termine, comprueba:

```bash
ls -lh /mnt/hdd250/backups/dump
```

Si ves archivos `.zst`, ya tienes backups funcionando.En **Contenido** selecciona:

```text
Respaldo
```

Quedaría así:

```text
ID: hdd250-backups
Directorio: /mnt/hdd250/backups
Contenido: Respaldo
Nodos: Todo
Activar: marcado
Compartido: desmarcado
```

Luego dale a **Agregar**.

Después iremos a:

```text
Centro de datos > Backup > Añadir
```

y creamos la tarea semanal usando ese almacenamiento `hdd250-backups`.
Sí, así está bien ✅

Solo revisa una cosa antes de crear:

```text
Programar: sun 01:00
```

Eso significa **todos los domingos a la 01:00**. Perfecto para backup semanal nocturno.

Yo lo dejaría así:

```text
Almacenamiento: hdd250-backups
Modo: Snapshot
Compresión: ZSTD
Modo de selección: Incluir las VMs seleccionadas
Seleccionados: 100, 101, 102, 103, 104
Activar: marcado
```

Ahora ve a la pestaña **Retención** y pon algo ligero:

```text
Mantener últimos: 2
```

o si aparece como `keep-last`:

```text
2
```

Así no se llena el HDD.

Luego dale a:

```text
Crear
```

Después puedes probarlo manualmente con **Ejecutar ahora** para confirmar que guarda bien.


Estás dentro del **CT 100 TailScale**, no en el host Proxmox.

Ese comando hay que ejecutarlo en:

```text
pve > Shell
```

No en la consola del CT.

Haz esto:

1. En Proxmox, clic en **pve**
    
2. Entra en **Shell**
    
3. Pega:
    

```bash
vzdump 100 --storage hdd250-backups --mode snapshot --compress zstd
```

Luego comprueba:

```bash
ls -lh /mnt/hdd250/backups/dump
```

Si quieres hacerlo desde la interfaz: **Centro de datos > Backup > selecciona el trabajo > Ejecutar ahora**.


Perfecto. Vamos a crear los perfiles en el **host Proxmox PVE**.

## 1. Instalar herramienta CPU

Entra en:

```text
pve > Shell
```

Pega:

```bash
apt update
apt install -y linux-cpupower hdparm
```

---

## 2. Ver qué modos soporta tu CPU

Pega:

```bash
cpupower frequency-info | grep -E "available cpufreq governors|hardware limits|current policy|current CPU frequency"
```

Mándame la salida si quieres que lo afinemos. Mientras, puedes seguir.

---
Perfecto, tu CPU soporta justo lo que necesitamos:

```text
powersave    → modo noche
performance  → modo turbo
schedutil     → modo equilibrado/moderno
```

Y sus límites son:

```text
mínimo: 1.40 GHz
máximo: 2.10 GHz
```

Ahora seguimos.



## 2. Crear `modo-turbo`

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

Prueba:

```bash
modo-turbo
```

Tiene que salir:

```text
performance
```

Cuando esos dos funcionen, te paso el bloque para programar:

```text
00:30 → modo noche
09:00 → modo turbo
```Sí, se puede hacer un **modo noche real**, no solo bajar CPU. La idea sería:

```text
Modo noche:
- CPU en ahorro
- HDD de backups en reposo
- parar CT/VM que no hagan falta
- dejar vivos solo Tailscale y DNS
```

Lo que **NO** recomiendo es forzar ventiladores a 0 manualmente, porque si el portátil sube de temperatura se puede colgar o dañar. Pero sí podemos hacer que casi no tenga carga para que no necesite ventilador.

## Qué dejaría encendido por la noche

Yo dejaría:

```text
CT 100 tailscale-gw  ✅ necesario para entrar remoto
CT 103 dns/adguard   ✅ DNS para Tailscale
```

Y apagaría por la noche:

```text
CT 101 dashboard     ❌ no hace falta por la noche
CT 102 portainer     ❌ no hace falta 24/7
VM 104 casaos-nas    ❌ opcional, si no necesitas Samba/Syncthing de noche
```

Si quieres que Obsidian/Syncthing siga sincronizando de noche, dejamos la VM 104 encendida. Pero para máximo silencio, la apagamos.

---



---

## Sobre los ventiladores

Los ventiladores normalmente los controla la BIOS/EC del portátil. Linux puede influir bajando temperatura, pero no siempre puede cambiar la curva directamente.

Podemos mirar si tu portátil deja controlar ventiladores con sensores:

```bash
apt install -y lm-sensors
sensors-detect
sensors
```

Pero en muchos portátiles ASUS, el ventilador lo controla firmware interno y no te deja poner una curva real desde Proxmox.

Lo más seguro y efectivo es esto:

```text
menos CT/VM encendidos
CPU limitada al mínimo
HDD en reposo
sin backups por la noche salvo cuando tú quieras
```

Prueba ahora:

```bash
modo-noche-total
```

y mira si baja el ruido tras 2–5 minutos.

Bien. Buenas noticias: **ahora mismo los ventiladores están apagados** según sensores:

```text
cpu_fan: 0 RPM
gpu_fan: 0 RPM
CPU:     36.8°C
GPU:     36.0°C
NVMe:    41.9°C
```

O sea, el portátil **sí puede estar en silencio**. Lo que queremos es mantenerlo así bajando carga y apagando CT/VM innecesarios.

Pero te recomiendo rehacer el script `modo-noche-total`, porque en tu copia se mezcló una línea rara. Vamos a dejarlo limpio.

## 1. Rehacer `modo-noche-total` limpio

En **pve > Shell** pega:

```bash
cat > /usr/local/sbin/modo-noche-total <<'EOF'
#!/bin/bash
echo "Activando MODO NOCHE TOTAL..."

# Lista blanca: máquinas que NO se apagan
KEEP_IDS="100 103 106"

keep_vm() {
    local id="$1"
    for keep in $KEEP_IDS; do
        if [ "$id" = "$keep" ]; then
            return 0
        fi
    done
    return 1
}

# CPU en ahorro y limitada al mínimo
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

# Dejar HDD de backups en reposo
hdparm -S 241 /dev/sda >/dev/null 2>&1 || true
hdparm -y /dev/sda >/dev/null 2>&1 || true

# Bajar prioridad de servicios Proxmox
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


## 3. Comandos que usarás

Para máximo silencio:

```bash
modo-noche-total
```

Para ver temperaturas y ventiladores:

```bash
sensors
```

Para ver qué CT/VM están encendidos:

```bash
pct list
qm list
```

Ahora mismo lo importante es esto: **los ventiladores ya aparecen a 0 RPM**, así que el control real lo lleva la BIOS/EC del ASUS, pero si mantenemos CPU baja, HDD dormido y menos máquinas encendidas, debería quedarse silencioso.


Perfecto. Íbamos a montar el siguiente bloque:

```text
CT 105 monitoring - 10.10.10.50
```

Pero como va en la red privada `vmbr10`, primero comprobamos si esa red tiene salida a Internet. Si no, lo arreglamos.

## 1. Crear CT 105 monitoring

En Proxmox pulsa:

```text
Crear CT
```

Pon:

|Campo|Valor|
|---|---|
|CT ID|`105`|
|Hostname|`monitoring`|
|Unprivileged|marcado|
|Nesting|marcado|
|Start at boot|marcado|
|Plantilla|`debian-13-standard`|
|Disco|`16 GB`|
|CPU|`1 core`|
|RAM|`1024 MB`|
|Swap|`512 MB`|
|Bridge|`vmbr10`|
|IPv4/CIDR|`10.10.10.50/24`|
|Gateway|vacío|
|DNS|`192.168.1.53`|

En red, importante:

```text
Puente: vmbr10
IPv4/CIDR: 10.10.10.50/24
Gateway: vacío
```

## 2. Cuando arranque, probar red

Entra en:

```text
CT 105 > Consola
```

Pega:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 192.168.1.1
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Resultado esperado probable:

```text
ping 10.10.10.87    OK
ping 192.168.1.1    puede fallar
ping 1.1.1.1        puede fallar
ping google.com     puede fallar
```

Si falla Internet, configuramos NAT en Proxmox para que `vmbr10` salga por `vmbr0`.


Perfecto, esto confirma lo esperado:

```text
10.10.10.50 → CT monitoring
10.10.10.87 → CT Tailscale gateway
Ping entre ellos → OK
Internet → NO
DNS → NO
```

Ahora hay que darle salida a Internet a `vmbr10`. Lo hacemos usando el **CT 100 TailScale** como gateway de la red privada.

## 1. En CT 105 pon gateway hacia TailScale

Entra en **CT 105 monitoring > Consola** y edita la red:

```bash
nano /etc/network/interfaces
```

Déjalo parecido a esto:

```text
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 10.10.10.50/24
        gateway 10.10.10.87
```

Guarda:

```text
Ctrl + O
Enter
Ctrl + X
```

Reinicia el CT 105:

```bash
reboot
```


cat > /etc/sysctl.d/99-private-router.conf <<'EOF'
net.ipv4.ip_forward=1
EOF

sysctl --system

Ahí falta el gateway. En el **CT 105 monitoring**, pega esto:

```bash
cat > /etc/network/interfaces <<'EOF'
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
        address 10.10.10.50/24
        gateway 10.10.10.87
        dns-nameservers 192.168.1.53 1.1.1.1
EOF

reboot
```

Cuando reinicie el CT 105, vuelve a entrar y comprueba:

```bash
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Tiene que aparecer:

```text
default via 10.10.10.87 dev eth0
```

Después hacemos el NAT en el **CT 100 TailScale**, que es el que tiene salida por `192.168.1.87`.


## 2. Dejar gateway permanente desde Proxmox

Ve a **pve > Shell**, no dentro del CT, y pega:

pct set 105 -net0 name=eth0,bridge=vmbr10,firewall=1,ip=10.10.10.50/24,gw=10.10.10.87  
pct reboot 105

Cuando reinicie el CT 105, entra y comprueba:

ip route

Debe salir:

default via 10.10.10.87 dev eth0  
10.10.10.0/24 dev eth0 ...

funcoia:
Perfecto ✅ Ahora el **CT 105 monitoring** ya tiene gateway:

```text
default via 10.10.10.87 dev eth0
```

Ahora falta asegurar el **NAT en CT 100 TailScale**, que es quien tiene salida hacia la LAN/Internet.

Entra en:

```text
CT 100 TailScale > Consola
```

Y pega:

```bash
apt update
apt install -y iptables iptables-persistent
```

Si pregunta guardar reglas IPv4/IPv6, dile **Sí**.

Luego pega:

```bash
cat > /etc/sysctl.d/99-private-router.conf <<'EOF'
net.ipv4.ip_forward=1
EOF

sysctl --system
```

Y ahora las reglas NAT:

```bash
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i eth1 -o eth0 -s 10.10.10.0/24 -j ACCEPT
iptables -A FORWARD -i eth0 -o eth1 -d 10.10.10.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT

netfilter-persistent save
```

Después vuelve al **CT 105 monitoring** y prueba:

```bash
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si esos dos funcionan, ya instalamos Docker y metemos **Uptime Kuma + Beszel**.

Genial ✅

Entonces ya tenemos la red privada funcionando así:

```text
CT 105 monitoring
IP: 10.10.10.50
Gateway: 10.10.10.87

CT 100 TailScale
LAN: 192.168.1.87
Privada: 10.10.10.87
NAT para 10.10.10.0/24 ✅
```

Ahora en **CT 105 monitoring** instalamos Docker.

## 1. Instalar Docker en CT 105

Pega en el CT 105:

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

## 2. Comprobar Docker

```bash
docker version
docker compose version
systemctl status docker --no-pager
```

Cuando salga `active (running)`, montamos primero **Uptime Kuma** en `10.10.10.50:3001`.


Perfecto. Ahora montamos **Uptime Kuma** primero.

## 1. Crear stack Uptime Kuma

En el **CT 105 monitoring**, pega:

```bash
mkdir -p /opt/stacks/uptime-kuma
cd /opt/stacks/uptime-kuma
```

```bash
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
```

## 2. Levantarlo

```bash
docker compose up -d
docker ps
```

## 3. Entrar desde navegador

Como está en red privada, entra usando Tailscale activo:

```text
http://10.10.10.50:3001
```

Ahí creas el usuario admin.

## 4. Monitores que metería primero

En Uptime Kuma añade estos:

```text
Proxmox      https://192.168.1.200:8006
Tailscale    ping 10.10.10.87
Dashboard    http://192.168.1.79:7575
Portainer    https://192.168.1.80:9443
AdGuard      http://192.168.1.53
CasaOS       http://192.168.1.81
```

Cuando te cargue Uptime Kuma, seguimos con **Beszel** para métricas de CPU/RAM/disco.

Ese error significa que **Portainer no llega al CT 105** por red. No es que el agent esté mal; el agent está arrancado.

El problema es este:

```text
Portainer CT 102 está en 192.168.1.80
Monitoring CT 105 está en 10.10.10.50
```

El CT 102 no sabe llegar a la red `10.10.10.0/24` si no le ponemos ruta.

## 1. Entra en CT 102 Portainer

En Proxmox:

```text
CT 102 Portainer > Consola
```

Pega:

```bash
ping -c 3 10.10.10.50
```

Seguramente fallará.

---

## 2. Añadir ruta hacia la red privada

En **CT 102 Portainer**, pega:

```bash
ip route add 10.10.10.0/24 via 192.168.1.87
```

Comprueba:

```bash
ip route
ping -c 3 10.10.10.50
```

Si ahora responde, prueba el puerto del agent:

```bash
apt update
apt install -y netcat-openbsd
nc -vz 10.10.10.50 9001
```

Tiene que salir algo tipo:

```text
succeeded
```

---

## 3. Hacer la ruta permanente

Si el ping funciona, deja la ruta fija en CT 102:

```bash
cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF
```

---

## 4. Volver a Portainer

En Portainer añade el environment así:

```text
Name: CT105-monitoring
Environment URL: tcp://10.10.10.50:9001
```

Asegúrate de que sea **Agent**, no Edge Agent.

Si vuelve a salir `https://10.10.10.50:9001/ping`, estás en la opción equivocada o lo has puesto con `https://`. Tiene que ser:

```text
tcp://10.10.10.50:9001
```





Perfecto, estás en el CT correcto y Docker está bien. Sigue con **Grafana + Prometheus**.

Pega esto en el **CT 105 monitoring**:

```bash
mkdir -p /opt/stacks/monitoring/{prometheus,grafana}
cd /opt/stacks/monitoring

cat > /opt/stacks/monitoring/prometheus/prometheus.yml <<'EOF'
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
EOF

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

docker compose up -d
docker ps
```

Luego abre:

```text
Prometheus:
http://10.10.10.50:9090

Grafana:
http://10.10.10.50:3002
```

Grafana entra con:

```text
Usuario: admin
Contraseña: admin
```

Cuando te pida cambiarla, pon una tuya.

Después dentro de Grafana:

```text
Connections > Data sources > Add data source > Prometheus
```

URL:

```text
http://prometheus:9090
```

Guardar con:

```text
Save & test
```

Cuando eso funcione, metemos **Speedtest Tracker**.


cd /opt/stacks/monitoring

docker compose down

chown -R 65534:65534 /opt/stacks/monitoring/prometheus/data
chown -R 472:472 /opt/stacks/monitoring/grafana

docker compose up -d



Sí, eso sale en `N/A` porque el dashboard espera variables como `job` e `instance`, pero Prometheus solo tiene un target básico y encima puede que esté mal apuntando a `localhost`.

Vamos a dejarlo útil de verdad con **node_exporter del CT 105**. Así Grafana verá CPU/RAM/disco del contenedor `monitoring`.


Perfecto ✅ Ahora conecta **Grafana con Prometheus**.

En Grafana:

```text
Connections > Data sources > Add data source
```

Elige:

```text
Prometheus
```

En **Prometheus server URL** pon:

```text
http://prometheus:9090
```

Baja abajo y pulsa:

```text
Save & test
```

Tiene que salir algo como:

```text
Successfully queried the Prometheus API
```


En **CT 105 monitoring**, pega:

```bash
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
docker ps | grep node-exporter
```

Ahora actualizamos Prometheus:

```bash
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

cd /opt/stacks/monitoring
docker compose restart prometheus
```

Comprueba en navegador:

```text
http://10.10.10.50:9090/targets
```

Tienen que salir los dos en **UP**:

```text
prometheus
monitoring-node
```

Luego en Grafana importa este dashboard mejor:

```text
Dashboards > New > Import
ID: 1860
```

Selecciona el datasource Prometheus y pulsa **Import**.

Ese dashboard sí debería mostrar CPU, RAM, disco y red del CT 105.


Sí, de esa lista queda así:

```text
✅ Beszel
✅ Uptime Kuma
✅ Grafana
✅ Prometheus
✅ Node Exporter
❌ Scrutiny
❌ Speedtest Tracker
⚪ NUT       → solo si tienes SAI/UPS
⚪ PeaNUT    → solo si tienes SAI/UPS
```

Como no tienes SAI ahora mismo, **NUT y PeaNUT los saltaría**. Vamos con **Speedtest Tracker** y luego vemos **Scrutiny** con cuidado.

## Instalar Speedtest Tracker

En el **CT 105 monitoring**, pega:

```bash
mkdir -p /opt/stacks/speedtest-tracker/{config,keys}
cd /opt/stacks/speedtest-tracker
```

Genera una app key:

```bash
APP_KEY="base64:$(openssl rand -base64 32)"
echo $APP_KEY
```

Ahora crea el compose:

```bash
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
```

Levántalo:

```bash
docker compose up -d
docker ps | grep speedtest
```

Abre:

```text
http://10.10.10.50:8085
```

Si te pide login inicial, prueba con el usuario/contraseña que muestre la pantalla inicial. Si no aparece, miramos logs:

```bash
docker logs speedtest-tracker --tail=80
```

Perfecto, está bien instalado ✅

Para iniciar sesión usa las credenciales por defecto:

```text
Email: admin@example.com
Password: password
```

Son las credenciales por defecto de Speedtest Tracker según la documentación de LinuxServer y la documentación oficial de la app. Cámbialas después de entrar. ([docs.linuxserver.io](https://docs.linuxserver.io/images/docker-speedtest-tracker/?utm_source=chatgpt.com "speedtest-tracker"))

Cuando entres, haz esto:

```text
Admin Panel > Speedtest > Run test
```

Si te sale error de Ookla/licencia o servidor, pásame la captura/logs:

```bash
docker logs speedtest-tracker --tail=100
```

Luego lo añadimos a Uptime Kuma y al dashboard:

```text
Speedtest Tracker: http://10.10.10.50:8085
```




Perfecto. Vamos con **Scrutiny**, pero con enfoque seguro.

Scrutiny sirve para ver salud SMART de discos. Como el disco físico está en **PVE host**, no lo voy a meter dentro del CT con privilegios raros. Mejor montamos **Scrutiny Collector directamente en PVE sin Docker**, o primero hacemos una comprobación SMART simple desde PVE.

## 1. Instalar smartmontools en PVE

En **pve > Shell**, pega:

```bash
apt update
apt install -y smartmontools
```

## 2. Comprobar discos

```bash
smartctl -a /dev/sda
smartctl -a /dev/nvme0n1
```

Si quieres algo más resumido:

```bash
smartctl -H /dev/sda
smartctl -H /dev/nvme0n1
```

Tiene que salir algo tipo:

```text
SMART overall-health self-assessment test result: PASSED
```

o en NVMe algo parecido a:

```text
SMART overall-health self-assessment test result: PASSED
```

## 3. Añadir chequeo de discos a Uptime Kuma

Para no complicarnos aún con Scrutiny, podemos crear un script en PVE que genere un estado simple y luego Uptime Kuma lo vigile después. Pero primero quiero ver si `smartctl` lee bien los dos discos.

Pásame la salida de:

```bash
smartctl -H /dev/sda
smartctl -H /dev/nvme0n1
```

Con eso decidimos si metemos Scrutiny completo o lo dejamos como comprobación SMART ligera.



Sí, podemos instalar **Scrutiny completo de forma limpia**:

```text
CT 105 monitoring
└── Scrutiny Web UI + base de datos

PVE host
└── Scrutiny Collector ligero para leer SMART real de /dev/sda y /dev/nvme0n1
```

Así **no instalamos Docker en PVE**, solo un binario collector + `smartmontools`, y la web queda en el CT de monitorización. Scrutiny está pensado justo para monitorizar S.M.A.R.T. de discos y guardar histórico en una web. ([GitHub](https://github.com/analogj/scrutiny?utm_source=chatgpt.com "AnalogJ/scrutiny: Hard Drive S.M.A.R.T Monitoring, ..."))

## 1. Scrutiny Web en CT 105

Entra en **CT 105 monitoring** y pega:

```bash
mkdir -p /opt/stacks/scrutiny/{config,influxdb}
cd /opt/stacks/scrutiny

cat > docker-compose.yml <<'EOF'
services:
  influxdb:
    image: influxdb:2.2
    container_name: scrutiny-influxdb
    restart: unless-stopped
    volumes:
      - /opt/stacks/scrutiny/influxdb:/var/lib/influxdb2

  scrutiny:
    image: ghcr.io/analogj/scrutiny:master-web
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
docker ps
```

Abre:

```text
http://10.10.10.50:8086
```

Si carga Scrutiny aunque salga vacío, está bien.

---

## 2. Collector ligero en PVE

Ahora en **pve > Shell**, pega:

```bash
mkdir -p /opt/scrutiny/bin /opt/scrutiny/config

curl -L \
  https://github.com/AnalogJ/scrutiny/releases/latest/download/scrutiny-collector-metrics-linux-amd64 \
  -o /opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64

chmod +x /opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64
```

Crea config del collector:

```bash
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
```

Prueba manual:

```bash
/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run \
  --config /opt/scrutiny/config/collector.yaml \
  --debug
```

Si funciona, en Scrutiny deberían aparecer los discos:

```text
/dev/sda       WDC 250GB
/dev/nvme0n1   Micron 512GB
```

---

## 3. Programar collector cada hora

En **PVE Shell**:

```bash
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

Comprueba:

```bash
systemctl status scrutiny-collector.service --no-pager
systemctl list-timers | grep scrutiny
```

---

Luego recarga:

```text
http://10.10.10.50:8086
```




Vale, ya veo el fallo exacto:

```text
Device sda has no scrutiny UUID; skipping collection
Device nvme0n1 has no scrutiny UUID; skipping collection
```

Esto no es que el disco esté mal. Es un problema de **mezcla de versión/config**: la web de Scrutiny está registrando los discos, pero el collector no consigue asociar las métricas SMART con el UUID del disco. Scrutiny recomienda usar imágenes/versiones coherentes y avisa que usar tags tipo `latest/master` puede dar problemas por cambios sin avisar; además, para Hub/Spoke usa `latest-web`, `latest-collector` e InfluxDB como piezas separadas. ([GitHub](https://github.com/analogj/scrutiny "GitHub - AnalogJ/scrutiny: Hard Drive S.M.A.R.T Monitoring, Historical Trends & Real World Failure Thresholds · GitHub"))

Vamos a hacerlo limpio: cambiar el contenedor web de `master-web` a `latest-web`, que va más alineado con el collector `v0.9.2`.

## 1. En CT 105 monitoring, cambia Scrutiny Web

Entra en el **CT 105 monitoring** y pega:

```bash
cd /opt/stacks/scrutiny

docker compose down
```

Ahora rehaz el compose:

```bash
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
```

Levanta:

```bash
docker compose pull
docker compose up -d
docker logs scrutiny --tail=50
```

Abre:

```text
http://10.10.10.50:8086
```

Seguramente seguirá vacío o con No Data hasta relanzar collector.

## 2. En PVE, fuerza collector otra vez

En **pve > Shell**:

```bash
/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run \
  --config /opt/scrutiny/config/collector.yaml \
  --debug
```

Ahora mira si desaparece esto:

```text
has no scrutiny UUID
```

y si ves algo como que envía métricas correctamente.

## 3. Si sigue igual, hacemos reset de la base de Scrutiny

Como Scrutiny no tiene datos útiles todavía, podemos borrar solo su base y empezar limpio.

En **CT 105 monitoring**:

```bash
cd /opt/stacks/scrutiny
docker compose down

rm -rf /opt/stacks/scrutiny/influxdb/*
rm -rf /opt/stacks/scrutiny/config/*

docker compose up -d
```

Luego en **PVE**:

```bash
/opt/scrutiny/bin/scrutiny-collector-metrics-linux-amd64 run \
  --config /opt/scrutiny/config/collector.yaml \
  --debug
```

Después recarga:

```text
http://10.10.10.50:8086
```

Si aun así sigue dando guerra, mi recomendación sería dejar Scrutiny como **opcional pendiente** y quedarnos con SMART desde Proxmox, porque SMART ya nos ha confirmado ambos discos como `PASSED`. Scrutiny es bonito, pero no merece romper la limpieza del PVE por él.





Sí, vamos a cerrar **backup/monitorización** y te dejo claro qué tienes.

## Qué es Duplicati

**Duplicati** es un panel web para hacer copias de seguridad de carpetas concretas.

No sustituye a los backups de Proxmox. Son cosas distintas:

|Tipo|Qué guarda|Dónde lo tenemos|
|---|---|---|
|Backup Proxmox|CT/VM completas|HDD 250 GB en PVE|
|Duplicati|Carpetas/archivos concretos|Lo montamos ahora|
|Syncthing|Sincroniza archivos, no es backup real|CasaOS/Obsidian|

Ejemplo:

```text
Proxmox backup → si se rompe el CT completo, restauras la máquina entera.
Duplicati → si borras una carpeta/documento, puedes recuperar solo esos archivos.
Syncthing → si borras algo, puede sincronizar también el borrado.
```

## Dónde pondría Duplicati

Yo lo pondría en la **VM 104 casaos-nas**, porque ahí viven los datos reales:

```text
VM 104 casaos-nas - 192.168.1.81
├── /data
├── /data/documents
├── /data/obsidian
├── /data/sync
├── /data/media
└── /data/backups
```

Así Duplicati ve directamente `/data`.

De momento hará backups dentro de:

```text
/data/backups/duplicati
```

Ojo: eso es backup local, útil contra borrados accidentales, pero no contra rotura del disco. Más adelante lo suyo sería sacar esa copia a otro disco, nube o NAS externo.

---

# Instalar Duplicati en CasaOS/NAS

Entra por SSH a CasaOS:

```powershell
ssh guillermo@192.168.1.81
```

Pega:

```bash
sudo mkdir -p /opt/stacks/duplicati
sudo mkdir -p /data/backups/duplicati
sudo chown -R guillermo:guillermo /opt/stacks/duplicati /data/backups/duplicati
cd /opt/stacks/duplicati
```

Sí, ya abre Duplicati ✅

Ahora te pide la **contraseña web de Duplicati**. Como no la configuramos, vamos a dejarla fija en el `docker-compose.yml`.

En la VM `casaos-nas`, dentro de `/opt/stacks/duplicati`, pega esto cambiando `TU_PASSWORD_AQUI` por una contraseña tuya:

```bash
cd /opt/stacks/duplicati

WEBPASS='TU_PASSWORD_AQUI'

KEY=$(grep SETTINGS_ENCRYPTION_KEY docker-compose.yml | cut -d= -f2-)

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

sudo docker compose down
sudo docker compose up -d
```

Espera 15–20 segundos y entra otra vez:

```text
http://192.168.1.81:8200
```

Contraseña:

```text
la que pusiste en WEBPASS
```

Cuando entres, configuramos el primer backup de `/source/documents`, `/source/obsidian` y `/source/sync`.



## Resumen de lo que tienes ahora

```text
PROXMOX PVE - 192.168.1.200
├── Panel Proxmox: https://192.168.1.200:8006
├── HDD 250 GB para backups Proxmox
│   ├── Disco físico: /dev/sda
│   ├── Montaje: /mnt/hdd250
│   └── Backups: /mnt/hdd250/backups
├── Backups automáticos semanales
├── Modo noche / modo turbo
└── SMART/Scrutiny para discos
```

```text
CT 100 TailScale - 192.168.1.87 / 10.10.10.87
├── IP LAN: 192.168.1.87
├── IP privada: 10.10.10.87
├── IP Tailscale: 100.96.189.117
├── Tailscale
├── Subnet Router
│   ├── 192.168.1.0/24
│   └── 10.10.10.0/24
├── Exit Node
└── Gateway/NAT para red privada 10.10.10.0/24
```

```text
CT 101 dashboard - 192.168.1.79
├── IP LAN: 192.168.1.79
├── Homepage: http://192.168.1.79:3000
├── Homarr: http://192.168.1.79:7575
├── Homer: http://192.168.1.79:8080
└── Heimdall: http://192.168.1.79:8081
```

```text
CT 102 Portainer - 192.168.1.80
├── IP LAN: 192.168.1.80
├── Portainer CE: https://192.168.1.80:9443
└── Agents conectados
    ├── CT 101 dashboard: tcp://192.168.1.79:9001
    ├── VM 104 casaos-nas: tcp://192.168.1.81:9001
    └── CT 105 monitoring: tcp://10.10.10.50:9001
```

```text
CT 103 DNS - 192.168.1.53
├── IP LAN: 192.168.1.53
├── AdGuard Home: http://192.168.1.53
├── DNS LAN/VPN: 192.168.1.53
└── Pi-hole: pendiente/opcional
```

```text
VM 104 casaos-nas - 192.168.1.81
├── IP LAN: 192.168.1.81
├── CasaOS: http://192.168.1.81
├── Samba: \\192.168.1.81\data
├── Syncthing: http://192.168.1.81:8384
├── Duplicati: http://192.168.1.81:8200
├── Portainer Agent: tcp://192.168.1.81:9001
└── /data
    ├── /data/obsidian
    ├── /data/sync
    ├── /data/shared
    ├── /data/documents
    └── /data/backups/duplicati
```

```text
CT 105 monitoring - 10.10.10.50
├── IP privada: 10.10.10.50
├── Gateway: 10.10.10.87
├── Uptime Kuma: http://10.10.10.50:3001
├── Beszel: http://10.10.10.50:8090
├── Grafana: http://10.10.10.50:3002
├── Prometheus: http://10.10.10.50:9090
├── Node Exporter: http://10.10.10.50:9100/metrics
├── Speedtest Tracker: http://10.10.10.50:8085
├── Scrutiny: http://10.10.10.50:8086
└── Portainer Agent: tcp://10.10.10.50:9001
```

## Backups que tienes

```text
Backups Proxmox:
HDD 250 GB → /mnt/hdd250/backups
Destino en Proxmox: hdd250-backups
Ruta de dumps: /mnt/hdd250/backups/dump
Sirven para restaurar CT/VM completas.

Máquinas incluidas:
├── CT 100 TailScale
├── CT 101 dashboard
├── CT 102 Portainer
├── CT 103 DNS
├── VM 104 casaos-nas
└── CT 105 monitoring
```

```text
Duplicati:
VM CasaOS → http://192.168.1.81:8200
Destino: /data/backups/duplicati/casaos-datos-importantes
Dentro del contenedor: /backups/casaos-datos-importantes

Origen configurado:
├── /source/documents
├── /source/obsidian
├── /source/sync
└── /source/shared

Sirve para restaurar carpetas concretas de /data.
```

```text
Syncthing:
VM CasaOS → http://192.168.1.81:8384
Windows ↔ CasaOS
Carpeta Windows: C:\Users\guill\Desktop\APPS\Cyber
Carpeta servidor: /data/obsidian

No es backup real, porque si borras algo también puede sincronizar el borrado.
```

## Estado general

```text
Backup + monitorización: cerrado ✅

Pendiente opcional:
├── Pi-hole si quieres tenerlo junto a AdGuard
├── NUT / PeaNUT si algún día pones SAI/UPS
└── Sacar backups fuera del servidor en el futuro
```

Siguiente bloque lógico: **Paperless** o **Vaultwarden**.





# 1. Crear CT 106 Vaultwarden

En Proxmox:

```text
Crear CT
```

Pon:

|Campo|Valor|
|---|---|
|CT ID|`106`|
|Hostname|`vaultwarden`|
|Unprivileged|marcado|
|Nesting|marcado|
|Start at boot|marcado|
|Plantilla|`debian-13-standard`|
|Disco|`12 GB`|
|CPU|`1 core`|
|RAM|`1024 MB`|
|Swap|`512 MB`|
|Bridge|`vmbr10`|
|IPv4/CIDR|`10.10.10.60/24`|
|Gateway|`10.10.10.87`|
|DNS|`1.1.1.1`|

En resumen debería quedar:

```text
vmid: 106
hostname: vaultwarden
rootfs: local-lvm:12
memory: 1024
swap: 512
net0: name=eth0,bridge=vmbr10,firewall=1,ip=10.10.10.60/24,gw=10.10.10.87
features: nesting=1
unprivileged: 1
```

---

# 2. Comprobar red

Cuando arranque, entra en:

```text
CT 106 vaultwarden > Consola
```

Pega:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Tiene que salir:

```text
IP: 10.10.10.60
default via 10.10.10.87
ping 1.1.1.1 OK
ping google.com OK
```

---

# 3. Instalar Docker

En el CT 106 pega:

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

Comprobar:

```bash
docker version
docker compose version
systemctl status docker --no-pager
```

---

# 4. Instalar Vaultwarden

Genera token de admin:

```bash
openssl rand -base64 48
```

Copia el resultado. Ahora crea el stack, cambiando `PEGA_AQUI_TU_TOKEN` por el token generado:

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
```

Si ya pegaste el token manualmente en el archivo, levanta:

```bash
docker compose up -d
docker ps
```

Abre desde navegador con Tailscale activo:

```text
http://10.10.10.60:8080
```

Panel admin:

```text
http://10.10.10.60:8080/admin
```

---



Ese error suele pasar en **LXC sin `/dev/net/tun` habilitado**. Tailscale está instalado, pero el CT no puede levantar el backend de red.

Vamos a habilitar TUN en el CT 106 desde **PVE**.

## 1. En PVE Shell, apaga el CT 106

```bash
pct shutdown 106 --timeout 60
```

Si no se apaga:

```bash
pct stop 106
```

## 2. Añade permisos TUN al CT

En **PVE Shell**:

```bash
cat >> /etc/pve/lxc/106.conf <<'EOF'
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF
```

Comprueba que quedó:

```bash
tail -5 /etc/pve/lxc/106.conf
```

## 3. Arranca el CT

```bash
pct start 106
```

## 4. Dentro del CT 106, reinicia Tailscale

Entra otra vez en la consola de `vaultwarden` y pega:

```bash
systemctl restart tailscaled
systemctl status tailscaled --no-pager
```

Luego prueba:

```bash
tailscale up --hostname=vaultwarden
```

Te debería dar el enlace para autorizarlo.

Cuando esté autorizado, seguimos con:

```bash
tailscale serve --bg --https=443 127.0.0.1:8080
```





## 1. Activar Tailscale Serve

En el **CT 106 vaultwarden**, pega:

```bash
tailscale serve --bg --https=443 127.0.0.1:8080
```

Luego mira la URL:

```bash
tailscale serve status
```

Te debería salir algo parecido a:

```text
https://vaultwarden.xxxxx.ts.net
```

## 2. Probar en navegador

Abre la URL que te dé Tailscale, por ejemplo:

```text
https://vaultwarden.TU-TAILNET.ts.net
```

No uses ya:

```text
http://10.10.10.60:8080
```

porque por HTTP seguirá fallando la parte segura.



## 1. Primero fija el dominio HTTPS en Vaultwarden

En el **CT 106 vaultwarden**, pega:

```bash
cd /opt/stacks/vaultwarden

cp docker-compose.yml docker-compose.yml.bak

sed -i '/DOMAIN=/d' docker-compose.yml
sed -i '/TZ=Europe\/Madrid/a\      - DOMAIN=https://vaultwarden.tailfcb362.ts.net' docker-compose.yml

docker compose down
docker compose up -d
```

## 2. Permitir registro temporalmente

Como pusimos los registros cerrados, vamos a abrirlos solo para crear tu cuenta.

```bash
cd /opt/stacks/vaultwarden

sed -i 's/SIGNUPS_ALLOWED=false/SIGNUPS_ALLOWED=true/' docker-compose.yml

docker compose down
docker compose up -d
```

Ahora entra aquí:

```text
https://vaultwarden.tailfcb362.ts.net/#/register
```

Crea tu cuenta con:

```text
Correo: el tuyo
Contraseña maestra: una contraseña fuerte y que recuerdes
```

## 3. Después de crear tu cuenta, cerrar registros

Muy importante. Cuando ya tengas tu usuario creado, vuelve al CT 106 y pega:

```bash
cd /opt/stacks/vaultwarden

sed -i 's/SIGNUPS_ALLOWED=true/SIGNUPS_ALLOWED=false/' docker-compose.yml

docker compose down
docker compose up -d
```

## 4. Entrar normal

Ahora entra aquí:

```text
https://vaultwarden.tailfcb362.ts.net
```

Y usa:

```text
Correo: el que registraste
Contraseña: la contraseña maestra que acabas de crear
```

El panel admin queda en:

```text
https://vaultwarden.tailfcb362.ts.net/admin
```

Ahí se entra con el `ADMIN_TOKEN`, no con tu contraseña maestra.

Después podemos arreglar el aviso amarillo del `ADMIN_TOKEN` en texto plano usando hash Argon2, pero primero crea tu usuario y comprueba que puedes entrar al vault.

Perfecto ✅ Vaultwarden ya está funcionando bien con HTTPS privado por Tailscale:

```text
Vaultwarden:
https://vaultwarden.tailfcb362.ts.net
```

Ahora haz solo estas 3 cosas para dejarlo fino:

```text
1. Cerrar registros otra vez
2. Añadirlo a Homarr/dashboard
3. Añadirlo a Uptime Kuma
```

En el **CT 106 vaultwarden**, cierra registros:

```bash
cd /opt/stacks/vaultwarden

sed -i 's/SIGNUPS_ALLOWED=true/SIGNUPS_ALLOWED=false/' docker-compose.yml

docker compose down
docker compose up -d
```

URLs finales:

```text
Vaultwarden:       https://vaultwarden.tailfcb362.ts.net
Vaultwarden Admin: https://vaultwarden.tailfcb362.ts.net/admin
IP privada:        10.10.10.60
Tailscale IP:      100.92.226.111
```

En Homarr añade:

```text
Nombre: Vaultwarden
URL: https://vaultwarden.tailfcb362.ts.net
```

En Uptime Kuma añade monitor HTTPS:

```text
Nombre: Vaultwarden
Tipo: HTTP(s)
URL: https://vaultwarden.tailfcb362.ts.net
```

Con esto queda añadido al esquema:

```text
CT 106 vaultwarden - 10.10.10.60 / 100.92.226.111
├── Vaultwarden
│   └── https://vaultwarden.tailfcb362.ts.net
├── Vaultwarden Admin
│   └── https://vaultwarden.tailfcb362.ts.net/admin
├── Tailscale Serve HTTPS
└── Registros cerrados
```


Sí, lo podemos actualizar, pero **no lo hagas encima a lo bruto**.

Homarr 1.0 es una **reescritura completa** y la propia guía recomienda migrar con cuidado: primero exportar desde la versión antigua y montar una instalación 1.0 en paralelo, porque los volúmenes/configs antiguos no son compatibles directamente. ([homarr.dev](https://homarr.dev/blog/2025/01/19/migration-guide-1.0/?utm_source=chatgpt.com "Migrate from 0.15.10+ to 1.0.0"))

Además, desde Homarr `0.15.10` existe una página de migración en `Management > Tools > Migrate to 1.0` para exportar boards, integraciones y usuarios. ([GitHub](https://github.com/ajnart/homarr/releases?utm_source=chatgpt.com "Releases · ajnart/homarr"))

## Lo que haría yo

No tocaría el Homarr actual todavía. Haría esto:

```text
1. Dejar Homarr antiguo funcionando en 192.168.1.79:7575
2. Exportar datos desde Homarr antiguo
3. Crear Homarr 1 nuevo en paralelo en 192.168.1.79:7576
4. Importar datos
5. Si queda bien, sustituimos el viejo
```

Así si algo sale mal, no pierdes el dashboard.

## Paso 1: backup rápido del CT dashboard

En **PVE Shell**:

```bash
vzdump 101 --storage hdd250-backups --mode snapshot --compress zstd
```

## Paso 2: exportar desde Homarr viejo

En Homarr actual busca:

```text
Management > Tools > Migrate to 1.0
```

Exporta el `.zip` y guarda también la **secret key** que te enseñe. Según la guía oficial, esa clave se necesita para importar datos secretos como hashes de usuarios, salts e integraciones. ([homarr.dev](https://homarr.dev/blog/2025/01/19/migration-guide-1.0/?utm_source=chatgpt.com "Migrate from 0.15.10+ to 1.0.0"))

## Paso 3: montar Homarr 1.0 en paralelo

Entra al **CT 101 dashboard** y localiza dónde tienes el stack actual:

```bash
find /opt /data -name "docker-compose.yml" 2>/dev/null | grep -i homarr
```

Cuando sepas la ruta, hacemos uno nuevo, por ejemplo:

```bash
mkdir -p /opt/stacks/homarr-v1
cd /opt/stacks/homarr-v1
```

Y lo pondríamos en puerto `7576`, no `7575`, para no pisar el actual. La guía de migración oficial recomienda precisamente usar un puerto externo distinto, por ejemplo `7576:7575`, para levantar la nueva instalación en paralelo. ([homarr.dev](https://homarr.dev/blog/2025/01/19/migration-guide-1.0/?utm_source=chatgpt.com "Migrate from 0.15.10+ to 1.0.0"))

Pásame primero la salida de:

```bash
docker ps | grep -i homarr
find /opt /data -name "docker-compose.yml" 2>/dev/null | grep -i homarr
```

y te doy el compose exacto sin romper el Homarr que ya tienes.




Sí, eso es normal. El **CT 101 dashboard** está en LAN:

```text
192.168.1.79
```

y los servicios privados están en:

```text
10.10.10.0/24
```

El dashboard no sabe llegar a esa red si no le ponemos una ruta hacia el gateway Tailscale:

```text
10.10.10.0/24 → vía 192.168.1.87
```

## 1. Entra en CT 101 dashboard

En Proxmox:

```text
CT 101 dashboard > Consola
```

Pega:

```bash
ip route add 10.10.10.0/24 via 192.168.1.87
```

Comprueba:

```bash
ip route
ping -c 3 10.10.10.50
curl -I http://10.10.10.50:3001
```

Si eso responde, Homarr ya debería poder ver Kuma, Beszel, Grafana, Prometheus, Speedtest y Scrutiny.

---

## 2. Dejar la ruta permanente

En el **CT 101 dashboard**, pega:

```bash
cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF
```

Luego reinicia red o el CT:

```bash
reboot
```

Cuando vuelva:

```bash
ip route
ping -c 3 10.10.10.50
```

---

## 3. Reiniciar Homarr por si mantiene estados antiguos

En el **CT 101 dashboard**:

```bash
docker restart homarr-v1
```

Luego recarga Homarr:

```text
http://192.168.1.79:7575
```

---

Con eso el dashboard debería poder alcanzar tanto:

```text
LAN:
192.168.1.53
192.168.1.80
192.168.1.81
192.168.1.200
```

como:

```text
Privado:
10.10.10.50
10.10.10.60
```

Para Vaultwarden, en Homarr usa mejor la URL HTTPS de Tailscale:

```text
https://vaultwarden.tailfcb362.ts.net
```


Porque Vaultwarden ahora lo estás usando por **Tailscale Serve HTTPS**:

```text
https://vaultwarden.tailfcb362.ts.net
```

y eso no responde como un ping normal desde Homarr. Homarr puede marcar mal el estado si intenta comprobar “ping” ICMP o si el contenedor `dashboard` no resuelve/entra bien a nombres `.ts.net`.

Para Vaultwarden, en Homarr no uses chequeo tipo **ping**. Usa chequeo **HTTP/HTTPS**.

Configúralo así:

```text
App URL:
https://vaultwarden.tailfcb362.ts.net

Health check / Ping:
HTTP status

Health check URL:
https://vaultwarden.tailfcb362.ts.net
```

Si Homarr te deja elegir código esperado:

```text
Expected status: 200
```

o si da redirección:

```text
Expected status: 200-399
```

Otra opción más simple: para el estado usa la IP privada interna:

```text
Health check URL:
http://10.10.10.60:8080
```

y para abrir la app usa la URL buena:

```text
App URL:
https://vaultwarden.tailfcb362.ts.net
```

Así queda perfecto:

```text
Abrir Vaultwarden → HTTPS Tailscale
Comprobar si está vivo → HTTP interno 10.10.10.60:8080
```

Vaultwarden **sí funciona**. Lo que falla es solo el método de comprobación/ping de Homarr.


Jajaja sí, te entiendo. **Nextcloud** será tu “nube para todo”, pero **Paperless** tiene sentido como herramienta especializada para documentos porque hace OCR/búsqueda y ordena PDFs/facturas mejor que una simple carpeta.

Orden que haría:

```text
1. Paperless     → documentos/OCR
2. Nextcloud     → nube familiar general
3. Immich        → fotos estilo Google Photos
```

Así dejamos primero el ligero y luego vamos a los gordos.

## Siguiente: CT 107 Paperless

Créalo en Proxmox así:

```text
CT ID: 107
Hostname: paperless
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Plantilla: debian-13-standard
Disco: 16 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.40/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Cuando arranque, entra en la consola del CT 107 y comprueba red:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si eso sale bien, instalamos Docker y Paperless.





Perfecto, entonces ya levantó bien ✅

Entra con:

```text
Usuario: root
Contraseña: la que pusiste al crear el superusuario
```

Como dejaste el campo de usuario vacío, Paperless usó `root`.

Después de entrar, hacemos estos 3 cierres:

```text
1. Añadir Paperless a Homarr
URL: http://10.10.10.40:8000

2. Añadir Paperless a Uptime Kuma
Tipo: HTTP(s)
URL: http://10.10.10.40:8000

3. Añadir Portainer Agent al CT 107
para gestionarlo desde Portainer
```

Para el agent de Portainer en `paperless`, pega en el CT 107:

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

Luego en Portainer añades environment:

```text
Name: CT107-paperless
Environment URL: 10.10.10.40:9001
```


Perfecto. Vamos con **Nextcloud** primero y luego **Immich**.

Yo lo separaría así:

```text
CT 108 nextcloud - 10.10.10.65
├── Nextcloud
├── MariaDB
├── Redis
└── Portainer Agent

VM/CT 109 immich - 10.10.10.30
├── Immich Server
├── Immich Machine Learning
├── Postgres
└── Redis
```

Nextcloud lo dejamos como **nube familiar general**. Immich luego como **Google Photos privado**.

---

# 1. Crear CT 108 Nextcloud

En Proxmox crea un CT nuevo:

```text
CT ID: 108
Hostname: nextcloud
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Plantilla: debian-13-standard
Disco: 32 GB
CPU: 2 cores
RAM: 2048 MB
Swap: 1024 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.65/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Nextcloud necesita algo más que Paperless, por eso pondría:

```text
CPU: 2 cores
RAM: 2 GB
Disco: 32 GB mínimo
```

Luego entra en la consola del CT y comprueba red:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

---

# 2. Instalar Docker en CT 108

En el CT `nextcloud`, pega:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

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

Comprobación:

```bash
docker version
docker compose version
```

---

# 3. Instalar Nextcloud

Pega esto en el CT 108:

```bash
mkdir -p /opt/stacks/nextcloud/{nextcloud,db,redis}
cd /opt/stacks/nextcloud
```

Generamos contraseñas:

```bash
MYSQL_ROOT_PASSWORD="$(openssl rand -base64 24)"
MYSQL_PASSWORD="$(openssl rand -base64 24)"
NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 18)"

echo "MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD"
echo "MYSQL_PASSWORD=$MYSQL_PASSWORD"
echo "NEXTCLOUD_ADMIN_USER=guillermo"
echo "NEXTCLOUD_ADMIN_PASSWORD=$NEXTCLOUD_ADMIN_PASSWORD"
```

Guarda esas contraseñas en Vaultwarden.

Ahora crea el `docker-compose.yml`:

```bash
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
```

Levanta:

```bash
docker compose up -d
docker ps
```

Espera 1-2 minutos y abre:

```text
http://10.10.10.65:8088
```

Usuario:

```text
guillermo
```

Contraseña:

```text
la que te salió en NEXTCLOUD_ADMIN_PASSWORD
```

---

# 4. Añadir Portainer Agent

Cuando Nextcloud funcione, en el CT 108 pega:

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

En Portainer añades:

```text
Name: CT108-nextcloud
Environment URL: tcp://10.10.10.65:9001
```

---

# 5. Añadir a Homarr y Uptime Kuma

Homarr:

```text
Nombre: Nextcloud
URL: http://10.10.10.65:8088
Health check: HTTP
```

Uptime Kuma:

```text
Tipo: HTTP(s)
Nombre: Nextcloud
URL: http://10.10.10.65:8088
```

---


Perfecto, dejamos Nextcloud para después y hacemos **Immich** ahora.

Para Immich sí prefiero **VM**, porque es más pesado y tiene machine learning.

```text
VM 109 immich - 10.10.10.30
├── Immich Server
├── Immich Machine Learning
├── Postgres
├── Redis
└── Portainer Agent
```

## 1. Crear VM 109 Immich

En Proxmox:

```text
Crear VM
```

Ponlo así:

```text
VM ID: 109
Nombre: immich
ISO: Debian 13 netinst
Sistema: Linux
Machine: q35
BIOS: OVMF (UEFI)
Qemu Agent: marcado
Disco: 64 GB
CPU: 2 cores
RAM: 4096 MB
Red: vmbr10
Modelo red: VirtIO
```

Durante la instalación Debian:

```text
Hostname: immich
Dominio: local
Usuario normal: guillermo
Entorno gráfico: NO
SSH server: SÍ
standard system utilities: SÍ
```

IP fija dentro de Debian:

```text
IP: 10.10.10.30/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Si prefieres hacerlo más rápido en CT también se puede, pero para Immich yo lo haría VM.

## 2. Después de instalar Debian

Cuando puedas entrar por SSH:

```powershell
ssh guillermo@10.10.10.30
```

Haz root:

```bash
su -
```

Y pega:

```bash
apt update
apt install -y sudo curl nano htop git qemu-guest-agent ca-certificates gnupg openssl
usermod -aG sudo guillermo
systemctl enable --now qemu-guest-agent
reboot
```

Luego vuelves a entrar por SSH:

```powershell
ssh guillermo@10.10.10.30
```

Y probamos:

```bash
sudo whoami
```

Tiene que responder:

```text
root
```

Primero crea la **VM 109** e instala Debian. Cuando tengas ping/SSH funcionando, montamos Docker + Immich con compose.




Perfecto ✅ Entonces la VM 109 `immich` ya está lista.

Ahora instalamos Docker + Immich.

## 1. Instalar Docker en VM 109

Entra por SSH:

```powershell
ssh guillermo@10.10.10.30
```

Pega:

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/debian/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

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

Cierra sesión y vuelve a entrar para que coja el grupo `docker`:

```bash
exit
```

Luego otra vez:

```powershell
ssh guillermo@10.10.10.30
```

Comprueba:

```bash
docker version
docker compose version
```

## 2. Crear stack Immich

Pega:

```bash
sudo mkdir -p /opt/stacks/immich/{library,postgres,model-cache}
sudo chown -R guillermo:guillermo /opt/stacks/immich
cd /opt/stacks/immich
```

Genera contraseña de base de datos:

```bash
DB_PASSWORD="$(openssl rand -base64 24)"
echo "DB_PASSWORD=$DB_PASSWORD"
```

Guárdala en Vaultwarden.

Ahora crea `.env`:

```bash
cat > .env <<EOF
UPLOAD_LOCATION=/opt/stacks/immich/library
DB_DATA_LOCATION=/opt/stacks/immich/postgres
IMMICH_VERSION=release
DB_PASSWORD=$DB_PASSWORD
DB_USERNAME=postgres
DB_DATABASE_NAME=immich
TZ=Europe/Madrid
EOF
```

Crea `docker-compose.yml`:

```bash
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
```

Levanta:

```bash
docker compose up -d
docker ps
```

## 3. Abrir Immich

Espera 1-2 minutos y abre:

```text
http://10.10.10.30:2283
```

Crea el usuario admin desde la primera pantalla.

Cuando esté abierto, añadimos:

```text
Homarr: http://10.10.10.30:2283
Uptime Kuma: HTTP(s) http://10.10.10.30:2283
Portainer Agent: tcp://10.10.10.30:9001
```



Perfecto ✅ Immich queda instalado y funcionando.

Ahora ciérralo bien con estas 3 cosas:

## 1. Añadir Immich a Homarr

```text
Nombre: Immich
URL: http://10.10.10.30:2283
Health check: HTTP
```

## 2. Añadir Immich a Uptime Kuma

```text
Tipo: HTTP(s)
Nombre: Immich
URL: http://10.10.10.30:2283
```

## 3. Añadir Portainer Agent en la VM 109

En la VM `immich`, pega:

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

Luego en Portainer:

```text
Name: VM109-immich
Environment URL: 10.10.10.30:9001
```

Y el esquema actualizado queda:

```text
VM 109 immich - 10.10.10.30
├── Immich Server
│   └── http://10.10.10.30:2283
├── Immich Machine Learning
├── PostgreSQL
├── Redis
├── App móvil funcionando ✅
└── Portainer Agent
    └── tcp://10.10.10.30:9001
```



Perfecto. Vamos a configurar **rclone + Google Drive cifrado** en el **host PVE**, para subir los backups de Proxmox fuera del portátil.

La idea:

```text
/mnt/hdd250/backups/dump
        ↓
rclone crypt
        ↓
Google Drive cifrado
```

## 1. Instalar rclone en PVE

En **pve > Shell**:

```bash
apt update
apt install -y rclone
```

Comprueba:

```bash
rclone version
```

---

## 2. Crear conexión a Google Drive

En **pve > Shell**:

```bash
rclone config
```

Vas respondiendo así:

```text
n
```

Nombre del remote:

```text
gdrive
```

Tipo de almacenamiento: busca Google Drive.

Normalmente puedes escribir:

```text
drive
```

Luego te preguntará `client_id` y `client_secret`:

```text
client_id> ENTER
client_secret> ENTER
```

Scope:

```text
1
```

Root folder ID:

```text
ENTER
```

Service account file:

```text
ENTER
```

Advanced config:

```text
n
```

Use auto config:

```text
n
```

Te dará una URL. Cópiala y ábrela en tu navegador de Windows.

Inicias sesión con tu Google Drive de 2 TB, aceptas permisos y te devolverá un código. Ese código lo pegas en la consola de PVE.

si no se te abre el navegador como a mi haces esto:

Ahí vas a **PowerShell de Windows** y ejecutas el comando que te ponga, por ejemplo:

rclone authorize "drive" "EL_TOKEN_QUE_T_DIO_ARRIBA"

Cuando Windows te dé el JSON largo, vuelves a Proxmox y lo pegas en:

config_token>

Después:

```text
Configure this as a Shared Drive?
n
```

Confirmas:

```text
y
```

Sales:

```text
q
```

---

Perfecto ✅ Ya está conectado `gdrive:` correctamente.

Ahora vamos a crear la carpeta base y luego el cifrado.

## 1. Crear carpeta base en Google Drive

En **pve > Shell**:

```bash
rclone mkdir gdrive:Homelab-Proxmox-Backups
rclone lsd gdrive:
```

Deberías ver también:

```text
Homelab-Proxmox-Backups
```

## 2. Crear remote cifrado encima

Ejecuta:

```bash
rclone config
```

Pulsa:

```text
n
```

Nombre:

```text
gdrive-crypt
```

Tipo de storage:

```text
crypt
```

Cuando pregunte `remote`, pon:

```text
gdrive:Homelab-Proxmox-Backups
```

Filename encryption:

```text
standard
```

Directory name encryption:

```text
true
```

Password:

```text
g
1024
```

Te dará una contraseña larga. **Guárdala en Vaultwarden** como:

```text
rclone gdrive-crypt password
```

Password 2 / salt:

```text
y
g
1024
```

Guarda esa segunda también como:

```text
rclone gdrive-crypt salt
```

Luego:

```text
Edit advanced config? n
Keep this "gdrive-crypt" remote? y
q
```

## 3. Probar cifrado

```bash
echo "prueba rclone proxmox $(date)" > /root/test-rclone.txt
rclone copy /root/test-rclone.txt gdrive-crypt:test
rclone ls gdrive-crypt:test
```

Tiene que salir:

```text
test-rclone.txt
```

Si eso sale, ya hacemos la subida real de los backups.

Perfecto ✅ El cifrado ya funciona.

Ahora ya puedes subir los backups reales de Proxmox a Google Drive cifrado.

## 1. Primera subida real

En **pve > Shell**:

```bash
rclone sync /mnt/hdd250/backups/dump gdrive-crypt:proxmox-dump \
  --progress \
  --transfers=2 \
  --checkers=4 \
  --drive-chunk-size=64M \
  --log-file=/var/log/rclone-proxmox-backup.log \
  --log-level=INFO
```

Esto subirá tus backups:

```text
/mnt/hdd250/backups/dump
```

a Google Drive cifrado:

```text
gdrive-crypt:proxmox-dump
```

## 2. Comprobar después

Cuando termine:

```bash
rclone lsf gdrive-crypt:proxmox-dump | tail -30
rclone size gdrive-crypt:proxmox-dump
```

## 3. Importante

En Google Drive verás carpetas y archivos con nombres raros. Eso es correcto: están cifrados.

No pierdas las dos claves que generó rclone:

```text
rclone gdrive-crypt password
rclone gdrive-crypt salt
```

Sin esas claves no podrás restaurar desde Google Drive.


Perfecto ✅ **Subida completada correctamente a Google Drive cifrado.**

Resultado bueno:

```text
Transferred: 36 / 36, 100%
Elapsed time: 37m3.3s
Remote size: 29.202 GiB
```

Y están todos los backups en:

```text
gdrive-crypt:proxmox-dump
```

Incluidos:

```text
CT 100, 101, 102, 103, 105, 106, 107, 108
VM 104, 109
```

Lo de que durante la subida marcara `47 GiB` y luego `rclone size` diga `29.202 GiB` no me preocupa. El dato importante final es este:

```text
Total objects: 36
Total size: 29.202 GiB
```

Eso coincide bastante con tu HDD local, que tenía unos `30G` usados. La copia está bien.

Ahora deja protegida la config de rclone:

```bash
chmod 600 /root/.config/rclone/rclone.conf
cp /root/.config/rclone/rclone.conf /root/rclone.conf.backup
```

Y comprueba:

```bash
ls -lh /root/.config/rclone/rclone.conf /root/rclone.conf.backup
```

## Estado actual de backups

```text
Backup local:
PVE → /mnt/hdd250/backups/dump
Tamaño aprox: 30 GB

Backup externo cifrado:
Google Drive → gdrive-crypt:proxmox-dump
Tamaño aprox: 29.2 GiB

Cifrado:
rclone crypt activo ✅
nombres de archivos cifrados en Google Drive ✅
contenido cifrado ✅
```

## Siguiente paso recomendado

Ahora crearía un script para no tener que escribir ese comando gigante cada vez:

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
```

Luego lo podrás ejecutar así:

```bash
subir-backups-gdrive
```

Y más adelante lo programamos para que se ejecute solo después del backup semanal de Proxmox



Sí. Vamos a programarlo para que se ejecute **los domingos a las 05:00**, después del backup local de Proxmox.

En **pve > Shell**, pega esto:

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
```

Ahora el timer semanal:

```bash
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
```

Activamos:

```bash
systemctl daemon-reload
systemctl enable --now subir-backups-gdrive.timer
```

Comprueba que quedó programado:

```bash
systemctl list-timers | grep subir-backups
```

Debería salir algo parecido a:

```text
Sun ... 05:00 ... subir-backups-gdrive.timer
```

Para probar el servicio sin esperar al domingo, puedes lanzar una ejecución manual:

```bash
systemctl start subir-backups-gdrive.service
```

Y ver el resultado:

```bash
systemctl status subir-backups-gdrive.service --no-pager
tail -40 /var/log/rclone-proxmox-backup.log
```

Como ahora ya está todo sincronizado, debería terminar rápido y no subir nada nuevo pesado.






mira sabes lo q quiero que hagas, en vez de seguir haciendo cosas quiero que cojas el documento ese de realizado el txt, y te cuento eso es todo lo que tengo hasta ahor en mi servidor, como vees arriba tengo un diagrama o algo que es lo que mas o menos voy siguientdo sabes?? por q es con lo q quiero tereminar en mi servidor, a mi me interesa todo esto y lo quiero subir a mi githu, quiero q me digas que es mejor, si subirlo como una gia de como mhe ido instalado todo o mas como una documentacino o com,o un gblog contantdo como lo tengo todo montado y como lo he hecho, yo creo que es mejor poner una gia del paso a paso o hacer ambas sabes??, de contar en algun sitio como lo tengo montado y algun resumen y que me dioo errores y como solucione cosas y porque las tengo asi y porque elijé esto y no otra cosa y luego en otros documentos aparte una gia de instalacionm por applicaciones sabes? q en vez de tener que buscarlo en google o preguntarle a una ia que puede fallar, que copien y peguen mi codigio y que ya les funcione sabes?? quiero montar algo asi, de que ellos puedan hacer copia y pega y que les funcinoe, es ciero que las claves y eoss las tendrias que ominit o no mostrar y que ellos cambien en el texto por sus contraseñas o esas cosas poero me gustaria eso que me des un un zip para descargar entero con todo lo que hay q subir a github sabes? osea subirlo entero y que se vea subper bien y profesional sabes?? entonces me das un zip y yo eso lo descomprimo lo subo a github y listo ya con todos los .,d y todo eso, para la portada y cambios finales pues esta carlo que no vale con subir archivos solo luego habra que poner descripcino y todas esas cosas, pero quiero que me des todo hecho.
De momento no hagas todo lo que te he dicho arriba que solo te lo he dicho para ver si eres capaz de leer todo el prompt y razonarlo, solo quiero que el txt lo transpofrmes a .md para obsidian y que lo hagas bonito para TU y la gente que lo lea lo entienda bien, sabes?? osea demomento no voy a subir nada a gith8ub pero yo quiero tener todo esto como documentado opr si algo falla poder pasarlete este archivo y te lo subo como el reazlizados y tu miras ahi y ya puedes saber porque falla y donde tengo todos los conetenedores, q rutas y todo eso sabes?? asi es mas facil para ti y para mi saber donmde está todo entonces solo damelo meor y liesto vale??


### Portainer Agent en CT 106 Vaultwarden

En Proxmox se entra en:

```text
CT 106 vaultwarden > Consola
````

Dentro del CT 106 se ejecuta:

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

Después, desde Portainer se añade el entorno:

```text
Name: CT106-vaultwarden
Environment URL: tcp://10.10.10.60:9001
Tipo: Agent
```


### Corrección de gateway en CT 105 monitoring

El CT 105 tenía la IP correcta `10.10.10.50/24`, pero inicialmente le faltaba la ruta por defecto. Por ese motivo podía comunicarse con el gateway privado `10.10.10.87`, pero no tenía salida a Internet y los servicios de monitorización no respondían correctamente desde el CT 101 dashboard.

Se corrigió desde PVE con:


	pct set 105 -net0 name=eth0,bridge=vmbr10,firewall=1,ip=10.10.10.50/24,gw=10.10.10.87
	pct reboot 105









## Stack corregido para Portainer

En Portainer, vuelve a:

```text
CT105-monitoring
→ Stacks
→ Add stack
→ Name: cadvisor
```

Pega este compose:

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

Dale a:

```text
Deploy the stack
```

Perfecto. Entonces ya tenemos el **compose correcto definitivo** para cAdvisor:

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

Ahora falta que **Prometheus lo lea** y luego **Grafana lo pinte**.

## 1. Comprobar cAdvisor en CT105

Entra en:

```text
CT 105 monitoring > Consola
```

Pega:

```bash
docker ps | grep cadvisor
curl -I http://127.0.0.1:8089
curl -s http://127.0.0.1:8089/metrics | head -20
```

Si ves métricas tipo:

```text
# HELP
# TYPE
container_cpu
container_memory
```

está perfecto.

## 2. Añadir cAdvisor a Prometheus

En **CT105 monitoring**, pega:

```bash
cp /opt/stacks/monitoring/prometheus/prometheus.yml /opt/stacks/monitoring/prometheus/prometheus.yml.bak.$(date +%F-%H%M)

grep -q 'job_name: "cadvisor"' /opt/stacks/monitoring/prometheus/prometheus.yml || cat >> /opt/stacks/monitoring/prometheus/prometheus.yml <<'EOF'

  - job_name: "cadvisor"
    scrape_interval: 15s
    static_configs:
      - targets:
          - "10.10.10.50:8089"
        labels:
          host: "CT105-monitoring"
EOF

docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
```

Comprueba que Prometheus está sano:

```bash
curl -I http://127.0.0.1:9090/-/healthy
```

## 3. Ver si Prometheus ya ve cAdvisor

Abre:

```text
http://10.10.10.50:9090/targets
```

Busca:

```text
cadvisor
```

Tiene que salir:

```text
UP
```

También puedes comprobarlo desde consola:

```bash
curl -s http://127.0.0.1:9090/api/v1/targets | grep -o "CT105-monitoring" | head
```

## 4. Importar dashboard en Grafana

Abre:

```text
http://10.10.10.50:3002
```

Luego:

```text
Dashboards
New
Import
```

Prueba con este ID:

```text
19908
```

Selecciona datasource:

```text
Prometheus
```

Si ese dashboard no te convence, probamos otro, pero primero confirmemos que Prometheus tiene el target `cadvisor UP`.



Sí, vamos a hacerlo, pero **primero solo con CT105-monitoring** para probar. No lo metemos en todos hasta confirmar que Homarr lo ve y que te deja **start / stop / restart**.

La idea es:

```
CT105-monitoringDocker socket → socket-proxy seguro → Homarr
```

Homarr recomienda usar socket proxy en vez de montar directamente el `docker.sock`, porque el socket de Docker da control muy alto sobre el host Docker. Para poder gestionar contenedores necesita permisos de start, stop y restart; con LSIO socket-proxy se puede permitir eso con `ALLOW_START`, `ALLOW_STOP` y `ALLOW_RESTARTS` sin abrir todo con `POST=1`.

---

## 1. Crear socket-proxy en CT105 desde Portainer

En Portainer entra en:

```
CT105-monitoring→ Stacks→ Add stack
```

Nombre:

```
socket-proxy
```

Pega esto:

```
services:  socket-proxy:    image: lscr.io/linuxserver/socket-proxy:latest    container_name: socket-proxy    restart: unless-stopped    read_only: true    tmpfs:      - /run    ports:      - "10.10.10.50:2375:2375"    environment:      - CONTAINERS=1      - IMAGES=1      - INFO=1      - PING=1      - VERSION=1      - ALLOW_START=1      - ALLOW_STOP=1      - ALLOW_RESTARTS=1      - POST=0    volumes:      - /var/run/docker.sock:/var/run/docker.sock:ro
```

Pulsa:

```
Deploy the stack
```

Esto no da permiso para borrar contenedores. Solo lectura + start/stop/restart.

---

## 2. Probar desde CT101 dashboard

Entra en:

```
CT101 dashboard > Consola
```

Pega:

```
curl -s http://10.10.10.50:2375/_pingcurl -s http://10.10.10.50:2375/containers/json | head
```

Resultado bueno:

```
OK
```

y luego debería salir JSON con contenedores de CT105.



Perfecto. El socket-proxy de CT105 funciona:

```text
CT101 Homarr → CT105 socket-proxy ✅
_ping = OK ✅
Contenedores de CT105 visibles ✅
```

Y ya sabemos que el Homarr bueno es:

```text
Ruta: /opt/stacks/homarr-v1/docker-compose.yml
Contenedor: homarr-v1
Puerto: 7575
Imagen: ghcr.io/homarr-labs/homarr:latest
```

## 1. Hacer backup del compose de Homarr

En **CT101 dashboard**, pega:

```bash
cd /opt/stacks/homarr-v1
cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)
```

Ahora en **CT101 dashboard**, pega esto tal cual:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

# Quita líneas antiguas si ya existían, para no duplicarlas
lines = [
    line for line in text.splitlines()
    if "DOCKER_HOSTNAMES=" not in line and "DOCKER_PORTS=" not in line
]

out = []
inserted = False

for line in lines:
    out.append(line)

    if line.strip().startswith("- SECRET_ENCRYPTION_KEY="):
        out.append("      - DOCKER_HOSTNAMES=10.10.10.50")
        out.append("      - DOCKER_PORTS=2375")
        inserted = True

if not inserted:
    raise SystemExit("ERROR: No encontré SECRET_ENCRYPTION_KEY en el compose.")

p.write_text("\n".join(out) + "\n")
PY

echo "===== COMPOSE RESULTANTE ====="
cat docker-compose.yml

echo
echo "===== REINICIANDO HOMARR ====="
docker compose up -d

echo
echo "===== ESTADO HOMARR ====="
docker ps | grep homarr-v1

echo
echo "===== LOGS HOMARR ====="
docker logs homarr-v1 --tail=80
```

Lo que debe quedar añadido es esto dentro de `environment`:

```yaml
      - DOCKER_HOSTNAMES=10.10.10.50
      - DOCKER_PORTS=2375
```

Tu `.md` ya confirma que Homarr actual está en el CT101/dashboard y que la red `10.10.10.0/24` se alcanza desde ahí mediante la ruta a `192.168.1.87`, así que CT101 puede hablar con el socket-proxy del CT105.

Después abre:

```text
http://192.168.1.79:7575
```

y busca el widget de Docker / Docker Containers. Deberían aparecer contenedores del CT105 como:

```text
uptime-kuma
grafana
prometheus
beszel
scrutiny
cadvisor
socket-proxy
```

Prueba primero con `cadvisor` o `socket-proxy` para ver si te deja reiniciar desde Homarr. No pruebes primero con `prometheus`, `grafana` o `uptime-kuma`.





Sí, vamos a añadir **todo lo demás**, pero ahora ya con el método correcto: **socket-proxy + Homarr**, no cAdvisor/Grafana para el control diario.

Ahora mismo Homarr solo está viendo:

```text
CT105-monitoring → 10.10.10.50
```

Faltan los otros Dockers que tienes en Portainer:

```text
CT101-dashboard
CT102-portainer
VM104-casaos-nas
CT106-vaultwarden
CT107-paperless
CT108-nextcloud
VM109-immich
```

No tocaría de momento **CT100 Tailscale Gateway** ni **CT103 DNS/AdGuard**, porque son servicios más críticos de red. Luego, si quieres, los añadimos también con más cuidado. El `.md` limpio ya tiene documentados estos CT/VM y sus IPs reales, así que seguimos ese mapa.

---

## 1. Crear `socket-proxy` en cada environment de Portainer

En Portainer entra en cada environment:

```text
CT101-dashboard
CT102-portainer
VM104-casaos-nas
CT106-vaultwarden
CT107-paperless
CT108-nextcloud
VM109-immich
```

En cada uno haz:

```text
Stacks > Add stack
Name: socket-proxy
```

Y pega el compose correspondiente según la IP.

---

## CT101-dashboard — 192.168.1.79

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
      - "192.168.1.79:2375:2375"
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

---

## CT102-portainer — 192.168.1.80

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
      - "192.168.1.80:2375:2375"
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

---

## VM104-casaos-nas — 192.168.1.81

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
      - "192.168.1.81:2375:2375"
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

---

## CT106-vaultwarden — 10.10.10.60

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
      - "10.10.10.60:2375:2375"
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

---

## CT107-paperless — 10.10.10.40

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
      - "10.10.10.40:2375:2375"
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

---

## CT108-nextcloud — 10.10.10.65

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
      - "10.10.10.65:2375:2375"
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

---

## VM109-immich — 10.10.10.30

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
      - "10.10.10.30:2375:2375"
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

---

## 2. Comprobar desde CT101 dashboard

Cuando hayas creado esos stacks, entra en:

```text
CT101 dashboard > Consola
```

Pega:

```bash
for ip in 192.168.1.79 192.168.1.80 192.168.1.81 10.10.10.50 10.10.10.60 10.10.10.40 10.10.10.65 10.10.10.30; do
  echo "===== $ip ====="
  curl -s --max-time 5 "http://$ip:2375/_ping" || echo "NO RESPONDE"
  echo
done
```

Lo bueno sería ver:

```text
OK
OK
OK
OK
OK
OK
OK
OK
```

---

## 3. Actualizar Homarr con todos los Docker remotos

Cuando todos respondan `OK`, en **CT101 dashboard** pega esto:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

hosts = "192.168.1.79,192.168.1.80,192.168.1.81,10.10.10.50,10.10.10.60,10.10.10.40,10.10.10.65,10.10.10.30"
ports = "2375,2375,2375,2375,2375,2375,2375,2375"

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

---

## 4. Resultado esperado en Homarr

Después de reiniciar Homarr, el widget de Docker debería poder mostrar contenedores de:

```text
CT101-dashboard
CT102-portainer
VM104-casaos-nas
CT105-monitoring
CT106-vaultwarden
CT107-paperless
CT108-nextcloud
VM109-immich
```

Y deberías ver:


	Nombre del contenedor
	Estado
	CPU
	RAM
	Stop
	Restart


______


Sí. Ahora hacemos **la parte de Grafana/cAdvisor en todos**, pero sabiendo ya esto:

```text
Homarr + socket-proxy = control diario sencillo.
Grafana + cAdvisor = gráficas e histórico.
```

Como tu `.md` ya tiene todos los CT/VM Docker principales y sus IPs, vamos a usar ese mapa: CT101, CT102, VM104, CT105, CT106, CT107, CT108 y VM109. No tocaría CT100 ni CT103 de momento porque son gateway/DNS.

## 1. Instalar cAdvisor en cada environment de Portainer

Ya lo tienes en:

```text
CT105-monitoring → 10.10.10.50 ✅
```

Ahora repite esto en Portainer en cada uno:

```text
CT101-dashboard
CT102-portainer
VM104-casaos-nas
CT106-vaultwarden
CT107-paperless
CT108-nextcloud
VM109-immich
```

Ruta:

```text
Portainer > Environment > Stacks > Add stack
Name: cadvisor
```

Pega siempre este mismo compose:

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

Cuando termines, desde **CT101 dashboard** comprueba:

```bash
for ip in 192.168.1.79 192.168.1.80 192.168.1.81 10.10.10.50 10.10.10.60 10.10.10.40 10.10.10.65 10.10.10.30; do
  echo "===== $ip cAdvisor ====="
  curl -s --max-time 5 "http://$ip:8089/metrics" | head -2 || echo "NO RESPONDE"
  echo
done
```

Lo bueno es ver líneas tipo:

```text
# HELP ...
# TYPE ...
```

---

## 2. Actualizar Prometheus con todos los cAdvisor

Entra en:

```text
CT105 monitoring > Consola
```

Pega esto:

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

echo
echo "===== HEALTH ====="
curl -I http://127.0.0.1:9090/-/healthy
```

---

## 3. Ver targets en Prometheus

Abre:

```text
http://10.10.10.50:9090/targets
```

Busca:

```text
cadvisor
```

Deberías ver 8 targets.

Estado ideal:

```text
CT105-monitoring   UP
CT101-dashboard    UP
CT102-portainer    UP
VM104-casaos-nas   UP
CT106-vaultwarden  UP
CT107-paperless    UP
CT108-nextcloud    UP
VM109-immich       UP
```

Si alguno sale `DOWN`, me pasas cuál y lo corregimos.

---

## 4. Grafana

Tu dashboard de Grafana ya funciona. Cuando Prometheus tenga todos los targets, ese mismo dashboard empezará a mostrar contenedores de todos los hosts.

Abre:

```text
http://10.10.10.50:3002
```

Dashboard:

```text
cAdvisor Docker Insights
```

Pon rango:

```text
Last 15 minutes
```

y refresco:

```text
5s o 10s
```




Perfecto. Lo siguiente planeado era el **CT110-tools**.

Lo haremos limpio así:

```text
CT110-tools - 10.10.10.70
├── IT-Tools
├── Stirling PDF
├── Portainer Agent
├── socket-proxy para Homarr
└── cAdvisor para Grafana/Prometheus
```

No metemos aquí pgAdmin/Adminer porque eso lo dejamos para un futuro CT de bases de datos. Seguimos la lógica de tu `.md`: apps privadas en `vmbr10`, gateway `10.10.10.87`, Docker por CT/VM, Portainer Agent, Homarr, Kuma y backups.

---

## 1. Crear CT 110 en Proxmox

En Proxmox crea un CT nuevo:

```text
CT ID: 110
Hostname: tools
Plantilla: debian-13-standard
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Disco: 16 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.70/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Cuando arranque, entra en:

```text
CT 110 tools > Consola
```

Y pega:

```bash
ip -br a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Tiene que salir:

```text
10.10.10.70/24
default via 10.10.10.87
ping 10.10.10.87 OK
ping 1.1.1.1 OK
ping google.com OK
```

---

## 2. Instalar Docker en CT110

Dentro de **CT110 tools**, pega:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

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
systemctl is-active docker
```

---

## 3. Instalar Portainer Agent en CT110

Esto sí lo hacemos por consola, para poder añadir el CT a Portainer.

Dentro de **CT110 tools**, pega:

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

Ahora entra en **CT102 portainer > Consola** y comprueba:

```bash
ping -c 2 10.10.10.70
timeout 5 bash -c "cat < /dev/null > /dev/tcp/10.10.10.70/9001" && echo "Agent OK" || echo "Agent NO responde"
```

En Portainer añade el entorno:

```text
Name: CT110-tools
Environment URL: tcp://10.10.10.70:9001
Tipo: Agent
```

---

## 4. Crear stack `tools` desde Portainer

Ahora en Portainer:

```text
CT110-tools
→ Stacks
→ Add stack
```

Nombre:

```text
tools
```

Pega este compose:

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

Pulsa:

```text
Deploy the stack
```

Accesos:

```text
IT-Tools:     http://10.10.10.70:8080
Stirling PDF: http://10.10.10.70:8081
```

---

## 5. Crear `socket-proxy` desde Portainer

En Portainer:

```text
CT110-tools
→ Stacks
→ Add stack
```

Nombre:

```text
socket-proxy
```

Compose:

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
      - "10.10.10.70:2375:2375"
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

Deploy.

Desde **CT101 dashboard**, comprueba:

```bash
curl -s http://10.10.10.70:2375/_ping
curl -s http://10.10.10.70:2375/containers/json | grep -o '"Names":\[[^]]*\]' | head
```

Debe salir:

```text
OK
```

y contenedores como:

```text
it-tools
stirling-pdf
portainer-agent
socket-proxy
```

---

## 6. Crear `cadvisor` desde Portainer

En Portainer:

```text
CT110-tools
→ Stacks
→ Add stack
```

Nombre:

```text
cadvisor
```

Compose:

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

Deploy.

Desde **CT101 dashboard**, comprueba:

```bash
curl -s --max-time 5 http://10.10.10.70:8089/metrics | head -5
```

Debe salir algo tipo:

```text
# HELP ...
# TYPE ...
```

---

## 7. Añadir CT110 a Homarr

En **CT101 dashboard**, pega esto para añadir `10.10.10.70` a la lista de Docker remotos de Homarr:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

hosts = "192.168.1.79,192.168.1.80,192.168.1.81,10.10.10.50,10.10.10.60,10.10.10.40,10.10.10.65,10.10.10.30,10.10.10.70"
ports = "2375,2375,2375,2375,2375,2375,2375,2375,2375"

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
    raise SystemExit("ERROR: No encontré SECRET_ENCRYPTION_KEY.")

p.write_text("\n".join(out) + "\n")
PY

docker compose up -d
docker logs homarr-v1 --tail=50
```

Luego en Homarr debería aparecer también CT110 con:

```text
it-tools
stirling-pdf
cadvisor
socket-proxy
portainer-agent
```

---

## 8. Añadir CT110 a Prometheus

En **CT105 monitoring**, pega:

```bash
cp /opt/stacks/monitoring/prometheus/prometheus.yml /opt/stacks/monitoring/prometheus/prometheus.yml.bak.$(date +%F-%H%M)

grep -q "10.10.10.70:8089" /opt/stacks/monitoring/prometheus/prometheus.yml || python3 - <<'PY'
from pathlib import Path

p = Path("/opt/stacks/monitoring/prometheus/prometheus.yml")
text = p.read_text()

needle = '''      - targets:
          - "10.10.10.30:8089"
        labels:
          host: "VM109-immich"'''

insert = needle + '''

      - targets:
          - "10.10.10.70:8089"
        labels:
          host: "CT110-tools"'''

if needle not in text:
    raise SystemExit("ERROR: No encontré el bloque VM109-immich. Pásame el prometheus.yml.")

text = text.replace(needle, insert)
p.write_text(text)
PY

docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
sleep 15
curl -I http://127.0.0.1:9090/-/healthy
```

Comprueba en:

```text
http://10.10.10.50:9090/targets
```

Debe aparecer:

```text
CT110-tools → 10.10.10.70:8089 → UP
```

---

## 9. Añadir a Homarr y Kuma como apps

En Homarr añade estas apps visuales:

```text
IT-Tools
URL: http://10.10.10.70:8080
Health: HTTP
```

```text
Stirling PDF
URL: http://10.10.10.70:8081
Health: HTTP
```

En Uptime Kuma añade:

```text
IT-Tools → http://10.10.10.70:8080
Stirling PDF → http://10.10.10.70:8081
```

---

## 10. Añadir CT110 al backup

En Proxmox:

```text
Datacenter > Backup > tarea semanal > Edit
```

Añade:

```text
110
```

La lista queda:

```text
100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110
```






Sí: **primero CT113-databases**.  
Y sobre lo del proxy: **sí, el reverse proxy lo haría antes de Keycloak**, pero **no hace falta antes del CT de bases de datos**. Keycloak sí agradecerá tener nombres tipo `auth.home`/HTTPS; databases puede ir perfectamente por IP privada.

Tu patrón bueno queda así: apps privadas en `vmbr10`, gateway `10.10.10.87`, Docker por CT, Portainer Agent, Homarr, Kuma, cAdvisor y backup. Eso encaja con la estructura actual de tu `.md`.

Vamos con:

```text
CT113-databases - 10.10.10.73
├── PostgreSQL lab
├── MariaDB lab
├── Redis lab
├── Adminer
├── pgAdmin
├── Portainer Agent
├── socket-proxy
└── cAdvisor
```

PostgreSQL usa `POSTGRES_PASSWORD` como variable clave, MariaDB usa `MARIADB_ROOT_PASSWORD`, y pgAdmin necesita `PGADMIN_DEFAULT_EMAIL` y `PGADMIN_DEFAULT_PASSWORD` al arrancar. ([hub.docker.com](https://hub.docker.com/_/postgres?utm_source=chatgpt.com "postgres - Official Image"))

---

Sí: **primero CT113-databases**.  
Y sobre lo del proxy: **sí, el reverse proxy lo haría antes de Keycloak**, pero **no hace falta antes del CT de bases de datos**. Keycloak sí agradecerá tener nombres tipo `auth.home`/HTTPS; databases puede ir perfectamente por IP privada.

Tu patrón bueno queda así: apps privadas en `vmbr10`, gateway `10.10.10.87`, Docker por CT, Portainer Agent, Homarr, Kuma, cAdvisor y backup. Eso encaja con la estructura actual de tu `.md`.

Vamos con:

```text
CT113-databases - 10.10.10.73
├── PostgreSQL lab
├── MariaDB lab
├── Redis lab
├── Adminer
├── pgAdmin
├── Portainer Agent
├── socket-proxy
└── cAdvisor
```

PostgreSQL usa `POSTGRES_PASSWORD` como variable clave, MariaDB usa `MARIADB_ROOT_PASSWORD`, y pgAdmin necesita `PGADMIN_DEFAULT_EMAIL` y `PGADMIN_DEFAULT_PASSWORD` al arrancar. ([hub.docker.com](https://hub.docker.com/_/postgres?utm_source=chatgpt.com "postgres - Official Image"))

---

## 1. Crear CT 113 en Proxmox

Crea un CT nuevo:

```text
CT ID: 113
Hostname: databases
Plantilla: debian-13-standard
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Disco: 24 GB
CPU: 1 core
RAM: 2048 MB
Swap: 1024 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.73/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Entra en:

```text
CT 113 databases > Consola
```

Pega:

```bash
ip -br a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

---

## 2. Instalar Docker en CT113

Dentro de **CT113 databases**, pega:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

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
systemctl is-active docker
```

---

## 3. Crear contraseñas y carpetas

Dentro de **CT113 databases**, pega:

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

PGADMIN_DEFAULT_EMAIL=guillermo@homelab.local
PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/databases/.env
cp /opt/stacks/databases/.env /root/CT113-databases-passwords.txt

echo "===== GUARDA ESTO EN VAULTWARDEN ====="
cat /root/CT113-databases-passwords.txt
```

Guarda esas contraseñas en Vaultwarden.

---

## 4. Instalar Portainer Agent

Dentro de **CT113 databases**, pega:

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

Desde **CT102 portainer > Consola**, comprueba:

```bash
ping -c 2 10.10.10.73
timeout 5 bash -c "cat < /dev/null > /dev/tcp/10.10.10.73/9001" && echo "Agent OK" || echo "Agent NO responde"
```

En Portainer añade:

```text
Name: CT113-databases
Environment URL: tcp://10.10.10.73:9001
Tipo: Agent
```

---

## 5. Crear stack `databases` desde Portainer

En Portainer:

```text
CT113-databases
→ Stacks
→ Add stack
```

Nombre:

```text
databases
```

Pega este compose:

```yaml
services:
  postgres:
    image: postgres:17
    container_name: lab-postgres
    restart: unless-stopped
    env_file:
      - /opt/stacks/databases/.env
    ports:
      - "10.10.10.73:5432:5432"
    volumes:
      - /opt/stacks/databases/postgres:/var/lib/postgresql/data

  mariadb:
    image: mariadb:11
    container_name: lab-mariadb
    restart: unless-stopped
    env_file:
      - /opt/stacks/databases/.env
    ports:
      - "10.10.10.73:3306:3306"
    volumes:
      - /opt/stacks/databases/mariadb:/var/lib/mysql

  redis:
    image: redis:7-alpine
    container_name: lab-redis
    restart: unless-stopped
    env_file:
      - /opt/stacks/databases/.env
    command: sh -c 'redis-server --appendonly yes --requirepass "$$REDIS_PASSWORD"'
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
      - ADMINER_DEFAULT_SERVER=postgres

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin
    restart: unless-stopped
    env_file:
      - /opt/stacks/databases/.env
    ports:
      - "8082:80"
    environment:
      - TZ=Europe/Madrid
    volumes:
      - /opt/stacks/databases/pgadmin:/var/lib/pgadmin
```

Pulsa:

```text
Deploy the stack
```

Accesos:

```text
Adminer: http://10.10.10.73:8080
pgAdmin: http://10.10.10.73:8082

PostgreSQL: 10.10.10.73:5432
MariaDB:    10.10.10.73:3306
Redis:      10.10.10.73:6379
```

---

## 6. Comprobar desde CT113

Dentro de **CT113 databases**, pega:

```bash
source /opt/stacks/databases/.env

echo "===== CONTENEDORES ====="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
echo "===== POSTGRES ====="
docker exec lab-postgres pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"

echo
echo "===== MARIADB ====="
docker exec lab-mariadb mariadb-admin ping -uroot -p"$MARIADB_ROOT_PASSWORD"

echo
echo "===== REDIS ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" ping

echo
echo "===== WEB ====="
curl -I http://127.0.0.1:8080
curl -I http://127.0.0.1:8082
```

---

## 7. socket-proxy para Homarr

En Portainer:

```text
CT113-databases
→ Stacks
→ Add stack
```

Nombre:

```text
socket-proxy
```

Compose:

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
      - "10.10.10.73:2375:2375"
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

Desde **CT101 dashboard**, comprueba:

```bash
curl -s http://10.10.10.73:2375/_ping
curl -s http://10.10.10.73:2375/containers/json | grep -o '"Names":\[[^]]*\]' | head
```

---

## 8. cAdvisor para Grafana

En Portainer:

```text
CT113-databases
→ Stacks
→ Add stack
```

Nombre:

```text
cadvisor
```

Compose:

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

Desde **CT101 dashboard**, comprueba:

```bash
curl -s --max-time 5 http://10.10.10.73:8089/metrics | head -5
```

---

## 9. Cuando esto funcione

Después añadimos:

```text
Homarr:
Adminer
pgAdmin
CT113 Docker remoto

Uptime Kuma:
Adminer
pgAdmin
PostgreSQL puerto 5432
MariaDB puerto 3306
Redis puerto 6379

Prometheus:
CT113-databases → 10.10.10.73:8089

Backup Proxmox:
añadir CT 113
```

Haz hasta el **paso 6** y pásame la salida de comprobación. Así vemos si Postgres, MariaDB, Redis, Adminer y pgAdmin están bien antes de meter Homarr/Grafana.



me dio este error oprque estaba mal : Failed to deploy a stack: failed to create compose project: failed to resolve services environment: env file /opt/stacks/databases/.env not found: stat /opt/stacks/databases/.env: no such file or directory

no era ct113 era ct 111

Eso significa una cosa muy simple: **Portainer está intentando desplegar el stack en CT113, pero dentro de CT113 no existe todavía este archivo**:

```text
/opt/stacks/databases/.env
```

No es fallo del compose. Falta crear el `.env` en el **CT113 databases** antes de darle a Deploy. La guía sigue el patrón de crear cada servicio dentro de su CT/VM y luego gestionarlo con Portainer.

## 1. Entra en CT113 databases

En Proxmox:

```text
CT 113 databases > Consola
```

O desde PVE Shell:

```bash
pct enter 113
```

Comprueba que estás en el CT correcto:

```bash
hostname
ip -br a
```

Debe salir algo tipo:

```text
databases
10.10.10.73/24
```

## 2. Crea el `.env` y carpetas

Pega esto **dentro de CT113 databases**:

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

PGADMIN_DEFAULT_EMAIL=guillermo@homelab.local
PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/databases/.env
cp /opt/stacks/databases/.env /root/CT113-databases-passwords.txt

echo "===== ARCHIVO .env CREADO ====="
ls -lah /opt/stacks/databases/.env

echo
echo "===== GUARDA ESTO EN VAULTWARDEN ====="
cat /root/CT113-databases-passwords.txt
```

Guarda esas contraseñas en Vaultwarden.

## 3. Verifica que existe

Dentro de CT113:

```bash
cat /opt/stacks/databases/.env
```

Si lo ves, ya está.

## 4. Vuelve a Portainer y despliega otra vez

Ahora vuelve a:

```text
Portainer
→ CT113-databases
→ Stacks
→ databases
→ Deploy the stack
```

O si el stack fallido quedó medio creado, bórralo y créalo otra vez con el mismo compose.

## Resumen

```text
Problema: faltaba /opt/stacks/databases/.env
Dónde se arregla: dentro de CT113 databases
Solución: crear el .env y volver a desplegar desde Portainer
```

Después del deploy, pásame la salida de:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```
Vale, perfecto. Entonces corregimos la nomenclatura:

```text
CT111-databases
IP: 10.10.10.73
```

El problema sigue siendo el mismo: **dentro del CT111 no existe `/opt/stacks/databases/.env`**. Tienes que crearlo dentro de **CT111 databases**, no en otro CT.

Tu `.md` ya sigue la lógica de CT/VM separados por función y apps privadas en `vmbr10` con gateway `10.10.10.87`, así que mantener `10.10.10.73` para databases está bien aunque el ID sea `111`.

## 1. Entra en CT111 databases

En Proxmox:

```text
CT 111 databases > Consola
```

Comprueba que estás en el CT correcto:

```bash
hostname
ip -br a
ip route
```

Debe ser algo parecido a:

```text
databases
10.10.10.73/24
default via 10.10.10.87
```

## 2. Crea el `.env` en CT111

Pega esto dentro de **CT111 databases**:

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

PGADMIN_DEFAULT_EMAIL=guillermo@gmail.com
PGADMIN_DEFAULT_PASSWORD=$PGADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/databases/.env
cp /opt/stacks/databases/.env /root/CT111-databases-passwords.txt

echo "===== ARCHIVO .env CREADO ====="
ls -lah /opt/stacks/databases/.env

echo
echo "===== GUARDA ESTO EN VAULTWARDEN ====="
cat /root/CT111-databases-passwords.txt
```

Guarda esas contraseñas en Vaultwarden.

## 3. Vuelve a Portainer y despliega otra vez

En Portainer:

```text
CT111-databases
→ Stacks
→ databases
→ Deploy the stack
```

Si el stack fallido quedó creado, bórralo y créalo otra vez con el mismo compose.

## 4. A partir de ahora cambiamos todo a CT111

Donde yo puse antes:

```text
CT113-databases
```

realmente queda:

```text
CT111-databases
```

Y los nombres finales serán:

```text
Portainer:
CT111-databases → tcp://10.10.10.73:9001

Homarr socket-proxy:
10.10.10.73:2375

Prometheus cAdvisor:
10.10.10.73:8089

Backup Proxmox:
añadir CT 111
```

Cuando despliegue bien, pásame:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```



## 2. Crea el stack otra vez

```text
CT111-databases
→ Stacks
→ Add stack
```

Nombre:

```text
databases
```

Pega **exactamente este compose**, sin añadir `env_file`:

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

## 3. En variables de entorno de Portainer

Abajo, donde pone **Environment variables**, pega el contenido real del `.env`, no la ruta.

Para verlo, en **CT111 databases** ejecuta:

```bash
grep -v '^$' /opt/stacks/databases/.env
```

Copia lo que salga, que tendrá esta forma:

```env
POSTGRES_DB=labdb
POSTGRES_USER=guillermo
POSTGRES_PASSWORD=xxxxxxxx
MARIADB_ROOT_PASSWORD=xxxxxxxx
MARIADB_DATABASE=labdb
MARIADB_USER=guillermo
MARIADB_PASSWORD=xxxxxxxx
REDIS_PASSWORD=xxxxxxxx
PGADMIN_DEFAULT_EMAIL=guillermo@gmail.com
PGADMIN_DEFAULT_PASSWORD=xxxxxxxx
```

Eso lo pegas en Portainer en **Environment variables / Advanced mode**.

No pegues esto:

```text
/opt/stacks/databases/.env
```

## 4. Deploy

Ahora dale a:

```text
Deploy the stack
```

Si te vuelve a salir `/opt/stacks/databases/.env not found`, es que todavía queda algún `env_file:` en el compose. Tiene que estar totalmente eliminado.




docker stop pgadmin

mkdir -p /opt/stacks/databases/pgadmin
chown -R 5050:5050 /opt/stacks/databases/pgadmin
chmod -R 750 /opt/stacks/databases/pgadmin

docker start pgadmin

sleep 20

docker ps -a | grep pgadmin
docker logs pgadmin --tail=40
curl -I http://127.0.0.1:8082


para sacar la contraseña de las BBDD:
echo "===== CONTRASEÑAS CT111 DATABASES ====="
cat /opt/stacks/databases/.env





Sí, vamos bien. Pero aclaro una cosa:

No hemos creado “muchas bases de datos” como tal. Hemos creado **3 motores/servicios de base de datos** y **2 herramientas web**:

```text
PostgreSQL  → motor de BD relacional
MariaDB     → motor de BD relacional tipo MySQL
Redis       → base de datos en memoria / caché clave-valor
Adminer     → web para conectarte a PostgreSQL/MariaDB
pgAdmin     → web específica para PostgreSQL
```

Y sí: antes de meter ChartDB o lo de diagramas, vamos a comprobar **todo CT111-databases completo**.

## Pega esto en CT111 databases

```bash
source /opt/stacks/databases/.env

echo "===== 1. CONTENEDORES CT111 ====="
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo
echo "===== 2. POSTGRESQL - CONEXION ====="
docker exec -e PGPASSWORD="$POSTGRES_PASSWORD" lab-postgres \
  psql -h 127.0.0.1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" \
  -c "SELECT current_user, current_database(), version();"

echo
echo "===== 3. POSTGRESQL - TABLA DE PRUEBA ====="
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
echo "===== 4. MARIADB - CONEXION ====="
docker exec lab-mariadb mariadb \
  -u"$MARIADB_USER" \
  -p"$MARIADB_PASSWORD" \
  "$MARIADB_DATABASE" \
  -e "SELECT USER(), DATABASE(), VERSION();"

echo
echo "===== 5. MARIADB - TABLA DE PRUEBA ====="
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
echo "===== 6. REDIS - PING ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" ping

echo
echo "===== 7. REDIS - SET / GET ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" SET prueba_redis "Redis funciona desde CT111"
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" GET prueba_redis

echo
echo "===== 8. REDIS - INFO BASICO ====="
docker exec lab-redis redis-cli -a "$REDIS_PASSWORD" INFO server | grep -E "redis_version|tcp_port|uptime_in_seconds"

echo
echo "===== 9. ADMINER WEB ====="
curl -I http://127.0.0.1:8080

echo
echo "===== 10. PGADMIN WEB ====="
curl -I http://127.0.0.1:8082

echo
echo "===== 11. PUERTOS ABIERTOS ====="
ss -lntp | grep -E "5432|3306|6379|8080|8082|9001" || true
```

## Resultado esperado

Tiene que salir algo así:

```text
PostgreSQL:
current_user = guillermo
current_database = labdb
tabla prueba_postgres creada ✅

MariaDB:
USER() = guillermo
DATABASE() = labdb
tabla prueba_mariadb creada ✅

Redis:
PONG
"Redis funciona desde CT111" ✅

Adminer:
HTTP/1.1 200 OK ✅

pgAdmin:
HTTP/1.1 302 FOUND /login ✅
```

## Después de esto

Si todo sale bien, cerramos CT111 con:

```text
socket-proxy para Homarr
cAdvisor para Grafana
Adminer y pgAdmin en Homarr
monitores en Uptime Kuma
CT111 en backup Proxmox
documentación en el .md
```

Y lo de “crear bases de datos en diagrama” es **ChartDB**. Lo metemos después de comprobar todo esto, porque tiene sentido añadirlo justo en este CT de databases. El esquema del `.md` ya separa los CT por función, así que CT111-databases es el sitio correcto para estas herramientas de BD.


Perfecto. **CT111-databases funciona completo.**

Queda confirmado:

```text
PostgreSQL ✅
- Contenedor levantado
- Login correcto con usuario guillermo
- Base labdb correcta
- Tabla prueba_postgres creada
- INSERT correcto

MariaDB ✅
- Contenedor levantado
- Login correcto con usuario guillermo
- Base labdb correcta
- Tabla prueba_mariadb creada
- INSERT correcto

Redis ✅
- PING responde PONG
- SET funciona
- GET funciona

Adminer ✅
- HTTP/1.1 200 OK

pgAdmin ✅
- HTTP/1.1 302 FOUND hacia /login

Portainer Agent ✅
- Puerto 9001 activo
```

Lo de los puertos también está perfecto:

```text
PostgreSQL: 10.10.10.73:5432
MariaDB:    10.10.10.73:3306
Redis:      10.10.10.73:6379
Adminer:    http://10.10.10.73:8080
pgAdmin:    http://10.10.10.73:8082
Agent:      tcp://10.10.10.73:9001
```

Ahora cerramos integración.

## 1. Crear socket-proxy en CT111

En Portainer:

```text
CT111-databases
→ Stacks
→ Add stack
```

Nombre:

```text
socket-proxy
```

Compose:

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
      - "10.10.10.73:2375:2375"
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

Deploy.

Luego en **CT101 dashboard**:

```bash
curl -s http://10.10.10.73:2375/_ping
curl -s http://10.10.10.73:2375/containers/json | grep -o '"Names":\[[^]]*\]' | head
```

Tiene que salir `OK`.

## 2. Crear cAdvisor en CT111

En Portainer:

```text
CT111-databases
→ Stacks
→ Add stack
```

Nombre:

```text
cadvisor
```

Compose:

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

Deploy.

Luego en **CT101 dashboard**:

```bash
curl -s --max-time 5 http://10.10.10.73:8089/metrics | head -5
```

Tiene que salir `# HELP` o `# TYPE`.

## 3. Añadir CT111 a Homarr remoto

En **CT101 dashboard**, pega:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)

python3 - <<'PY'
from pathlib import Path

new_host = "10.10.10.73"
new_port = "2375"

p = Path("docker-compose.yml")
text = p.read_text()

lines = text.splitlines()
hosts_line = None
ports_line = None

for line in lines:
    if "DOCKER_HOSTNAMES=" in line:
        hosts_line = line
    if "DOCKER_PORTS=" in line:
        ports_line = line

if hosts_line and ports_line:
    old_hosts = hosts_line.split("DOCKER_HOSTNAMES=", 1)[1].strip()
    old_ports = ports_line.split("DOCKER_PORTS=", 1)[1].strip()

    hosts = old_hosts.split(",") if old_hosts else []
    ports = old_ports.split(",") if old_ports else []

    if new_host not in hosts:
        hosts.append(new_host)
        ports.append(new_port)

    text = text.replace(hosts_line, "      - DOCKER_HOSTNAMES=" + ",".join(hosts))
    text = text.replace(ports_line, "      - DOCKER_PORTS=" + ",".join(ports))
else:
    raise SystemExit("ERROR: No encontré DOCKER_HOSTNAMES/DOCKER_PORTS.")

p.write_text(text + ("\n" if not text.endswith("\n") else ""))
PY

docker compose up -d
docker logs homarr-v1 --tail=50
```

## 4. Añadir CT111 a Prometheus

En **CT105 monitoring**, pega:

```bash
cp /opt/stacks/monitoring/prometheus/prometheus.yml /opt/stacks/monitoring/prometheus/prometheus.yml.bak.$(date +%F-%H%M)

grep -q "10.10.10.73:8089" /opt/stacks/monitoring/prometheus/prometheus.yml || cat >> /opt/stacks/monitoring/prometheus/prometheus.yml <<'EOF'

      - targets:
          - "10.10.10.73:8089"
        labels:
          host: "CT111-databases"
EOF

docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
sleep 15
curl -I http://127.0.0.1:9090/-/healthy
```

Luego mira:

```text
http://10.10.10.50:9090/targets
```

Debe aparecer:

```text
CT111-databases → UP
```

## 5. Añadir apps a Homarr y Kuma

En Homarr:

```text
Adminer
URL: http://10.10.10.73:8080
Health: HTTP
```

```text
pgAdmin
URL: http://10.10.10.73:8082
Health: HTTP
```

En Uptime Kuma:

```text
Adminer → HTTP(s) → http://10.10.10.73:8080
pgAdmin → HTTP(s) → http://10.10.10.73:8082
PostgreSQL → TCP Port → 10.10.10.73:5432
MariaDB → TCP Port → 10.10.10.73:3306
Redis → TCP Port → 10.10.10.73:6379
```






Perfecto, vamos a ello. Empezamos con **reverse proxy interno** antes de Keycloak.

Usaremos **Nginx Proxy Manager** porque es visual, fácil de manejar y encaja bien con tu forma de trabajar. Su documentación oficial usa Docker con los puertos `80`, `81` y `443`, y explica que el puerto `81` es la interfaz de administración. ([nginxproxymanager.com](https://nginxproxymanager.com/guide/ "Guide | Nginx Proxy Manager"))

## Decisión importante de red

No lo pondría solo en `10.10.10.0/24`. Lo pondría en LAN:

```text
CT112-proxy - 192.168.1.82
```

Y dentro del CT añadimos ruta hacia la red privada:

```text
10.10.10.0/24 via 192.168.1.87
```

Así consigues esto:

```text
Tu PC / móvil en casa → 192.168.1.82 proxy
Proxy → servicios privados 10.10.10.x
```

Si pusiéramos el proxy solo en `10.10.10.74`, algunos dispositivos de casa podrían no llegar si no tienen Tailscale o ruta hacia `10.10.10.0/24`.

Usaremos dominio interno:

```text
home.arpa
```

`home.arpa` está reservado para uso en redes domésticas/residenciales, así que es mejor que `.local` o nombres inventados. ([RFC Editor](https://www.rfc-editor.org/rfc/rfc8375.html?utm_source=chatgpt.com "RFC 8375: Special-Use Domain 'home.arpa.'"))

---

# 1. Crear CT112 proxy

En Proxmox crea un CT:

```text
CT ID: 112
Hostname: proxy
Plantilla: debian-13-standard
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Disco: 12 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Bridge: vmbr0
IPv4/CIDR: 192.168.1.82/24
Gateway: 192.168.1.1
DNS: 1.1.1.1
```

Entra en:

```text
CT112 proxy > Consola
```

Y pega:

```bash
ip -br a
ip route
ping -c 3 192.168.1.1
ping -c 3 1.1.1.1
ping -c 3 google.com
```

---

# 2. Añadir ruta hacia red privada

Dentro de **CT112 proxy**, pega:

```bash
ip route add 10.10.10.0/24 via 192.168.1.87 || true

cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF

ip route
```

Prueba acceso a servicios privados:

```bash
ping -c 2 10.10.10.50
ping -c 2 10.10.10.73
curl -I http://10.10.10.73:8080
curl -I http://10.10.10.50:3002/api/health
```

Si eso responde, el proxy podrá llegar a Grafana, Adminer, pgAdmin, etc.

---

# 3. Instalar Docker en CT112

Dentro de **CT112 proxy**, pega:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

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
systemctl is-active docker
```

---

# 4. Instalar Portainer Agent

Dentro de **CT112 proxy**, pega:

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

Desde **CT102 portainer > Consola**:

```bash
ping -c 2 192.168.1.82
timeout 5 bash -c "cat < /dev/null > /dev/tcp/192.168.1.82/9001" && echo "Agent OK" || echo "Agent NO responde"
```

En Portainer añade:

```text
Name: CT112-proxy
Environment URL: tcp://192.168.1.82:9001
Tipo: Agent
```

---

# 5. Crear stack Nginx Proxy Manager desde Portainer

En Portainer:

```text
CT112-proxy
→ Stacks
→ Add stack
```

Nombre:

```text
nginx-proxy-manager
```

Compose:

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

Deploy.

Acceso:

```text
http://192.168.1.82:81
```

Credenciales iniciales habituales:

```text
Email: admin@example.com
Password: changeme
```

Al entrar, cambia el email y la contraseña.

---

# 6. Crear DNS rewrites en AdGuard

En AdGuard:

```text
Filters / Filtros
→ DNS rewrites / Reescrituras DNS
```

Crea estos apuntando al proxy:

```text
homarr.home.arpa      → 192.168.1.82
portainer.home.arpa   → 192.168.1.82
grafana.home.arpa     → 192.168.1.82
kuma.home.arpa        → 192.168.1.82
adminer.home.arpa     → 192.168.1.82
pgadmin.home.arpa     → 192.168.1.82
chartdb.home.arpa     → 192.168.1.82
tools.home.arpa       → 192.168.1.82
pdf.home.arpa         → 192.168.1.82
nextcloud.home.arpa   → 192.168.1.82
paperless.home.arpa   → 192.168.1.82
vault.home.arpa       → 192.168.1.82
immich.home.arpa      → 192.168.1.82
auth.home.arpa        → 192.168.1.82
```

Después, desde tu PC o desde CT101:

```bash
nslookup grafana.home.arpa 192.168.1.53
nslookup adminer.home.arpa 192.168.1.53
```

Debe devolver:

```text
192.168.1.82
```

---

# 7. Primeras rutas en Nginx Proxy Manager

Dentro de NPM:

```text
Hosts
→ Proxy Hosts
→ Add Proxy Host
```

Prueba primero con servicios fáciles.

## Adminer

```text
Domain Names:
adminer.home.arpa

Scheme:
http

Forward Hostname / IP:
10.10.10.73

Forward Port:
8080

Websockets Support:
activado si aparece

Block Common Exploits:
activado
```

Guardar.

Prueba:

```text
http://adminer.home.arpa
```

## Grafana

```text
Domain Names:
grafana.home.arpa

Scheme:
http

Forward Hostname / IP:
10.10.10.50

Forward Port:
3002

Websockets Support:
activado

Block Common Exploits:
activado
```

Prueba:

```text
http://grafana.home.arpa
```

## Homarr

```text
Domain Names:
homarr.home.arpa

Scheme:
http

Forward Hostname / IP:
192.168.1.79

Forward Port:
7575

Websockets Support:
activado

Block Common Exploits:
activado
```

Prueba:

```text
http://homarr.home.arpa
```

---

# 8. De momento sin HTTPS

Primero lo dejamos funcionando por HTTP interno.

Cuando esto funcione, ya vemos HTTPS interno. Con `home.arpa` no vas a poder pedir certificados normales de Let’s Encrypt como si fuera un dominio público. Para HTTPS interno hay que usar certificado propio/local, wildcard interno o una CA tipo Step-CA. Eso lo dejamos para después; para preparar Keycloak, con nombre estable ya avanzamos mucho.

---

# 9. Añadir socket-proxy y cAdvisor a CT112

Como con los demás.

## socket-proxy

Portainer > CT112-proxy > Stacks > Add stack:

```text
Name: socket-proxy
```

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
      - "192.168.1.82:2375:2375"
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

## cAdvisor

```text
Name: cadvisor
```

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

---

# 10. Resultado esperado

Al terminar, deberías tener:

```text
NPM admin: http://192.168.1.82:81

Servicios limpios:
http://homarr.home.arpa
http://grafana.home.arpa
http://adminer.home.arpa
http://pgadmin.home.arpa
http://chartdb.home.arpa
```

Y ya estaremos preparados para que Keycloak nazca como:

```text
http://auth.home.arpa
```

Primero crea el **CT112 proxy**, añade la ruta a `10.10.10.0/24`, instala Docker + Agent y pásame la salida de las pruebas de red.





si la contraseña del proxy no te funconia al hacer log in haz esto:
apt install -y apache2-utils sqlite3

NEWPASS='Corralejo2007.'
DB="/opt/stacks/nginx-proxy-manager/data/database.sqlite"

USER_ID=$(sqlite3 "$DB" "SELECT id FROM user WHERE is_deleted=0 ORDER BY id LIMIT 1;")

HASH=$(htpasswd -bnBC 10 "" "$NEWPASS" | tr -d ':\n' | sed 's/^\$2y\$/\$2b\$/')

echo "Usuario ID: $USER_ID"
echo "Hash generado: $HASH"

sqlite3 "$DB" "UPDATE auth SET secret='$HASH' WHERE user_id=$USER_ID AND type='password';"

docker restart nginx-proxy-manager

echo "===== LOGIN NPM ====="
sqlite3 "$DB" "SELECT email FROM user WHERE id=$USER_ID;"
echo "Password nueva: $NEWPASS"

a mi me sigue dando error esto es lo que lo solucionó

El problema es que has mezclado dos caminos:

```text
NPM lo creaste desde Portainer.
Pero has intentado hacer docker compose down desde /opt/stacks/nginx-proxy-manager.
Ahí no hay docker-compose.yml, por eso salió:
no configuration file provided: not found
```

O sea, ese `docker compose down` **no paró realmente el stack**. Y ahora seguramente NPM está medio reseteado/medio con datos antiguos.

Vamos a hacerlo limpio.

## Primero prueba esto

Como moviste la carpeta `data`, si el reset ha funcionado, **ya no tienes que entrar con tu correo**, sino con el login inicial:

```text
Email: admin@example.com
Password: changeme
```

Prueba eso primero.

Si no funciona, hacemos reset limpio de verdad.

---

## Reset limpio de NPM

En **CT112 proxy**, pega esto:

```bash
echo "===== PARANDO Y BORRANDO CONTENEDOR NPM ====="
docker stop nginx-proxy-manager 2>/dev/null || true
docker rm nginx-proxy-manager 2>/dev/null || true

echo
echo "===== BACKUP DE DATOS ANTIGUOS ====="
mkdir -p /opt/stacks/nginx-proxy-manager

cd /opt/stacks/nginx-proxy-manager

mv data data.bak.$(date +%F-%H%M) 2>/dev/null || true
mv letsencrypt letsencrypt.bak.$(date +%F-%H%M) 2>/dev/null || true

mkdir -p data letsencrypt

echo
echo "===== COMPROBANDO CARPETAS ====="
ls -lah /opt/stacks/nginx-proxy-manager
```

Ahora ve a **Portainer**:

```text
CT112-proxy
→ Stacks
→ nginx-proxy-manager
→ Update the stack / Redeploy
```

Si no te aparece el stack, créalo otra vez con este compose:

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

Espera 30-40 segundos y comprueba en **CT112 proxy**:

```bash
docker ps | grep nginx-proxy-manager
docker logs nginx-proxy-manager --tail=40
```

Luego entra:

```text
http://192.168.1.82:81
```

Login inicial:

```text
Nombre: guillermo
Email: admin@example.com
Password: changeme
```

Después te pedirá cambiarlo. Pon el correo en minúsculas, por ejemplo:

```text
guillermo.erdg@gmail.com
```

Y guarda la nueva contraseña en Vaultwarden.



en vez de meter todas una a una vamos hacer un scirpt q nos facilite esto:

Sí, se puede automatizar. Y tienes razón: hacerlo a mano en **AdGuard** y luego otra vez en **Nginx Proxy Manager** es un coñazo.

Lo limpio es crear **una lista maestra** con:

```text
dominio.home.arpa → proxy
proxy → IP:puerto real
```

Y que un script cree todo de golpe:

```text
AdGuard DNS Rewrite ✅
Nginx Proxy Manager Proxy Host ✅
```

AdGuard tiene API bajo `/control` y usa autenticación básica; su propia interfaz web está montada encima de esa API. ([GitHub](https://github.com/AdguardTeam/AdGuardHome/blob/master/openapi/openapi.yaml "AdGuardHome/openapi/openapi.yaml at master · AdguardTeam/AdGuardHome · GitHub")) Nginx Proxy Manager está pensado justo para crear “proxy hosts” y exponer servicios web de tu red privada con una UI simple. ([nginxproxymanager.com](https://nginxproxymanager.com/ "Nginx Proxy Manager"))

Lo de cogerlo automáticamente desde Homarr lo dejaría para más adelante. Mejor ahora usamos una lista maestra clara. Así no dependemos de cómo Homarr guarde sus apps por dentro.

## Script automático AdGuard + NPM

Ejecuta esto en **CT112 proxy**:

```bash
mkdir -p /root/scripts

cat > /root/scripts/crear-dns-y-proxy.sh <<'PY'
#!/usr/bin/env python3
import base64
import getpass
import json
import urllib.error
import urllib.request

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
    {"domain": "vault.home.arpa", "scheme": "http", "host": "10.10.10.60", "port": 80},
    {"domain": "paperless.home.arpa", "scheme": "http", "host": "10.10.10.40", "port": 8000},
    {"domain": "nextcloud.home.arpa", "scheme": "http", "host": "10.10.10.65", "port": 8088},
    {"domain": "immich.home.arpa", "scheme": "http", "host": "10.10.10.30", "port": 2283},
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

chmod +x /root/scripts/crear-dns-y-proxy.sh
```

Ahora ejecútalo:

```bash
/root/scripts/crear-dns-y-proxy.sh
```

Te pedirá:

```text
Usuario AdGuard
Contraseña AdGuard
Email NPM
Contraseña NPM
```

No se guardan en el script; solo se usan en ese momento.

## Después prueba

Desde tu PC:

```cmd
nslookup grafana.home.arpa 192.168.1.53
nslookup adminer.home.arpa 192.168.1.53
nslookup nextcloud.home.arpa 192.168.1.53
```

Todos deberían devolver:

```text
192.168.1.82
```

Y en navegador:

```text
http://adminer.home.arpa
http://grafana.home.arpa
http://homarr.home.arpa
http://chartdb.home.arpa
http://tools.home.arpa
```



hay algunos que no funcinoan como portainer o el mismo proxmox y necesitan certificados y tal eso lo solucinoamos asi: Vale, ya tenemos el fallo exacto. No era Proxmox. Era esto:

```text
nginx_err": "proxy_http_version directive is duplicate"
```

O sea: en el bloque **Advanced** metimos líneas que Nginx Proxy Manager ya mete por su cuenta. Al duplicarse, NPM no activa ese host y por eso no aparece `proxmox.home.arpa` en la config.

Vamos a dejar el Advanced mínimo, solo con lo que hace falta.

## 1. Arreglar Proxmox sin directivas duplicadas

En **CT112 proxy**, pega esto:

```bash
cat > /root/scripts/arreglar-proxmox-ssl-minimo.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.request
import urllib.error

NPM_URL = "http://127.0.0.1:81"
DOMAIN = "proxmox.home.arpa"
CERT_NAME = "home-arpa-local"

ADVANCED = """proxy_ssl_verify off;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;
"""

def req(method, path, data=None, token=None):
    body = None
    if data is not None:
        body = json.dumps(data).encode()

    r = urllib.request.Request(NPM_URL + path, data=body, method=method)
    r.add_header("Content-Type", "application/json")

    if token:
        r.add_header("Authorization", f"Bearer {token}")

    try:
        with urllib.request.urlopen(r, timeout=20) as resp:
            raw = resp.read().decode()
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        raw = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR {method} {path}: HTTP {e.code}\n{raw}")

email = input("Email NPM: ").strip()
password = getpass.getpass("Password NPM: ")

print("===== LOGIN NPM =====")
token = req("POST", "/api/tokens", {
    "identity": email,
    "secret": password
})["token"]
print("Login OK")

print("===== BUSCANDO CERTIFICADO =====")
certs = req("GET", "/api/nginx/certificates", token=token)

cert_id = None
for c in certs:
    name = c.get("nice_name") or c.get("name") or ""
    if name == CERT_NAME:
        cert_id = c.get("id")
        print(f"Certificado encontrado: ID={cert_id} Name={name}")

if not cert_id:
    raise SystemExit(f"ERROR: No encontré el certificado {CERT_NAME}")

print("===== BUSCANDO HOST ACTIVO =====")
hosts = req("GET", "/api/nginx/proxy-hosts", token=token)

host_id = None
for h in hosts:
    if DOMAIN in h.get("domain_names", []):
        host_id = h["id"]
        print(f"Host activo encontrado: ID={host_id}")

if not host_id:
    raise SystemExit("ERROR: No encontré proxmox.home.arpa activo")

payload = {
    "domain_names": [DOMAIN],
    "forward_scheme": "https",
    "forward_host": "192.168.1.200",
    "forward_port": 8006,
    "access_list_id": 0,
    "certificate_id": cert_id,
    "ssl_forced": True,
    "caching_enabled": False,
    "block_exploits": False,
    "allow_websocket_upgrade": True,
    "http2_support": False,
    "hsts_enabled": False,
    "hsts_subdomains": False,
    "advanced_config": ADVANCED,
    "locations": [],
    "enabled": True,
    "meta": {
        "letsencrypt_agree": False,
        "dns_challenge": False
    }
}

print("===== ACTUALIZANDO HOST CON ADVANCED MINIMO =====")
updated = req("PUT", f"/api/nginx/proxy-hosts/{host_id}", data=payload, token=token)
print(json.dumps({
    "id": updated["id"],
    "domain_names": updated["domain_names"],
    "certificate_id": updated["certificate_id"],
    "ssl_forced": updated["ssl_forced"],
    "nginx_online": updated.get("meta", {}).get("nginx_online"),
    "nginx_err": updated.get("meta", {}).get("nginx_err"),
}, indent=2))

print("PROXMOX ACTUALIZADO")
PY

chmod +x /root/scripts/arreglar-proxmox-ssl-minimo.py
python3 /root/scripts/arreglar-proxmox-ssl-minimo.py
```

---

## 2. Reiniciar y comprobar

Después pega:

```bash
docker restart nginx-proxy-manager
sleep 10

echo "===== BUSCAR PROXMOX EN CONFIG ====="
docker exec nginx-proxy-manager grep -R "proxmox.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece proxmox.home.arpa"

echo
echo "===== TEST NGINX ====="
docker exec nginx-proxy-manager nginx -t

echo
echo "===== DB NPM PROXMOX ====="
sqlite3 /opt/stacks/nginx-proxy-manager/data/database.sqlite \
"SELECT id, domain_names, forward_scheme, forward_host, forward_port, certificate_id, ssl_forced, enabled, is_deleted FROM proxy_host WHERE domain_names LIKE '%proxmox%';"
```

Ahora queremos ver algo tipo:

```text
/data/nginx/proxy_host/28.conf:  server_name proxmox.home.arpa;
```

y en la DB:

```text
28|["proxmox.home.arpa"]|https|192.168.1.200|8006|1|1|1|0
```

---

## 3. Probar navegador

Cierra pestañas viejas de Proxmox y abre ventana privada:

```text
https://proxmox.home.arpa
```

Si sale aviso de certificado, acepta el riesgo.



Sí, ahora toca **Portainer**, que era el otro que daba guerra.

El fallo de Portainer:

```text
Forbidden - origin invalid
```

normalmente pasa porque Portainer detecta que estás entrando por un dominio/proxy distinto al origen que espera. Igual que Proxmox, lo vamos a poner con:

```text
https://portainer.home.arpa
```

usando el certificado `home-arpa-local`.

## 1. Edita Portainer en NPM

Entra en:

```text
Nginx Proxy Manager
→ Hosts
→ Proxy Hosts
→ portainer.home.arpa
→ Edit
```

### Details

Déjalo así:

```text
Domain Names:
portainer.home.arpa

Scheme:
https

Forward Hostname / IP:
192.168.1.80

Forward Port:
9443

Access List:
Publicly Accessible

Cache Assets:
OFF

Block Common Exploits:
OFF

Websockets Support:
ON
```

### SSL

```text
SSL Certificate:
home-arpa-local

Force SSL:
ON

HTTP/2 Support:
OFF

HSTS:
OFF
```

### Engranaje / Advanced

No metas el bloque largo de antes, porque ya vimos que NPM duplica algunas directivas.

Pega solo esto:

```nginx
proxy_ssl_verify off;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;
```

Guarda.

## 2. Reinicia NPM

En **CT112 proxy**:

```bash
docker restart nginx-proxy-manager
sleep 10

docker exec nginx-proxy-manager nginx -t

docker exec nginx-proxy-manager grep -R "portainer.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece portainer.home.arpa"
```

Tiene que aparecer `portainer.home.arpa`.

## 3. Prueba en ventana privada

Abre:

```text
https://portainer.home.arpa
```

Acepta el certificado si sale aviso.

Luego entra y prueba justo lo que fallaba:

```text
reiniciar un contenedor
parar/arrancar un contenedor
```

## 4. Si Portainer sigue dando `origin invalid`

Entonces probamos a meter un ajuste extra en **Advanced**, pero sin duplicar `proxy_http_version`.

Añade debajo del bloque anterior esto:

```nginx
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Proto https;
```

Quedaría así:

```nginx
proxy_ssl_verify off;

proxy_buffering off;
proxy_request_buffering off;

proxy_read_timeout 3600s;
proxy_send_timeout 3600s;

client_max_body_size 0;

proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Proto https;
```

Guardas, reinicias NPM y pruebas otra vez:

```bash
docker restart nginx-proxy-manager
sleep 10
docker exec nginx-proxy-manager nginx -t
```

## Mi recomendación

Para apps normales, usa dominios siempre.

Para paneles críticos, ahora que Proxmox ya funciona, puedes dejar:

```text
Proxmox:   https://proxmox.home.arpa
Portainer: https://portainer.home.arpa si conseguimos quitar el origin invalid
NPM:       http://192.168.1.82:81 o https://npm.home.arpa si lo configuras
AdGuard:   http://192.168.1.53 o adguard.home.arpa
```

Prueba Portainer con el bloque mínimo primero. Si sigue fallando al reiniciar contenedores, metemos las tres líneas `X-Forwarded-*`.


Perfecto. Siguiente que merece la pena dejar bien: **Nginx Proxy Manager por dominio propio**.

Así podrás entrar por:

```text
https://npm.home.arpa
```

en vez de:

```text
http://192.168.1.82:81
```

## 1. Editar `npm.home.arpa` en NPM

Ve a:

```text
Nginx Proxy Manager
→ Hosts
→ Proxy Hosts
→ npm.home.arpa
→ Edit
```

### Details

Ponlo así:

```text
Domain Names:
npm.home.arpa

Scheme:
http

Forward Hostname / IP:
127.0.0.1

Forward Port:
81

Access List:
Publicly Accessible

Cache Assets:
OFF

Block Common Exploits:
OFF

Websockets Support:
ON
```

### SSL

```text
SSL Certificate:
home-arpa-local

Force SSL:
ON

HTTP/2 Support:
OFF

HSTS:
OFF
```

### Engranaje / Advanced

Déjalo vacío o, como mucho, pon solo esto:

```nginx
client_max_body_size 0;
```

Nada más, para no duplicar directivas.

Guarda.

## 2. Reiniciar NPM

En **CT112 proxy**:

```bash
docker restart nginx-proxy-manager
sleep 10

docker exec nginx-proxy-manager nginx -t

docker exec nginx-proxy-manager grep -R "npm.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece npm.home.arpa"
```

## 3. Probar

Abre ventana privada:

```text
https://npm.home.arpa
```

Aceptas el certificado si sale aviso.

Si entra bien, ya tendrías estos paneles críticos funcionando bonito:

```text
https://proxmox.home.arpa ✅
https://portainer.home.arpa ✅
https://npm.home.arpa ✅
```

Después hacemos **AdGuard**:

```text
https://adguard.home.arpa
```

Siguiente: **AdGuard por dominio bonito**.

Objetivo:

```text
https://adguard.home.arpa
```

en vez de:

```text
http://192.168.1.53
```

## 1. Editar `adguard.home.arpa` en NPM

Ve a:

```text
Nginx Proxy Manager
→ Hosts
→ Proxy Hosts
→ adguard.home.arpa
→ Edit
```

### Details

Déjalo así:

```text
Domain Names:
adguard.home.arpa

Scheme:
http

Forward Hostname / IP:
192.168.1.53

Forward Port:
80

Access List:
Publicly Accessible

Cache Assets:
OFF

Block Common Exploits:
OFF

Websockets Support:
ON
```

### SSL

```text
SSL Certificate:
home-arpa-local

Force SSL:
ON

HTTP/2 Support:
OFF

HSTS:
OFF
```

### Engranaje / Advanced

Déjalo vacío. Si quieres poner algo, solo esto:

```nginx
client_max_body_size 0;
```

Guarda.

## 2. Reiniciar NPM

En **CT112 proxy**:

```bash
docker restart nginx-proxy-manager
sleep 10

docker exec nginx-proxy-manager nginx -t

docker exec nginx-proxy-manager grep -R "adguard.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece adguard.home.arpa"
```

## 3. Probar

Abre en ventana privada:

```text
https://adguard.home.arpa
```

Aceptas el certificado si te sale aviso.

Con esto ya tendrías bonitos los paneles principales:

```text
https://proxmox.home.arpa
https://portainer.home.arpa
https://npm.home.arpa
https://adguard.home.arpa
```

Después de este, yo haría **Grafana/Kuma/Prometheus/Scrutiny** con HTTPS interno.


vamos hacer esto para todos y que todos tengan certificado y el https:
Sí, **se puede hacer con script** y sí: **podemos ponérselo a todos**.

La única razón de no hacerlo a todos “a lo bruto” es que no todas las apps se comportan igual:

```text
Apps normales:
Block Common Exploits ON

Paneles críticos:
Proxmox, Portainer, NPM, AdGuard → OFF

Apps de subida grande:
Immich, Nextcloud, Paperless → client_max_body_size 0
```

Pero eso lo puede controlar el script. La idea buena es:

```text
Buscar todos los Proxy Hosts *.home.arpa en NPM
Aplicar certificado home-arpa-local
Activar Force SSL
Activar Websockets
Poner Block Common Exploits ON/OFF según app
Poner Advanced mínimo según app
```

## Script para aplicar SSL a todos los `.home.arpa`

Ejecuta esto en **CT112 proxy**:

```bash
cat > /root/scripts/aplicar-ssl-home-arpa.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.request
import urllib.error

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

Te pedirá:

```text
Email NPM
Password NPM
```

## Después reinicia y comprueba

En **CT112 proxy**:

```bash
docker restart nginx-proxy-manager
sleep 10

echo "===== TEST NGINX ====="
docker exec nginx-proxy-manager nginx -t

echo
echo "===== HOSTS HOME.ARPA CON SSL ====="
sqlite3 /opt/stacks/nginx-proxy-manager/data/database.sqlite \
"SELECT id, domain_names, forward_scheme, forward_host, forward_port, certificate_id, ssl_forced, block_exploits, enabled, is_deleted FROM proxy_host WHERE domain_names LIKE '%home.arpa%' AND is_deleted=0 ORDER BY id;"
```

Lo bueno es que en todos los activos salga:

```text
certificate_id = 1
ssl_forced = 1
enabled = 1
is_deleted = 0
```

## Luego pruebas varios

Desde el navegador:

```text
https://proxmox.home.arpa
https://portainer.home.arpa
https://npm.home.arpa
https://adguard.home.arpa
https://grafana.home.arpa
https://kuma.home.arpa
https://adminer.home.arpa
https://pgadmin.home.arpa
https://chartdb.home.arpa
https://tools.home.arpa
https://pdf.home.arpa
https://nextcloud.home.arpa
https://immich.home.arpa
```

## Por qué sí podemos hacerlo a todos

Porque ya tenemos:

```text
DNS en AdGuard → todos apuntan al proxy
NPM → todos tienen Proxy Host
Certificado wildcard → *.home.arpa
```

Así que sí, se puede aplicar a todos. Lo único que cambia es la configuración fina por tipo de app. El script ya lo contempla.

Si alguna app deja de abrir después, no significa que todo esté mal: editamos solo esa app en NPM y ajustamos `Block Common Exploits`, Websockets o Advanced.

vault por ejemplo sigeu dando erro rporque tiene configuracino especiales tmb, vamos a ello:
Ese `502` con el backend directo funcionando significa casi seguro que **NPM todavía está apuntando a `10.10.10.60:80` o no ha guardado/regenerado bien el cambio**.

Vamos a forzarlo por API como hicimos con Proxmox.

En **CT112 proxy**, pega esto:

```bash
cat > /root/scripts/arreglar-vault-npm.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.request
import urllib.error

NPM_URL = "http://127.0.0.1:81"
DOMAIN = "vault.home.arpa"
CERT_NAME = "home-arpa-local"

ADVANCED = """client_max_body_size 0;
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
        with urllib.request.urlopen(r, timeout=20) as resp:
            raw = resp.read().decode("utf-8")
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        raw = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR {method} {path}: HTTP {e.code}\n{raw}")

email = input("Email NPM: ").strip()
password = getpass.getpass("Password NPM: ")

print("===== LOGIN NPM =====")
token = req("POST", "/api/tokens", {
    "identity": email,
    "secret": password
})["token"]
print("Login OK")

print("===== BUSCANDO CERTIFICADO =====")
certs = req("GET", "/api/nginx/certificates", token=token)

cert_id = None
for c in certs:
    name = c.get("nice_name") or c.get("name") or ""
    if name == CERT_NAME:
        cert_id = c.get("id")
        print(f"Certificado encontrado: ID={cert_id} Name={name}")

if not cert_id:
    raise SystemExit(f"ERROR: No encontré el certificado {CERT_NAME}")

print("===== BUSCANDO HOST VAULT =====")
hosts = req("GET", "/api/nginx/proxy-hosts", token=token)

host_id = None
for h in hosts:
    if DOMAIN in h.get("domain_names", []):
        host_id = h["id"]
        print(f"Host activo encontrado: ID={host_id}")

if not host_id:
    raise SystemExit("ERROR: No encontré vault.home.arpa activo en NPM")

payload = {
    "domain_names": [DOMAIN],
    "forward_scheme": "http",
    "forward_host": "10.10.10.60",
    "forward_port": 8080,
    "access_list_id": 0,
    "certificate_id": cert_id,
    "ssl_forced": True,
    "caching_enabled": False,
    "block_exploits": True,
    "allow_websocket_upgrade": True,
    "http2_support": False,
    "hsts_enabled": False,
    "hsts_subdomains": False,
    "advanced_config": ADVANCED,
    "locations": [],
    "enabled": True,
    "meta": {
        "letsencrypt_agree": False,
        "dns_challenge": False
    }
}

print("===== ACTUALIZANDO VAULTWARDEN =====")
updated = req("PUT", f"/api/nginx/proxy-hosts/{host_id}", data=payload, token=token)

print(json.dumps({
    "id": updated["id"],
    "domain_names": updated["domain_names"],
    "forward_scheme": updated["forward_scheme"],
    "forward_host": updated["forward_host"],
    "forward_port": updated["forward_port"],
    "certificate_id": updated["certificate_id"],
    "ssl_forced": updated["ssl_forced"],
    "nginx_online": updated.get("meta", {}).get("nginx_online"),
    "nginx_err": updated.get("meta", {}).get("nginx_err"),
}, indent=2))

print("VAULTWARDEN ACTUALIZADO")
PY

chmod +x /root/scripts/arreglar-vault-npm.py
python3 /root/scripts/arreglar-vault-npm.py
```

Después reinicia y comprueba:

```bash
docker restart nginx-proxy-manager
sleep 10

echo "===== TEST NGINX ====="
docker exec nginx-proxy-manager nginx -t

echo
echo "===== VAULT EN DB ====="
sqlite3 /opt/stacks/nginx-proxy-manager/data/database.sqlite \
"SELECT id, domain_names, forward_scheme, forward_host, forward_port, certificate_id, ssl_forced, block_exploits, enabled, is_deleted FROM proxy_host WHERE domain_names LIKE '%vault%';"

echo
echo "===== VAULT EN CONFIG ====="
docker exec nginx-proxy-manager grep -R "vault.home.arpa\|10.10.10.60\|8080" /data/nginx/proxy_host 2>/dev/null || echo "No aparece vault en config"

echo
echo "===== PRUEBA VAULT ====="
curl -k -I --resolve vault.home.arpa:443:127.0.0.1 https://vault.home.arpa
```

Lo bueno sería ver algo así:

```text
vault.home.arpa
forward_host: 10.10.10.60
forward_port: 8080
HTTP/1.1 200 OK
```

Si después de eso sigue en `502`, pásame la parte de `VAULT EN DB` y `VAULT EN CONFIG`, porque ahí veremos exactamente si NPM está generando mal la config o si hay otro problema.



Perfecto, el contenedor se llama exactamente:

```text
nextcloud
```

Pega esto en **PVE Shell** para añadir `nextcloud.home.arpa` como dominio permitido y decirle que está detrás del proxy HTTPS:

```bash
pct exec 108 -- bash -lc '
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 2 --value=10.10.10.65
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 3 --value=192.168.1.82

docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value=192.168.1.82
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.home.arpa

echo
echo "===== TRUSTED DOMAINS ====="
docker exec -u www-data nextcloud php occ config:system:get trusted_domains

echo
echo "===== OVERWRITE ====="
docker exec -u www-data nextcloud php occ config:system:get overwritehost
docker exec -u www-data nextcloud php occ config:system:get overwriteprotocol
docker exec -u www-data nextcloud php occ config:system:get overwrite.cli.url
'
```

Luego prueba:

```bash
curl -k -I --max-time 8 --resolve nextcloud.home.arpa:443:192.168.1.82 https://nextcloud.home.arpa
```

Si ya no sale `400 Bad Request`, está arreglado. Lo normal será ver `200 OK` o `302 Found`.

Después abre en navegador:

```text
https://nextcloud.home.arpa
```

Si te sale el aviso del certificado, es normal por ser certificado interno/autofirmado.




vamos a cambier una vez todo funcione las ip por los nombres en homarr:

Sí, el preview ha encontrado justo lo que queríamos. El error final es porque Homarr tiene una tabla llamada `group`, y `group` es palabra reservada de SQL. No pasa nada, porque lo importante está en la tabla `app`.

Y mejor todavía: **no vamos a tocar `ping_url`**.

Lo ideal es:

```text
href     → URL bonita con dominio
ping_url → dejar IP:puerto original
```

Así Homarr abre la app con el dominio bonito, pero comprueba salud contra la URL real interna.

## Aplica solo las URLs visibles de Homarr

Pega esto en **PVE Shell**:

```bash
pct exec 101 -- bash -lc 'cat > /root/actualizar-homarr-href.py <<'"'"'PY'"'"'
import sqlite3
import shutil
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

if not db.exists():
    raise SystemExit(f"ERROR: No existe {db}")

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

echo "===== PARANDO HOMARR ====="
docker stop homarr-v1

echo
echo "===== ACTUALIZANDO HREF DE HOMARR ====="
python3 /root/actualizar-homarr-href.py

echo
echo "===== ARRANCANDO HOMARR ====="
docker start homarr-v1

sleep 10

echo
echo "===== LOGS HOMARR ====="
docker logs homarr-v1 --tail=40
'
```

Después entra en:

```text
https://homarr.home.arpa
```

y revisa que al pulsar las apps ya abran por dominio bonito.

## Comprobar después

Para ver cómo ha quedado:

```bash
pct exec 101 -- bash -lc '
sqlite3 /opt/stacks/homarr-v1/appdata/db/db.sqlite "
SELECT rowid, name, href, ping_url
FROM app
ORDER BY rowid;
"
'
```

## Si algo sale mal

El script crea un backup antes de tocar nada. Para ver backups:

```bash
pct exec 101 -- bash -lc 'ls -lah /opt/stacks/homarr-v1/appdata/db | grep bak'
```

Pero en principio esto es seguro porque solo toca `app.href`, no toca grupos, widgets, docker, ping ni configuración interna.

	Perfecto, Homarr arrancó bien y el cambio se aplicó. Pero hay **2 URLs que han quedado regular** por el orden del script:

```text
rowid=11
OLD: http://192.168.1.81:8384
NEW: https://casaos.home.arpa:8384 ❌
Debe ser: https://syncthing.home.arpa ✅

rowid=13
OLD: http://192.168.1.81:8200
NEW: https://casaos.home.arpa:8200 ❌
Debe ser: https://duplicati.home.arpa ✅
```

Pasa porque el script cambió primero `http://192.168.1.81` por `https://casaos.home.arpa`, antes de llegar a las reglas más concretas con puerto.

Arreglamos solo esos dos:

```bash
pct exec 101 -- bash -lc '
docker stop homarr-v1

sqlite3 /opt/stacks/homarr-v1/appdata/db/db.sqlite "
UPDATE app SET href = '\''https://syncthing.home.arpa'\'' WHERE rowid = 11;
UPDATE app SET href = '\''https://duplicati.home.arpa'\'' WHERE rowid = 13;
"

docker start homarr-v1

sleep 8

echo "===== COMPROBACION HREF HOMARR ====="
sqlite3 /opt/stacks/homarr-v1/appdata/db/db.sqlite "
SELECT rowid, name, href, ping_url
FROM app
ORDER BY rowid;
"
'
```

Después entra en:

```text
https://homarr.home.arpa
```

y ya deberían abrir bien Syncthing y Duplicati con sus dominios bonitos.

Por lo demás, el cambio ha salido bien:

```text
24 URLs principales cambiadas ✅
ping_url no tocado ✅
backup creado ✅
Homarr arrancó correctamente ✅
```

El backup quedó aquí:

```text
/opt/stacks/homarr-v1/appdata/db/db.sqlite.bak-20260430-114240
```


Sí, exactamente. Lo correcto para Homarr es esto:

```text
URL:
https://adminer.home.arpa

Use different URL for ping:
http://10.10.10.73:8080
```

Así:

```text
Cuando haces clic → abre dominio bonito ✅
Cuando Homarr comprueba estado → usa IP interna directa ✅
```

Lo que te sale inválido es porque has puesto solo:

```text
192.168.1.85
```

Eso no es una URL válida. Tiene que llevar `http://` o `https://` y normalmente puerto:

```text
http://10.10.10.73:8080
```

Para **Adminer**, pon exactamente:

```text
URL:
https://adminer.home.arpa

Ping URL:
http://10.10.10.73:8080
```

---

## Script para dejar Homarr así automáticamente

Este script deja:

```text
app.href     → dominio bonito
app.ping_url → IP:puerto real
```

Pégalo en **PVE Shell**:

```bash
pct exec 101 -- bash -lc 'cat > /root/arreglar-homarr-ping-url.py <<'"'"'PY'"'"'
import sqlite3
import shutil
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

sleep 8

sqlite3 /opt/stacks/homarr-v1/appdata/db/db.sqlite "
SELECT rowid, name, href, ping_url
FROM app
ORDER BY rowid;
"
'
```

Después entra otra vez en:

```text
https://homarr.home.arpa
```

Y debería quedar como tú quieres:

```text
Nombre/app visible → dominio bonito
Ping/check → IP interna real
```

No uses solo IP en el campo de ping. Siempre así:

```text
http://IP:PUERTO
```

o:

```text
https://IP:PUERTO
```



_______________
---
---
---
---
---
---
----
-----
------
-----
-----
---
-----
________________________________


_______________
---
---
---
---
---
---
----
-----
------
-----
-----
---
-----
________________________________

_______________
---
---
---
---
---
---
----
-----
------
-----
-----
---
-----
________________________________

_______________
---
---
---
---
---
---
----
-----
------
-----
-----
---
-----
________________________________






















# continuación:


Sí, te entiendo perfectamente. El ritmo bueno para tu homelab es este:

```text
1. Crear CT
2. Instalar Docker
3. Instalar Portainer Agent por consola
4. Añadir CT a Portainer
5. Desde Portainer meter los stacks YML:
   - keycloak
   - cadvisor
   - socket-proxy
6. Luego proxy/DNS/Homarr/Uptime Kuma
```

Así queda igual que CT110, CT111 y CT112. En la Guía 3.0 ya sigues ese patrón con Portainer Agent, cAdvisor, socket-proxy y `auth.home.arpa` ya reservado en los dominios `.home.arpa`.

Te lo dejo en el mismo formato que el ejemplo del CT112.

---

# 1. Crear CT113 identity

En Proxmox crea un CT:

```text
CT ID: 113
Hostname: identity
Plantilla: debian-13-standard
Unprivileged: marcado
Nesting: marcado
Start at boot: marcado
Disco: 24 GB
CPU: 2 cores
RAM: 2048 MB
Swap: 1024 MB
Bridge: vmbr10
IPv4/CIDR: 10.10.10.74/24
Gateway: 10.10.10.87
DNS: 1.1.1.1
```

Entra en:

```text
CT113 identity > Consola
```

Y pega:

```bash
ip -br a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si responde, el CT está bien conectado a la red privada.

---

# 2. Instalar Docker en CT113

Dentro de **CT113 identity**, pega:

```bash
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git openssl

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
systemctl is-active docker
```

---

# 3. Instalar Portainer Agent

Dentro de **CT113 identity**, pega:

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

Desde **CT102 portainer > Consola**:

```bash
ping -c 2 10.10.10.74
timeout 5 bash -c "cat < /dev/null > /dev/tcp/10.10.10.74/9001" && echo "Agent OK" || echo "Agent NO responde"
```

En Portainer añade:

```text
Name: CT113-identity
Environment URL: tcp://10.10.10.74:9001
Tipo: Agent
```

---

# 4. Crear carpetas y contraseñas de Keycloak

Dentro de **CT113 identity**, pega esto para preparar las carpetas y generar contraseñas:

```bash
mkdir -p /opt/stacks/identity/{postgres,keycloak}
chmod 700 /opt/stacks/identity

KC_DB_PASSWORD="$(openssl rand -hex 32)"
KC_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '\n')"

cat > /opt/stacks/identity/.env <<EOF
KC_DB_DATABASE=keycloak
KC_DB_USERNAME=keycloak
KC_DB_PASSWORD=$KC_DB_PASSWORD

KC_ADMIN_USER=guillermo
KC_ADMIN_PASSWORD=$KC_ADMIN_PASSWORD
EOF

chmod 600 /opt/stacks/identity/.env
cp /opt/stacks/identity/.env /root/CT113-identity-passwords.txt

echo "===== GUARDA ESTO EN VAULTWARDEN ====="
cat /root/CT113-identity-passwords.txt
```

Ahora guarda esas contraseñas en Vaultwarden.

---

# 5. Crear stack Keycloak desde Portainer

En Portainer:

```text
CT113-identity
→ Stacks
→ Add stack
```

Nombre:

```text
identity
```

Compose:

```yaml
services:
  keycloak-db:
    image: postgres:17-alpine
    container_name: keycloak-db
    restart: unless-stopped
    environment:
      POSTGRES_DB: keycloak
      POSTGRES_USER: keycloak
      POSTGRES_PASSWORD: CAMBIA_ESTO_POR_LA_KC_DB_PASSWORD
    volumes:
      - /opt/stacks/identity/postgres:/var/lib/postgresql/data

  keycloak:
    image: quay.io/keycloak/keycloak:latest
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
      KC_DB_PASSWORD: CAMBIA_ESTO_POR_LA_KC_DB_PASSWORD

      KC_BOOTSTRAP_ADMIN_USERNAME: guillermo
      KC_BOOTSTRAP_ADMIN_PASSWORD: CAMBIA_ESTO_POR_LA_KC_ADMIN_PASSWORD

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

Antes de darle a **Deploy**, cambia:

```text
CAMBIA_ESTO_POR_LA_KC_DB_PASSWORD
CAMBIA_ESTO_POR_LA_KC_ADMIN_PASSWORD
```

Por los valores de:

```bash
cat /root/CT113-identity-passwords.txt
```

Keycloak detrás de Nginx Proxy Manager necesita `KC_HTTP_ENABLED=true` y `KC_PROXY_HEADERS=xforwarded` cuando el HTTPS termina en el proxy; además, el puerto `9000` es para health/metrics y no se debe publicar hacia fuera con el proxy. ([Keycloak](https://www.keycloak.org/server/reverseproxy?utm_source=chatgpt.com "Configuring a reverse proxy"))

---

# 6. Comprobar Keycloak

Dentro de **CT113 identity**, pega:

```bash
docker ps

echo
echo "===== LOGS KEYCLOAK ====="
docker logs keycloak --tail=80

echo
echo "===== HTTP KEYCLOAK ====="
curl -I http://10.10.10.74:8080

echo
echo "===== HEALTH ====="
curl -s http://10.10.10.74:9000/health/ready

echo
echo "===== OPENID CONFIG ====="
curl -s http://10.10.10.74:8080/realms/master/.well-known/openid-configuration | head
```

Acceso interno provisional:

```text
http://10.10.10.74:8080
```

Usuario:

```text
guillermo
```

Contraseña:

```bash
cat /root/CT113-identity-passwords.txt
```
# 3. Generar contraseñas reales automáticamente

Pega esto en **CT113 identity**:

```
KC_DB_PASSWORD="$(openssl rand -hex 24)"KC_ADMIN_PASSWORD="$(openssl rand -base64 24 | tr -d '\n')"cat > /root/CT113-identity-passwords.txt <<EOFKC_DB_PASSWORD=$KC_DB_PASSWORDKC_ADMIN_USER=guillermoKC_ADMIN_PASSWORD=$KC_ADMIN_PASSWORDEOFchmod 600 /root/CT113-identity-passwords.txtecho "===== GUARDA ESTO EN VAULTWARDEN ====="cat /root/CT113-identity-passwords.txt
```

Ese archivo es el que manda. La contraseña buena será la que te salga ahí, por ejemplo:

```
KC_DB_PASSWORD=lo_que_te_salga_a_tiKC_ADMIN_PASSWORD=lo_que_te_salga_a_ti
```

---

# 4. Crear el YAML listo para copiar en Portainer

Ahora pega esto:

```
KC_DB_PASSWORD="$(grep '^KC_DB_PASSWORD=' /root/CT113-identity-passwords.txt | cut -d= -f2-)"KC_ADMIN_PASSWORD="$(grep '^KC_ADMIN_PASSWORD=' /root/CT113-identity-passwords.txt | cut -d= -f2-)"cat > /root/identity-portainer.yml <<EOFservices:  keycloak-db:    image: postgres:17-alpine    container_name: keycloak-db    restart: unless-stopped    environment:      POSTGRES_DB: keycloak      POSTGRES_USER: keycloak      POSTGRES_PASSWORD: "$KC_DB_PASSWORD"    volumes:      - /opt/stacks/identity/postgres:/var/lib/postgresql/data  keycloak:    image: quay.io/keycloak/keycloak:26.6.1    container_name: keycloak    restart: unless-stopped    depends_on:      - keycloak-db    command: start    ports:      - "10.10.10.74:8080:8080"      - "10.10.10.74:9000:9000"    environment:      KC_DB: postgres      KC_DB_URL: jdbc:postgresql://keycloak-db:5432/keycloak      KC_DB_USERNAME: keycloak      KC_DB_PASSWORD: "$KC_DB_PASSWORD"      KC_BOOTSTRAP_ADMIN_USERNAME: guillermo      KC_BOOTSTRAP_ADMIN_PASSWORD: "$KC_ADMIN_PASSWORD"      KC_HTTP_ENABLED: "true"      KC_HOSTNAME: "https://auth.home.arpa"      KC_PROXY_HEADERS: "xforwarded"      KC_PROXY_TRUSTED_ADDRESSES: "192.168.1.82"      KC_HEALTH_ENABLED: "true"      KC_METRICS_ENABLED: "true"      KC_LOG_LEVEL: "info"      JAVA_OPTS_KC_HEAP: "-XX:MaxRAMPercentage=65 -XX:InitialRAMPercentage=40"    volumes:      - /opt/stacks/identity/keycloak:/opt/keycloak/dataEOFecho "===== YAML PARA PORTAINER ====="cat /root/identity-portainer.yml
```

---

# 5. Meter el YAML en Portainer

En Portainer:

```
CT113-identity→ Stacks→ Add stack
```

Nombre:

```
identity
```

Y pegas el contenido de:

```
cat /root/identity-portainer.yml
```

Deploy.

---

# 6. Comprobar

Cuando despliegue, en **CT113 identity** pega:

```
echo "===== CONTENEDORES ====="docker psechoecho "===== LOGS KEYCLOAK ====="docker logs keycloak --tail=100echoecho "===== HTTP KEYCLOAK ====="curl -I http://10.10.10.74:8080echoecho "===== HEALTH ====="curl -s http://10.10.10.74:9000/health/readyechoecho "===== OPENID CONFIG ====="curl -s http://10.10.10.74:8080/realms/master/.well-known/openid-configuration | head
```

---

# 7. Acceso

Cuando funcione:

```
URL interna: http://10.10.10.74:8080Usuario: guillermoContraseña: la de KC_ADMIN_PASSWORD
```

Para ver la contraseña:

```
cat /root/CT113-identity-passwords.txt
```




Sí, ya lo he visto. Está subido al lado de la guía y lo he leído. Tienes razón: tu documento en sucio no lo hacías “a medias”; primero montabas servicio interno, luego **AdGuard → NPM → certificado `home-arpa-local` → prueba final**, y después Homarr/Uptime Kuma/Prometheus. En la Guía 3.0 también aparece que los dominios `.home.arpa`, incluido `auth.home.arpa`, deben apuntar al proxy `192.168.1.82`, no al servicio real.

También he visto en tu plano que `CT futuro identity - 10.10.10.74` estaba pensado justo para **Keycloak + OAuth2 + OpenID**, así que lo que hemos hecho encaja con tu esquema.

Ahora mismo el estado real es este:

```text
CT113 identity - 10.10.10.74
├── Portainer Agent ✅
├── PostgreSQL ✅
├── Keycloak ✅
├── Health ✅
├── auth.home.arpa ❌ falta AdGuard
├── NPM Proxy Host ❌ falta
└── SSL home-arpa-local ❌ falta aplicarlo a auth
```

Así que ahora toca **cerrar la parte de dominio bonito**, no seguir con cAdvisor ni Homarr todavía.

---

# 1. Primero comprobar desde CT112 proxy que llega a Keycloak

Entra en:

```text
CT112 proxy > Consola
```

Pega:

```bash
ping -c 2 10.10.10.74
curl -I http://10.10.10.74:8080
curl -s http://10.10.10.74:9000/health/ready
```

Tiene que salir algo parecido a:

```text
HTTP/1.1 302 Found
```

y en health:

```text
"status": "UP"
```

Si eso funciona, NPM puede llegar a Keycloak.

---

# 5. Crear Proxy Host en NPM para Keycloak

En Nginx Proxy Manager:

```text
Proxy Hosts
→ Add Proxy Host
```

## Details

Pon:

```text
Domain Names:
auth.home.arpa

Scheme:
http

Forward Hostname / IP:
10.10.10.74

Forward Port:
8080

Cache Assets:
OFF

Block Common Exploits:
OFF

Websockets Support:
ON
```

Para Keycloak prefiero `Block Common Exploits: OFF`, igual que con paneles delicados tipo Proxmox/Portainer/NPM, para evitar que NPM bloquee rutas raras de login/OIDC.

## SSL

```text
SSL Certificate:
home-arpa-local

Force SSL:
ON

HTTP/2 Support:
OFF

HSTS:
OFF
```

## Advanced

Pon solo esto:

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

No metas `proxy_http_version`, porque en tu propio documento ya viste que algunas directivas duplicadas rompen NPM con errores como `proxy_http_version directive is duplicate`.

Guarda.

---

# 6. Reiniciar NPM y validar configuración

En **CT112 proxy**, pega:

```bash
docker restart nginx-proxy-manager
sleep 10

docker exec nginx-proxy-manager nginx -t

docker exec nginx-proxy-manager grep -R "auth.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece auth.home.arpa"
```

Si `nginx -t` dice:

```text
syntax is ok
test is successful
```

vamos bien.

---

# 7. Probar DNS desde tu PC

En Windows CMD o PowerShell:

```powershell
nslookup auth.home.arpa 192.168.1.53
```

Tiene que devolver:

```text
Address: 192.168.1.82
```

Si no devuelve `192.168.1.82`, el problema está en AdGuard o en que tu PC no está usando AdGuard como DNS.

---

# 8. Probar HTTPS final

Desde tu PC:

```powershell
curl -k -I https://auth.home.arpa
```

Resultado bueno:

```text
HTTP/1.1 302 Found
```

o:

```text
HTTP/2 302
```

Luego abre en navegador:

```text
https://auth.home.arpa/admin/
```

Usuario:

```text
guillermo
```

Contraseña:

```bash
cat /root/CT113-identity-passwords.txt
```

Usas el valor de:

```text
KC_ADMIN_PASSWORD=
```

---

# 9. Lo que NO hacemos todavía

No seguimos todavía con:

```text
cAdvisor
socket-proxy
Homarr
Uptime Kuma
Prometheus
Backups
modo-noche
```

Primero dejamos esto cerrado:

```text
https://auth.home.arpa/admin/ funcionando
```

Cuando eso cargue, ya sí seguimos con la integración normal del CT113 como hiciste con los demás.



Perfecto, ahora sí ✅

Eso confirma que ya está funcionando todo el camino completo:

```text
auth.home.arpa
→ AdGuard
→ 192.168.1.82 CT112 proxy
→ Nginx Proxy Manager
→ 10.10.10.74:8080 CT113 identity
→ Keycloak
```

Y encaja con tu plano: el CT de identity estaba pensado justo para `10.10.10.74` con Keycloak/OAuth2/OpenID.

Ahora **no sigas configurando clientes todavía**. Primero hay que quitar ese aviso amarillo de seguridad.

---

# 1. Crear usuario admin permanente

En Keycloak, en el panel que tienes abierto:

```text
Users
→ Add user
```

Pon algo así:

```text
Username: admin-guillermo
Email: tu correo si quieres
First name: Guillermo
Last name: Encinas
User enabled: ON
Email verified: ON
```

---

# 1. Poner contraseña al admin nuevo

Arriba entra en:

```text
Credentials
```

Luego busca:

```text
Set password
```

Pon una contraseña fuerte.

Muy importante:

```text
Temporary: OFF
```

Tiene que quedar como contraseña definitiva, no temporal.

Luego:

```text
Save password
```

---

# 2. Darle permisos de administrador

Ahora entra en:

```text
Role mapping
```

Pulsa:

```text
Assign role
```

Busca:

```text
realm-admin
```

Puede aparecer como:

```text
realm-management / realm-admin
```

Selecciónalo y pulsa:

```text
Assign
```

Ese permiso es el importante. Sin eso, el usuario existe pero **no manda nada**.

---
Sí, eso que ves está perfecto ✅

Esa pantalla confirma que **`admin-guillermo` entra en incógnito y tiene permisos de administración**, porque puedes ver:

```text
Clients
Client scopes
Realm roles
Users
Groups
Sessions
Events
Realm settings
Authentication
Identity providers
```

Así que el usuario nuevo ya vale. El siguiente paso es **quitar el usuario temporal** y limpiar el stack, como marca la propia guía donde el usuario bootstrap `guillermo` se creó solo para arrancar Keycloak.

---

# 1. Borrar el usuario temporal

En esta sesión donde estás logueado como `admin-guillermo`, ve a:

```text
Users
```

Busca:

```text
guillermo
```

Ojo: no borres este:

```text
admin-guillermo
```

Borra solo el usuario temporal:

```text
guillermo
```

Ruta:

```text
Users
→ guillermo
→ Action
→ Delete
→ Confirm
```

Cuando lo borres, el aviso amarillo de “temporary admin user” ya debería desaparecer.

---

# 2. Quitar las variables bootstrap del stack

Después ve a **Portainer**:

```text
CT113-identity
→ Stacks
→ identity
→ Editor
```

Busca estas líneas:

```yaml
KC_BOOTSTRAP_ADMIN_USERNAME: guillermo
KC_BOOTSTRAP_ADMIN_PASSWORD: "..."
```

Y bórralas.

Te tiene que quedar el bloque de Keycloak sin esas dos variables, más o menos así:

```yaml
environment:
  KC_DB: postgres
  KC_DB_URL: jdbc:postgresql://keycloak-db:5432/keycloak
  KC_DB_USERNAME: keycloak
  KC_DB_PASSWORD: "TU_PASSWORD_REAL"

  KC_HTTP_ENABLED: "true"
  KC_HOSTNAME: "https://auth.home.arpa"
  KC_PROXY_HEADERS: "xforwarded"
  KC_PROXY_TRUSTED_ADDRESSES: "192.168.1.82"

  KC_HEALTH_ENABLED: "true"
  KC_METRICS_ENABLED: "true"
  KC_LOG_LEVEL: "info"

  JAVA_OPTS_KC_HEAP: "-XX:MaxRAMPercentage=65 -XX:InitialRAMPercentage=40"
```

Luego:

```text
Update the stack
```

---

# 3. Comprobar que sigue funcionando

En **CT113 identity**, pega:

```bash
echo "===== CONTENEDORES ====="
docker ps

echo
echo "===== HEALTH ====="
curl -s http://10.10.10.74:9000/health/ready

echo
echo "===== HTTPS FINAL ====="
curl -k -I https://auth.home.arpa

echo
echo "===== LOGS ====="
docker logs keycloak --tail=60
```

Tiene que seguir saliendo:

```text
"status": "UP"
```

y:

```text
HTTP/1.1 302 Found
```

---

# 4. Lo de “No es seguro”

Eso es normal porque estás usando un certificado local `home-arpa-local`, no uno público de Let’s Encrypt. No significa que Keycloak esté mal. Para que el navegador no muestre “No es seguro”, habría que instalar la CA/certificado local como confiable en Windows/navegador.

Ahora mismo lo importante es:

```text
https://auth.home.arpa/admin/ ✅
admin-guillermo ✅
usuario temporal pendiente de borrar ✅
```

Borra `guillermo`, quita las dos líneas bootstrap y ya cerramos Keycloak limpio.



Vale, tranquilo: **eso que te sale no es grave**.

Ahora mismo hay 2 cosas normales pasando:

```text
1. Keycloak acaba de reiniciarse hace 8 segundos.
2. El CT113 no resuelve auth.home.arpa porque usa DNS 1.1.1.1, no AdGuard.
```

Tu PC sí entra a `auth.home.arpa`, así que **AdGuard + NPM ya funcionan desde fuera**. El fallo de `curl` dentro del CT113 es solo DNS interno del propio CT.

En la guía, los `.home.arpa` se resuelven por AdGuard apuntando al proxy `192.168.1.82`, y `auth.home.arpa` está en esa lista.

---

# 1. Primero espera a que Keycloak termine

Como pone:

```text
Changes detected in configuration. Updating the server image.
```

espera 30-60 segundos y pega esto en **CT113 identity**:

```bash
echo "===== ESPERANDO KEYCLOAK ====="
sleep 45

echo
echo "===== CONTENEDORES ====="
docker ps

echo
echo "===== HEALTH POR IP ====="
curl -s http://10.10.10.74:9000/health/ready
echo

echo
echo "===== HTTP POR IP ====="
curl -I http://10.10.10.74:8080

echo
echo "===== LOGS ====="
docker logs keycloak --tail=80
```

Lo bueno sería ver:

```text
"status": "UP"
```

---

# 2. Lo de `auth.home.arpa` dentro del CT113

Esto:

```text
curl: (6) Could not resolve host: auth.home.arpa
```

es porque el CT113 seguramente tiene DNS:

```text
1.1.1.1
```

Y Cloudflare no sabe qué es `auth.home.arpa`.

Desde **CT113**, si quieres probar el dominio bonito igualmente, usa este comando:

```bash
curl -k -I --resolve auth.home.arpa:443:192.168.1.82 https://auth.home.arpa
```

Eso fuerza:

```text
auth.home.arpa → 192.168.1.82
```

Si devuelve `302 Found`, está perfecto.

---

# 3. Si quieres que CT113 también resuelva `.home.arpa`

Dentro de **CT113 identity**, cambia DNS a AdGuard:

```bash
cat > /etc/resolv.conf <<'EOF'
nameserver 192.168.1.53
nameserver 1.1.1.1
EOF

nslookup auth.home.arpa
curl -k -I https://auth.home.arpa
```

Pero ojo: esto puede no ser permanente si el CT regenera `resolv.conf`. Lo importante para Keycloak **no es que CT113 resuelva `auth.home.arpa`**, sino que:

```text
Tu PC/Tailscale → auth.home.arpa → 192.168.1.82 → NPM → 10.10.10.74:8080
```

Y eso ya lo has demostrado con la captura.

---

# 4. Estado real ahora mismo

```text
Keycloak por navegador: ✅
admin-guillermo probado: ✅
usuario temporal quitado: casi seguro ✅
stack reiniciado: ✅
health: esperar 30-60s
DNS interno CT113: no importante
```

Pega el bloque del punto 1 después de esperar y vemos si Keycloak ya volvió a `UP`.




Perfecto, ahora sí está **cerrado y funcionando bien** ✅

Tienes confirmado todo esto:

```
Keycloak interno por IP: OKhttp://10.10.10.74:8080 → 302Health interno: OKhttp://10.10.10.74:9000/health/ready → UPDNS interno del CT113: OKauth.home.arpa → 192.168.1.82Proxy HTTPS final: OKhttps://auth.home.arpa → 302NPM: OKX-Served-By: auth.home.arpa
```

El camino completo ya funciona:

```
auth.home.arpa→ AdGuard 192.168.1.53→ CT112 proxy 192.168.1.82→ Nginx Proxy Manager→ CT113 identity 10.10.10.74:8080→ Keycloak
```

---

# 1. Hacer permanente el DNS del CT113

Lo que hiciste con `/etc/resolv.conf` funciona, pero puede perderse al reiniciar. Mejor dejarlo fijo desde **PVE Shell**, no dentro del CT.

Entra en:

```
pve > Shell
```

Pega:

```
pct set 113 --nameserver 192.168.1.53 --searchdomain home.arpapct reboot 113
```

Cuando reinicie, entra en **CT113 identity** y comprueba:

```
cat /etc/resolv.confnslookup auth.home.arpacurl -k -I https://auth.home.arpacurl -s http://10.10.10.74:9000/health/ready
```


Perfecto, ahora ya está bien del todo ✅

Tu salida confirma:

```text
DNS permanente en CT113: OK
auth.home.arpa → 192.168.1.82

Keycloak health: OK
status: UP

Keycloak por IP: OK
10.10.10.74:8080 → 302

Keycloak por proxy HTTPS: OK
https://auth.home.arpa → 302

NPM está sirviendo el dominio:
X-Served-By: auth.home.arpa
```

Esto encaja justo con la guía: los dominios `.home.arpa`, incluido `auth.home.arpa`, deben resolverse hacia el proxy `192.168.1.82`, y luego NPM aplica el certificado local `home-arpa-local` y reenvía al servicio real.

---

# Estado cerrado de CT113

```text
CT113 identity - 10.10.10.74
├── Docker ✅
├── Portainer Agent ✅
├── PostgreSQL ✅
├── Keycloak 26.6.1 ✅
├── Admin permanente ✅
├── DNS auth.home.arpa ✅
├── NPM Proxy Host ✅
├── SSL home-arpa-local ✅
├── Health 9000 ✅
└── OpenID/OAuth2 listo ✅
```

---

# Siguiente: cAdvisor en Portainer

En Portainer:

```text
CT113-identity
→ Stacks
→ Add stack
```

Nombre:

```text
cadvisor
```

Compose:

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

Deploy.

Comprobar desde **CT113 identity**:

```bash
curl -s --max-time 5 http://10.10.10.74:8089/metrics | head
```

---

# Después: socket-proxy

En Portainer:

```text
CT113-identity
→ Stacks
→ Add stack
```

Nombre:

```text
socket-proxy
```

Compose:

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
      - "10.10.10.74:2375:2375"
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

Comprobar:

```bash
curl -s http://10.10.10.74:2375/_ping
```

Tiene que devolver:

```text
OK
```

Luego ya lo añadimos a Homarr, Uptime Kuma, Prometheus y backups.




vamos a ponerlo facil: 



Visualmente para ti o tu familia sería:

```text
Entras a grafana.home.arpa
→ sale iniciar sesión con Google
→ eliges tu cuenta
→ entras a Grafana
```

Pero por debajo trabaja así:

```text
grafana.home.arpa
→ Grafana manda al usuario a auth.home.arpa
→ Keycloak usa el realm homelab
→ Keycloak manda a Google
→ Google confirma quién eres
→ Keycloak aplica grupos/permisos
→ Grafana recibe el login válido
```

La parte importante es esta:

```text
Google = quién eres
Keycloak = qué puedes hacer
Grafana = servicio final
```

Google documenta este flujo como OAuth para aplicaciones web: la app redirige al usuario al servidor de autorización de Google, Google autentica/solicita consentimiento y devuelve la respuesta a la URL de redirección configurada. ([Google for Developers](https://developers.google.com/identity/protocols/oauth2/web-server "Using OAuth 2.0 for Web Server Applications  |  Authorization  |  Google for Developers"))

---

## Lo que tú quieres conseguir

No quieres esto:

```text
Grafana → pantalla rara de Keycloak → luego Google → luego Grafana
```

Quieres esto:

```text
Grafana → Google → Grafana
```

Y eso se puede hacer usando Keycloak en medio, pero escondido.

---

## Cómo se consigue

Primero se configura Google dentro de Keycloak:

```text
Keycloak Admin
→ Realm homelab
→ Identity providers
→ Google
```

Luego se configura el login para que Google sea el proveedor principal.

Así Keycloak no se presenta como “otra app más” al usuario, sino como el intermediario que manda directamente a Google.

---

## Por qué me gusta para tu homelab

Porque si mañana tienes:

```text
grafana.home.arpa
nextcloud.home.arpa
paperless.home.arpa
homarr.home.arpa
```

no configuras Google cuatro veces.

Configuras esto:

```text
Google → Keycloak
```

y luego:

```text
Grafana → Keycloak
Nextcloud → Keycloak
Paperless → Keycloak
Homarr → Keycloak
```

Más limpio, más profesional y más fácil de controlar.

---

## Importante antes de hacerlo

Para Google tendrás que crear un OAuth Client en Google Cloud y poner una redirect URI de Keycloak, normalmente:

```text
https://auth.home.arpa/realms/homelab/broker/google/endpoint
```

Google exige crear credenciales OAuth para aplicaciones web y registrar las redirect URIs autorizadas; esas URIs deben coincidir exactamente con las que usa la app, incluyendo esquema `http/https`, mayúsculas/minúsculas y barra final si la hay. ([Google for Developers](https://developers.google.com/identity/protocols/oauth2/web-server "Using OAuth 2.0 for Web Server Applications  |  Authorization  |  Google for Developers"))

El orden bueno sigue siendo:

```text
1. Grafana con Keycloak local
2. Google dentro de Keycloak
3. Botón Google
4. Auto-redirección a Google
```

Así queda bonito para el usuario sin perder el control centralizado.




Perfecto, con esa salida ya está clarísimo:

```text
Keycloak health: OK ✅
Keycloak web: OK ✅
Nextcloud: OK ✅
CT112 socket-proxy: NO responde ❌
```

El único fallo real de esos logs de Homarr es este:

```text
192.168.1.82:2375 → NO RESPONDE
```

Eso corresponde al **socket-proxy del CT112 proxy**. En tu guía Homarr usa `socket-proxy` para consultar los Dockers remotos por el puerto `2375`, y en la comprobación aparece también `192.168.1.82:2375` como uno de los hosts esperados. En tu plano, `192.168.1.82` es el CT112 proxy/NPM.

---

# 1. Arreglar CT112 socket-proxy

En Portainer:

```text
CT112-proxy
→ Stacks
→ Add stack
```

Nombre:

```text
socket-proxy
```

Compose:

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
      - "192.168.1.82:2375:2375"
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

Dale a **Deploy**.

---

# 2. Comprobar desde CT101 dashboard

En **CT101 dashboard**, pega:

```bash
echo "===== CT112 socket-proxy ====="
curl -s --max-time 5 http://192.168.1.82:2375/_ping || echo "NO RESPONDE"

echo
echo "===== CT112 docker info ====="
curl -s --max-time 5 http://192.168.1.82:2375/info | head || echo "NO RESPONDE"
```

Tiene que salir:

```text
OK
```

Con eso Homarr dejará de quejarse de:

```text
connect ECONNREFUSED 192.168.1.82:2375
```

---

# 3. Keycloak en Homarr está bien, pero cambia el health check

Keycloak funciona:

```text
http://10.10.10.74:9000/health/ready → UP ✅
http://10.10.10.74:8080 → 302 ✅
```

Pero para Homarr es mejor poner:

```text
App URL:
https://auth.home.arpa

Health check URL:
http://10.10.10.74:9000/health/ready
```

No uses `http://10.10.10.74:8080` como check principal, porque redirige a `auth.home.arpa/admin/`.

---

# 4. Nextcloud también está bien

Nextcloud responde:

```text
http://10.10.10.65:8088 → 302 Found ✅
Location: https://nextcloud.home.arpa/login
```

Para Homarr mejor pon:

```text
App URL:
https://nextcloud.home.arpa

Health check URL:
http://10.10.10.65:8088/status.php
```

Ese `/status.php` suele ser más limpio para comprobar Nextcloud que la página de login.

---

# 5. Después reinicia Homarr

Cuando hayas levantado el socket-proxy de CT112 y cambiado esos checks:

```bash
cd /opt/stacks/homarr-v1
docker restart homarr-v1
docker logs homarr-v1 --tail=80
```

Resultado esperado:

```text
192.168.1.82:2375 → OK
Keycloak → OK
Nextcloud → OK
```

Resumen: **no es problema de Google, ni Keycloak, ni OAuth**. Es solo que Homarr tenía configurado CT112 en Docker remoto, pero CT112 no tenía el `socket-proxy` escuchando en `2375`.






Perfecto. Siguiente bloque: **Google → Keycloak → Grafana**, pero lo vamos a hacer sin romper el login local de Grafana.

Tu estructura ya está preparada para esto: `grafana.home.arpa` y `auth.home.arpa` van por el proxy `192.168.1.82`, y Grafana realmente está detrás en `10.10.10.50:3002`.

La idea final será:

```text
https://grafana.home.arpa
→ botón Google
→ Keycloak homelab
→ Google
→ vuelve a Keycloak
→ vuelve a Grafana
```

Grafana soporta Keycloak por OAuth/OIDC y además permite usar `kc_idp_hint=google` para mandar directo al proveedor Google sin que el usuario vea tanta pantalla de Keycloak. ([Grafana Labs](https://grafana.com/docs/grafana/latest/setup-grafana/configure-access/configure-authentication/keycloak/ "Configure Keycloak OAuth2 authentication | Grafana documentation"))

---

# 0. Antes de tocar Grafana

No cierres tu sesión actual de Grafana.

Deja abierta una pestaña con:

```text
https://grafana.home.arpa
```

Así, si algo falla, sigues teniendo acceso local.

---

# 1. Comprobar que CT105 resuelve los dominios internos

Entra en:

```text
CT105 monitoring > Consola
```

Pega:

```bash
echo "===== DNS AUTH ====="
nslookup auth.home.arpa 192.168.1.53

echo
echo "===== HTTPS AUTH ====="
curl -k -I https://auth.home.arpa

echo
echo "===== HTTPS GRAFANA ====="
curl -k -I https://grafana.home.arpa
```

Si `auth.home.arpa` no resuelve, en **PVE Shell** mete DNS de AdGuard al CT105:

```bash
pct set 105 --nameserver 192.168.1.53 --searchdomain home.arpa
pct reboot 105
```

Luego vuelves a probar los tres comandos.

---

# 2. Crear OAuth Client en Google

Entra en Google Cloud:

```text
https://console.cloud.google.com/
```

Ve a:

```text
APIs & Services
→ OAuth consent screen
```

Configura lo básico:

```text
App name: Homelab Guillermo
User support email: tu Gmail
Audience/User type: External
Developer contact: tu Gmail
```

Si está en modo testing, añade tu Gmail como test user.

Luego:

```text
APIs & Services
→ Credentials
→ Create Credentials
→ OAuth client ID
```

Tipo:

```text
Web application
```

Nombre:

```text
Keycloak Homelab
```

En **Authorized redirect URIs**, pon exactamente:

```text
https://auth.home.arpa/realms/homelab/broker/google/endpoint
```

Google exige que las redirect URIs usen HTTPS, no sean IPs crudas y coincidan exactamente; si no, dará `redirect_uri_mismatch`. ([Ayuda de Google](https://support.google.com/cloud/answer/15549257?hl=en "Manage OAuth Clients - Google Cloud Platform Console Help"))

Guarda:

```text
Client ID
Client Secret
```

Ojo: si Google no acepta `home.arpa`, no sigas inventando. Entonces habría que usar un dominio real tuyo o una URL HTTPS válida tipo Tailscale/Funnel. Primero prueba con `home.arpa`.

---




# 2. Meter Google en Keycloak

Entra en:

```text
https://auth.home.arpa/admin/
```

Cambia arriba a:

```text
Realm: homelab
```

Ve a:

```text
Identity providers
→ Add provider
→ Google
```

Pon:

```text
Alias: google
Display name: Google
Client ID: el nuevo Client ID de Google
Client Secret: el nuevo Client Secret de Google
Default scopes: openid email profile
Trust email: ON
Enabled: ON
```

Guarda.

---

Sí, **así está bien** ✅

Lo importante está correcto:

```text
Redirect URI:
https://auth.home.arpa/realms/homelab/broker/google/endpoint

Alias:
google

Display name:
Google

Client ID:
relleno ✅

Client Secret:
relleno ✅
```

Además encaja con tu guía: `auth.home.arpa` forma parte de los dominios internos `.home.arpa` y todos apuntan al proxy `192.168.1.82`, con certificado local `home-arpa-local`.

Puedes dejar así:

```text
Display order: vacío
Prompt: vacío
Hosted Domain: vacío
Use userIp param: OFF
Request refresh token: OFF
JWT Authorization Grant: OFF
Max allowed assertion expiration: 3600
```

Dale a:

```text
Add
```

---

Después de guardarlo, prueba esto en ventana privada:

```text
https://auth.home.arpa/realms/homelab/account/
```

Te debería salir el botón de Google.

Ojo con una cosa: en Google Cloud te salía que el acceso OAuth está restringido a **test users**. Eso significa que de momento solo podrán entrar los Gmail que hayas añadido como usuarios de prueba en el OAuth consent screen.

Si te sale error, casi seguro será por una de estas dos cosas:

```text
1. Tu Gmail no está añadido como test user.
2. La redirect URI en Google Cloud no coincide exactamente.
```

Tiene que estar exactamente así en Google:

```text
https://auth.home.arpa/realms/homelab/broker/google/endpoint
```

Sin barra final.

Cuando te deje entrar con Google a la cuenta de Keycloak, seguimos con:

```text
Keycloak → Clients → grafana
```

y luego conectamos Grafana con este login.


Perfecto. Eso significa que **Google → Keycloak homelab ya funciona** ✅

Lo que estás viendo es la cuenta creada/importada desde Google dentro del realm `homelab`. Ahora toca conectar **Grafana**.

Tu guía encaja con esto porque `grafana.home.arpa` está en CT105 `10.10.10.50:3002`, `auth.home.arpa` existe como dominio interno, y los servicios `.home.arpa` van por el proxy `192.168.1.82` con certificado local `home-arpa-local`.

---

# 1. Meter tu usuario de Google en grupos

Vuelve a:

```text
https://auth.home.arpa/admin/
```

Cambia a:

```text
Realm: homelab
```

Ve a:

```text
Users
→ busca el usuario de Google que acaba de entrar
→ Groups
→ Join group
```

Añade:

```text
homelab-admins
homelab-users
```

Así Keycloak podrá decirle a Grafana que tú eres admin.

---

# 2. Crear client `grafana` en Keycloak

En Keycloak:

```text
Realm homelab
→ Clients
→ Create client
```

Pon:

```text
Client type: OpenID Connect
Client ID: grafana
Name: Grafana
```

Siguiente.

Configura:

```text
Client authentication: ON
Authorization: OFF
Standard flow: ON
Direct access grants: OFF
Implicit flow: OFF
Service accounts: OFF
```

Siguiente.

Pon:

```text
Root URL:
https://grafana.home.arpa

Home URL:
https://grafana.home.arpa

Valid redirect URIs:
https://grafana.home.arpa/login/generic_oauth

Valid post logout redirect URIs:
https://grafana.home.arpa/*

Web origins:
https://grafana.home.arpa
```

Guarda.

Luego entra en:

```text
Clients
→ grafana
→ Credentials
```

Copia el:

```text
Client secret
```

Guárdalo en Vaultwarden. No lo pegues aquí.

---

Sí, estás en el sitio correcto. En tu versión de Keycloak el botón no sale exactamente como “Group Membership” directamente; tienes que entrar por **Configure a new mapper**.

Tu guía va con el patrón `auth.home.arpa` / `grafana.home.arpa` detrás de NPM y certificado local `home-arpa-local`, así que este mapper es justo para que Grafana reciba los grupos del realm `homelab` y pueda asignarte rol.

Hazlo así:

# Mapper de grupos para Grafana

En esa pantalla:

```text
grafana-dedicated
→ Mappers
→ Configure a new mapper
```

Te saldrá una lista de tipos. Elige:

```text
Group Membership
```

Si no lo ves a primera vista, busca algo como:

```text
Group Membership
```

Luego rellena:

```text
Name:
groups

Token Claim Name:
groups

Full group path:
ON

Add to ID token:
ON

Add to access token:
ON

Add to userinfo:
ON
```

Guarda.

Tiene que quedar un mapper llamado:

```text
groups
```

---

# Si no aparece “Group Membership”

Usa el otro botón:

```text
Add predefined mapper
```

y mira si aparece algo parecido a:

```text
groups
group membership
```

Pero lo normal es que esté en:

```text
Configure a new mapper
→ Group Membership
```

---

# Después comprueba tus grupos

Antes de ir a Grafana, revisa que tu usuario de Google esté en:

```text
Realm homelab
→ Users
→ tu usuario de Google
→ Groups
```

Debe tener:

```text
homelab-admins
homelab-users
```

Como pusimos `Full group path: ON`, Grafana recibirá:

```text
/homelab-admins
/homelab-users
```

Por eso en Grafana usamos esta línea:

```text
contains(groups[*], '/homelab-admins') && 'Admin' || contains(groups[*], '/homelab-users') && 'Viewer' || 'Viewer'
```

Cuando tengas el mapper `groups` creado, ya puedes pasar al bloque de configurar Grafana en CT105.




El problema está clarísimo: **has metido el placeholder como secret**.

Tu salida lo confirma:

```text
GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET=PEGA_AQUI_EL_SECRET_DE_GRAFANA
```

O sea, al principio escribiste el secret real, pero luego pegaste el bloque completo y esta línea lo sobrescribió:

```bash
SECRET='PEGA_AQUI_EL_SECRET_DE_GRAFANA'
```

Además, como el secret real ya ha salido en la conversación, yo lo regeneraría en Keycloak para ir limpio. La guía también avisa que los secretos reales deben sustituirse por claves propias y no quedarse como placeholders.

---

# 1. Regenerar secret del client `grafana`

En Keycloak:

```text
Realm homelab
→ Clients
→ grafana
→ Credentials
→ Regenerate secret
```

Copia el nuevo secret y guárdalo en Vaultwarden.

No lo pegues aquí.

---

# 2. Meter el secret bien en CT105

En **CT105 monitoring**, pega esto:

```bash
cd /opt/stacks/monitoring

echo "===== INTRODUCE EL NUEVO SECRET DE GRAFANA ====="
read -s -p "Client secret grafana: " SECRET
echo

echo "===== ACTUALIZAR .env ====="
grep -v '^GRAFANA_CLIENT_SECRET=' .env 2>/dev/null > .env.tmp || true
echo "GRAFANA_CLIENT_SECRET=$SECRET" >> .env.tmp
mv .env.tmp .env
chmod 600 .env

echo "===== RECREAR GRAFANA ====="
docker compose up -d --force-recreate grafana

sleep 12

echo "===== COMPROBAR QUE YA NO ESTA EL PLACEHOLDER ====="
docker exec grafana printenv | grep 'GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET' | sed 's/=.*/=********/'

echo
echo "===== CONFIG OAUTH SIN SECRET ====="
docker exec grafana printenv | grep -E 'GF_SERVER|GF_AUTH_GENERIC|GF_AUTH_OAUTH|GF_AUTH_DISABLE' | grep -v 'CLIENT_SECRET' | sort

echo
echo "===== LOGS RECIENTES ====="
docker logs grafana --tail=80
```

Cuando te pida:

```text
Client secret grafana:
```

pegas el secret nuevo de Keycloak. No se verá en pantalla, eso está bien.

---

# 3. Ignora este error de momento

Este error:

```text
Failed to install plugin elasticsearch ... permission denied
```

No tiene que ver con OAuth. Grafana está arrancando y la config OAuth se ha cargado. Lo arreglamos luego si molesta, pero ahora no bloquea el login.

---

# 4. Probar login

Ahora abre incógnito:

```text
https://grafana.home.arpa
```

Debería salir el botón:

```text
Sign in with Google
```

Al pulsarlo:

```text
Grafana
→ Keycloak
→ Google
→ Keycloak
→ Grafana
```

Tu guía tiene `grafana.home.arpa` como CT105 `10.10.10.50` puerto `3002`, y todos los servicios `.home.arpa` usan el certificado local `home-arpa-local`, así que la ruta por NPM/AdGuard es coherente con lo que estás haciendo.

Si falla, mándame solo esto:

```bash
docker logs grafana --tail=120 | grep -i -E 'oauth|login|error|token|auth'
```

No pegues la línea del secret.




Perfecto, entonces ya tienes:

```text
Google → Keycloak homelab → Grafana ✅
```

Ahora toca el último ajuste para que sea como querías: **que el usuario casi no vea Keycloak**.

# 1. Activar auto-login en Grafana

En **CT105 monitoring**, pega:

```bash
cd /opt/stacks/monitoring

echo "===== BACKUP DEL OVERRIDE ====="
cp docker-compose.override.yml docker-compose.override.yml.bak.autologin.$(date +%F-%H%M)

echo
echo "===== ACTIVAR AUTO LOGIN OAUTH ====="
sed -i 's/GF_AUTH_OAUTH_AUTO_LOGIN: "false"/GF_AUTH_OAUTH_AUTO_LOGIN: "true"/' docker-compose.override.yml

echo
echo "===== APLICAR ====="
docker compose up -d
docker restart grafana

sleep 10

echo
echo "===== COMPROBAR ====="
docker exec grafana printenv | grep -E 'GF_AUTH_OAUTH_AUTO_LOGIN|GF_AUTH_GENERIC_OAUTH_AUTH_URL'
docker logs grafana --tail=60
```

Con esto, al abrir:

```text
https://grafana.home.arpa
```

el flujo visual será:

```text
Grafana
→ Google
→ Grafana
```

Aunque por debajo seguirá siendo:

```text
Grafana
→ Keycloak homelab
→ Google
→ Keycloak
→ Grafana
```

Tu estructura encaja con esto porque `grafana.home.arpa` y `auth.home.arpa` están dentro de los dominios `.home.arpa` que resuelven al proxy `192.168.1.82`, y la guía usa el certificado local `home-arpa-local` para estos servicios internos.

---

# 2. Probar en ventana privada

Abre incógnito:

```text
https://grafana.home.arpa
```

Debe mandarte casi directo a Google.

Si entra bien y ves Grafana, queda cerrado.

---

# 3. Mantener plan B por seguridad

Como todavía tienes:

```text
GF_AUTH_DISABLE_LOGIN_FORM: "false"
```

el login local de Grafana sigue disponible. Eso está bien de momento.

Si en algún momento te bloqueas, puedes desactivar el auto-login así:

```bash
cd /opt/stacks/monitoring

sed -i 's/GF_AUTH_OAUTH_AUTO_LOGIN: "true"/GF_AUTH_OAUTH_AUTO_LOGIN: "false"/' docker-compose.override.yml

docker compose up -d
docker restart grafana
```

---

# 4. Estado final de este bloque

```text
CT113 identity
├── Keycloak ✅
├── Realm homelab ✅
├── Google Identity Provider ✅
├── Client grafana ✅
├── Mapper groups ✅
└── OAuth/OIDC funcionando ✅

CT105 monitoring
├── Grafana ✅
├── Login local todavía activo ✅
├── Login Google por Keycloak ✅
└── Auto-login OAuth activable ✅
```

Después de esto, el siguiente servicio ideal para integrar sería **Uptime Kuma o Homarr**, pero Grafana ya es la prueba buena de que el sistema SSO funciona.






Sí, me gusta mucho la idea, pero lo haría en **dos capas**:

```text
1. Script central en Keycloak
   → crea los clients OIDC de cada app
   → mete mapper de grupos
   → genera secrets
   → deja todo preparado en auth.home.arpa

2. Script/app específica
   → aplica la configuración dentro de Grafana, Homarr, Immich, Portainer, etc.
```

No conviene un único script que “copie Grafana a todas”, porque cada app tiene sus variables distintas. Pero sí podemos crear una **fábrica SSO** que deje todos los clients creados igual que Grafana y luego vamos activando app por app.

Además, tu guía ya tiene todos los servicios `.home.arpa` apuntando al proxy `192.168.1.82`, con `auth.home.arpa`, `grafana.home.arpa`, `homarr.home.arpa`, `paperless.home.arpa`, `nextcloud.home.arpa`, `immich.home.arpa`, etc. en la lista de DNS rewrites. Y tu plano deja claro que el CT de identity es para Keycloak/OAuth2/OpenID en `10.10.10.74`.

Sobre lo de Google: sí, con esto obligas a que el usuario tenga una cuenta Google válida y, mientras tu app OAuth siga en modo testing, solo podrán entrar los correos que tú metas como **test users** en Google Cloud. No es “seguridad mágica”, pero es muchísimo mejor que dejar formularios sueltos o cuentas temporales.

---

# Apps que sí metería en este sistema

Las candidatas buenas son:

```text
Grafana       ✅ ya funciona
Homarr        ✅ buen candidato para SSO
Immich        ✅ buen candidato para familia/fotos
Portainer     ✅ posible, pero con cuidado
Nextcloud     ✅ posible, pero lo haría despacio
Paperless     ✅ posible, pero lo dejaría para después
Uptime Kuma   ⚠️ posible según versión/config, pero no lo tocaría primero
```

Homarr soporta OIDC según su documentación, Immich soporta autenticación externa vía OIDC, y Portainer tiene configuración OAuth desde el panel de autenticación. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/?utm_source=chatgpt.com "Single Sign On | Homarr documentation")) Grafana ya lo hemos hecho con Generic OAuth/Keycloak, que es el método documentado por Grafana. ([Grafana Labs](https://grafana.com/docs/grafana/latest/setup-grafana/configure-access/configure-authentication/generic-oauth/?utm_source=chatgpt.com "Configure Generic OAuth authentication"))

No metería todavía:

```text
Proxmox
NPM
AdGuard
Vaultwarden
Adminer
pgAdmin
```

Esos son más delicados o no interesa tocarlos a lo bruto. Primero hacemos apps “reversibles”.

---

# 1. Script: fábrica de clients SSO en Keycloak

Esto se ejecuta en:

```text
CT113 identity
```

Crea clients OIDC para varias apps y genera un archivo con los secrets.

Pega esto en **CT113 identity**:

```bash
mkdir -p /root/scripts /root/secrets

cat > /root/scripts/keycloak-sso-factory.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.parse
import urllib.request
import urllib.error
from pathlib import Path

KEYCLOAK_URL = "http://127.0.0.1:8080"
PUBLIC_AUTH_URL = "https://auth.home.arpa"
ADMIN_REALM = "master"
REALM = "homelab"

OUTPUT = Path("/root/secrets/keycloak-sso-client-secrets.env")

APPS = [
    {
        "client_id": "grafana",
        "name": "Grafana",
        "home": "https://grafana.home.arpa",
        "redirect_uris": [
            "https://grafana.home.arpa/login/generic_oauth"
        ],
        "web_origins": [
            "https://grafana.home.arpa"
        ],
    },
    {
        "client_id": "homarr",
        "name": "Homarr",
        "home": "https://homarr.home.arpa",
        "redirect_uris": [
            "https://homarr.home.arpa/*"
        ],
        "web_origins": [
            "https://homarr.home.arpa"
        ],
    },
    {
        "client_id": "immich",
        "name": "Immich",
        "home": "https://immich.home.arpa",
        "redirect_uris": [
            "https://immich.home.arpa/*"
        ],
        "web_origins": [
            "https://immich.home.arpa"
        ],
    },
    {
        "client_id": "nextcloud",
        "name": "Nextcloud",
        "home": "https://nextcloud.home.arpa",
        "redirect_uris": [
            "https://nextcloud.home.arpa/*"
        ],
        "web_origins": [
            "https://nextcloud.home.arpa"
        ],
    },
    {
        "client_id": "paperless",
        "name": "Paperless",
        "home": "https://paperless.home.arpa",
        "redirect_uris": [
            "https://paperless.home.arpa/*"
        ],
        "web_origins": [
            "https://paperless.home.arpa"
        ],
    },
    {
        "client_id": "portainer",
        "name": "Portainer",
        "home": "https://portainer.home.arpa",
        "redirect_uris": [
            "https://portainer.home.arpa/*"
        ],
        "web_origins": [
            "https://portainer.home.arpa"
        ],
    },
]

def request(method, url, token=None, data=None):
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
            try:
                return json.loads(raw)
            except json.JSONDecodeError:
                return raw
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR HTTP {e.code} en {url}\n{detail}") from e

def form_post(url, form):
    data = urllib.parse.urlencode(form).encode()
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR login Keycloak HTTP {e.code}\n{detail}") from e

def get_token():
    print("===== LOGIN ADMIN KEYCLOAK =====")
    user = input("Usuario admin Keycloak master [admin-guillermo]: ").strip() or "admin-guillermo"
    password = getpass.getpass("Password admin Keycloak: ")

    res = form_post(
        f"{KEYCLOAK_URL}/realms/{ADMIN_REALM}/protocol/openid-connect/token",
        {
            "grant_type": "password",
            "client_id": "admin-cli",
            "username": user,
            "password": password,
        },
    )
    return res["access_token"]

def get_client(token, client_id):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients?clientId={urllib.parse.quote(client_id)}"
    res = request("GET", url, token=token)
    return res[0] if res else None

def get_group(token, name):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/groups?search={urllib.parse.quote(name)}"
    res = request("GET", url, token=token)
    for g in res or []:
        if g.get("name") == name:
            return g
    return None

def ensure_group(token, name):
    g = get_group(token, name)
    if g:
        print(f"Grupo existe: {name}")
        return g

    request(
        "POST",
        f"{KEYCLOAK_URL}/admin/realms/{REALM}/groups",
        token=token,
        data={"name": name},
    )
    g = get_group(token, name)
    print(f"Grupo creado: {name}")
    return g

def ensure_default_group(token, group):
    group_id = group["id"]
    try:
        request(
            "PUT",
            f"{KEYCLOAK_URL}/admin/realms/{REALM}/default-groups/{group_id}",
            token=token,
            data=None,
        )
        print(f"Grupo por defecto activado: {group['name']}")
    except SystemExit:
        print(f"AVISO: no se pudo poner {group['name']} como grupo por defecto. Puedes hacerlo manualmente.")

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
        "authorizationServicesEnabled": False,
        "frontchannelLogout": True,
        "rootUrl": app["home"],
        "baseUrl": app["home"],
        "redirectUris": app["redirect_uris"],
        "webOrigins": app["web_origins"],
        "attributes": {
            "post.logout.redirect.uris": app["home"] + "/*",
            "pkce.code.challenge.method": "S256",
        },
    }

    if existing:
        cid = existing["id"]
        request(
            "PUT",
            f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{cid}",
            token=token,
            data=payload,
        )
        print(f"Client actualizado: {app['client_id']}")
    else:
        request(
            "POST",
            f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients",
            token=token,
            data=payload,
        )
        cid = get_client(token, app["client_id"])["id"]
        print(f"Client creado: {app['client_id']}")

    return get_client(token, app["client_id"])["id"]

def ensure_group_mapper(token, client_uuid):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{client_uuid}/protocol-mappers/models"
    mappers = request("GET", url, token=token) or []

    wanted_name = "groups"
    payload = {
        "name": wanted_name,
        "protocol": "openid-connect",
        "protocolMapper": "oidc-group-membership-mapper",
        "consentRequired": False,
        "config": {
            "full.path": "true",
            "id.token.claim": "true",
            "access.token.claim": "true",
            "userinfo.token.claim": "true",
            "claim.name": "groups",
        },
    }

    for m in mappers:
        if m.get("name") == wanted_name:
            request(
                "PUT",
                f"{url}/{m['id']}",
                token=token,
                data=payload,
            )
            print("  Mapper groups actualizado")
            return

    request("POST", url, token=token, data=payload)
    print("  Mapper groups creado")

def get_secret(token, client_uuid):
    res = request(
        "GET",
        f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{client_uuid}/client-secret",
        token=token,
    )
    return res["value"]

def main():
    token = get_token()

    print()
    print("===== GRUPOS BASE =====")
    admins = ensure_group(token, "homelab-admins")
    users = ensure_group(token, "homelab-users")
    ensure_group(token, "familia")
    ensure_group(token, "invitados")

    print()
    print("===== DEFAULT GROUP =====")
    ensure_default_group(token, users)

    print()
    print("===== CLIENTS SSO =====")
    secrets = []
    for app in APPS:
        client_uuid = ensure_client(token, app)
        ensure_group_mapper(token, client_uuid)
        secret = get_secret(token, client_uuid)

        key = app["client_id"].upper().replace("-", "_")
        secrets.append(f"{key}_CLIENT_ID={app['client_id']}")
        secrets.append(f"{key}_CLIENT_SECRET={secret}")
        secrets.append(f"{key}_ISSUER={PUBLIC_AUTH_URL}/realms/{REALM}")
        secrets.append("")

    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT.write_text("\n".join(secrets))
    OUTPUT.chmod(0o600)

    print()
    print("===== LISTO =====")
    print(f"Secrets guardados en: {OUTPUT}")
    print()
    print("No pegues ese archivo en chats. Guárdalo en Vaultwarden.")
    print()
    print("Issuer común:")
    print(f"{PUBLIC_AUTH_URL}/realms/{REALM}")
    print()
    print("Discovery URL:")
    print(f"{PUBLIC_AUTH_URL}/realms/{REALM}/.well-known/openid-configuration")

if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/keycloak-sso-factory.py
python3 /root/scripts/keycloak-sso-factory.py
```

Cuando termine, te deja los secrets aquí:

```bash
/root/secrets/keycloak-sso-client-secrets.env
```

Para verlos **solo en tu consola** y guardarlos en Vaultwarden:

```bash
cat /root/secrets/keycloak-sso-client-secrets.env
```

No lo pegues en el chat.

---

# 2. Qué hace este script exactamente

Crea esto en Keycloak:

```text
Realm homelab
├── Groups
│   ├── homelab-admins
│   ├── homelab-users
│   ├── familia
│   └── invitados
│
├── Clients OIDC
│   ├── grafana
│   ├── homarr
│   ├── immich
│   ├── nextcloud
│   ├── paperless
│   └── portainer
│
└── Mapper en cada client
    └── groups → ID token / access token / userinfo
```

Y deja un patrón común:

```text
Issuer:
https://auth.home.arpa/realms/homelab

Auth URL:
https://auth.home.arpa/realms/homelab/protocol/openid-connect/auth?kc_idp_hint=google

Token URL:
https://auth.home.arpa/realms/homelab/protocol/openid-connect/token

Userinfo URL:
https://auth.home.arpa/realms/homelab/protocol/openid-connect/userinfo

Scopes:
openid email profile
```

---

# 3. Sobre “todos admin de momento”

Aquí iría con cuidado.

No haría esto:

```text
Cualquier Google que entre → Admin en todas las apps
```

Haría esto:

```text
Tu Gmail → homelab-admins
Familia → familia / homelab-users
Invitados → invitados
```

Así, aunque Google confirme que la persona existe, Keycloak decide qué puede hacer. Esa es la gracia:

```text
Google = quién eres
Keycloak = qué permisos tienes
App = servicio final
```

Además, como tu OAuth de Google está en modo testing, primero solo entran los correos añadidos como **test users**. Eso te da una capa extra para evitar que entre cualquiera.

---

# 4. Siguiente automatización real

Después de ejecutar la fábrica, yo haría scripts por app en este orden:

```text
1. Homarr
2. Immich
3. Portainer
4. Nextcloud
5. Paperless
```

El siguiente que te recomiendo es **Homarr**, porque es el dashboard y queda muy limpio que entre directo con Google/Keycloak.

Para cada app haremos un script tipo:

```text
aplicar-sso-homarr.sh
aplicar-sso-immich.sh
aplicar-sso-portainer.sh
aplicar-sso-nextcloud.sh
aplicar-sso-paperless.sh
```

Pero todos leerán del mismo archivo:

```bash
/root/secrets/keycloak-sso-client-secrets.env
```

Ejemplo mental:

```text
Homarr lee:
HOMARR_CLIENT_ID=homarr
HOMARR_CLIENT_SECRET=...

Immich lee:
IMMICH_CLIENT_ID=immich
IMMICH_CLIENT_SECRET=...

Portainer lee:
PORTAINER_CLIENT_ID=portainer
PORTAINER_CLIENT_SECRET=...
```

Así no vas creando secretos a mano cada vez.

---

# 5. Antes de seguir

Ejecuta primero el script de fábrica en CT113. Cuando termine, dime si ves esto:

```text
Client creado/actualizado: grafana
Client creado/actualizado: homarr
Client creado/actualizado: immich
Client creado/actualizado: nextcloud
Client creado/actualizado: paperless
Client creado/actualizado: portainer
Secrets guardados en: /root/secrets/keycloak-sso-client-secrets.env
```

Y luego seguimos con **aplicar SSO a Homarr**.

No se ha roto nada. El fallo es este:

```text
ConnectionRefusedError: [Errno 111] Connection refused
```

Tu script intenta hablar con Keycloak en:

```text
http://127.0.0.1:8080
```

pero tu contenedor Keycloak está publicado en:

```text
10.10.10.74:8080
```

No en `127.0.0.1`. Además, por el pegado raro hay dos posibles erratas dentro del script: `admin-gillermo` y `protocol-mappers/moels`.

Tu guía confirma que `auth.home.arpa` va por el proxy `192.168.1.82` y que `auth.home.arpa` está dentro de la lista de dominios internos `.home.arpa` . Tu plano también marca el CT identity en `10.10.10.74` para Keycloak/OAuth2/OpenID .

Pega esto en **CT113 identity**:

```bash
echo "===== COMPROBAR KEYCLOAK ====="
curl -I --max-time 5 http://127.0.0.1:8080 || echo "127.0.0.1 NO responde, normal"
curl -I --max-time 5 http://10.10.10.74:8080 || echo "10.10.10.74 NO responde"

echo
echo "===== ARREGLAR SCRIPT ====="
sed -i 's|KEYCLOAK_URL = "http://127.0.0.1:8080"|KEYCLOAK_URL = "http://10.10.10.74:8080"|' /root/scripts/keycloak-sso-factory.py
sed -i 's/admin-gillermo/admin-guillermo/g' /root/scripts/keycloak-sso-factory.py
sed -i 's|protocol-mappers/moels|protocol-mappers/models|g' /root/scripts/keycloak-sso-factory.py

echo
echo "===== VERIFICAR LINEAS CLAVE ====="
grep -nE 'KEYCLOAK_URL|admin-guillermo|protocol-mappers' /root/scripts/keycloak-sso-factory.py

echo
echo "===== COMPROBAR SINTAXIS ====="
python3 -m py_compile /root/scripts/keycloak-sso-factory.py && echo "Sintaxis OK"

echo
echo "===== EJECUTAR OTRA VEZ ====="
python3 /root/scripts/keycloak-sso-factory.py
```

Cuando pregunte:

```text
Usuario admin Keycloak master [admin-guillermo]:
```

pulsa Enter o escribe:

```text
admin-guillermo
```

Y luego mete la contraseña de `admin-guillermo`.

Si después de eso te sale error de login tipo `invalid_grant` o algo de OTP/2FA, me pegas solo ese error. Ahí el problema ya no sería conexión, sino que el usuario admin tiene 2FA y habría que hacerlo con otro método.

Vale, ese error ya no es de conexión. Ahora es login:

```
{"error":"invalid_grant","error_description":"Invalid user credentials"}
```

Significa una de estas dos cosas:

```
1. La contraseña de admin-guillermo no es la que has puesto.2. Ese usuario tiene 2FA/OTP y el script no puede entrar solo con usuario+contraseña.
```

Como este CT113 está montado para Keycloak en `10.10.10.74` y `auth.home.arpa`, exactamente como tu plano de identity/OAuth/OpenID, lo mejor es no usar tu admin personal para scripts. Vamos a crear un **client de automatización** en Keycloak con service account. Así el script no necesita tu contraseña ni OTP.

---

# 1. Crear client de automatización en Keycloak

Entra en:

```
https://auth.home.arpa/admin/
```

Realm:

```
homelab
```

Ve a:

```
Clients→ Create client
```

Pon:

```
Client type: OpenID ConnectClient ID: keycloak-automationName: Keycloak Automation
```

Siguiente.

Activa:

```
Client authentication: ONService accounts roles: ONStandard flow: OFFDirect access grants: OFFImplicit flow: OFFAuthorization: OFF
```

Guarda.

Sí, estás en el sitio correcto, pero **no es la pestaña “Roles”**. Esa pestaña crea roles propios del client, y **eso no nos sirve ahora**.

Lo que falta es activar bien el client para que aparezcan estas pestañas:

```text
Credentials
Service account roles
```

Ahora mismo en tu captura se ve el problema:

```text
Client authentication: OFF
Standard flow: ON
```

Para automatización tiene que ser al revés.

---

# 1. Arregla el client `keycloak-automation`

En esa misma pantalla de **Settings**, baja a **Capability config** y pon:

```text
Client authentication: ON
Authorization: OFF

Authentication flow:
Standard flow: OFF
Direct access grants: OFF
Service accounts roles: ON
```

Si al activar `Client authentication: ON` todavía no ves `Service accounts roles`, dale a **Save** primero y vuelve a entrar al client.

No hace falta poner:

```text
Root URL
Home URL
Valid redirect URIs
Web origins
```

Este client no es para login web, es solo para scripts.

Dale a:

```text
Save
```

Tu homelab ya usa `auth.home.arpa` como dominio interno y el identity CT está en `10.10.10.74`, así que este client solo será una herramienta interna para automatizar Keycloak.

---

# 2. Copiar el secret

Después de guardar, debería aparecer una pestaña:

```text
Credentials
```

Entra ahí y copia:

```text
Client secret
```

Guárdalo en Vaultwarden.

No lo pegues aquí.

---

# 3. Dar permisos al service account

Ahora debería aparecer otra pestaña:

```text
Service account roles
```

Entra ahí:

```text
Service account roles
→ Assign role
```

En el filtro, cambia a algo tipo:

```text
Filter by clients
```

Busca:

```text
realm-management
```

Y asigna estos roles:

```text
manage-clients
manage-realm
manage-users
view-clients
view-realm
view-users
```

No uses la pestaña **Roles** que enseñas en la segunda captura. Esa no es para esto.

---


Pega esto en **CT113 identity**:

```bash
cd /root/scripts

echo "===== PARCHEAR MAPPER PARA NO ACTUALIZAR SI YA EXISTE ====="

python3 - <<'PY'
from pathlib import Path

p = Path("/root/scripts/keycloak-sso-factory.py")
text = p.read_text()

start = text.index("def ensure_group_mapper(")
end = text.index("\ndef get_secret", start)

new_func = r'''def ensure_group_mapper(token, client_uuid):
    url = f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{client_uuid}/protocol-mappers/models"
    mappers = request("GET", url, token=token) or []

    wanted_name = "groups"

    for m in mappers:
        if m.get("name") == wanted_name:
            print("  Mapper groups ya existe, no se toca")
            return

    payload = {
        "name": wanted_name,
        "protocol": "openid-connect",
        "protocolMapper": "oidc-group-membership-mapper",
        "consentRequired": False,
        "config": {
            "full.path": "true",
            "id.token.claim": "true",
            "access.token.claim": "true",
            "userinfo.token.claim": "true",
            "claim.name": "groups",
        },
    }

    request("POST", url, token=token, data=payload)
    print("  Mapper groups creado")
'''

text = text[:start] + new_func + text[end:]
p.write_text(text)
PY

echo
echo "===== COMPROBAR SINTAXIS ====="
python3 -m py_compile /root/scripts/keycloak-sso-factory.py && echo "Sintaxis OK"

echo
echo "===== EJECUTAR SCRIPT ====="
python3 /root/scripts/keycloak-sso-factory.py
```

Cuando pregunte:

```text
Client ID automation [keycloak-automation]:
```

pulsa **Enter**.

Cuando pregunte:

```text
Client secret automation:
```

pega el secret de `keycloak-automation`.

---

Resultado bueno esperado:

```text
Client actualizado: grafana
  Mapper groups ya existe, no se toca

Client creado: homarr
  Mapper groups creado

Client creado: immich
  Mapper groups creado

Client creado: nextcloud
  Mapper groups creado

Client creado: paperless
  Mapper groups creado

Client creado: portainer
  Mapper groups creado

Secrets guardados en: /root/secrets/keycloak-sso-client-secrets.env
```

Luego comprueba que existe el archivo:

```bash
ls -lh /root/secrets/keycloak-sso-client-secrets.env
```

Y para verlo **solo tú**:

```bash
cat /root/secrets/keycloak-sso-client-secrets.env
```

No pegues ese contenido aquí; guárdalo en Vaultwarden.


Vale, eso tiene sentido. **La “contraseña” que pegaste NO es una contraseña para iniciar sesión en Homarr**. Es el **Client Secret OIDC de Homarr**, o sea, una clave interna que usa Homarr para hablar con Keycloak. Tú nunca la usas en el navegador.

El flujo es:

```text
Tú abres Homarr
→ Homarr usa HOMARR_CLIENT_SECRET por detrás
→ Homarr pregunta a Keycloak
→ Keycloak manda a Google
→ Google valida tu cuenta
→ vuelves a Homarr
```

Según la documentación de Homarr, para OIDC se controla con variables como `AUTH_PROVIDERS`, `AUTH_OIDC_ISSUER`, `AUTH_OIDC_CLIENT_ID`, `AUTH_OIDC_CLIENT_SECRET`, etc. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation")) Y en tu guía, Homarr activo es `homarr-v1`, ruta `/opt/stacks/homarr-v1`, puerto `7575`, base de datos `/opt/stacks/homarr-v1/appdata/db/db.sqlite`.

Ahora hay que ver si Homarr ha cogido esas variables o no.

---

Perfecto. Entonces la **fábrica SSO ya está creada** ✅

Has conseguido esto:

```text
Client actualizado: grafana
Client creado: homarr
Client creado: immich
Client creado: nextcloud
Client creado: paperless
Client creado: portainer

Secrets guardados en:
/root/secrets/keycloak-sso-client-secrets.env
```

No pegues ese archivo aquí. Guárdalo en Vaultwarden. Tu guía confirma que el Homarr activo es `homarr-v1`, está en `/opt/stacks/homarr-v1`, usa puerto `7575` y su base de datos está en `/opt/stacks/homarr-v1/appdata/db/db.sqlite`.

Ahora vamos con **Homarr → Keycloak → Google**.

---

# 1. Importante antes de tocar Homarr

Homarr soporta `credentials`, `ldap` y `oidc`, y permite activar varios proveedores separados por coma, por ejemplo `credentials,oidc`. Para no bloquearte, primero dejaremos:

```text
AUTH_PROVIDERS=credentials,oidc
```

Así sigues teniendo el login local/root por si algo falla. Cuando esté probado, lo dejamos en `oidc` solo. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation"))

Además, Homarr crea usuarios OIDC automáticamente y puede sincronizar grupos desde el claim `groups`, pero para que los permisos funcionen tienes que crear en Homarr un grupo con el mismo nombre y darle permisos. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation"))

---

# 2. Copia el secret de Homarr desde CT113

En **CT113 identity**, mira el archivo solo para ti:

```bash
cat /root/secrets/keycloak-sso-client-secrets.env
```

Busca estas líneas:

```text
HOMARR_CLIENT_ID=homarr
HOMARR_CLIENT_SECRET=...
HOMARR_ISSUER=https://auth.home.arpa/realms/homelab
```

Copia solo el valor de:

```text
HOMARR_CLIENT_SECRET
```

No lo pegues aquí.

---

# 3. Aplicar SSO en Homarr

Entra en:

```text
CT101 dashboard > Consola
```

Pega esto:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP HOMARR ====="
cp docker-compose.yml docker-compose.yml.bak.sso.$(date +%F-%H%M)
[ -f .env ] && cp .env .env.bak.sso.$(date +%F-%H%M) || true

echo
echo "===== INTRODUCE SECRET DE HOMARR ====="
read -s -p "HOMARR_CLIENT_SECRET: " HOMARR_SECRET
echo

echo
echo "===== GUARDAR SECRET EN .env ====="
grep -v '^HOMARR_CLIENT_SECRET=' .env 2>/dev/null > .env.tmp || true
echo "HOMARR_CLIENT_SECRET=$HOMARR_SECRET" >> .env.tmp
mv .env.tmp .env
chmod 600 .env

echo
echo "===== PARCHEAR DOCKER-COMPOSE HOMARR ====="
python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

remove_keys = [
    "BASE_URL=",
    "NEXTAUTH_URL=",
    "AUTH_PROVIDERS=",
    "AUTH_OIDC_CLIENT_ID=",
    "AUTH_OIDC_CLIENT_SECRET=",
    "AUTH_OIDC_ISSUER=",
    "AUTH_OIDC_CLIENT_NAME=",
    "AUTH_OIDC_SCOPE_OVERWRITE=",
    "AUTH_OIDC_GROUPS_ATTRIBUTE=",
    "AUTH_OIDC_AUTO_LOGIN=",
    "AUTH_OIDC_FORCE_USERINFO=",
    "AUTH_LOGOUT_REDIRECT_URL=",
]

lines = []
for line in text.splitlines():
    stripped = line.strip()
    if stripped.startswith("- "):
        env = stripped[2:]
        if any(env.startswith(k) for k in remove_keys):
            continue
    lines.append(line)

insert = [
    "      - BASE_URL=https://homarr.home.arpa",
    "      - NEXTAUTH_URL=https://homarr.home.arpa",
    "      - AUTH_PROVIDERS=credentials,oidc",
    "      - AUTH_OIDC_CLIENT_ID=homarr",
    "      - AUTH_OIDC_CLIENT_SECRET=${HOMARR_CLIENT_SECRET}",
    "      - AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab",
    "      - AUTH_OIDC_CLIENT_NAME=Google",
    "      - AUTH_OIDC_SCOPE_OVERWRITE=openid email profile groups",
    "      - AUTH_OIDC_GROUPS_ATTRIBUTE=groups",
    "      - AUTH_OIDC_AUTO_LOGIN=false",
    "      - AUTH_OIDC_FORCE_USERINFO=true",
    "      - AUTH_LOGOUT_REDIRECT_URL=https://homarr.home.arpa",
]

out = []
inserted = False

for line in lines:
    out.append(line)
    if line.strip().startswith("- SECRET_ENCRYPTION_KEY="):
        out.extend(insert)
        inserted = True

if not inserted:
    raise SystemExit("ERROR: No encontré SECRET_ENCRYPTION_KEY en docker-compose.yml")

p.write_text("\n".join(out) + "\n")
PY

echo
echo "===== CONFIG SSO AÑADIDA ====="
grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' docker-compose.yml

echo
echo "===== REINICIAR HOMARR ====="
docker compose up -d
docker restart homarr-v1

sleep 15

echo
echo "===== LOGS HOMARR ====="
docker logs homarr-v1 --tail=120
```

---

# 4. Probar login

Abre ventana privada:

```text
https://homarr.home.arpa
```

Deberías ver login local y opción OIDC/Google. En esta primera prueba está bien que no te mande automático porque hemos puesto:

```text
AUTH_OIDC_AUTO_LOGIN=false
```

Cuando pulses Google/OIDC, el flujo será:

```text
Homarr
→ Keycloak homelab
→ Google
→ Keycloak
→ Homarr
```

---

# 5. Dar permisos admin en Homarr

Entra con tu usuario local/root de Homarr y crea un grupo:

```text
Management
→ Users / Groups
→ Groups
→ Create group
```

Nombre exacto:

```text
homelab-admins
```

Luego dale permisos de admin o todos los permisos disponibles.

Tu usuario de Google ya está en Keycloak dentro de:

```text
homelab-admins
homelab-users
```

Como el mapper envía `groups`, Homarr podrá asociarte al grupo si existe con el mismo nombre. Homarr documenta justo ese patrón: crear un grupo con el mismo nombre que el proveedor OIDC y asignarle permisos. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation"))

---

# 6. Cuando funcione, hacerlo invisible

Cuando confirmes que entras con Google y tienes permisos, en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

cp docker-compose.yml docker-compose.yml.bak.sso-autologin.$(date +%F-%H%M)

sed -i 's/AUTH_PROVIDERS=credentials,oidc/AUTH_PROVIDERS=oidc/' docker-compose.yml
sed -i 's/AUTH_OIDC_AUTO_LOGIN=false/AUTH_OIDC_AUTO_LOGIN=true/' docker-compose.yml

docker compose up -d
docker restart homarr-v1

sleep 10
docker logs homarr-v1 --tail=80
```

Así el usuario casi no verá Homarr login:

```text
homarr.home.arpa
→ Google
→ Homarr
```

pero por debajo seguirá siendo:

```text
Homarr
→ Keycloak
→ Google
→ Keycloak
→ Homarr
```

---

# 7. Rollback rápido si algo falla

En **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUPS DISPONIBLES ====="
ls -1 docker-compose.yml.bak.sso.*

echo
echo "Para volver atrás:"
echo "cp docker-compose.yml.bak.sso.FECHA docker-compose.yml"
echo "docker compose up -d && docker restart homarr-v1"
```

Primero déjalo con `credentials,oidc`. Cuando me confirmes que entras con Google, lo pasamos a `oidc` + `auto-login`.


Vale, eso tiene sentido. **La “contraseña” que pegaste NO es una contraseña para iniciar sesión en Homarr**. Es el **Client Secret OIDC de Homarr**, o sea, una clave interna que usa Homarr para hablar con Keycloak. Tú nunca la usas en el navegador.

El flujo es:

```text
Tú abres Homarr
→ Homarr usa HOMARR_CLIENT_SECRET por detrás
→ Homarr pregunta a Keycloak
→ Keycloak manda a Google
→ Google valida tu cuenta
→ vuelves a Homarr
```

Según la documentación de Homarr, para OIDC se controla con variables como `AUTH_PROVIDERS`, `AUTH_OIDC_ISSUER`, `AUTH_OIDC_CLIENT_ID`, `AUTH_OIDC_CLIENT_SECRET`, etc. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation")) Y en tu guía, Homarr activo es `homarr-v1`, ruta `/opt/stacks/homarr-v1`, puerto `7575`, base de datos `/opt/stacks/homarr-v1/appdata/db/db.sqlite`.

Ahora hay que ver si Homarr ha cogido esas variables o no.

---

# 1. Comprobar si Homarr tiene OIDC cargado

En **CT101 dashboard**, pega:

```bash
cd /opt/stacks/homarr-v1

echo "===== COMPOSE AUTH ====="
grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' docker-compose.yml || true

echo
echo "===== ENV REAL DENTRO DEL CONTENEDOR ====="
docker exec homarr-v1 printenv | grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' | sort || true

echo
echo "===== PROVIDERS API ====="
curl -k -s https://homarr.home.arpa/api/auth/providers || true

echo
echo "===== SIGNIN PAGE ====="
curl -k -I https://homarr.home.arpa/api/auth/signin || true

echo
echo "===== LOGS AUTH HOMARR ====="
docker logs homarr-v1 --tail=150 | grep -i -E 'auth|oidc|provider|nextauth|error|warn' || true
```

Pásame esa salida, pero **si aparece `AUTH_OIDC_CLIENT_SECRET`, bórralo antes de mandarlo**.

---

# 2. Si no aparecen variables `AUTH_OIDC`

Si el comando muestra que dentro del contenedor no existen estas líneas:

```text
AUTH_PROVIDERS=...
AUTH_OIDC_CLIENT_ID=...
AUTH_OIDC_ISSUER=...
```

entonces Homarr no ha cargado la configuración y hay que parchear el compose otra vez.

---

# 3. Configuración correcta que queremos ver

Al final debería aparecer algo parecido a esto dentro del contenedor:

```text
BASE_URL=https://homarr.home.arpa
NEXTAUTH_URL=https://homarr.home.arpa
AUTH_PROVIDERS=oidc,credentials
AUTH_OIDC_CLIENT_ID=homarr
AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab
AUTH_OIDC_CLIENT_NAME=Google
AUTH_OIDC_SCOPE_OVERWRITE=openid email profile groups
AUTH_OIDC_GROUPS_ATTRIBUTE=groups
AUTH_OIDC_FORCE_USERINFO=true
AUTH_OIDC_AUTO_LOGIN=false
```

Homarr documenta que `AUTH_PROVIDERS` puede usar varios proveedores separados por coma, por ejemplo `credentials,oidc`, y que los usuarios OIDC se crean al iniciar sesión. También indica que los grupos se sincronizan desde el claim configurado en `AUTH_OIDC_GROUPS_ATTRIBUTE`. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation"))

---

# 4. Ojo con el callback de Homarr en Keycloak

En Keycloak, el client `homarr` debería tener este redirect exacto:

```text
https://homarr.home.arpa/api/auth/callback/oidc
```

En la fábrica pusimos wildcard, pero Homarr espera ese callback concreto. Luego lo revisamos si el login ya aparece pero falla al volver.

---

# 5. Qué debería pasar visualmente

Con esta fase de pruebas:

```text
AUTH_PROVIDERS=oidc,credentials
AUTH_OIDC_AUTO_LOGIN=false
```

al abrir:

```text
https://homarr.home.arpa
```

debería salir login local y opción Google/OIDC.

Cuando ya funcione, pondremos:

```text
AUTH_PROVIDERS=oidc
AUTH_OIDC_AUTO_LOGIN=true
```

y ahí sí quedará como Grafana: entras a Homarr y te manda casi directo a Google.

Vale, ya está claro el problema:

```text
COMPOSE AUTH: vacío ❌
ENV REAL: AUTH_PROVIDERS=credentials ❌
curl homarr.home.arpa: no resuelve DNS ❌
```

O sea: **Homarr no ha cogido nada de OIDC**. Sigue igual que antes, solo con login local:

```text
AUTH_PROVIDERS=credentials
```

Además, la guía confirma que el Homarr activo es `homarr-v1`, ruta `/opt/stacks/homarr-v1`, puerto `7575` y base de datos `/opt/stacks/homarr-v1/appdata/db/db.sqlite`, así que estamos tocando el sitio correcto.

Vamos a hacerlo más directo y robusto.

---

# 1. Arreglar DNS del CT101 dashboard

En **PVE Shell**, pega:

```bash
pct set 101 --nameserver 192.168.1.53 --searchdomain home.arpa
pct reboot 101
```

Cuando reinicie, entra otra vez en **CT101 dashboard** y comprueba:

```bash
cat /etc/resolv.conf
nslookup homarr.home.arpa
curl -k -I https://homarr.home.arpa
```

Tiene que resolver:

```text
homarr.home.arpa → 192.168.1.82
```

---

# 2. Ver el compose real antes de tocarlo

En **CT101 dashboard**, pega:

```bash
cd /opt/stacks/homarr-v1

echo "===== DOCKER COMPOSE HOMARR ACTUAL ====="
cat docker-compose.yml
```

No hace falta que me lo pegues si no quieres, pero esto es para que tú veas dónde está `environment:`.

---

# 3. Aplicar OIDC a Homarr, versión robusta

En **CT101 dashboard**, pega esto. Te pedirá el secret de Homarr que salió en:

```text
/root/secrets/keycloak-sso-client-secrets.env
```

concretamente:

```text
HOMARR_CLIENT_SECRET=...
```

Pega:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP HOMARR ====="
cp docker-compose.yml docker-compose.yml.bak.sso.$(date +%F-%H%M)
[ -f .env ] && cp .env .env.bak.sso.$(date +%F-%H%M) || true

echo
echo "===== INTRODUCE SECRET OIDC DE HOMARR ====="
read -s -p "HOMARR_CLIENT_SECRET: " HOMARR_SECRET
echo

echo
echo "===== GUARDAR SECRET EN .env ====="
grep -v '^HOMARR_CLIENT_SECRET=' .env 2>/dev/null > .env.tmp || true
echo "HOMARR_CLIENT_SECRET=$HOMARR_SECRET" >> .env.tmp
mv .env.tmp .env
chmod 600 .env

echo
echo "===== PARCHEAR COMPOSE HOMARR ====="
python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

remove_prefixes = [
    "BASE_URL=",
    "NEXTAUTH_URL=",
    "AUTH_PROVIDERS=",
    "AUTH_OIDC_CLIENT_ID=",
    "AUTH_OIDC_CLIENT_SECRET=",
    "AUTH_OIDC_ISSUER=",
    "AUTH_OIDC_CLIENT_NAME=",
    "AUTH_OIDC_SCOPE_OVERWRITE=",
    "AUTH_OIDC_GROUPS_ATTRIBUTE=",
    "AUTH_OIDC_AUTO_LOGIN=",
    "AUTH_OIDC_FORCE_USERINFO=",
    "AUTH_LOGOUT_REDIRECT_URL=",
]

auth_lines = [
    "      - BASE_URL=https://homarr.home.arpa",
    "      - NEXTAUTH_URL=https://homarr.home.arpa",
    "      - AUTH_PROVIDERS=credentials,oidc",
    "      - AUTH_OIDC_CLIENT_ID=homarr",
    "      - AUTH_OIDC_CLIENT_SECRET=${HOMARR_CLIENT_SECRET}",
    "      - AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab",
    "      - AUTH_OIDC_CLIENT_NAME=Google",
    "      - AUTH_OIDC_SCOPE_OVERWRITE=openid email profile groups",
    "      - AUTH_OIDC_GROUPS_ATTRIBUTE=groups",
    "      - AUTH_OIDC_AUTO_LOGIN=false",
    "      - AUTH_OIDC_FORCE_USERINFO=true",
    "      - AUTH_LOGOUT_REDIRECT_URL=https://homarr.home.arpa",
]

lines = text.splitlines()

clean = []
for line in lines:
    stripped = line.strip()
    if stripped.startswith("- "):
        value = stripped[2:]
        if any(value.startswith(prefix) for prefix in remove_prefixes):
            continue
    clean.append(line)

out = []
inserted = False

for i, line in enumerate(clean):
    out.append(line)

    if line.strip() == "environment:" and not inserted:
        out.extend(auth_lines)
        inserted = True

if not inserted:
    raise SystemExit("ERROR: No encontré bloque environment: en docker-compose.yml")

p.write_text("\n".join(out) + "\n")
PY

echo
echo "===== COMPOSE AUTH RESULTANTE ====="
grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' docker-compose.yml

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1

sleep 20

echo
echo "===== ENV REAL DENTRO DEL CONTENEDOR ====="
docker exec homarr-v1 printenv | grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' | grep -v SECRET | sort

echo
echo "===== LOGS HOMARR ====="
docker logs homarr-v1 --tail=120
```

---

# 4. Resultado que queremos ver

Después del comando, tiene que salir dentro del contenedor algo así:

```text
AUTH_PROVIDERS=credentials,oidc
AUTH_OIDC_CLIENT_ID=homarr
AUTH_OIDC_CLIENT_NAME=Google
AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab
AUTH_OIDC_AUTO_LOGIN=false
BASE_URL=https://homarr.home.arpa
NEXTAUTH_URL=https://homarr.home.arpa
```

Si eso sale, ya estará cargado.

---

# 5. Probar Homarr

Abre incógnito:

```text
https://homarr.home.arpa
```

Ahora sí debería aparecer opción de login con OIDC/Google o algo equivalente.

Si no aparece, prueba directamente:

```text
https://homarr.home.arpa/api/auth/signin
```

---

# 6. Si sigue sin salir login

Pega esto en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== AUTH ENV SIN SECRET ====="
docker exec homarr-v1 printenv | grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' | grep -v SECRET | sort

echo
echo "===== PROVIDERS ====="
curl -k -s https://homarr.home.arpa/api/auth/providers

echo
echo "===== LOGS AUTH ====="
docker logs homarr-v1 --tail=200 | grep -i -E 'auth|oidc|provider|nextauth|error|warn'
```

No pegues el `HOMARR_CLIENT_SECRET`.

---

Resumen rápido: **no te salía nada porque Homarr seguía con `AUTH_PROVIDERS=credentials` y el compose ni siquiera tenía las variables OIDC**. Ahora vamos a meterlas de verdad y recrear el contenedor.

Vale, ahora sí lo vemos claro: tu `docker-compose.yml` actual **no tiene nada de OIDC**, por eso Homarr sigue solo con:

```text
AUTH_PROVIDERS=credentials
```

Vamos a rehacer el compose completo, respetando lo que ya tienes: `SECRET_ENCRYPTION_KEY`, `DOCKER_HOSTNAMES`, `DOCKER_PORTS`, puerto `7575` y volumen `/opt/stacks/homarr-v1/appdata`. Tu guía confirma que la instancia activa es `homarr-v1`, en `/opt/stacks/homarr-v1`, puerto `7575` y DB en `/opt/stacks/homarr-v1/appdata/db/db.sqlite`.

---

# 1. Parchear Homarr bien

En **CT101 dashboard**, pega esto:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP COMPOSE ====="
cp docker-compose.yml docker-compose.yml.bak.sso.$(date +%F-%H%M)
[ -f .env ] && cp .env .env.bak.sso.$(date +%F-%H%M) || true

echo
echo "===== INTRODUCE EL SECRET OIDC DE HOMARR ====="
read -s -p "HOMARR_CLIENT_SECRET: " HOMARR_SECRET
echo

echo
echo "===== GUARDAR SECRET EN .env ====="
cat > .env <<EOF
HOMARR_CLIENT_SECRET=$HOMARR_SECRET
EOF
chmod 600 .env

echo
echo "===== RECREAR DOCKER-COMPOSE CON OIDC ====="
cat > docker-compose.yml <<'EOF'
services:
  homarr-v1:
    image: ghcr.io/homarr-labs/homarr:latest
    container_name: homarr-v1
    restart: unless-stopped
    ports:
      - "7575:7575"
    environment:
      - SECRET_ENCRYPTION_KEY=b9bbe031b034c88bdbebfac89e848d45a6bc26dbe5da11bbbbbed068dc2c6362

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

      - DOCKER_HOSTNAMES=192.168.1.79,192.168.1.80,192.168.1.81,10.10.10.50,10.10.10.60,10.10.10.40,10.10.10.65,10.10.10.30,10.10.10.70,10.10.10.73,192.168.1.82,10.10.10.74
      - DOCKER_PORTS=2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375,2375
    volumes:
      - /opt/stacks/homarr-v1/appdata:/appdata
      - /var/run/docker.sock:/var/run/docker.sock
EOF

echo
echo "===== VER COMPOSE AUTH ====="
grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' docker-compose.yml

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1

sleep 20

echo
echo "===== ENV REAL DENTRO DEL CONTENEDOR ====="
docker exec homarr-v1 printenv | grep -E 'BASE_URL|NEXTAUTH_URL|AUTH_PROVIDERS|AUTH_OIDC|AUTH_LOGOUT' | grep -v SECRET | sort

echo
echo "===== LOGS HOMARR ====="
docker logs homarr-v1 --tail=120
```

Cuando te pida:

```text
HOMARR_CLIENT_SECRET:
```

pegas el valor de:

```text
HOMARR_CLIENT_SECRET=...
```

del archivo de CT113:

```bash
/root/secrets/keycloak-sso-client-secrets.env
```

No pegues ese secret aquí.

---

# 2. Lo que queremos ver

Después del comando, dentro del contenedor debe salir algo así:

```text
AUTH_PROVIDERS=credentials,oidc
AUTH_OIDC_AUTO_LOGIN=false
AUTH_OIDC_CLIENT_ID=homarr
AUTH_OIDC_CLIENT_NAME=Google
AUTH_OIDC_FORCE_USERINFO=true
AUTH_OIDC_GROUPS_ATTRIBUTE=groups
AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab
BASE_URL=https://homarr.home.arpa
NEXTAUTH_URL=https://homarr.home.arpa
```

---

# 3. Probar login

Abre incógnito:

```text
https://homarr.home.arpa/api/auth/signin
```

Mejor prueba esa URL directamente, no solo la home.

Debería salir algo tipo:

```text
Sign in with credentials
Sign in with Google
```

o un botón OIDC/Google.

---

# 4. Si aparece error de redirect

En Keycloak revisa el client `homarr`:

```text
Realm homelab
→ Clients
→ homarr
```

En **Valid redirect URIs**, añade esta exacta si no está:

```text
https://homarr.home.arpa/api/auth/callback/oidc
```

Puedes dejar también:

```text
https://homarr.home.arpa/*
```

Pero esa concreta es la importante para Homarr.

---

Pega primero la salida de `ENV REAL DENTRO DEL CONTENEDOR` si sigue sin aparecer el login.

Vale, ahora ya no estamos en el error anterior. **Esto es avance**:

```text
Login con Google ya aparece ✅
Homarr detecta OIDC ✅
Homarr ya llega a Keycloak ✅
El error de certificado ya está saltado ✅
```

El fallo actual es este:

```text
OAUTH_INVALID_RESPONSE
OAuthCallbackError
provider="oidc"
```

Ese error existe tal cual reportado en Homarr con OIDC/Auth.js: llega al callback, pero la respuesta OAuth no cuadra con lo esperado. ([GitHub](https://github.com/homarr-labs/homarr/issues/4406 "bug: OIDC not working with Cloudflare Zero Trust / SaaS · Issue #4406 · homarr-labs/homarr · GitHub"))

Además, en tu caso yo veo una cosa sospechosa: estamos pidiendo este scope:

```text
openid email profile groups
```

Pero en Keycloak no hemos creado un **client scope** llamado `groups`; hemos creado un mapper `groups`. Para Keycloak/Grafana nos bastó con:

```text
openid email profile
```

Homarr puede leer grupos desde `userinfo` porque tienes `AUTH_OIDC_FORCE_USERINFO=true` y el mapper manda `groups`. La documentación de Homarr dice que OIDC usa `AUTH_OIDC_GROUPS_ATTRIBUTE` para leer los grupos desde el claim, y que los grupos de Homarr deben llamarse igual que los del proveedor. ([homarr.dev](https://homarr.dev/docs/advanced/single-sign-on/ "Single Sign On | Homarr documentation"))

Vamos a probar el arreglo limpio.

---

# 1. Parchear Homarr: quitar `groups` del scope

En **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP ANTES DE FIX OIDC ====="
cp docker-compose.yml docker-compose.yml.bak.oidcfix.$(date +%F-%H%M)

echo
echo "===== QUITAR groups DEL SCOPE ====="
sed -i 's/AUTH_OIDC_SCOPE_OVERWRITE=openid email profile groups/AUTH_OIDC_SCOPE_OVERWRITE=openid email profile/' docker-compose.yml

echo
echo "===== AÑADIR NAME ATTRIBUTE SI NO EXISTE ====="
grep -q 'AUTH_OIDC_NAME_ATTRIBUTE_OVERWRITE=' docker-compose.yml || \
sed -i '/AUTH_OIDC_GROUPS_ATTRIBUTE=groups/a\      - AUTH_OIDC_NAME_ATTRIBUTE_OVERWRITE=name' docker-compose.yml

echo
echo "===== COMPROBAR OIDC ====="
grep -E 'AUTH_PROVIDERS|AUTH_OIDC|BASE_URL|NEXTAUTH|NODE_TLS' docker-compose.yml | grep -v SECRET

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1

sleep 20

echo
echo "===== ENV REAL SIN SECRET ====="
docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC|BASE_URL|NEXTAUTH|NODE_TLS' | grep -v SECRET | sort

echo
echo "===== LOGS AUTH ====="
docker logs homarr-v1 --tail=120 | grep -i -E 'auth|oidc|provider|callback|error|warn' || true
```

---

# 2. Parchear client `homarr` en Keycloak

Ahora vamos a dejar el client de Keycloak más exacto. En **CT113 identity**:

```bash
cat > /root/scripts/fix-keycloak-homarr-client.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.parse
import urllib.request
import urllib.error

KEYCLOAK_URL = "http://10.10.10.74:8080"
REALM = "homelab"
CLIENT_ID = "keycloak-automation"
TARGET_CLIENT = "homarr"

def form_post(url, form):
    data = urllib.parse.urlencode(form).encode()
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )
    with urllib.request.urlopen(req, timeout=20) as r:
        return json.loads(r.read().decode())

def request(method, url, token, data=None):
    body = None
    headers = {"Authorization": f"Bearer {token}"}
    if data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=body, headers=headers, method=method)
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            raw = r.read().decode()
            return json.loads(raw) if raw else None
    except urllib.error.HTTPError as e:
        print(e.read().decode(errors="ignore"))
        raise

secret = getpass.getpass("Client secret keycloak-automation: ")

token = form_post(
    f"{KEYCLOAK_URL}/realms/{REALM}/protocol/openid-connect/token",
    {
        "grant_type": "client_credentials",
        "client_id": CLIENT_ID,
        "client_secret": secret,
    },
)["access_token"]

clients = request(
    "GET",
    f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients?clientId={TARGET_CLIENT}",
    token,
)

if not clients:
    raise SystemExit("No existe client homarr")

client = clients[0]
uuid = client["id"]

client["enabled"] = True
client["publicClient"] = False
client["clientAuthenticatorType"] = "client-secret"
client["standardFlowEnabled"] = True
client["implicitFlowEnabled"] = False
client["directAccessGrantsEnabled"] = False
client["serviceAccountsEnabled"] = False
client["redirectUris"] = [
    "https://homarr.home.arpa/api/auth/callback/oidc",
    "https://homarr.home.arpa/*",
]
client["webOrigins"] = [
    "https://homarr.home.arpa",
]
client["rootUrl"] = "https://homarr.home.arpa"
client["baseUrl"] = "https://homarr.home.arpa"

attrs = client.get("attributes") or {}
attrs.pop("pkce.code.challenge.method", None)
attrs["post.logout.redirect.uris"] = "https://homarr.home.arpa/*"
client["attributes"] = attrs

request(
    "PUT",
    f"{KEYCLOAK_URL}/admin/realms/{REALM}/clients/{uuid}",
    token,
    client,
)

print("Client homarr corregido:")
print("- redirect exacto añadido")
print("- web origin añadido")
print("- PKCE quitado para evitar líos con Auth.js/Homarr")
PY

chmod +x /root/scripts/fix-keycloak-homarr-client.py
python3 /root/scripts/fix-keycloak-homarr-client.py
```

Cuando pida:

```text
Client secret keycloak-automation:
```

pega el secret de `keycloak-automation`.

---

# 3. Limpia sesión/cookies antes de probar

Como el error es de `state/callback`, puede quedar una cookie OAuth vieja. Haz una de estas dos cosas:

```text
Opción rápida:
abrir una ventana incógnito nueva de verdad
```

o en el navegador:

```text
Borrar datos del sitio homarr.home.arpa
Borrar datos del sitio auth.home.arpa
```

Luego entra directamente aquí:

```text
https://homarr.home.arpa/api/auth/signin/oidc
```

No pulses muchas veces el botón. Una sola vez y espera.

---

# 4. Si falla otra vez, saca el error limpio

En **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== LOGS LOGIN LIMPIOS ====="
docker logs homarr-v1 --since=3m | grep -i -E 'auth|oidc|provider|callback|oauth|token|error|warn'

echo
echo "===== PROVIDERS ====="
curl -k -s https://homarr.home.arpa/api/auth/providers
```

No pegues secrets.

---

Resumen: **el botón ya aparece**, así que Homarr ya está viendo OIDC. Ahora estamos corrigiendo el callback. Primero quitamos `groups` del scope, dejamos Keycloak con redirect exacto y limpiamos cookies de OAuth.


Vale. He releído tus fuentes y **la idea correcta no es un script gigante que toque Grafana, Homarr, Immich, Nextcloud, Paperless y Portainer a la vez**. Tu propio plano ya lo deja claro: primero una capa central en Keycloak que crea los clients OIDC, grupos, mappers y secrets; luego cada app se configura por separado porque cada una usa variables y callbacks distintos.

Tu arquitectura base también cuadra: `auth.home.arpa` debe ir a `192.168.1.82`, que es el proxy, y desde ahí NPM manda a Keycloak en `10.10.10.74:8080`. Eso ya lo tenías funcionando según tus pruebas y según la guía del proxy/DNS.

Así que vamos a hacer **solo el script bueno de Keycloak**, idempotente y seguro. No toca Homarr, no toca Grafana, no rompe apps. Solo deja Keycloak limpio para que las apps usen SSO.

## Antes de ejecutar nada

En **PVE Shell**, haz snapshot/backup de lo importante:

```
vzdump 101 105 112 113 --storage hdd250-backups --mode snapshot --compress zstd
```

Luego en **CT113 identity**, pega esto.

## Script bueno: fábrica OIDC Keycloak

```
mkdir -p /root/scripts /root/secretscat > /root/scripts/keycloak-oidc-factory-safe.py <<'PY'#!/usr/bin/env python3import jsonimport getpassimport urllib.parseimport urllib.requestimport urllib.errorimport timefrom pathlib import PathKEYCLOAK_INTERNAL_URL = "http://10.10.10.74:8080"KEYCLOAK_PUBLIC_URL = "https://auth.home.arpa"REALM = "homelab"OUTPUT = Path("/root/secrets/keycloak-oidc-client-secrets.env")APPS = [    {        "client_id": "grafana",        "name": "Grafana",        "root_url": "https://grafana.home.arpa",        "redirect_uris": [            "https://grafana.home.arpa/login/generic_oauth"        ],        "web_origins": [            "https://grafana.home.arpa"        ],    },    {        "client_id": "homarr",        "name": "Homarr",        "root_url": "https://homarr.home.arpa",        "redirect_uris": [            "https://homarr.home.arpa/api/auth/callback/oidc"        ],        "web_origins": [            "https://homarr.home.arpa"        ],    },    {        "client_id": "immich",        "name": "Immich",        "root_url": "https://immich.home.arpa",        "redirect_uris": [            "https://immich.home.arpa/auth/login",            "https://immich.home.arpa/user-settings",            "https://immich.home.arpa/*"        ],        "web_origins": [            "https://immich.home.arpa"        ],    },    {        "client_id": "nextcloud",        "name": "Nextcloud",        "root_url": "https://nextcloud.home.arpa",        "redirect_uris": [            "https://nextcloud.home.arpa/*"        ],        "web_origins": [            "https://nextcloud.home.arpa"        ],    },    {        "client_id": "paperless",        "name": "Paperless",        "root_url": "https://paperless.home.arpa",        "redirect_uris": [            "https://paperless.home.arpa/accounts/oidc/keycloak/login/callback/",            "https://paperless.home.arpa/*"        ],        "web_origins": [            "https://paperless.home.arpa"        ],    },    {        "client_id": "portainer",        "name": "Portainer",        "root_url": "https://portainer.home.arpa",        "redirect_uris": [            "https://portainer.home.arpa/*"        ],        "web_origins": [            "https://portainer.home.arpa"        ],    },]GROUPS = [    "homelab-admins",    "homelab-users",    "familia",    "invitados",]def die(msg):    raise SystemExit(f"\nERROR: {msg}\n")def http_json(method, url, token=None, data=None, expected=(200, 201, 204)):    headers = {}    body = None    if token:        headers["Authorization"] = f"Bearer {token}"    if data is not None:        body = json.dumps(data).encode("utf-8")        headers["Content-Type"] = "application/json"    req = urllib.request.Request(url, data=body, headers=headers, method=method)    try:        with urllib.request.urlopen(req, timeout=20) as r:            raw = r.read().decode("utf-8", errors="ignore")            if r.status not in expected:                die(f"HTTP inesperado {r.status} en {url}: {raw}")            if not raw:                return None            try:                return json.loads(raw)            except json.JSONDecodeError:                return raw    except urllib.error.HTTPError as e:        detail = e.read().decode("utf-8", errors="ignore")        if e.code in expected:            return None        die(f"HTTP {e.code} en {url}\n{detail}")    except urllib.error.URLError as e:        die(f"No conecta con {url}\n{e}")def http_form(url, form):    data = urllib.parse.urlencode(form).encode("utf-8")    req = urllib.request.Request(        url,        data=data,        headers={"Content-Type": "application/x-www-form-urlencoded"},        method="POST",    )    try:        with urllib.request.urlopen(req, timeout=20) as r:            return json.loads(r.read().decode("utf-8"))    except urllib.error.HTTPError as e:        detail = e.read().decode("utf-8", errors="ignore")        die(f"Login Keycloak HTTP {e.code}\n{detail}")    except urllib.error.URLError as e:        die(f"No conecta con Keycloak token endpoint\n{e}")def preflight():    print("===== PREFLIGHT KEYCLOAK =====")    ready_url = f"{KEYCLOAK_INTERNAL_URL}/health/ready"    try:        health = urllib.request.urlopen(ready_url, timeout=10).read().decode()        print("Health endpoint OK")        if '"status": "UP"' not in health and '"status":"UP"' not in health:            print(health)            die("Keycloak no está UP todavía.")    except Exception as e:        die(f"No responde health endpoint: {ready_url}\n{e}")    config_url = f"{KEYCLOAK_INTERNAL_URL}/realms/{REALM}/.well-known/openid-configuration"    try:        urllib.request.urlopen(config_url, timeout=10).read()        print("Realm homelab OK")    except Exception as e:        die(f"No responde el realm {REALM}. Revisa que exista.\n{e}")    print("Preflight OK")def get_token():    print()    print("===== LOGIN ADMIN API =====")    print("Modo recomendado: service account del client keycloak-automation en realm homelab.")    print("Si falla, revisa que tenga roles de realm-management.")    auth_realm = input("Auth realm [homelab]: ").strip() or "homelab"    client_id = input("Client ID [keycloak-automation]: ").strip() or "keycloak-automation"    client_secret = getpass.getpass("Client secret: ")    res = http_form(        f"{KEYCLOAK_INTERNAL_URL}/realms/{auth_realm}/protocol/openid-connect/token",        {            "grant_type": "client_credentials",            "client_id": client_id,            "client_secret": client_secret,        },    )    token = res.get("access_token")    if not token:        die("No se recibió access_token.")    print("Login service account OK")    return tokendef get_group(token, name):    url = f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/groups?search={urllib.parse.quote(name)}"    groups = http_json("GET", url, token=token) or []    for g in groups:        if g.get("name") == name:            return g    return Nonedef ensure_group(token, name):    existing = get_group(token, name)    if existing:        print(f"Grupo existe: {name}")        return existing    http_json(        "POST",        f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/groups",        token=token,        data={"name": name},        expected=(201, 204),    )    time.sleep(0.5)    created = get_group(token, name)    if not created:        die(f"No se pudo crear/verificar grupo {name}")    print(f"Grupo creado: {name}")    return createddef ensure_default_group(token, group):    group_id = group["id"]    try:        http_json(            "PUT",            f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/default-groups/{group_id}",            token=token,            expected=(204, 409),        )        print(f"Grupo por defecto OK: {group['name']}")    except SystemExit:        print(f"AVISO: no se pudo poner como default group: {group['name']}")def get_client(token, client_id):    url = f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/clients?clientId={urllib.parse.quote(client_id)}"    res = http_json("GET", url, token=token) or []    return res[0] if res else Nonedef ensure_client(token, app):    existing = get_client(token, app["client_id"])    payload = {        "clientId": app["client_id"],        "name": app["name"],        "enabled": True,        "protocol": "openid-connect",        "publicClient": False,        "clientAuthenticatorType": "client-secret",        "standardFlowEnabled": True,        "implicitFlowEnabled": False,        "directAccessGrantsEnabled": False,        "serviceAccountsEnabled": False,        "authorizationServicesEnabled": False,        "frontchannelLogout": True,        "rootUrl": app["root_url"],        "baseUrl": app["root_url"],        "redirectUris": app["redirect_uris"],        "webOrigins": app["web_origins"],        "attributes": {            "pkce.code.challenge.method": "S256",            "post.logout.redirect.uris": app["root_url"] + "/*",        },    }    if existing:        uuid = existing["id"]        http_json(            "PUT",            f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/clients/{uuid}",            token=token,            data=payload,            expected=(204,),        )        print(f"Client actualizado: {app['client_id']}")    else:        http_json(            "POST",            f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/clients",            token=token,            data=payload,            expected=(201, 204),        )        time.sleep(0.5)        uuid = get_client(token, app["client_id"])["id"]        print(f"Client creado: {app['client_id']}")    return get_client(token, app["client_id"])["id"]def ensure_group_mapper(token, client_uuid):    url = f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/clients/{client_uuid}/protocol-mappers/models"    mappers = http_json("GET", url, token=token) or []    for mapper in mappers:        if mapper.get("name") == "groups":            print("  Mapper groups ya existe, no se toca")            return    payload = {        "name": "groups",        "protocol": "openid-connect",        "protocolMapper": "oidc-group-membership-mapper",        "consentRequired": False,        "config": {            "full.path": "true",            "id.token.claim": "true",            "access.token.claim": "true",            "userinfo.token.claim": "true",            "claim.name": "groups",        },    }    http_json(        "POST",        url,        token=token,        data=payload,        expected=(201, 204),    )    print("  Mapper groups creado")def get_secret(token, client_uuid):    res = http_json(        "GET",        f"{KEYCLOAK_INTERNAL_URL}/admin/realms/{REALM}/clients/{client_uuid}/client-secret",        token=token,    )    value = res.get("value")    if not value:        die("No se pudo leer client secret")    return valuedef main():    preflight()    token = get_token()    print()    print("===== GRUPOS =====")    group_objs = {}    for group in GROUPS:        group_objs[group] = ensure_group(token, group)    ensure_default_group(token, group_objs["homelab-users"])    print()    print("===== CLIENTS OIDC =====")    output_lines = [        f"KEYCLOAK_ISSUER={KEYCLOAK_PUBLIC_URL}/realms/{REALM}",        f"KEYCLOAK_DISCOVERY={KEYCLOAK_PUBLIC_URL}/realms/{REALM}/.well-known/openid-configuration",        "",    ]    for app in APPS:        uuid = ensure_client(token, app)        ensure_group_mapper(token, uuid)        secret = get_secret(token, uuid)        key = app["client_id"].upper().replace("-", "_")        output_lines.append(f"{key}_CLIENT_ID={app['client_id']}")        output_lines.append(f"{key}_CLIENT_SECRET={secret}")        output_lines.append(f"{key}_ISSUER={KEYCLOAK_PUBLIC_URL}/realms/{REALM}")        output_lines.append("")    OUTPUT.parent.mkdir(parents=True, exist_ok=True)    OUTPUT.write_text("\n".join(output_lines), encoding="utf-8")    OUTPUT.chmod(0o600)    print()    print("===== LISTO =====")    print(f"Archivo de secrets: {OUTPUT}")    print("No lo pegues en chats. Guárdalo en Vaultwarden.")    print()    print("Issuer:")    print(f"{KEYCLOAK_PUBLIC_URL}/realms/{REALM}")    print()    print("Discovery:")    print(f"{KEYCLOAK_PUBLIC_URL}/realms/{REALM}/.well-known/openid-configuration")if __name__ == "__main__":    main()PYchmod +x /root/scripts/keycloak-oidc-factory-safe.pypython3 -m py_compile /root/scripts/keycloak-oidc-factory-safe.py && echo "Sintaxis OK"
```

## Ejecutarlo

```
python3 /root/scripts/keycloak-oidc-factory-safe.py
```

Cuando termine, comprueba:

```
ls -lh /root/secrets/keycloak-oidc-client-secrets.envcat /root/secrets/keycloak-oidc-client-secrets.env | sed 's/=.*/=********/'
```

## Qué debe salir

Algo así:

```
Preflight OKLogin service account OKGrupo existe: homelab-adminsGrupo existe: homelab-usersGrupo por defecto OK: homelab-usersClient actualizado: grafana  Mapper groups ya existe, no se tocaClient actualizado: homarr  Mapper groups ya existe, no se tocaClient actualizado: immich  Mapper groups ya existe, no se toca...===== LISTO =====
```

Esto no debería romper nada porque:

```
- no borra clients- no borra users- no borra grupos- no cambia tu Google Identity Provider- no toca Docker- no toca Homarr- no toca Grafana- no toca NPM- no toca AdGuard
```

Lo siguiente después de esto no es “meter todas las apps”. Lo siguiente es **validar Homarr y dejarlo fino**, y solo cuando Homarr esté perfecto pasamos a Immich o Nextcloud. Ah, y los secrets que pegaste antes en el chat: regenéralos luego en Google Cloud/Keycloak cuando todo funcione, porque ya no los consideraría limpios.

root@identity:~# python3 /root/scripts/keycloak-oidc-factory-safe.py ===== PREFLIGHT KEYCLOAK ===== ERROR: No responde health endpoint: http://10.10.10.74:8080/health/ready HTTP Error 404: Not Found

Thought for 7s

Bien, esto **no significa que Keycloak esté mal**. El fallo es mío en el script:

```
http://10.10.10.74:8080/health/ready → 404
```

Porque en tu Keycloak el **health va por el puerto 9000**, no por el 8080.

Tú ya lo habías comprobado antes:

```
http://10.10.10.74:9000/health/ready → UP
```

Pega esto en `identity`:

```
cd /root/scriptsecho "===== PARCHEAR HEALTH DE 8080 A 9000 ====="python3 - <<'PY'from pathlib import Pathp = Path("/root/scripts/keycloak-oidc-factory-safe.py")text = p.read_text()# Añadir URL de management si no existeif 'KEYCLOAK_MGMT_URL' not in text:    text = text.replace(        'KEYCLOAK_INTERNAL_URL = "http://10.10.10.74:8080"\n',        'KEYCLOAK_INTERNAL_URL = "http://10.10.10.74:8080"\nKEYCLOAK_MGMT_URL = "http://10.10.10.74:9000"\n'    )# Cambiar solo el health endpointtext = text.replace(    'ready_url = f"{KEYCLOAK_INTERNAL_URL}/health/ready"',    'ready_url = f"{KEYCLOAK_MGMT_URL}/health/ready"')p.write_text(text)PYechoecho "===== COMPROBAR SINTAXIS ====="python3 -m py_compile /root/scripts/keycloak-oidc-factory-safe.py && echo "Sintaxis OK"echoecho "===== PROBAR HEALTH REAL ====="curl -s http://10.10.10.74:9000/health/readyechoechoecho "===== EJECUTAR SCRIPT ====="python3 /root/scripts/keycloak-oidc-factory-safe.py
```

Ahora debería pasar de:

```
Preflight OKRealm homelab OK
```

y pedirte:

```
Auth realm [homelab]:Client ID [keycloak-automation]:Client secret:
```

Ahí mete el secret bueno del service account `keycloak-automation`.

root@identity:~/scripts# python3 /root/scripts/keycloak-oidc-factory-safe.py ===== PREFLIGHT KEYCLOAK ===== Health endpoint OK Realm homelab OK Preflight OK ===== LOGIN ADMIN API ===== Modo recomendado: service account del client keycloak-automation en realm homelab. Si falla, revisa que tenga roles de realm-management. Auth realm [homelab]: Client ID [keycloak-automation]: Client secret: Login service account OK ===== GRUPOS ===== Grupo existe: homelab-admins Grupo existe: homelab-users Grupo existe: familia Grupo existe: invitados Grupo por defecto OK: homelab-users ===== CLIENTS OIDC ===== Client actualizado: grafana Mapper groups ya existe, no se toca Client actualizado: homarr Mapper groups ya existe, no se toca Client actualizado: immich Mapper groups ya existe, no se toca Client actualizado: nextcloud Mapper groups ya existe, no se toca Client actualizado: paperless Mapper groups ya existe, no se toca Client actualizado: portainer Mapper groups ya existe, no se toca ===== LISTO ===== Archivo de secrets: /root/secrets/keycloak-oidc-client-secrets.env No lo pegues en chats. Guárdalo en Vaultwarden. Issuer: https://auth.home.arpa/realms/homelab Discovery: https://auth.home.arpa/realms/homelab/.well-known/openid-configuration root@identity:~/scripts#

Thought for 9s

Ahora sí, esto es **resultado bueno** ✅

El script ya ha hecho lo que tenía que hacer:

```
Preflight OKLogin service account OKGrupos OKClients OIDC actualizados OKMappers groups detectados OKSecrets guardados OK
```

No ha roto nada porque ha sido actualización idempotente:

```
grafana   actualizadohomarr    actualizadoimmich    actualizadonextcloud actualizadopaperless actualizadoportainer actualizado
```

Y el archivo importante queda aquí:

```
/root/secrets/keycloak-oidc-client-secrets.env
```

No pegues ese archivo aquí. Guárdalo en Vaultwarden.

Para comprobarlo sin mostrar secretos:

```
cat /root/secrets/keycloak-oidc-client-secrets.env | sed 's/=.*/=********/'
```

Ahora mismo **yo no restauraría snapshot**. Esta parte ha quedado bien.

Antes de seguir, haz snapshot desde **PVE Shell**:

```
pct snapshot 113 post-keycloak-oidc-factory-$(date +%F-%H%M)pct snapshot 101 post-homarr-oidc-$(date +%F-%H%M)
```

Estado actual:

```
CT113 identity├── Keycloak funcionando ✅├── Realm homelab funcionando ✅├── Google IdP funcionando ✅├── Clients OIDC creados/actualizados ✅├── Groups base creados ✅└── Secrets guardados ✅CT101 Homarr├── OIDC activado ✅├── Login con Google funciona ✅├── Auto-login activado ✅└── Falta dejar fino Home board/permisos si todavía sale raro
```

Lo siguiente no debería ser “meter todas las apps”. Lo siguiente es **cerrar Homarr al 100%**: asignar `Home board` a `Sir Chatie` y comprobar si tienes permisos reales de admin. Si eso queda bien, hacemos snapshot y pasamos a la siguiente app una por una.

vamos a ello

Thought for 7s

Vale, vamos a cerrar **Homarr** sin tocar más apps.

Objetivo ahora:

```
1. Ver si Sir Chatie tiene grupo/permisos reales2. Ver por qué sale “No home board found”3. Asignar home board si hace falta4. Dejar rollback limpio
```

Primero solo diagnóstico, sin romper nada.

En **CT101 dashboard**, pega esto:

```
cd /opt/stacks/homarr-v1echo "===== BACKUP DB HOMARR ====="cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.pre-check.$(date +%F-%H%M)echoecho "===== CONTENEDOR Y AUTH ====="docker ps | grep homarrdocker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL' | sortechoecho "===== DB INFO ====="ls -lh appdata/db/db.sqliteechoecho "===== INSTALAR SQLITE SI FALTA ====="apt update >/dev/nullapt install -y sqlite3 >/dev/nullechoecho "===== TABLAS HOMARR ====="sqlite3 appdata/db/db.sqlite ".tables"echoecho "===== BUSCAR TABLAS IMPORTANTES ====="sqlite3 appdata/db/db.sqlite "SELECT name FROM sqlite_master WHERE type='table' AND (  name LIKE '%user%' OR   name LIKE '%group%' OR   name LIKE '%board%' OR   name LIKE '%permission%' OR  name LIKE '%member%')ORDER BY name;"echoecho "===== COLUMNAS DE TABLAS IMPORTANTES ====="for t in $(sqlite3 appdata/db/db.sqlite "SELECT name FROM sqlite_master WHERE type='table' AND (name LIKE '%user%' OR name LIKE '%group%' OR name LIKE '%board%' OR name LIKE '%permission%' OR name LIKE '%member%') ORDER BY name;"); do  echo  echo "--- $t ---"  sqlite3 appdata/db/db.sqlite "PRAGMA table_info($t);"doneechoecho "===== FILAS RELEVANTES ====="for t in $(sqlite3 appdata/db/db.sqlite "SELECT name FROM sqlite_master WHERE type='table' AND (name LIKE '%user%' OR name LIKE '%group%' OR name LIKE '%board%' OR name LIKE '%permission%' OR name LIKE '%member%') ORDER BY name;"); do  echo  echo "--- $t ---"  sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM $t LIMIT 10;" 2>/dev/null || truedone
```

Pégame la salida desde:

```
===== TABLAS HOMARR =====
```

hasta el final.

No hace falta que pegues logs largos ni secrets. Con eso vemos exactamente cómo se llaman las tablas de Homarr y te doy el comando preciso para dejar a `Sir Chatie` con su board/permisos sin inventar nada.

===== DB INFO ===== -rw-r--r-- 1 root root 6.2M May 2 10:52 appdata/db/db.sqlite ===== INSTALAR SQLITE SI FALTA ===== WARNING: apt does not have a stable CLI interface. Use with caution in scripts. WARNING: apt does not have a stable CLI interface. Use with caution in scripts. ===== TABLAS HOMARR ===== __drizzle_migrations integration_item account invite apiKey item app item_layout board layout boardGroupPermission media boardUserPermission onboarding cron_job_configuration search_engine group section groupMember section_collapse_state groupPermission section_layout icon serverSetting iconRepository session integration trusted_certificate_hostname integrationGroupPermissions user integrationSecret verificationToken integrationUserPermission

Thought for 6s

Perfecto, justo lo que necesitábamos. La DB tiene las tablas buenas:

```
usergroupgroupMemberboardboardUserPermissionboardGroupPermissiongroupPermission
```

Ahora vamos a ver **columnas + contenido real** para hacer el arreglo exacto, sin inventar nombres.

En **CT101 dashboard**, pega esto:

```
cd /opt/stacks/homarr-v1echo "===== BACKUP EXTRA DB ====="cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.pre-homarr-fix.$(date +%F-%H%M)echoecho "===== SCHEMA USER ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(user);"echoecho "===== USERS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM user;"echoecho "===== SCHEMA GROUP ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info('group');"echoecho "===== GROUPS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM 'group';"echoecho "===== SCHEMA GROUPMEMBER ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(groupMember);"echoecho "===== GROUP MEMBERS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM groupMember;"echoecho "===== SCHEMA BOARD ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(board);"echoecho "===== BOARDS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM board;"echoecho "===== SCHEMA BOARD USER PERMISSION ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(boardUserPermission);"echoecho "===== BOARD USER PERMISSIONS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM boardUserPermission;"echoecho "===== SCHEMA BOARD GROUP PERMISSION ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(boardGroupPermission);"echoecho "===== BOARD GROUP PERMISSIONS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM boardGroupPermission;"echoecho "===== SCHEMA GROUP PERMISSION ====="sqlite3 appdata/db/db.sqlite "PRAGMA table_info(groupPermission);"echoecho "===== GROUP PERMISSIONS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM groupPermission;"
```

Pásame esa salida. Con eso te doy el comando final para:

```
Sir Chatie → grupo homelab-adminsSir Chatie → Home board Generalhomelab-admins → permisos del board
```

De momento no vamos a tocar nada a ciegas.

root@dashboard:/opt/stacks/homarr-v1# cd /opt/stacks/homarr-v1 echo "===== BACKUP EXTRA DB =====" cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.pre-homarr-fix.$(date +%F-%H%M) echo echo "===== SCHEMA USER =====" sqlite3 appdata/db/db.sqlite "PRAGMA table_info(user);" echo echo "===== USERS =====" sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM user;" echo echo "===== SCHEMA GROUP =====" sqlite3 appdata/db/db.sqlite "PRAGMA table_info('group');" echo echo "===== GROUPS =====" sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM 'group';" sqlite3 -header -column appdata/db/db.sqlite "SELECT * FROM groupPermission;"ion;" ===== BACKUP EXTRA DB ===== ===== SCHEMA USER ===== 0|id|TEXT|1||1 1|name|TEXT|0||0 2|email|TEXT|0||0 3|email_verified|INTEGER|0||0 4|image|TEXT|0||0 5|password|TEXT|0||0 6|provider|TEXT|1|'credentials'|0 7|home_board_id|TEXT|0||0 8|mobile_home_board_id|TEXT|0||0 9|default_search_engine_id|TEXT|0||0 10|open_search_in_new_tab|INTEGER|1|true|0 11|color_scheme|TEXT|1|'dark'|0 12|first_day_of_week|INTEGER|1|1|0 13|ping_icons_enabled|INTEGER|1|false|0 ===== USERS ===== id name email email_verified image password provider home_board_id mobile_home_board_id default_search_engine_id open_search_in_new_tab color_scheme first_day_of_week ping_icons_enabled ------------------------------------ ---------- ------------------- -------------- ----- ------------------------------------------------------------ ----------- ------------------------ -------------------- ------------------------ ---------------------- ------------ ----------------- ------------------ tzy3m92pksinucxag26k40hq root $2a$10$YzYbsTvZoUYuD6t5iiDhwuhNXgBtEVH1YOOa6QUrG91O4SC4FiGOW credentials gxm78idexnr7xvi4ir0s3kpg 1 dark 1 0 34aa305b-73d9-4310-b1a3-f9f0118e9b79 Sir Chatie sirchatie@gmail.com oidc 1 dark 1 0 ===== SCHEMA GROUP ===== 0|id|TEXT|1||1 1|name|TEXT|1||0 2|owner_id|TEXT|0||0 3|home_board_id|TEXT|0||0 4|mobile_home_board_id|TEXT|0||0 5|position|INTEGER|1||0 ===== GROUPS ===== id name owner_id home_board_id mobile_home_board_id position ------------------------ ----------------- -------- ------------- -------------------- -------- ldnxopvxrpspyzsugvzk1q6c everyone -1 o0ffemj47m3yl8loofnvvncf credentials-admin 1 ===== SCHEMA GROUPMEMBER ===== 0|group_id|TEXT|1||1 1|user_id|TEXT|1||2 ===== GROUP MEMBERS ===== group_id user_id ------------------------ ------------------------------------ o0ffemj47m3yl8loofnvvncf tzy3m92pksinucxag26k40hq ldnxopvxrpspyzsugvzk1q6c tzy3m92pksinucxag26k40hq ldnxopvxrpspyzsugvzk1q6c 34aa305b-73d9-4310-b1a3-f9f0118e9b79 ===== SCHEMA BOARD ===== 0|id|TEXT|1||1 1|name|TEXT|1||0 2|is_public|INTEGER|1|false|0 3|creator_id|TEXT|0||0 4|page_title|TEXT|0||0 5|meta_title|TEXT|0||0 6|logo_image_url|TEXT|0||0 7|favicon_image_url|TEXT|0||0 8|background_image_url|TEXT|0||0 9|background_image_attachment|TEXT|1|'fixed'|0 10|background_image_repeat|TEXT|1|'no-repeat'|0 11|background_image_size|TEXT|1|'cover'|0 12|primary_color|TEXT|1|'#fa5252'|0 13|secondary_color|TEXT|1|'#fd7e14'|0 14|opacity|INTEGER|1|100|0 15|custom_css|TEXT|0||0 16|disable_status|INTEGER|1|false|0 17|item_radius|TEXT|1|'lg'|0 18|icon_color|TEXT|0||0 ===== BOARDS ===== id name is_public creator_id page_title meta_title logo_image_url favicon_image_url background_image_url background_image_attachment background_image_repeat background_image_size primary_color secondary_color opacity custom_css disable_status item_radius icon_color ------------------------ ------- --------- ---------- ---------- ---------- -------------- ----------------- -------------------- --------------------------- ----------------------- --------------------- ------------- --------------- ------- ---------- -------------- ----------- ---------- gxm78idexnr7xvi4ir0s3kpg default 0 Homarr ⭐️ fixed no-repeat cover #fa5252 #fab005 100 0 lg ===== SCHEMA BOARD USER PERMISSION ===== 0|board_id|TEXT|1||1 1|user_id|TEXT|1||3 2|permission|TEXT|1||2 ===== BOARD USER PERMISSIONS ===== ===== SCHEMA BOARD GROUP PERMISSION ===== 0|board_id|TEXT|1||1 1|group_id|TEXT|1||2 2|permission|TEXT|1||3 ===== BOARD GROUP PERMISSIONS ===== ===== SCHEMA GROUP PERMISSION ===== 0|group_id|TEXT|1||0 1|permission|TEXT|1||0 ===== GROUP PERMISSIONS ===== group_id permission ------------------------ ---------- o0ffemj47m3yl8loofnvvncf admin

Thought for 8s

Perfecto. Aquí ya está clarísimo el problema:

```
Sir Chatie existe ✅Sir Chatie entra por OIDC ✅Pero Sir Chatie NO está en grupo admin ❌Sir Chatie NO tiene home_board_id ❌
```

Ahora mismo Homarr tiene:

```
root → grupo credentials-admin → permission adminSir Chatie → solo grupo everyone
```

Por eso te sale raro y aparece:

```
No home board found
```

Vamos a arreglarlo directo en la DB, con backup y sin inventar.

En **CT101 dashboard**, pega esto:

```
cd /opt/stacks/homarr-v1echo "===== BACKUP DB ANTES DE FIX ADMIN/OIDC ====="cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.fix-sirchatie.$(date +%F-%H%M)echoecho "===== PARAR HOMARR PARA EDITAR SQLITE ====="docker compose stop homarr-v1echoecho "===== APLICAR FIX: SIR CHATIE ADMIN + HOME BOARD ====="sqlite3 appdata/db/db.sqlite <<'SQL'BEGIN TRANSACTION;-- 1) Crear grupo homelab-admins si no existeINSERT OR IGNORE INTO "group" (  id,  name,  owner_id,  home_board_id,  mobile_home_board_id,  position)VALUES (  'homelab-admins',  'homelab-admins',  NULL,  'gxm78idexnr7xvi4ir0s3kpg',  'gxm78idexnr7xvi4ir0s3kpg',  2);-- 2) Dar permisos admin al grupo homelab-adminsINSERT OR IGNORE INTO groupPermission (  group_id,  permission)VALUES (  'homelab-admins',  'admin');-- 3) Meter a Sir Chatie en homelab-adminsINSERT OR IGNORE INTO groupMember (  group_id,  user_id)VALUES (  'homelab-admins',  '34aa305b-73d9-4310-b1a3-f9f0118e9b79');-- 4) Asignar board default como home board de Sir ChatieUPDATE userSET  home_board_id = 'gxm78idexnr7xvi4ir0s3kpg',  mobile_home_board_id = 'gxm78idexnr7xvi4ir0s3kpg'WHERE id = '34aa305b-73d9-4310-b1a3-f9f0118e9b79';COMMIT;SQLechoecho "===== ARRANCAR HOMARR ====="docker compose up -d homarr-v1sleep 15echoecho "===== VERIFICAR USUARIO ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT id, name, email, provider, home_board_id, mobile_home_board_idFROM userWHERE email = 'sirchatie@gmail.com';"echoecho "===== VERIFICAR GRUPOS DE SIR CHATIE ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT g.id, g.name, gp.permissionFROM groupMember gmJOIN 'group' g ON g.id = gm.group_idLEFT JOIN groupPermission gp ON gp.group_id = g.idWHERE gm.user_id = '34aa305b-73d9-4310-b1a3-f9f0118e9b79';"echoecho "===== LOGS HOMARR ====="docker logs homarr-v1 --tail=80
```

Resultado esperado en la verificación:

```
Sir Chatie → home_board_id = gxm78idexnr7xvi4ir0s3kpgSir Chatie → grupo everyoneSir Chatie → grupo homelab-admins → admin
```

Después abre:

```
https://homarr.home.arpa
```

Si entra directo y ya no sale `No home board found`, Homarr queda cerrado.

Lo que viste de “grupo creado” seguramente era en **Keycloak**, no en la base interna de **Homarr**. En la DB de Homarr no existía `homelab-admins`; solo existían `everyone` y `credentials-admin`.

se habre ho,ar perfectamente...

Thought for 8s

Perfecto. Entonces **Homarr ya queda funcional** ✅

Estado bueno:

```
Homarr abre bien ✅Login OIDC/Google funciona ✅Auto-login activo ✅Sir Chatie entra ✅Home board arreglado ✅Ya no toca restaurar snapshot ✅
```

Ahora **no toques más Homarr** hasta hacer snapshot.

En **PVE Shell**, haz esto:

```
pct snapshot 101 post-homarr-sso-ok-$(date +%F-%H%M)pct snapshot 113 post-keycloak-sso-ok-$(date +%F-%H%M)
```

Y en **CT101 dashboard**, guarda copia final de compose y DB:

```
cd /opt/stacks/homarr-v1cp docker-compose.yml docker-compose.yml.final.sso-ok.$(date +%F-%H%M)cp appdata/db/db.sqlite appdata/db/db.sqlite.final.sso-ok.$(date +%F-%H%M)echo "===== AUTH FINAL HOMARR ====="docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL|NODE_TLS' | sort
```

Te debería salir algo parecido a:

```
AUTH_PROVIDERS=oidcAUTH_OIDC_AUTO_LOGIN=trueAUTH_OIDC_CLIENT_ID=homarrAUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelabBASE_URL=https://homarr.home.arpaNEXTAUTH_URL=https://homarr.home.arpaNODE_TLS_REJECT_UNAUTHORIZED=0
```

Lo único “feo” que queda es esto:

```
NODE_TLS_REJECT_UNAUTHORIZED=0
```

Pero no lo tocaría ahora. Homarr funciona, Keycloak funciona, Google funciona. Primero snapshot.

Después de snapshot, el siguiente paso lógico sería **quitar el segundo clic de Google en Keycloak** o pasar a la siguiente app, pero yo dejaría Homarr congelado como punto estable.

root@dashboard:/opt/stacks/homarr-v1# cd /opt/stacks/homarr-v1 er-compose.yroot@dashboard:/opt/stacks/homarr-v1# root@dashboard:/opt/stacks/homarr-v1# cp docker-compose.yml docker-compose.yml.final.sso-ok.$(date +%F-%H%M) db/db.sqlite appdata/db/db.sqlite.final.sso-ok.$(date +%F-%H%M) echo "===== AUTH FINAL HOMARR =====" docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL|NODE_TLS' | sortroot@dashboard:/opt/stacks/homarr-vk.$(date +%F-%H%M)b.sqlite appdata/db/db.sqlite.final.sso-ok root@dashboard:/opt/stacks/homarr-v1# root@dashboard:/opt/stacks/homarr-v1# echo "===== AUTH FINAL HOMARR =====" ===== AUTH FINAL HOMARR ===== root@dashboard:/opt/stacks/homarr-v1# docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL|NODE_TLS' | sort AUTH_OIDC_AUTO_LOGIN=true AUTH_OIDC_CLIENT_ID=homarr AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab AUTH_PROVIDERS=oidc BASE_URL=https://homarr.home.arpa NEXTAUTH_URL=https://homarr.home.arpa NODE_TLS_REJECT_UNAUTHORIZED=0 root@dashboard:/opt/stacks/homarrosea que ya no inicio sesion con otra cuenta rara?? ya no puedo inicar sesion normla no ? ahora inicio con la de google que es la de admion no ?

Thought for a couple of seconds

Sí, ahora mismo Homarr está así:

```
AUTH_PROVIDERS=oidcAUTH_OIDC_AUTO_LOGIN=true
```

Eso significa:

```
Ya NO sale login normal de Homarr.Ya NO entras con root/contraseña local desde la web.Ahora entras con Google mediante Keycloak.
```

El usuario que entra ahora es:

```
sirchatie@gmail.com
```

y lo hemos dejado como admin en Homarr metiéndolo en el grupo admin de la DB. Por eso ahora Homarr abre bien.

Tu usuario local antiguo `root` **sigue existiendo en la base de datos**, pero como has dejado solo `oidc`, la pantalla de login local queda desactivada/oculta.

Para confirmarlo:

```
cd /opt/stacks/homarr-v1sqlite3 -header -column appdata/db/db.sqlite "SELECT u.name, u.email, u.provider, g.name AS grupo, gp.permissionFROM user uLEFT JOIN groupMember gm ON gm.user_id = u.idLEFT JOIN 'group' g ON g.id = gm.group_idLEFT JOIN groupPermission gp ON gp.group_id = g.idORDER BY u.name, g.name;"
```

Deberías ver algo tipo:

```
Sir Chatie | sirchatie@gmail.com | oidc | homelab-admins | adminroot       |                     | credentials | credentials-admin | admin
```

Si algún día quieres volver al login normal + Google:

```
cd /opt/stacks/homarr-v1sed -i 's/AUTH_PROVIDERS=oidc/AUTH_PROVIDERS=credentials,oidc/' docker-compose.ymlsed -i 's/AUTH_OIDC_AUTO_LOGIN=true/AUTH_OIDC_AUTO_LOGIN=false/' docker-compose.ymldocker compose up -d --force-recreate homarr-v1
```

Eso te devuelve:

```
Login local root + Login Google
```

Pero si ya te funciona con `sirchatie@gmail.com`, déjalo así. Es más limpio: Homarr queda protegido por Google/Keycloak y no por un formulario local suelto.

name email provider grupo permission ---------- ------------------- ----------- ----------------- ---------- Sir Chatie sirchatie@gmail.com oidc everyone Sir Chatie sirchatie@gmail.com oidc homelab-admins admin root credentials credentials-admin admin root credentials everyone , prefiero log in normla mas google siempre, asi yo entro sin google, y mi familia desde google sabes?? yo creo q es mejor asi...

Thought for 8s

Sí, tiene todo el sentido. Lo mejor para tu caso es:

```
Tú → puedes entrar con root local si Google/Keycloak fallaTú/familia → pueden entrar con GoogleHomarr → sigue protegido con SSO, pero no te bloqueas
```

Ahora mismo está así:

```
AUTH_PROVIDERS=oidcAUTH_OIDC_AUTO_LOGIN=true
```

Lo vamos a dejar así:

```
AUTH_PROVIDERS=credentials,oidcAUTH_OIDC_AUTO_LOGIN=false
```

Pega esto en **CT101 dashboard**:

```
cd /opt/stacks/homarr-v1echo "===== BACKUP ANTES DE LOGIN MIXTO ====="cp docker-compose.yml docker-compose.yml.bak.login-mixto.$(date +%F-%H%M)echoecho "===== ACTIVAR LOGIN LOCAL + GOOGLE ====="sed -i 's/AUTH_PROVIDERS=oidc/AUTH_PROVIDERS=credentials,oidc/' docker-compose.ymlsed -i 's/AUTH_OIDC_AUTO_LOGIN=true/AUTH_OIDC_AUTO_LOGIN=false/' docker-compose.ymlechoecho "===== RECREAR HOMARR ====="docker compose up -d --force-recreate homarr-v1sleep 15echoecho "===== AUTH FINAL ====="docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL|NODE_TLS' | sortechoecho "===== USUARIOS Y PERMISOS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT u.name, u.email, u.provider, g.name AS grupo, gp.permissionFROM user uLEFT JOIN groupMember gm ON gm.user_id = u.idLEFT JOIN 'group' g ON g.id = gm.group_idLEFT JOIN groupPermission gp ON gp.group_id = g.idORDER BY u.name, g.name;"
```

Resultado esperado:

```
AUTH_PROVIDERS=credentials,oidcAUTH_OIDC_AUTO_LOGIN=false
```

Después entra en:

```
https://homarr.home.arpa
```

Y deberías tener:

```
Login normal/rootLogin con Google
```

Tu situación quedaría perfecta así:

```
root → credentials → adminSir Chatie / sirchatie@gmail.com → Google/OIDC → adminfamilia → Google/OIDC → usuario normal o lo que tú les pongas
```

Si algún día quieres volver a “solo Google”:

```
cd /opt/stacks/homarr-v1sed -i 's/AUTH_PROVIDERS=credentials,oidc/AUTH_PROVIDERS=oidc/' docker-compose.ymlsed -i 's/AUTH_OIDC_AUTO_LOGIN=false/AUTH_OIDC_AUTO_LOGIN=true/' docker-compose.ymldocker compose up -d --force-recreate homarr-v1
```

Pero yo lo dejaría mixto. Es más práctico para tu homelab porque no dependes al 100% de Google/Keycloak para entrar tú.

salvo q tu de verdad crees q es mejor aasi y que con burp suit no se puee hcacer sql injeccion y cosas asi sabes??:

Thought for 4s

Sí, te entiendo. Mi opinión real:

```
Para tu homelab: mejor login mixto.Para algo público en Internet: mejor solo Google/Keycloak.
```

En tu caso yo dejaría:

```
AUTH_PROVIDERS=credentials,oidcAUTH_OIDC_AUTO_LOGIN=false
```

Porque así tienes:

```
Tú → root local si Keycloak/Google fallaTú/familia → Google/Keycloak
```

Eso es más práctico para un homelab. Si mañana Keycloak se rompe, Google falla, cambias mal un secret o AdGuard/NPM falla, **no te quedas fuera de Homarr**.

Sobre Burp Suite y SQL injection: tener login local **no significa automáticamente que te puedan hacer SQL injection**. Burp Suite no “rompe” una app por existir; sirve para probar peticiones. Para que haya SQLi, Homarr tendría que tener una vulnerabilidad real en cómo procesa datos. El riesgo más realista de dejar login local no es tanto SQLi, sino:

```
1. Ataques de fuerza bruta contra root2. Reutilización de contraseña3. Fallos de sesión/cookies4. Exponer Homarr fuera de tu LAN/Tailscale5. Alguna vulnerabilidad futura de Homarr
```

Por eso la decisión depende de exposición:

|Caso|Recomendación|
|---|---|
|Solo LAN/Tailscale|Login mixto está bien|
|Expuesto públicamente|Solo OIDC/Google|
|Uso familiar|Google/Keycloak|
|Acceso de emergencia tuyo|root local como plan B|

Yo lo dejaría mixto, pero con estas condiciones:

```
- Homarr NO público en Internet- Acceso solo LAN/Tailscale- Contraseña root larga y única- Google/Keycloak para familia- Snapshot hecho- Nada de abrir 7575 directo al router
```

Para dejarlo mixto:

```
cd /opt/stacks/homarr-v1sed -i 's/AUTH_PROVIDERS=oidc/AUTH_PROVIDERS=credentials,oidc/' docker-compose.ymlsed -i 's/AUTH_OIDC_AUTO_LOGIN=true/AUTH_OIDC_AUTO_LOGIN=false/' docker-compose.ymldocker compose up -d --force-recreate homarr-v1docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN'
```

Resultado bueno:

```
AUTH_PROVIDERS=credentials,oidcAUTH_OIDC_AUTO_LOGIN=false
```

Así tienes lo mejor de los dos mundos: **no dependes al 100% de Google/Keycloak**, pero tu familia entra por Google.

![Imagen cargada](https://chatgpt.com/backend-api/estuary/content?id=file_0000000095a471f4adf3b2942b47e19c&ts=493811&p=fs&cid=1&sig=ebb7ea6ad38bdfbf2dcdfc442294cf0ac05523d15acee33ddb54995157665cb5&v=0)

ahora con google sale esto pero con contrasñea uy uusario si me daje entrar perfecto

Thought for 21s

Tranqui, esto **no ha roto Homarr**. Si con usuario/contraseña entra, Homarr está vivo. El 502 solo aparece en el camino de Google, así que casi seguro está fallando una de estas rutas:

```
Homarr → auth.home.arpa → Keycloak
``

o el proxy `auth.home.arpa` en NPM. Según tu guía, todos los dominios `.home.arpa` apuntan al proxy `192.168.1.82`, y `auth.home.arpa` también va por ahí hacia Keycloak en `10.10.10.74` . Tu plano también marca `identity`/Keycloak en `10.10.10.74` .

No cambies nada todavía. Vamos a diagnosticar.

## 1. Desde CT101 dashboard

Pega esto:

```
echo "===== DESDE CT101 DASHBOARD ====="echoecho "===== DNS ====="nslookup homarr.home.arpa 192.168.1.53nslookup auth.home.arpa 192.168.1.53echoecho "===== HOMARR LOCAL ====="curl -I --max-time 5 http://127.0.0.1:7575 || truecurl -k -I --max-time 5 https://homarr.home.arpa || trueechoecho "===== AUTH / KEYCLOAK POR PROXY ====="curl -k -I --max-time 10 https://auth.home.arpa || truecurl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration || trueechoecho "===== KEYCLOAK DIRECTO ====="curl -I --max-time 5 http://10.10.10.74:8080 || truecurl -s --max-time 5 http://10.10.10.74:9000/health/ready || trueechoecho "===== HOMARR AUTH ENV ====="cd /opt/stacks/homarr-v1docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC|BASE_URL|NEXTAUTH_URL|NODE_TLS' | grep -v SECRET | sortechoecho "===== LOGS HOMARR RECIENTES ====="docker logs homarr-v1 --since=5m | grep -i -E 'auth|oidc|callback|oauth|fetch|error|warn|502|bad gateway' || true
```

## 2. Desde CT112 proxy

Si lo anterior dice que `auth.home.arpa` da 502, entra en **CT112 proxy** y pega:

```
echo "===== DESDE CT112 PROXY ====="echoecho "===== CONTENEDORES ====="docker psechoecho "===== RUTA A KEYCLOAK ====="ip routeping -c 2 10.10.10.74curl -I --max-time 5 http://10.10.10.74:8080 || truecurl -s --max-time 5 http://10.10.10.74:9000/health/ready || trueechoecho "===== NGINX TEST ====="docker exec nginx-proxy-manager nginx -techoecho "===== BUSCAR AUTH EN CONFIG NPM ====="docker exec nginx-proxy-manager grep -R "auth.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || trueechoecho "===== LOGS NPM RECIENTES ====="docker logs nginx-proxy-manager --since=10m | grep -i -E 'auth.home.arpa|homarr.home.arpa|502|connect|upstream|error|failed' || true
```

## 3. Si quieres comprobar rápido en navegador

Cuando salga el 502, mira la barra de arriba. Si pone:

```
auth.home.arpa
```

entonces el problema es **proxy → Keycloak**.

Si pone:

```
homarr.home.arpa/api/auth/callback/oidc
``

entonces el problema es **callback Homarr/OIDC**.

Pégame las salidas del bloque 1 y, si `auth.home.arpa` da 502, también el bloque 2. No vamos a tocar configuración hasta ver exactamente dónde se corta.

root@dashboard:/opt/stacks/homarr-v1# echo "===== DESDE CT101 DASHBOARD =====" echo echo "===== DNS =====" nslookup homarr.home.arpa 192.168.1.53 nslookup auth.home.arpa 192.168.1.53 echo echo "===== HOMARR LOCAL =====" curl -I --max-time 5 http://127.0.0.1:7575 || true curl -k -I --max-time 5 https://homarr.home.arpa || true echo echo "===== AUTH / KEYCLOAK POR PROXY =====" curl -k -I --max-time 10 https://auth.home.arpa || true curl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration || true echo echo "===== KEYCLOAK DIRECTO =====" curl -I --max-time 5 http://10.10.10.74:8080 || true ad gateway' || truev1 --since=5m | grep -i -E 'auth|oidc|callback|oauth|fetch|error|warn|502|b ===== DESDE CT101 DASHBOARD ===== ===== DNS ===== Server: 192.168.1.53 Address: 192.168.1.53#53 Non-authoritative answer: Name: homarr.home.arpa Address: 192.168.1.82 Server: 192.168.1.53 Address: 192.168.1.53#53 Non-authoritative answer: Name: auth.home.arpa Address: 192.168.1.82 ===== HOMARR LOCAL ===== HTTP/1.1 200 OK Server: nginx/1.28.3 Date: Sat, 02 May 2026 11:22:10 GMT Content-Type: text/html; charset=utf-8 Connection: keep-alive Content-Security-Policy: default-src 'self'; script-src * 'unsafe-inline' 'unsafe-eval'; worker-src * blob:; base-uri 'self'; connect-src *; style-src * 'unsafe-inline'; frame-ancestors *; frame-src *; form-action 'self'; img-src * data:; font-src * data:; media-src * data: blob:; set-cookie: homarr.locale=en; Path=/; Expires=Sun, 02 May 2027 11:22:10 GMT; Max-Age=31536000; SameSite=lax x-middleware-rewrite: /en Vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding link: </_next/static/media/83afe278b6a6bb3c-s.p.0q-301v4kxxnr.woff2>; rel=preload; as="font"; crossorigin=""; type="font/woff2", </_next/static/chunks/0ni5b12yxui9o.css>; rel=preload; as="style", </_next/static/chunks/0uxq_mlvru5ou.css>; rel=preload; as="style", </_next/static/chunks/0h7~k88s2z5c0.css>; rel=preload; as="style", </_next/static/chunks/0l9qv.-yvh1pj.css>; rel=preload; as="style", </_next/static/chunks/0cokv_-ytabgr.css>; rel=preload; as="style", </_next/static/chunks/0i.um96z3w4jc.css>; rel=preload; as="style", </_next/static/chunks/0uvv3w6jw9dv5.css>; rel=preload; as="style", </_next/static/chunks/0w~svmv01lgzs.css>; rel=preload; as="style", </_next/static/chunks/0trqin7jzimhe.css>; rel=preload; as="style", </_next/static/chunks/0x.yl..g9fpu0.css>; rel=preload; as="style", </_next/static/chunks/17cnhqrxv6-~l.css>; rel=preload; as="style", </_next/static/chunks/0lojrtx68bwgy.css>; rel=preload; as="style", </_next/static/chunks/0l6zrp8y5gw18.css>; rel=preload; as="style", </_next/static/chunks/11rpmbig0-60v.css>; rel=preload; as="style", </_next/static/chunks/1628fhy78kgu-.css>; rel=preload; as="style", </_next/static/chunks/082v6.kmoiven.css>; rel=preload; as="style", </_next/static/chunks/06o-cfw5th_yy.css>; rel=preload; as="style", </_next/static/chunks/00-lj9z1sfqvn.css>; rel=preload; as="style" X-Powered-By: Next.js Cache-Control: private, no-cache, no-store, max-age=0, must-revalidate HTTP/1.1 200 OK Server: openresty Date: Sat, 02 May 2026 11:22:10 GMT Content-Type: text/html; charset=utf-8 Connection: keep-alive Content-Security-Policy: default-src 'self'; script-src * 'unsafe-inline' 'unsafe-eval'; worker-src * blob:; base-uri 'self'; connect-src *; style-src * 'unsafe-inline'; frame-ancestors *; frame-src *; form-action 'self'; img-src * data:; font-src * data:; media-src * data: blob:; set-cookie: homarr.locale=en; Path=/; Expires=Sun, 02 May 2027 11:22:10 GMT; Max-Age=31536000; SameSite=lax x-middleware-rewrite: /en Vary: rsc, next-router-state-tree, next-router-prefetch, next-router-segment-prefetch, Accept-Encoding link: </_next/static/media/83afe278b6a6bb3c-s.p.0q-301v4kxxnr.woff2>; rel=preload; as="font"; crossorigin=""; type="font/woff2", </_next/static/chunks/0ni5b12yxui9o.css>; rel=preload; as="style", </_next/static/chunks/0uxq_mlvru5ou.css>; rel=preload; as="style", </_next/static/chunks/0h7~k88s2z5c0.css>; rel=preload; as="style", </_next/static/chunks/0l9qv.-yvh1pj.css>; rel=preload; as="style", </_next/static/chunks/0cokv_-ytabgr.css>; rel=preload; as="style", </_next/static/chunks/0i.um96z3w4jc.css>; rel=preload; as="style", </_next/static/chunks/0uvv3w6jw9dv5.css>; rel=preload; as="style", </_next/static/chunks/0w~svmv01lgzs.css>; rel=preload; as="style", </_next/static/chunks/0trqin7jzimhe.css>; rel=preload; as="style", </_next/static/chunks/0x.yl..g9fpu0.css>; rel=preload; as="style", </_next/static/chunks/17cnhqrxv6-~l.css>; rel=preload; as="style", </_next/static/chunks/0lojrtx68bwgy.css>; rel=preload; as="style", </_next/static/chunks/0l6zrp8y5gw18.css>; rel=preload; as="style", </_next/static/chunks/11rpmbig0-60v.css>; rel=preload; as="style", </_next/static/chunks/1628fhy78kgu-.css>; rel=preload; as="style", </_next/static/chunks/082v6.kmoiven.css>; rel=preload; as="style", </_next/static/chunks/06o-cfw5th_yy.css>; rel=preload; as="style", </_next/static/chunks/00-lj9z1sfqvn.css>; rel=preload; as="style" X-Powered-By: Next.js Cache-Control: private, no-cache, no-store, max-age=0, must-revalidate X-Served-By: homarr.home.arpa ===== AUTH / KEYCLOAK POR PROXY ===== HTTP/1.1 302 Found Server: openresty Date: Sat, 02 May 2026 11:22:10 GMT Connection: keep-alive Location: https://auth.home.arpa/admin/ Referrer-Policy: no-referrer Strict-Transport-Security: max-age=31536000; includeSubDomains X-Content-Type-Options: nosniff X-Robots-Tag: none X-Served-By: auth.home.arpa HTTP/1.1 200 OK Server: openresty Date: Sat, 02 May 2026 11:22:10 GMT Content-Type: application/json Connection: keep-alive Cache-Control: no-cache, must-revalidate, no-transform, no-store Referrer-Policy: no-referrer Strict-Transport-Security: max-age=31536000; includeSubDomains X-Content-Type-Options: nosniff X-Frame-Options: SAMEORIGIN X-Robots-Tag: none X-Served-By: auth.home.arpa ===== KEYCLOAK DIRECTO ===== HTTP/1.1 302 Found Location: https://auth.home.arpa/admin/ Referrer-Policy: no-referrer Strict-Transport-Security: max-age=31536000; includeSubDomains X-Content-Type-Options: nosniff X-Robots-Tag: none { "status": "UP", "checks": [ { "name": "Graceful Shutdown", "status": "UP" }, { "name": "Keycloak cluster health check", "status": "UP" }, { "name": "Keycloak Initialized", "status": "UP" }, { "name": "Keycloak database connections async health check", "status": "UP" } ] } ===== HOMARR AUTH ENV ===== AUTH_OIDC_AUTO_LOGIN=false AUTH_OIDC_CLIENT_ID=homarr AUTH_OIDC_CLIENT_NAME=Google AUTH_OIDC_FORCE_USERINFO=true AUTH_OIDC_GROUPS_ATTRIBUTE=groups AUTH_OIDC_ISSUER=https://auth.home.arpa/realms/homelab AUTH_OIDC_NAME_ATTRIBUTE_OVERWRITE=name AUTH_OIDC_SCOPE_OVERWRITE=openid email profile AUTH_PROVIDERS=credentials,oidc BASE_URL=https://homarr.home.arpa NEXTAUTH_URL=https://homarr.home.arpa NODE_TLS_REJECT_UNAUTHORIZED=0 ===== LOGS HOMARR RECIENTES ===== ⨯ Error [TRPCError]: No home board found at <unknown> (.next/server/chunks/ssr/packages_0mjt3j9._.js:1:11056) at async o.middlewares (.next/server/chunks/ssr/_13wonq1._.js:1:16017) at async s (.next/server/chunks/ssr/_13wonq1._.js:4:68) at async b (.next/server/chunks/ssr/_13wonq1._.js:1:16250) at async (.next/server/chunks/ssr/_13wonq1._.js:1:10236) at async getInitialBoardAsync (.next/server/chunks/ssr/_03sve6o._.js:1:8216) at async page (.next/server/chunks/ssr/_0~68._v._.js:1:24134) { cause: undefined, code: 'NOT_FOUND', digest: '535196690' } 2026-05-02T11:20:55.557Z info: User is trying to log in. Checking password... module="basicAuthorization" userName="root" 2026-05-02T11:20:55.617Z info: User successfully authorized module="basicAuthorization" userName="root" 2026-05-02T11:20:55+00:00 info: User logged in module="authEvents" userId="tzy3m92pksinucxag26k40hq" userName="root" 2026-05-02T11:20:55.806Z info: Successfully prefetched apps for app widget module="appWidgetPrefetch" count="26" 2026-05-02T11:20:55.981Z info: Successfully prefetched apps for app widget module="appWidgetPrefetch" count="26" ⨯ Error [TRPCError]: No home board found at <unknown> (.next/server/chunks/ssr/packages_0mjt3j9._.js:1:11056) at async o.middlewares (.next/server/chunks/ssr/_13wonq1._.js:1:16017) at async s (.next/server/chunks/ssr/_13wonq1._.js:4:68) at async b (.next/server/chunks/ssr/_13wonq1._.js:1:16250) at async (.next/server/chunks/ssr/_13wonq1._.js:1:10236) at async getInitialBoardAsync (.next/server/chunks/ssr/_03sve6o._.js:1:8216) at async page (.next/server/chunks/ssr/_0~68._v._.js:1:24134) { cause: undefined, 2026-05-02T11:20:58.424Z error: Failed to send ping request url="http://10.10.10.50:3002" caused by TypeError: fetch failed caused by Error: redirect count exceeded code: 'NOT_FOUND', digest: '535196690' } ⨯ Error [TRPCError]: No home board found at <unknown> (.next/server/chunks/ssr/packages_0mjt3j9._.js:1:11056) at async o.middlewares (.next/server/chunks/ssr/_13wonq1._.js:1:16017) at async s (.next/server/chunks/ssr/_13wonq1._.js:4:68) at async b (.next/server/chunks/ssr/_13wonq1._.js:1:16250) at async (.next/server/chunks/ssr/_13wonq1._.js:1:10236) at async getInitialBoardAsync (.next/server/chunks/ssr/_03sve6o._.js:1:8216) at async page (.next/server/chunks/ssr/_0~68._v._.js:1:24134) { cause: undefined, code: 'NOT_FOUND', digest: '535196690' } ⨯ Error [TRPCError]: No home board found at <unknown> (.next/server/chunks/ssr/packages_0mjt3j9._.js:1:11056) at async o.middlewares (.next/server/chunks/ssr/_13wonq1._.js:1:16017) at async s (.next/server/chunks/ssr/_13wonq1._.js:4:68) at async b (.next/server/chunks/ssr/_13wonq1._.js:1:16250) at async (.next/server/chunks/ssr/_13wonq1._.js:1:10236) at async getInitialBoardAsync (.next/server/chunks/ssr/_03sve6o._.js:1:8216) at async page (.next/server/chunks/ssr/_0~68._v._.js:1:24134) { cause: undefined, code: 'NOT_FOUND', digest: '535196690' }

Thought for 9s

Vale, con esa salida **no parece que esté roto ni Homarr ni Keycloak**:

```
homarr.home.arpa → 200 OKauth.home.arpa → 302 / 200 OKKeycloak directo → UPHomarr local → 200 OK
```

Así que ese **502 no viene de que el proxy o Keycloak estén caídos**. Ahora mismo apunta más a una de estas dos cosas:

```
1. Sesión/cookies viejas del intento anterior de Google/OIDC.2. Callback OIDC raro después de cambiar de solo OIDC a login mixto.
```

Primero vamos a dejar Homarr mixto bien, confirmar el board y limpiar sesión.

## 1. Comprueba/fuerza home board para root y Sir Chatie

En **CT101 dashboard**, pega:

```
cd /opt/stacks/homarr-v1echo "===== BACKUP DB ====="cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.fix-homeboard-final.$(date +%F-%H%M)echoecho "===== FORZAR HOME BOARD PARA ROOT Y SIR CHATIE ====="sqlite3 appdata/db/db.sqlite <<'SQL'BEGIN TRANSACTION;UPDATE userSET  home_board_id = 'gxm78idexnr7xvi4ir0s3kpg',  mobile_home_board_id = 'gxm78idexnr7xvi4ir0s3kpg'WHERE id IN (  'tzy3m92pksinucxag26k40hq',  '34aa305b-73d9-4310-b1a3-f9f0118e9b79');INSERT OR IGNORE INTO boardGroupPermission (  board_id,  group_id,  permission)VALUES  ('gxm78idexnr7xvi4ir0s3kpg', 'o0ffemj47m3yl8loofnvvncf', 'view'),  ('gxm78idexnr7xvi4ir0s3kpg', 'o0ffemj47m3yl8loofnvvncf', 'modify'),  ('gxm78idexnr7xvi4ir0s3kpg', 'homelab-admins', 'view'),  ('gxm78idexnr7xvi4ir0s3kpg', 'homelab-admins', 'modify');COMMIT;SQLechoecho "===== VERIFICAR USERS ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT id, name, email, provider, home_board_id, mobile_home_board_idFROM user;"echoecho "===== VERIFICAR PERMISOS BOARD ====="sqlite3 -header -column appdata/db/db.sqlite "SELECT bgp.board_id, b.name AS board, g.name AS grupo, bgp.permissionFROM boardGroupPermission bgpJOIN board b ON b.id = bgp.board_idJOIN 'group' g ON g.id = bgp.group_idORDER BY g.name, bgp.permission;"echoecho "===== REINICIAR HOMARR ====="docker compose up -d --force-recreate homarr-v1sleep 15echoecho "===== AUTH FINAL ====="docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_AUTO_LOGIN|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL|NODE_TLS' | sort
```

Resultado bueno:

```
AUTH_PROVIDERS=credentials,oidcAUTH_OIDC_AUTO_LOGIN=false
```

Y los dos usuarios con:

```
home_board_id = gxm78idexnr7xvi4ir0s3kpg
```

---

## 2. Limpia sesión del navegador

Como has cambiado varias veces entre:

```
oidc auto-logincredentials + oidcGoogleKeycloak
```

haz esto antes de probar Google:

```
Cierra TODAS las ventanas privadas.Abre una ventana privada nueva.Entra en auth.home.arpa y cierra sesión si aparece sesión iniciada.Entra en homarr.home.arpa.Pulsa Login with Google una sola vez.
```

No hagas refresh muchas veces mientras redirige.

---

## 3. Si vuelve a salir 502, necesito una cosa exacta

Cuando salga el 502, dime **qué URL aparece arriba en la barra**:

```
auth.home.arpa/...
```

o

```
homarr.home.arpa/api/auth/callback/oidc...
```

Eso decide el arreglo.

Y justo después del 502, en **CT101 dashboard**, pega:

```
cd /opt/stacks/homarr-v1echo "===== LOGS JUSTO DESPUES DEL 502 ====="docker logs homarr-v1 --since=3m | grep -i -E 'auth|oidc|callback|oauth|token|signin|error|warn|fetch|provider|502|bad gateway' || trueechoecho "===== PROVIDERS ====="curl -k -s https://homarr.home.arpa/api/auth/providers

Ahora mismo lo importante: **infraestructura está OK**. El 502 no es caída general; es el flujo de Google/cookies/callback.




Sí, te has explicado perfecto.

Ahora mismo funciona así:

```text
Google = confirma quién es la persona
Keycloak = decide en qué grupo entra
Homarr = enseña lo que ese grupo puede ver/hacer
```

Si ahora intentas entrar con **otra cuenta de Google**, pueden pasar 3 cosas:

```text
1. Si NO está como test user en Google Cloud:
   → Google la bloquea.
   → No entra a Keycloak ni a Homarr.

2. Si SÍ está permitida en Google Cloud pero no le das grupo admin:
   → Keycloak la acepta.
   → Homarr crea el usuario.
   → Entraría como usuario normal/familia, no admin.

3. Si la metes en homelab-admins:
   → Entraría como admin, como Sir Chatie.
```

Así que no, **cualquier cuenta rara de Google no debería ver tu Homarr**, siempre que mantengas Google OAuth en modo testing con solo tus test users o controles bien los usuarios/grupos en Keycloak.

Lo que tú quieres es exactamente esto:

```text
root local
→ admin total
→ por si Google/Keycloak falla

sirchatie@gmail.com
→ admin por Google
→ homelab-admins

familia
→ entra con Google
→ grupo familia
→ ve solo un board familiar
→ no puede tocar configuración/admin
→ no puede gestionar usuarios, integraciones raras, settings, etc.
```

Y el punto más importante: **el board de Homarr solo oculta/ordena enlaces**. Si un servicio como Jellyfin, Grafana, Nextcloud, etc. está accesible directamente por URL, Homarr no lo protege. Para seguridad real, cada app también necesita su login, Keycloak, Tailscale ACL, NPM access list o estar solo en red interna.

Yo lo dejaría así:

```text
Board default/admin
→ solo tú
→ todas las apps, integraciones, cosas internas

Board familia
→ grupo familia
→ solo apps permitidas:
   jellyfin.home.arpa
   nextcloud.home.arpa si quieres
   alguna app familiar
   nada de Portainer, Grafana admin, Keycloak, NPM, AdGuard, Proxmox

Usuarios familia
→ pueden ver ese board
→ no admin
→ si Homarr permite board personal, que creen el suyo, pero sin permisos globales
```

Antes de tocar nada más con scripts, el siguiente paso bueno es **ver qué permisos exactos existen en Homarr**, porque no quiero inventarme nombres de permisos y romper la DB. Ahora mismo solo hemos visto:

```text
admin
view
modify
```

pero necesitamos saber si hay permisos tipo crear board, gestionar apps, manage users, etc.

Pega esto en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== PERMISOS EXISTENTES EN HOMARR ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT DISTINCT permission FROM groupPermission
UNION
SELECT DISTINCT permission FROM boardGroupPermission
UNION
SELECT DISTINCT permission FROM boardUserPermission
ORDER BY permission;
"

echo
echo "===== GRUPOS ACTUALES ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT * FROM 'group';
"

echo
echo "===== USUARIOS / GRUPOS / PERMISOS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT u.name, u.email, u.provider, g.name AS grupo, gp.permission AS global_permission
FROM user u
LEFT JOIN groupMember gm ON gm.user_id = u.id
LEFT JOIN 'group' g ON g.id = gm.group_id
LEFT JOIN groupPermission gp ON gp.group_id = g.id
ORDER BY u.name, g.name;
"

echo
echo "===== BOARDS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT id, name, is_public, creator_id FROM board;
"

echo
echo "===== PERMISOS DE BOARDS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
ORDER BY b.name, g.name, bgp.permission;
"
```

Con eso hacemos el modelo bien:

```text
homelab-admins → admin total
familia → acceso al board familia
everyone → mínimo o nada
root → admin local
```

Y en Keycloak después dejamos:

```text
Usuarios nuevos Google → grupo familia por defecto
Tú → homelab-admins
Familia concreta → familia
Invitados → invitados
```

No metería todavía a toda la familia hasta dejar creado el board `familia` y probar con una segunda cuenta Google de prueba.




Sí, te has explicado perfecto. Lo que tú quieres no es “un board familiar editable por todos”, sino esto:

```text
Board familia-base
→ lo ven todos
→ sirve como tablero inicial común
→ con las apps que tú permites

Board padre
→ solo lo ve/modifica tu padre
→ su interfaz personalizada

Board hermano
→ solo lo ve/modifica tu hermano
→ su interfaz personalizada

Board root / admin
→ solo tú
→ todo lo sensible
```

Eso es mucho mejor que dar `modify` al grupo `familia` sobre el mismo board, porque si todos modifican el mismo tablero, tu padre cambia algo y también se lo cambia a tu hermano.

La estructura buena sería:

```text
homelab-admins
→ admin total
→ tu cuenta Google + root local

familia
→ NO admin
→ puede ver familia-base

cada usuario familiar
→ tiene su propio board personal
→ ese board se pone como Home board de ese usuario
```

Entonces el flujo sería:

```text
Mi padre entra con Google
→ Homarr detecta su usuario
→ le muestra su board personal padre
→ él puede ordenar sus apps a su gusto

Mi hermano entra con Google
→ Homarr detecta otro usuario
→ le muestra su board personal hermano
→ no ve ni cambia el board de tu padre
```

Y todos seguirían teniendo acceso al board común `familia-base` si tú quieres.

Yo no pondría `modify` al grupo `familia` sobre `familia-base`. Pondría solo:

```text
familia → view → board familia-base
```

Y luego:

```text
usuario padre → full access/modify → board padre
usuario hermano → full access/modify → board hermano
```

La idea es:

```text
Board común = plantilla / punto de partida
Boards personales = cada uno se organiza lo suyo
```

Lo importante es que Homarr no debe ser la seguridad final de las apps. Homarr decide qué enlaces ve cada uno, pero si tu hermano conoce `portainer.home.arpa`, Homarr no lo bloquea. Por eso las apps peligrosas no se ponen en el board familiar y, más adelante, Portainer/NPM/Keycloak/Grafana se protegen también por su propio login o solo para tu usuario.

Yo lo haría así:

```text
1. Crear board familia-base
2. Poner ahí solo apps familiares
3. Dar al grupo familia permiso view sobre familia-base
4. Cuando entre tu padre con Google, crear o duplicar un board para él
5. Poner ese board como Home board de su usuario
6. Darle permisos solo a él sobre su board
7. Repetir con tu hermano/madre/etc.
```

En resumen: **sí, se puede montar como cualquier app web multiusuario**: cada cuenta con su perfil y su tablero. Lo que no haría es que todos modifiquen el mismo board familiar, porque se pisarían los cambios entre ellos.



cd /opt/stacks/homarr-v1

echo "===== BACKUP HOMARR ====="
cp docker-compose.yml docker-compose.yml.bak.family-boards.$(date +%F-%H%M)
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.family-boards.$(date +%F-%H%M)

echo "Backups creados:"
ls -lh docker-compose.yml.bak.family-boards.* appdata/db/db.sqlite.bak.family-boards.* | tail


he eliminado el otp del usuario admin-guillermo para que vayamos haciendo todo desde ese sin necestiadad de lo del otp que siempre no sdaba prioblemas y por eso creamos otro usuario pero a vecves ese falla opr permisos asi q ashoraa mejor y q funcnioe todo sabes? me sale esto en homarr en acces control mira:

Sí, exacto. **Ese es el modelo bueno** para tu Homarr:

```text
familia-base
→ tablero común
→ solo lectura para familia
→ apps permitidas por ti

board-padre
→ tablero personal de tu padre
→ solo lo ve/modifica él

board-hermano
→ tablero personal de tu hermano
→ solo lo ve/modifica él

default/admin
→ tablero tuyo/root
→ cosas sensibles
```

En tu caso tiene sentido porque Homarr ya está como `homarr-v1` en `/opt/stacks/homarr-v1`, usando la base de datos `appdata/db/db.sqlite`, así que antes de tocar permisos hacemos backup de eso. Además ya tienes Keycloak con grupos como `homelab-admins`, `homelab-users`, `familia` e `invitados`, y el mapper de `groups`, que es justo lo que necesitamos para que Homarr entienda los grupos que vienen de Google/Keycloak.

## 1. Antes de tocar nada: backup rápido

En **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP HOMARR ====="
cp docker-compose.yml docker-compose.yml.bak.family-boards.$(date +%F-%H%M)
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.family-boards.$(date +%F-%H%M)

echo "Backups creados:"
ls -lh docker-compose.yml.bak.family-boards.* appdata/db/db.sqlite.bak.family-boards.* | tail
```

## 2. Keycloak: separar bien los grupos

En Keycloak, en el realm `homelab`:

```text
Tu Gmail
→ homelab-admins
→ homelab-users

Padre / madre / hermano
→ familia
→ homelab-users

Invitados
→ invitados
```

Importante:

```text
familia NO debe estar en homelab-admins
invitados NO debe estar en homelab-admins
```

Así queda:

```text
Google = confirma que la cuenta existe
Keycloak = decide si es admin, familia o invitado
Homarr = aplica permisos según el grupo
```

## 3. Homarr: crear grupo `familia`

En Homarr entra con `root` o con tu cuenta admin:

```text
Management
→ Users / Groups
→ Groups
→ Create group
```

Nombre exacto:

```text
familia
```

Tiene que llamarse **igual que en Keycloak**, porque Homarr está usando el claim `groups` para sincronizar grupos desde OIDC. En tu configuración ya aparece `AUTH_OIDC_GROUPS_ATTRIBUTE=groups`, así que la idea es correcta.

No le des admin global a `familia`.

## 4. Crear board común

En Homarr:

```text
Boards
→ Create board
```

Nombre:

```text
familia-base
```

Este board será el que tú preparas con las apps que sí quieres que vea la familia.

Por ejemplo:

```text
Nextcloud
Immich
Jellyfin cuando esté
Vaultwarden si quieres
Paperless si quieres
CasaOS si quieres
```

No metería aquí:

```text
Portainer
Keycloak
Nginx Proxy Manager
Grafana admin
Prometheus
Proxmox
AdGuard admin
```

## 5. Permisos del board `familia-base`

Dentro del board `familia-base`:

```text
Access control
→ Groups
→ Add
```

Añade:

```text
familia → View
homelab-admins → Full access / Modify
```

La idea:

```text
familia
→ puede ver el board
→ no puede romperlo

homelab-admins
→ tú puedes editarlo
```

No pongas `modify` al grupo `familia` en `familia-base`, porque si no tu padre cambia algo y se lo cambia a todos.


Sí, eso que te sale es normal. En ese desplegable **solo aparecen los grupos que existen dentro de Homarr**, no todos los de Keycloak.

Ahora mismo Homarr solo conoce estos:

```text
everyone
credentials-admin
homelab-admins
```

Por eso no aparece `familia`.

El grupo `familia` puede existir en Keycloak, pero **Homarr no lo muestra hasta que exista también dentro de Homarr** o hasta que se sincronice correctamente al iniciar sesión un usuario que venga con ese grupo.

Haz esto en **CT101 dashboard** para crear los grupos que faltan directamente en Homarr sin romper nada:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ANTES DE CREAR GRUPOS ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.create-family-groups.$(date +%F-%H%M)

echo
echo "===== CREAR GRUPOS HOMARR ====="
sqlite3 appdata/db/db.sqlite <<'SQL'
BEGIN TRANSACTION;

INSERT OR IGNORE INTO 'group' (
  id,
  name,
  owner_id,
  home_board_id,
  mobile_home_board_id,
  position
) VALUES (
  'familia',
  'familia',
  NULL,
  NULL,
  NULL,
  3
);

INSERT OR IGNORE INTO 'group' (
  id,
  name,
  owner_id,
  home_board_id,
  mobile_home_board_id,
  position
) VALUES (
  'invitados',
  'invitados',
  NULL,
  NULL,
  NULL,
  4
);

COMMIT;
SQL

echo
echo "===== VER GRUPOS ====="
sqlite3 -header -column appdata/db/db.sqlite "SELECT id,name,position FROM 'group' ORDER BY position;"

echo
echo "===== REINICIAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1
```

Después recarga Homarr con `Ctrl + F5`.

Ahora en ese desplegable debería salir:

```text
everyone
credentials-admin
homelab-admins
familia
invitados
```

Luego ya haces esto:

```text
Board familia-base
→ Access control
→ Groups
→ Add
→ familia
→ Permission: View
→ Save group permission
```

Y para ti:

```text
Board familia-base
→ Access control
→ Groups
→ homelab-admins
→ Full access / Modify
```

Sobre lo del OTP: vale, para montar todo ahora tiene sentido quitarlo temporalmente si te estaba bloqueando. Pero cuando esté estable, yo dejaría así:

```text
root local de Homarr
→ emergencia / sin Google

admin-guillermo en Keycloak
→ administración normal

OTP
→ lo volvemos a activar al final, cuando todo funcione
```

Ahora mismo lo importante es crear `familia` en Homarr y seguir con los boards.

Sí. **La opción B es la buena**: un _provisioner_ que, cuando entra una cuenta nueva por Google/OIDC, le crea automáticamente su propio board personal y se lo pone como inicio.

La guía confirma que el Homarr activo está en `/opt/stacks/homarr-v1`, puerto `7575`, y DB real en `/opt/stacks/homarr-v1/appdata/db/db.sqlite`, así que el script va a trabajar justo ahí.

La lógica será:

```text
familia-base
→ board común
→ lo ve todo el grupo familia
→ NO lo modifican todos

personal-sir-chatie
→ solo Sir Chatie lo ve/modifica

personal-padre
→ solo tu padre lo ve/modifica

personal-hermano
→ solo tu hermano lo ve/modifica

homelab-admins
→ tú/root puedes ver y arreglar todo
```

Este primer script **no clona todavía todos los widgets/apps de familia-base**. Hace la parte segura: crea board personal vacío/privado, permisos y home board. Lo de clonar el contenido exacto del board lo hacemos después si quieres, pero no lo voy a inventar a ciegas porque ahí hay que copiar `layout`, `section`, `item`, `item_layout`, etc. y si se copia mal se rompe el dashboard.

---

## 1. Requisito previo en Homarr

Crea una vez a mano el board:

```text
familia-base
```

Y en Access Control pon:

```text
familia → View
homelab-admins → Modify / Full access
```

Ese será el board común.

---

## 2. Script provisioner automático

En **CT101 dashboard**, pega esto:

```bash
mkdir -p /root/scripts

cat > /root/scripts/homarr-family-provisioner.py <<'PY'
#!/usr/bin/env python3
import argparse
import datetime
import secrets
import shutil
import sqlite3
import sys
from pathlib import Path

DB = Path("/opt/stacks/homarr-v1/appdata/db/db.sqlite")

FAMILY_GROUP_ID = "familia"
FAMILY_GROUP_NAME = "familia"

ADMIN_GROUP_ID = "homelab-admins"
ADMIN_GROUP_NAME = "homelab-admins"

TEMPLATE_BOARD_NAME = "familia-base"

AUTO_ADD_OIDC_USERS_TO_FAMILIA = True
SKIP_ADMIN_USERS = True


def new_id(prefix=""):
    return prefix + secrets.token_urlsafe(18).replace("-", "").replace("_", "")[:24]


def now():
    return datetime.datetime.now().strftime("%Y%m%d-%H%M%S")


def backup_db():
    backup = DB.with_name(DB.name + f".bak-provisioner-{now()}")
    shutil.copy2(DB, backup)
    return backup


def q1(cur, sql, params=()):
    return cur.execute(sql, params).fetchone()


def qall(cur, sql, params=()):
    return cur.execute(sql, params).fetchall()


def ensure_group(cur, group_id, name, position):
    row = q1(cur, 'SELECT id FROM "group" WHERE id = ? OR name = ? LIMIT 1', (group_id, name))
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
        '''
        INSERT OR IGNORE INTO groupMember (
          group_id,
          user_id
        )
        VALUES (?, ?)
        ''',
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
        "SELECT 1 FROM groupMember WHERE user_id = ? AND group_id = ? LIMIT 1",
        (user_id, group_id),
    ) is not None


def user_has_global_admin(cur, user_id):
    row = q1(
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
    )
    return row is not None


def personal_board_name(user):
    email = user["email"] or ""
    name = user["name"] or ""
    base = email.split("@")[0] if email else name if name else user["id"][:8]
    safe = "".join(c.lower() if c.isalnum() else "-" for c in base).strip("-")
    while "--" in safe:
        safe = safe.replace("--", "-")
    return f"personal-{safe or user['id'][:8]}"


def board_exists_by_name(cur, name):
    return q1(cur, "SELECT * FROM board WHERE name = ? LIMIT 1", (name,))


def create_personal_board(cur, user):
    name = personal_board_name(user)
    existing = board_exists_by_name(cur, name)
    if existing:
        board_id = existing["id"]
    else:
        board_id = new_id("brd_")
        page_title = f"Homarr - {user['name'] or user['email'] or 'usuario'}"

        cur.execute(
            '''
            INSERT INTO board (
              id,
              name,
              is_public,
              creator_id,
              page_title
            )
            VALUES (?, ?, 0, ?, ?)
            ''',
            (board_id, name, user["id"], page_title),
        )

    ensure_board_user_perm(cur, board_id, user["id"], "view")
    ensure_board_user_perm(cur, board_id, user["id"], "modify")

    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "view")
    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "modify")

    cur.execute(
        '''
        UPDATE user
        SET
          home_board_id = ?,
          mobile_home_board_id = ?
        WHERE id = ?
        ''',
        (board_id, board_id, user["id"]),
    )

    return board_id, name


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--apply", action="store_true", help="Aplica cambios. Sin esto solo muestra lo que haría.")
    args = parser.parse_args()

    if not DB.exists():
        print(f"ERROR: no existe DB: {DB}")
        sys.exit(1)

    con = sqlite3.connect(DB)
    con.row_factory = sqlite3.Row
    cur = con.cursor()

    print("===== HOMARR FAMILY PROVISIONER =====")
    print(f"DB: {DB}")
    print(f"Modo: {'APPLY' if args.apply else 'DRY-RUN'}")
    print()

    template = q1(cur, "SELECT * FROM board WHERE name = ? LIMIT 1", (TEMPLATE_BOARD_NAME,))
    if not template:
        print(f"ERROR: no existe el board plantilla/común llamado: {TEMPLATE_BOARD_NAME}")
        print("Créalo primero en Homarr y dale permisos al grupo familia.")
        sys.exit(1)

    template_board_id = template["id"]
    print(f"Board común encontrado: {TEMPLATE_BOARD_NAME} ({template_board_id})")

    users = qall(
        cur,
        '''
        SELECT *
        FROM user
        WHERE provider = 'oidc'
        ORDER BY name, email
        ''',
    )

    if not users:
        print("No hay usuarios OIDC todavía.")
        sys.exit(0)

    print()
    print("Usuarios OIDC detectados:")
    for u in users:
        admin = user_has_global_admin(cur, u["id"])
        in_family = is_user_in_group(cur, u["id"], FAMILY_GROUP_ID)
        print(f"- {u['name']} | {u['email']} | admin={admin} | familia={in_family} | home_board={u['home_board_id']}")

    if not args.apply:
        print()
        print("DRY-RUN terminado. Si todo cuadra, ejecuta con --apply.")
        sys.exit(0)

    backup = backup_db()
    print()
    print(f"Backup creado: {backup}")

    try:
        cur.execute("BEGIN TRANSACTION")

        ensure_group(cur, FAMILY_GROUP_ID, FAMILY_GROUP_NAME, 3)
        ensure_group(cur, ADMIN_GROUP_ID, ADMIN_GROUP_NAME, 2)

        ensure_board_group_perm(cur, template_board_id, FAMILY_GROUP_ID, "view")
        ensure_board_group_perm(cur, template_board_id, ADMIN_GROUP_ID, "view")
        ensure_board_group_perm(cur, template_board_id, ADMIN_GROUP_ID, "modify")

        print()
        print("Provisionando usuarios:")

        for u in users:
            user_id = u["id"]
            email = u["email"] or ""
            name = u["name"] or email or user_id

            if SKIP_ADMIN_USERS and user_has_global_admin(cur, user_id):
                print(f"- SKIP admin: {name}")
                continue

            if AUTO_ADD_OIDC_USERS_TO_FAMILIA:
                ensure_group_member(cur, FAMILY_GROUP_ID, user_id)

            current_home = u["home_board_id"]

            if current_home:
                board = q1(cur, "SELECT name FROM board WHERE id = ? LIMIT 1", (current_home,))
                board_name = board["name"] if board else "UNKNOWN"
                if board_name.startswith("personal-"):
                    print(f"- OK ya tiene board personal: {name} -> {board_name}")
                    continue

            board_id, board_name = create_personal_board(cur, u)
            print(f"- creado/asignado: {name} -> {board_name} ({board_id})")

        con.commit()

    except Exception as e:
        con.rollback()
        print(f"ERROR: rollback aplicado: {e}")
        sys.exit(1)
    finally:
        con.close()

    print()
    print("===== RESULTADO =====")
    print("Usuarios familia/OIDC no admin tienen board personal y permisos propios.")
    print("Los admins siguen sin tocarse.")


if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/homarr-family-provisioner.py
python3 -m py_compile /root/scripts/homarr-family-provisioner.py && echo "Sintaxis OK"
```

---

## 3. Primera prueba sin tocar nada

```bash
python3 /root/scripts/homarr-family-provisioner.py
```

Tiene que mostrar los usuarios OIDC y terminar con:

```text
DRY-RUN terminado. Si todo cuadra, ejecuta con --apply.
```

---


Sí, te entiendo, y tienes razón en lo principal:

```text
2 Homarr = más consumo
1 Homarr = menos consumo y más simple
```

No sería una locura tener 2 porque Homarr no debería consumir una barbaridad, pero **sí consume más**: otro contenedor, otra app Next.js, otra Redis interna, otra base de datos, más RAM, más procesos. Para tu homelab, si quieres ir fino y no complicarte, **me parece mejor quedarnos con 1 Homarr**.

Y tu comparación de la Play Store tiene sentido:

```text
Apps globales de Homarr
→ es como un catálogo

Board familia-base
→ es lo que tú les recomiendas/pones delante

Servicios reales
→ se protegen con su propio login
```

O sea, aunque vean:

```text
proxmox.home.arpa
keycloak.home.arpa
npm.home.arpa
pgadmin.home.arpa
```

si no tienen usuario/contraseña o permisos, **no entran**. Homarr no es el firewall; solo es el escaparate.

Yo lo dejaría así:

```text
Un solo Homarr
→ tu panel admin
→ board familia-base para familia
→ Apps global visible, pero no pasa nada
→ servicios sensibles protegidos con login propio
```

Lo único que sí corregiría es esto: **paramos el auto-provisioner de boards personales**, porque ha creado un board vacío que da errores. Para que cada usuario tenga su propio board personalizado, mejor primero hacerlo desde la interfaz de Homarr si la app lo permite bien, no por SQL inventado.

Pega esto para parar el script automático y dejar Homarr estable:

```bash
echo "===== PARAR AUTO-PROVISIONER HOMARR ====="
systemctl disable --now homarr-family-provisioner.timer 2>/dev/null || true
systemctl stop homarr-family-provisioner.service 2>/dev/null || true

echo
echo "===== COMPROBAR TIMER ====="
systemctl list-timers | grep homarr-family || echo "Timer parado OK"
```

Luego limpiamos los boards `personal-*` que ha creado el script:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.clean-personal-boards.$(date +%F-%H%M)

echo
echo "===== BORRAR BOARDS PERSONAL-* ROTOS ====="
sqlite3 appdata/db/db.sqlite <<'SQL'
BEGIN TRANSACTION;

DELETE FROM boardUserPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

DELETE FROM boardGroupPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

UPDATE user
SET home_board_id = NULL,
    mobile_home_board_id = NULL
WHERE home_board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

DELETE FROM board
WHERE name LIKE 'personal-%';

COMMIT;
SQL

echo
echo "===== REINICIAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1

echo
echo "===== BOARDS ACTUALES ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT id, name, is_public, creator_id
FROM board
ORDER BY name;
"
```

Y el diseño final sería:

```text
default / Guillermo
→ tuyo/admin
→ puede tener todo: Proxmox, Keycloak, NPM, Grafana, Portainer, etc.

familia-base
→ familia
→ Immich, Nextcloud, Vaultwarden, Jellyfin, etc.

Apps globales
→ pueden ver más cosas, pero no acceder si cada servicio está bien protegido
```

Para mí, en tu caso, **mejor 1 Homarr bien protegido que 2 Homarr consumiendo más y complicando todo**.  
La seguridad real la ponemos en cada app importante, no en esconder el enlace.



Sí, eso es justo lo que pensaba: **la ACL está funcionando, pero está sucia/repetida**.

Ahora mismo en ese board personal tienes:

```text
homelab-admins → Full access
homelab-admins → Modify board
homelab-admins → View board
```

Eso no debería estar así. Con **Full access** ya vale para admin. No hace falta tener las tres filas.

La estructura limpia para un board personal debería ser:

```text
Usuarios:
usuario dueño del board → Full access

Grupos:
homelab-admins → Full access

NO:
familia → nada
everyone → nada
```

Así:

```text
El dueño puede tocar su board.
Tú como admin puedes arreglarlo.
La familia no ve el board personal de otro.
```

Vamos a limpiar permisos duplicados de todos los boards `personal-*` y dejarlo más limpio.

Pega esto en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ANTES DE LIMPIAR ACL PERSONAL ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.clean-personal-acl.$(date +%F-%H%M)

echo
echo "===== VER ACL ANTES ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, g.name, bgp.permission;
"

echo
echo "===== LIMPIAR ACL DE GRUPOS EN BOARDS PERSONAL-* ====="
sqlite3 appdata/db/db.sqlite <<'SQL'
BEGIN TRANSACTION;

DELETE FROM boardGroupPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

INSERT OR IGNORE INTO boardGroupPermission (
  board_id,
  group_id,
  permission
)
SELECT
  id,
  'homelab-admins',
  'full'
FROM board
WHERE name LIKE 'personal-%';

COMMIT;
SQL

echo
echo "===== VER ACL DESPUES ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, g.name, bgp.permission;
"

echo
echo "===== VER ACL DE USUARIOS EN PERSONAL-* ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, u.name AS usuario, u.email, bup.permission
FROM boardUserPermission bup
JOIN board b ON b.id = bup.board_id
JOIN user u ON u.id = bup.user_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, u.name, bup.permission;
"
```

Después recarga Homarr con `Ctrl + F5`.

Lo ideal es que en **Groups** solo veas:

```text
homelab-admins → Full access
```

Y en **Users** el dueño del board debería tener acceso. Si sale con `view` y `modify` también está bien, pero si quieres dejarlo más limpio aún, luego lo cambiamos a:

```text
usuario dueño → Full access
```

De momento lo importante: **no debe aparecer `familia` ni `everyone` en el board personal**.




Sí, aquí el problema **no es usuario/contraseña**, porque en los logs se ve que Google **sí llega a autenticar**:

```text
User logged in ... userName="Sir Chatie"
```

El fallo viene después: Homarr se queda con sesión/OIDC raro o intenta cargar un `home_board` que no encuentra. Además, ahora mismo tu timer está parado:

```text
homarr-family-provisioner.timer → inactive (dead)
```

Así que **ahora mismo NO se va a crear automáticamente el board personal**. Eso lo dejamos parado hasta que el login Google sea estable.

También hay un detalle importante: la documentación de Homarr permite varios proveedores separados por coma, como `credentials,oidc`, pero recomienda usar solo uno. Nosotros lo dejamos con dos porque tú quieres root local + Google, pero hay que afinar bien el logout para que no se quede una sesión rara. ([Homarr](https://homarr.dev/docs/advanced/single-sign-on/?utm_source=chatgpt.com "Single Sign On | Homarr documentation"))

## 1. Arreglar el logout de Google/Keycloak

Ahora tienes:

```text
AUTH_LOGOUT_REDIRECT_URL=https://homarr.home.arpa
```

Eso cierra sesión en Homarr, pero **no limpia bien la sesión de Keycloak**. Vamos a hacer que al cerrar sesión mande a Keycloak logout y vuelva a Homarr.

Pega esto en CT101:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP COMPOSE ====="
cp docker-compose.yml docker-compose.yml.bak.logout-fix.$(date +%F-%H%M)

echo
echo "===== CAMBIAR LOGOUT REDIRECT A KEYCLOAK ====="
python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

old_line_prefix = "      - AUTH_LOGOUT_REDIRECT_URL="
new_line = "      - AUTH_LOGOUT_REDIRECT_URL=https://auth.home.arpa/realms/homelab/protocol/openid-connect/logout?client_id=homarr&post_logout_redirect_uri=https%3A%2F%2Fhomarr.home.arpa%2F"

lines = []
changed = False

for line in text.splitlines():
    if line.startswith(old_line_prefix):
        lines.append(new_line)
        changed = True
    else:
        lines.append(line)

if not changed:
    lines.append(new_line)

p.write_text("\n".join(lines) + "\n")
PY

echo
echo "===== VER AUTH LOGOUT ====="
grep -E 'AUTH_LOGOUT_REDIRECT_URL|AUTH_PROVIDERS|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|BASE_URL|NEXTAUTH_URL' docker-compose.yml
```

## 2. Limpiar sesiones rotas de Homarr

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.clean-oauth-sessions.$(date +%F-%H%M)

echo
echo "===== PARAR HOMARR ====="
docker compose stop homarr-v1

echo
echo "===== LIMPIAR SESIONES ====="
sqlite3 appdata/db/db.sqlite <<'SQL'
BEGIN TRANSACTION;
DELETE FROM session;
DELETE FROM verificationToken;
COMMIT;
SQL

echo
echo "===== ARRANCAR HOMARR ====="
docker compose up -d homarr-v1

sleep 15

echo
echo "===== ENV AUTH ====="
docker exec homarr-v1 printenv | grep -E 'AUTH_PROVIDERS|AUTH_OIDC_CLIENT_ID|AUTH_OIDC_ISSUER|AUTH_LOGOUT|BASE_URL|NEXTAUTH_URL' | sort
```

## 3. Asegurar home boards válidos

Esto deja:

```text
root + Sir Chatie → default
usuarios familia → familia-base
grupo familia → familia-base
grupo homelab-admins → default
```

Pega:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB HOME BOARDS ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.fix-homeboards.$(date +%F-%H%M)

DEFAULT_ID="$(sqlite3 appdata/db/db.sqlite "SELECT id FROM board WHERE name='default' LIMIT 1;")"
FAMILY_BASE_ID="$(sqlite3 appdata/db/db.sqlite "SELECT id FROM board WHERE name='familia-base' LIMIT 1;")"

echo "DEFAULT_ID=$DEFAULT_ID"
echo "FAMILY_BASE_ID=$FAMILY_BASE_ID"

if [ -z "$DEFAULT_ID" ] || [ -z "$FAMILY_BASE_ID" ]; then
  echo "ERROR: falta default o familia-base"
  exit 1
fi

sqlite3 appdata/db/db.sqlite <<SQL
BEGIN TRANSACTION;

UPDATE user
SET home_board_id = '$DEFAULT_ID',
    mobile_home_board_id = '$DEFAULT_ID'
WHERE id IN (
  SELECT gm.user_id
  FROM groupMember gm
  JOIN groupPermission gp ON gp.group_id = gm.group_id
  WHERE gp.permission = 'admin'
);

UPDATE user
SET home_board_id = '$FAMILY_BASE_ID',
    mobile_home_board_id = '$FAMILY_BASE_ID'
WHERE provider = 'oidc'
  AND id NOT IN (
    SELECT gm.user_id
    FROM groupMember gm
    JOIN groupPermission gp ON gp.group_id = gm.group_id
    WHERE gp.permission = 'admin'
  );

UPDATE "group"
SET home_board_id = '$FAMILY_BASE_ID',
    mobile_home_board_id = '$FAMILY_BASE_ID'
WHERE name = 'familia';

UPDATE "group"
SET home_board_id = '$DEFAULT_ID',
    mobile_home_board_id = '$DEFAULT_ID'
WHERE name = 'homelab-admins';

COMMIT;
SQL

echo
echo "===== VERIFICAR USERS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT u.name, u.email, u.provider, b.name AS home_board
FROM user u
LEFT JOIN board b ON b.id = u.home_board_id
ORDER BY u.name;
"

echo
echo "===== VERIFICAR GROUPS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT g.name, b.name AS home_board
FROM 'group' g
LEFT JOIN board b ON b.id = g.home_board_id
ORDER BY g.name;
"

docker compose up -d --force-recreate homarr-v1
```

## 4. Prueba bien limpia

Cierra **todas** las ventanas de incógnito antiguas.

Luego abre una incógnito nueva y entra solo aquí:

```text
https://homarr.home.arpa
```

Prueba este orden:

```text
1. Login with Google con Sir Chatie.
2. Logout.
3. Login with Google otra vez.
```

Si funciona dos veces seguidas, ya está arreglado el problema de sesión.

Luego prueba con `gencinasr@gmail.com`.

## Importante sobre el secret

Has pegado el `AUTH_OIDC_CLIENT_SECRET` en el chat. Cuando terminemos y todo esté estable, entra en Keycloak y **regenera el secret del cliente `homarr`**, luego lo actualizamos en `.env`/compose. No lo hagas todavía para no meter otra variable mientras estamos depurando.

## Sobre el board personal

Ahora mismo tu usuario `gencinasr@gmail.com` está yendo a:

```text
familia-base
```

Eso está bien y estable.

No reactivaría todavía el provisioner de board personal, porque ya vimos que el board creado por SQL puede quedar sin estructura y dar:

```text
This page couldn't load
```

Primero dejamos Google login estable. Después, si quieres personal por usuario, hacemos una versión que **duplique correctamente `familia-base` completo**, no solo crear una fila en `board`.
Sí, lo has entendido perfecto. Ahora mismo funciona, pero la ACL está “demasiado abierta” para el usuario personal.

Ahora tienes esto:

```text
personal-gencinasr
→ Guillermo: full + modify + view
→ homelab-admins: full + modify + view
```

El problema es que **Full access** probablemente permite tocar también el Access Control. Entonces sí: `gencinasr` podría cambiar permisos de su propio board, quitar admins, etc.

Lo más limpio sería:

```text
personal-gencinasr
→ Guillermo: view + modify
→ homelab-admins: full

familia-base
→ familia: view
→ homelab-admins: full
```

Así:

```text
Usuario familiar
→ puede editar su tablero personal
→ no puede tocar ACL/permisos

Admin
→ puede controlar todo

Familia
→ solo ve familia-base
```

Y sí, tienes razón: tener `full + modify + view` repetido queda feo. Vamos a limpiarlo.

Pega esto en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ANTES DE LIMPIAR ACL ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.clean-acl-final.$(date +%F-%H%M)

echo
echo "===== LIMPIAR ACL PERSONAL-* ====="
sqlite3 appdata/db/db.sqlite <<'SQL'
BEGIN TRANSACTION;

-- Limpiar permisos de grupo en boards personales
DELETE FROM boardGroupPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

-- Admin solo necesita FULL en boards personales
INSERT OR IGNORE INTO boardGroupPermission (
  board_id,
  group_id,
  permission
)
SELECT
  id,
  'homelab-admins',
  'full'
FROM board
WHERE name LIKE 'personal-%';

-- Quitar FULL al dueño del board personal
DELETE FROM boardUserPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
)
AND permission = 'full';

-- Asegurar que el dueño puede ver y modificar su propio board
INSERT OR IGNORE INTO boardUserPermission (
  board_id,
  user_id,
  permission
)
SELECT
  b.id,
  b.creator_id,
  'view'
FROM board b
WHERE b.name LIKE 'personal-%'
  AND b.creator_id IS NOT NULL;

INSERT OR IGNORE INTO boardUserPermission (
  board_id,
  user_id,
  permission
)
SELECT
  b.id,
  b.creator_id,
  'modify'
FROM board b
WHERE b.name LIKE 'personal-%'
  AND b.creator_id IS NOT NULL;

-- Limpiar familia-base
DELETE FROM boardGroupPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name='familia-base'
);

-- familia solo ve familia-base
INSERT OR IGNORE INTO boardGroupPermission (
  board_id,
  group_id,
  permission
)
SELECT
  id,
  'familia',
  'view'
FROM board
WHERE name='familia-base';

-- admin full en familia-base
INSERT OR IGNORE INTO boardGroupPermission (
  board_id,
  group_id,
  permission
)
SELECT
  id,
  'homelab-admins',
  'full'
FROM board
WHERE name='familia-base';

COMMIT;
SQL

echo
echo "===== ACL USER BOARDS PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, u.name AS usuario, u.email, bup.permission
FROM boardUserPermission bup
JOIN board b ON b.id = bup.board_id
JOIN user u ON u.id = bup.user_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, u.name, bup.permission;
"

echo
echo "===== ACL GROUP BOARDS PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, g.name, bgp.permission;
"

echo
echo "===== ACL FAMILIA-BASE ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name='familia-base'
ORDER BY g.name, bgp.permission;
"

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1
```

El resultado ideal será:

```text
personal-gencinasr
→ Guillermo Encinas: modify
→ Guillermo Encinas: view
→ homelab-admins: full

familia-base
→ familia: view
→ homelab-admins: full
```

Luego entra con `gencinasr` y prueba:

```text
Debe poder editar widgets/apps de su board personal.
No debería poder cambiar permisos/Access Control.
No debería poder editar familia-base.
```

Después de confirmar eso, habría que parchear el script para que los futuros usuarios nazcan ya así, sin `full` para el usuario normal.


Sí, ahora vamos a montar **lo que querías de verdad**:

```text
familia-base
→ board común
→ familia solo lo ve
→ nadie de familia lo edita

personal-gencinasr
personal-padre
personal-hermano
...
→ se crean automáticamente desde familia-base
→ cada usuario solo edita el suyo
→ nadie ve el board personal de otro
→ homelab-admins tiene full en todos
```

La clave: **ya no vamos a crear un board vacío por SQL**, porque eso fue lo que daba páginas rotas. Ahora el script va a **clonar `familia-base` completo** y luego asignarlo al usuario.

## 1. Snapshot antes de tocar

En el **host Proxmox PVE**:

```bash
pct snapshot 101 homarr-before-personal-boards-$(date +%F-%H%M) --description "Antes de provisionar boards personales clonados desde familia-base"
pct listsnapshot 101
```

## 2. En CT101: parar timer viejo

```bash
systemctl disable --now homarr-family-provisioner.timer 2>/dev/null || true
systemctl stop homarr-family-provisioner.service 2>/dev/null || true
```

## 3. Crear el script bueno

En **CT101 dashboard**:

```bash
cat > /root/scripts/homarr-family-provisioner.py <<'PY'
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
    board_data["creator_id"] = user["id"]
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

    cur.execute(
        "DELETE FROM boardGroupPermission WHERE board_id=? AND group_id IN ('familia','everyone')",
        (board_id,),
    )

    ensure_board_user_perm(cur, board_id, user_id, "view")
    ensure_board_user_perm(cur, board_id, user_id, "modify")
    ensure_board_user_perm(cur, board_id, user_id, "full")

    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "view")
    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "modify")
    ensure_board_group_perm(cur, board_id, ADMIN_GROUP_ID, "full")

    cur.execute(
        '''
        UPDATE user
        SET home_board_id=?,
            mobile_home_board_id=?
        WHERE id=?
        ''',
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

        ensure_board_group_perm(cur, template["id"], FAMILY_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "modify")
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
PY

chmod +x /root/scripts/homarr-family-provisioner.py
python3 -m py_compile /root/scripts/homarr-family-provisioner.py && echo "Sintaxis OK"
```

## 4. Probar primero sin tocar

```bash
python3 /root/scripts/homarr-family-provisioner.py
```

Debería salir algo parecido a:

```text
Guillermo Encinas | gencinasr@gmail.com | admin=False | familia=True | needs=True
DRY-RUN: hay usuarios pendientes
```

## 5. Aplicar de verdad

```bash
cd /opt/stacks/homarr-v1

echo "===== APLICAR PROVISIONER ====="
python3 /root/scripts/homarr-family-provisioner.py --apply

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1

sleep 15
```

## 6. Verificar permisos

```bash
cd /opt/stacks/homarr-v1

echo "===== USUARIOS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT u.name, u.email, u.provider, b.name AS home_board
FROM user u
LEFT JOIN board b ON b.id = u.home_board_id
ORDER BY u.name;
"

echo
echo "===== BOARDS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT id, name, creator_id
FROM board
ORDER BY name;
"

echo
echo "===== ACL USER BOARDS PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, u.name AS usuario, u.email, bup.permission
FROM boardUserPermission bup
JOIN board b ON b.id = bup.board_id
JOIN user u ON u.id = bup.user_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, u.name, bup.permission;
"

echo
echo "===== ACL GROUP BOARDS PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, g.name, bgp.permission;
"

echo
echo "===== ACL FAMILIA-BASE ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name='familia-base'
ORDER BY g.name, bgp.permission;
"
```

Lo correcto sería:

```text
gencinasr@gmail.com
→ home_board = personal-gencinasr

personal-gencinasr
→ Guillermo Encinas: full / modify / view
→ homelab-admins: full / modify / view
→ familia: nada
→ everyone: nada

familia-base
→ familia: view
→ homelab-admins: full / modify / view
```

## 7. Reactivar timer automático

Cuando veas que `gencinasr` entra y puede editar su board personal:

```bash
cat > /etc/systemd/system/homarr-family-provisioner.service <<'EOF'
[Unit]
Description=Homarr family OIDC personal board provisioner
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/bin/flock -n /run/homarr-family-provisioner.lock /usr/bin/python3 /root/scripts/homarr-family-provisioner.py --apply
EOF

cat > /etc/systemd/system/homarr-family-provisioner.timer <<'EOF'
[Unit]
Description=Run Homarr family personal board provisioner every minute

[Timer]
OnBootSec=2min
OnUnitActiveSec=1min
Unit=homarr-family-provisioner.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now homarr-family-provisioner.timer

systemctl status homarr-family-provisioner.timer --no-pager
```

A partir de ahí:

```text
usuario nuevo entra con Google
→ Homarr lo crea
→ timer lo detecta
→ lo mete en familia
→ clona familia-base
→ crea personal-usuario
→ solo ese usuario edita su board
→ admin puede ver/arreglar todo
```

No des `modify` al grupo `familia` sobre `familia-base`. Ese board se queda como plantilla común de solo lectura.

Sí, eso que ves tiene explicación: **el “Full access” de arriba seguramente no viene de `boardUserPermission`**, viene de que el board tiene como `creator_id` a `Guillermo Encinas`.

O sea:

```text
personal-gencinasr
→ creator_id = Guillermo Encinas
→ Homarr lo trata como dueño del board
→ por eso le da Full access implícito
```

Por eso aunque borremos el permiso `full`, Homarr lo sigue mostrando.

La solución buena es:

```text
creator_id del board personal → root/admin
usuario familiar → view + modify
homelab-admins → full
```

Así el usuario puede editar widgets/apps de su panel, pero **no debería tener full/owner sobre permisos**.

Pega esto en **CT101 dashboard**:

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ANTES DE QUITAR OWNER A USUARIOS FAMILIA ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.fix-personal-owner.$(date +%F-%H%M)

echo
echo "===== IDS ====="
ROOT_ID="$(sqlite3 appdata/db/db.sqlite "SELECT id FROM user WHERE name='root' AND provider='credentials' LIMIT 1;")"
echo "ROOT_ID=$ROOT_ID"

if [ -z "$ROOT_ID" ]; then
  echo "ERROR: no encuentro usuario root local"
  exit 1
fi

echo
echo "===== CAMBIAR OWNER DE BOARDS PERSONAL-* A ROOT ====="
sqlite3 appdata/db/db.sqlite <<SQL
BEGIN TRANSACTION;

UPDATE board
SET creator_id = '$ROOT_ID'
WHERE name LIKE 'personal-%';

DELETE FROM boardUserPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
)
AND permission = 'full';

INSERT OR IGNORE INTO boardUserPermission (
  board_id,
  user_id,
  permission
)
SELECT
  b.id,
  u.id,
  'view'
FROM board b
JOIN user u ON b.name = 'personal-' || substr(u.email, 1, instr(u.email, '@') - 1)
WHERE b.name LIKE 'personal-%'
  AND u.provider = 'oidc';

INSERT OR IGNORE INTO boardUserPermission (
  board_id,
  user_id,
  permission
)
SELECT
  b.id,
  u.id,
  'modify'
FROM board b
JOIN user u ON b.name = 'personal-' || substr(u.email, 1, instr(u.email, '@') - 1)
WHERE b.name LIKE 'personal-%'
  AND u.provider = 'oidc';

DELETE FROM boardGroupPermission
WHERE board_id IN (
  SELECT id FROM board WHERE name LIKE 'personal-%'
);

INSERT OR IGNORE INTO boardGroupPermission (
  board_id,
  group_id,
  permission
)
SELECT
  id,
  'homelab-admins',
  'full'
FROM board
WHERE name LIKE 'personal-%';

COMMIT;
SQL

echo
echo "===== VER BOARDS PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.id, b.name, u.name AS creator, u.email AS creator_email
FROM board b
LEFT JOIN user u ON u.id = b.creator_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name;
"

echo
echo "===== ACL USER PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, u.name AS usuario, u.email, bup.permission
FROM boardUserPermission bup
JOIN board b ON b.id = bup.board_id
JOIN user u ON u.id = bup.user_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, u.name, bup.permission;
"

echo
echo "===== ACL GROUP PERSONAL ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name LIKE 'personal-%'
ORDER BY b.name, g.name, bgp.permission;
"

echo
echo "===== RECREAR HOMARR ====="
docker compose up -d --force-recreate homarr-v1
```

Después entra con `gencinasr`, recarga con `Ctrl + F5` y mira el Access Control del board personal.

Lo ideal ahora sería:

```text
Users:
Guillermo Encinas → Modify board
Guillermo Encinas → View board

Groups:
homelab-admins → Full access
```

Y sí: **que pueda editar widgets, iconos, apps, layout, etc. dentro de su board está bien**. Eso es justo lo que querías. Lo que queremos quitar es que sea “dueño total” de los permisos.

Luego hay que parchear el script para que los próximos boards personales nazcan con `creator_id = root`, no con `creator_id = usuario familiar`.




Sí, lo dejamos así. **Root ahí no me preocupa**: es tu usuario de emergencia/admin. Lo importante es limpiar duplicados y dejar el script preparado para futuros usuarios.

Vamos a dejar la política así:

```text
familia-base
→ familia: view
→ homelab-admins: full

personal-usuario
→ usuario dueño: full
→ homelab-admins: full
→ nadie más
```

Y luego borramos el usuario de prueba `gencinasr@gmail.com` para que puedas probar desde cero.

## 1. Parar timer mientras tocamos

En **CT101 dashboard**:

```bash
systemctl disable --now homarr-family-provisioner.timer 2>/dev/null || true
systemctl stop homarr-family-provisioner.service 2>/dev/null || true
```

## 2. Parchear el script para que no meta permisos repetidos

```bash
python3 - <<'PY'
from pathlib import Path

p = Path("/root/scripts/homarr-family-provisioner.py")
text = p.read_text()

backup = p.with_name(p.name + ".bak.clean-acl")
backup.write_text(text)

if "def get_root_user_id(cur):" not in text:
    marker = "\ndef clone_board_from_template("
    insert = r'''
def get_root_user_id(cur):
    row = q1(
        cur,
        "SELECT id FROM user WHERE name='root' AND provider='credentials' LIMIT 1"
    )
    if not row:
        raise RuntimeError("No encuentro el usuario root local de Homarr")
    return row["id"]

'''
    text = text.replace(marker, "\n" + insert + marker.lstrip("\n"))

text = text.replace(
    'board_data["creator_id"] = user["id"]',
    'board_data["creator_id"] = get_root_user_id(cur)'
)

start = text.index("def fix_permissions_and_home(")
end = text.index("\ndef main", start)

new_func = r'''def fix_permissions_and_home(cur, user, board_id):
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
'''

text = text[:start] + new_func + text[end:]

old = '''        ensure_board_group_perm(cur, template["id"], FAMILY_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "modify")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "full")'''

new = '''        cur.execute(
            "DELETE FROM boardGroupPermission WHERE board_id=?",
            (template["id"],),
        )

        ensure_board_group_perm(cur, template["id"], FAMILY_GROUP_ID, "view")
        ensure_board_group_perm(cur, template["id"], ADMIN_GROUP_ID, "full")'''

if old in text:
    text = text.replace(old, new)

p.write_text(text)
PY

python3 -m py_compile /root/scripts/homarr-family-provisioner.py && echo "Script OK"
```

## 3. Limpiar ACL actual y borrar usuario de prueba

Esto borra `gencinasr@gmail.com` de **Homarr**, no de Google ni de Keycloak. Cuando vuelva a iniciar sesión, Homarr lo recreará y el script debería crearle de nuevo su board.

```bash
cd /opt/stacks/homarr-v1

echo "===== BACKUP DB ====="
cp appdata/db/db.sqlite appdata/db/db.sqlite.bak.reset-test-users.$(date +%F-%H%M)

cat > /root/scripts/homarr-reset-test-users.py <<'PY'
#!/usr/bin/env python3
import sqlite3
from pathlib import Path

DB = Path("/opt/stacks/homarr-v1/appdata/db/db.sqlite")

KEEP_OIDC_EMAILS = {
    "sirchatie@gmail.com",
}

FAMILY_GROUP_ID = "familia"
ADMIN_GROUP_ID = "homelab-admins"
TEMPLATE_BOARD_NAME = "familia-base"


def q1(cur, sql, params=()):
    return cur.execute(sql, params).fetchone()


def qall(cur, sql, params=()):
    return cur.execute(sql, params).fetchall()


def cols(cur, table):
    return [r[1] for r in cur.execute(f"PRAGMA table_info('{table}')").fetchall()]


def table_exists(cur, table):
    return q1(cur, "SELECT name FROM sqlite_master WHERE type='table' AND name=?", (table,)) is not None


def personal_name_from_email(email):
    local = email.split("@")[0]
    safe = "".join(c.lower() if c.isalnum() else "-" for c in local).strip("-")
    while "--" in safe:
        safe = safe.replace("--", "-")
    return "personal-" + safe


def delete_board(cur, board_id):
    # Recoger IDs relacionados antes de borrar
    layout_ids = []
    section_ids = []
    item_ids = []

    if table_exists(cur, "layout") and "board_id" in cols(cur, "layout"):
        layout_ids = [r[0] for r in cur.execute("SELECT id FROM layout WHERE board_id=?", (board_id,)).fetchall()]

    if table_exists(cur, "section") and "board_id" in cols(cur, "section"):
        section_ids = [r[0] for r in cur.execute("SELECT id FROM section WHERE board_id=?", (board_id,)).fetchall()]

    if table_exists(cur, "item") and "board_id" in cols(cur, "item"):
        item_ids = [r[0] for r in cur.execute("SELECT id FROM item WHERE board_id=?", (board_id,)).fetchall()]

    if table_exists(cur, "item_layout"):
        c = cols(cur, "item_layout")
        if "item_id" in c and item_ids:
            cur.execute(
                f"DELETE FROM item_layout WHERE item_id IN ({','.join(['?'] * len(item_ids))})",
                item_ids,
            )
        if "layout_id" in c and layout_ids:
            cur.execute(
                f"DELETE FROM item_layout WHERE layout_id IN ({','.join(['?'] * len(layout_ids))})",
                layout_ids,
            )
        if "section_id" in c and section_ids:
            cur.execute(
                f"DELETE FROM item_layout WHERE section_id IN ({','.join(['?'] * len(section_ids))})",
                section_ids,
            )

    if table_exists(cur, "section_layout"):
        c = cols(cur, "section_layout")
        if "section_id" in c and section_ids:
            cur.execute(
                f"DELETE FROM section_layout WHERE section_id IN ({','.join(['?'] * len(section_ids))})",
                section_ids,
            )
        if "layout_id" in c and layout_ids:
            cur.execute(
                f"DELETE FROM section_layout WHERE layout_id IN ({','.join(['?'] * len(layout_ids))})",
                layout_ids,
            )

    for table in ["boardUserPermission", "boardGroupPermission"]:
        if table_exists(cur, table):
            cur.execute(f"DELETE FROM {table} WHERE board_id=?", (board_id,))

    for table in ["item", "section", "layout"]:
        if table_exists(cur, table) and "board_id" in cols(cur, table):
            cur.execute(f"DELETE FROM {table} WHERE board_id=?", (board_id,))

    cur.execute("DELETE FROM board WHERE id=?", (board_id,))


con = sqlite3.connect(DB)
cur = con.cursor()

cur.execute("BEGIN TRANSACTION")

# Borrar usuarios OIDC de prueba excepto Sir Chatie
users = qall(cur, "SELECT id, email FROM user WHERE provider='oidc'")

for user_id, email in users:
    email = email or ""

    if email in KEEP_OIDC_EMAILS:
        continue

    personal_board_name = personal_name_from_email(email) if email else None

    board_ids = set()

    if personal_board_name:
        row = q1(cur, "SELECT id FROM board WHERE name=?", (personal_board_name,))
        if row:
            board_ids.add(row[0])

    row = q1(cur, "SELECT home_board_id FROM user WHERE id=?", (user_id,))
    if row and row[0]:
        b = q1(cur, "SELECT name FROM board WHERE id=?", (row[0],))
        if b and b[0].startswith("personal-"):
            board_ids.add(row[0])

    for board_id in board_ids:
        delete_board(cur, board_id)

    for table in ["session", "account", "groupMember", "boardUserPermission"]:
        if table_exists(cur, table) and "user_id" in cols(cur, table):
            cur.execute(f"DELETE FROM {table} WHERE user_id=?", (user_id,))

    cur.execute("DELETE FROM user WHERE id=?", (user_id,))

# Limpiar familia-base: familia view, admins full
template = q1(cur, "SELECT id FROM board WHERE name=?", (TEMPLATE_BOARD_NAME,))
if template:
    template_id = template[0]

    cur.execute("DELETE FROM boardGroupPermission WHERE board_id=?", (template_id,))

    cur.execute(
        "INSERT OR IGNORE INTO boardGroupPermission (board_id, group_id, permission) VALUES (?, ?, ?)",
        (template_id, FAMILY_GROUP_ID, "view"),
    )

    cur.execute(
        "INSERT OR IGNORE INTO boardGroupPermission (board_id, group_id, permission) VALUES (?, ?, ?)",
        (template_id, ADMIN_GROUP_ID, "full"),
    )

    cur.execute(
        "UPDATE 'group' SET home_board_id=?, mobile_home_board_id=? WHERE id=? OR name=?",
        (template_id, template_id, FAMILY_GROUP_ID, FAMILY_GROUP_ID),
    )

# Limpiar boards personales restantes: dueño full, admins full
personal_boards = qall(cur, "SELECT id, name FROM board WHERE name LIKE 'personal-%'")

for board_id, board_name in personal_boards:
    cur.execute("DELETE FROM boardUserPermission WHERE board_id=?", (board_id,))
    cur.execute("DELETE FROM boardGroupPermission WHERE board_id=?", (board_id,))

    suffix = board_name.replace("personal-", "", 1)
    owner = q1(
        cur,
        "SELECT id FROM user WHERE provider='oidc' AND email LIKE ? LIMIT 1",
        (suffix + "@%",),
    )

    if owner:
        cur.execute(
            "INSERT OR IGNORE INTO boardUserPermission (board_id, user_id, permission) VALUES (?, ?, ?)",
            (board_id, owner[0], "full"),
        )

    cur.execute(
        "INSERT OR IGNORE INTO boardGroupPermission (board_id, group_id, permission) VALUES (?, ?, ?)",
        (board_id, ADMIN_GROUP_ID, "full"),
    )

con.commit()
con.close()

print("Limpieza terminada")
PY

python3 /root/scripts/homarr-reset-test-users.py

docker compose up -d --force-recreate homarr-v1
```

## 4. Verificar que solo queda Sir Chatie y root

```bash
cd /opt/stacks/homarr-v1

echo "===== USUARIOS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT u.name, u.email, u.provider, b.name AS home_board
FROM user u
LEFT JOIN board b ON b.id = u.home_board_id
ORDER BY u.name;
"

echo
echo "===== BOARDS ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT id, name, creator_id
FROM board
ORDER BY name;
"

echo
echo "===== ACL FAMILIA-BASE ====="
sqlite3 -header -column appdata/db/db.sqlite "
SELECT b.name AS board, g.name AS grupo, bgp.permission
FROM boardGroupPermission bgp
JOIN board b ON b.id = bgp.board_id
JOIN 'group' g ON g.id = bgp.group_id
WHERE b.name='familia-base'
ORDER BY g.name, bgp.permission;
"
```

Deberías ver algo así:

```text
root
Sir Chatie
```

Y no debería estar `Guillermo Encinas / gencinasr`.

## 5. Reactivar el provisioner

```bash
cat > /etc/systemd/system/homarr-family-provisioner.service <<'EOF'
[Unit]
Description=Homarr family OIDC personal board provisioner
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/usr/bin/flock -n /run/homarr-family-provisioner.lock /usr/bin/python3 /root/scripts/homarr-family-provisioner.py --apply
EOF

cat > /etc/systemd/system/homarr-family-provisioner.timer <<'EOF'
[Unit]
Description=Run Homarr family personal board provisioner every minute

[Timer]
OnBootSec=2min
OnUnitActiveSec=1min
Unit=homarr-family-provisioner.service

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now homarr-family-provisioner.timer

systemctl status homarr-family-provisioner.timer --no-pager
```

## 6. Prueba final

Ahora entra con `gencinasr@gmail.com` otra vez desde Google.

Lo esperado:

```text
1. Homarr crea de nuevo el usuario.
2. Keycloak lo mete en familia.
3. Timer lo detecta.
4. Script clona familia-base.
5. Crea personal-gencinasr.
6. gencinasr ve su board personal.
7. gencinasr puede editar su board.
8. familia-base solo lo puede ver.
9. Sir Chatie/root/admin pueden controlar todo.
```

Y sí: con `full` en su board personal podrá tocar bastante de su propio board. De momento lo dejamos así porque funciona y es su espacio. La seguridad real sigue estando en las apps finales, no en Homarr.



Vale, ya lo he mirado en los documentos.

Immich en tu guía **no está “seguramente” en cualquier sitio**. Está así:

```text
VM 109 - immich
IP: 10.10.10.30/24
Gateway: 10.10.10.87
Stack: /opt/stacks/immich
Puerto Immich: 2283
Acceso directo: http://10.10.10.30:2283
Contenedores:
- immich-server
- immich-machine-learning
- immich-redis
- immich-postgres
Datos:
- /opt/stacks/immich/library
- /opt/stacks/immich/postgres
- /opt/stacks/immich/model-cache
```

Tu guía dice exactamente que la VM 109 `immich` va en `vmbr10`, con IP `10.10.10.30/24`, gateway `10.10.10.87`, y que el stack se crea en `/opt/stacks/immich` con `library`, `postgres` y `model-cache`. También indica que el acceso directo es `http://10.10.10.30:2283`.

Immich oficialmente usa OAuth desde **Administration → Settings → OAuth Authentication**, con redirect web tipo `https://immich.home.arpa/auth/login`, otro para vincular cuenta `https://immich.home.arpa/user-settings`, y para móvil `app.immich:///oauth-callback`. ([Immich](https://docs.immich.app/administration/oauth?utm_source=chatgpt.com "OAuth Authentication"))

Vamos ordenado.

## 1. Entra en la VM 109 de Immich

Desde Proxmox o SSH:

```bash
ssh guillermo@10.10.10.30
```

Si entras como root, perfecto también.

## 2. Comprobación real de Immich

Pega esto en la VM 109:

```bash
echo "===== HOST ====="
hostname
ip a
ip route

echo
echo "===== STACK IMMICH ====="
cd /opt/stacks/immich || exit 1
pwd
ls -lah

echo
echo "===== ENV SIN PASSWORD ====="
grep -E 'UPLOAD_LOCATION|DB_DATA_LOCATION|IMMICH_VERSION|DB_USERNAME|DB_DATABASE_NAME|TZ' .env || true

echo
echo "===== CONTENEDORES IMMICH ====="
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' | grep -i -E 'immich|redis|postgres|NAME'

echo
echo "===== HTTP LOCAL ====="
curl -I --max-time 10 http://127.0.0.1:2283 || true
curl -I --max-time 10 http://10.10.10.30:2283 || true
```




Vale, perfecto. Ya estás como:

```bash
root@immich:~#
```

Así ahora puedes copiar y pegar todo sin problemas de permisos.

Solo te digo una cosa: **cuando acabemos**, si quieres ir más seguro, podemos dejar root por SSH desactivado otra vez o permitirlo solo con clave. Pero para trabajar ahora, seguimos.

## 1. Backup Immich desde root

Pega esto tal cual en `root@immich`:

```bash
cd /opt/stacks/immich || exit 1

echo "===== BACKUP IMMICH PRE-SSO ====="
BACKUP_DIR="/opt/backups/immich/pre-sso-$(date +%F-%H%M)"
mkdir -p "$BACKUP_DIR"

echo
echo "===== COPIAR CONFIG ====="
cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml"
cp .env "$BACKUP_DIR/.env"

echo
echo "===== DUMP POSTGRES ====="
docker exec immich-postgres pg_dumpall -U postgres > "$BACKUP_DIR/immich-postgres-dump.sql"

echo
echo "===== INFO CONTENEDORES ====="
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' > "$BACKUP_DIR/docker-ps.txt"

echo
echo "===== BACKUP CREADO ====="
ls -lh "$BACKUP_DIR"
```

## 2. Comprobar proxy y Keycloak

Después pega esto:

```bash
echo "===== DNS IMMICH ====="
nslookup immich.home.arpa 192.168.1.53

echo
echo "===== IMMICH HTTPS POR PROXY ====="
curl -k -I --max-time 10 https://immich.home.arpa

echo
echo "===== IMMICH DIRECTO ====="
curl -I --max-time 10 http://10.10.10.30:2283

echo
echo "===== KEYCLOAK DISCOVERY ====="
curl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
```

Lo que queremos ver:

```text
immich.home.arpa → 192.168.1.82
https://immich.home.arpa → responde
http://10.10.10.30:2283 → 200 OK
Keycloak discovery → 200 OK
```

Cuando tengas esa salida, seguimos con el cliente `immich` en Keycloak y luego activamos OAuth dentro de Immich.



Para activar el acceso SSH como root en Linux, edite el archivo `/etc/ssh/sshd_config` usando `sudo nano /etc/ssh/sshd_config`, cambie o añada la línea `PermitRootLogin yes`, guarde los cambios y reinicie el servicio con `sudo systemctl restart ssh`. Asegúrese de tener una contraseña de root definida con `sudo passwd root`



Bien, el **backup está perfecto**:

```text
immich-postgres-dump.sql → 158 MB ✅
docker-compose.yml ✅
.env también está copiado, pero no sale porque es archivo oculto
```

Para verlo:

```bash
ls -lah /opt/backups/immich/pre-sso-2026-05-04-0849
```

El problema ahora es claro: **la VM de Immich no está usando tu DNS interno por defecto**.

Esto lo demuestra:

```text
nslookup immich.home.arpa 192.168.1.53 → funciona ✅
curl https://immich.home.arpa → no resuelve ❌
curl https://auth.home.arpa → no resuelve ❌
```

O sea, cuando fuerzas `192.168.1.53`, funciona. Pero el sistema usa otro DNS.

## 1. Arreglar DNS en la VM Immich

Pega esto en `root@immich`:

```bash
echo "===== BACKUP RESOLV.CONF ====="
cp /etc/resolv.conf /etc/resolv.conf.bak.$(date +%F-%H%M) 2>/dev/null || true

echo
echo "===== PONER DNS INTERNO ====="
cat > /etc/resolv.conf <<'EOF'
search home.arpa
nameserver 192.168.1.53
nameserver 1.1.1.1
EOF

echo
echo "===== VER RESOLV.CONF ====="
cat /etc/resolv.conf

echo
echo "===== PROBAR RESOLUCION ====="
getent hosts immich.home.arpa
getent hosts auth.home.arpa
nslookup immich.home.arpa
nslookup auth.home.arpa
```

## 2. Probar otra vez proxy y Keycloak

```bash
echo "===== IMMICH HTTPS POR PROXY ====="
curl -k -I --max-time 10 https://immich.home.arpa

echo
echo "===== AUTH KEYCLOAK ====="
curl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
```

Lo bueno ahora sería:

```text
https://immich.home.arpa → responde
https://auth.home.arpa/...openid-configuration → 200 OK
```

## 3. Hacer que los contenedores cojan el DNS nuevo

Docker normalmente coge el DNS al recrear contenedores. Pega:

```bash
cd /opt/stacks/immich || exit 1

echo "===== RECREAR IMMICH PARA DNS ====="
docker compose up -d --force-recreate

sleep 15

echo
echo "===== TEST DNS DENTRO DE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'getent hosts auth.home.arpa || nslookup auth.home.arpa || true'

echo
echo "===== TEST CONTENEDORES ====="
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -i -E 'immich|postgres|redis|NAME'
```

Si dentro del contenedor `auth.home.arpa` resuelve, ya podemos seguir con Keycloak + OAuth de Immich.

## 4. Si después de reiniciar vuelve a fallar

Este cambio de `/etc/resolv.conf` puede ser temporal si tu sistema lo regenera. Si se pierde tras reboot, lo hacemos persistente en la configuración de red. Pero para seguir ahora con Immich, con esto vale.


cd /opt/stacks/immich || exit 1

echo "===== RECREAR IMMICH PARA QUE DOCKER COJA DNS ====="
docker compose up -d --force-recreate

sleep 15

echo
echo "===== TEST DNS DENTRO DE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'getent hosts auth.home.arpa || nslookup auth.home.arpa || true'

echo
echo "===== TEST HTTPS DESDE DENTRO DE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'wget -S --spider --no-check-certificate https://auth.home.arpa/realms/homelab/.well-known/openid-configuration 2>&1 | head -30 || true'

echo
echo "===== CONTENEDORES ====="
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -i -E 'immich|postgres|redis|NAME'



Sí, ahora está bien. Antes fallaba por esto:

```text
nslookup immich.home.arpa 192.168.1.53
```

Ese comando **forzaba** usar el DNS `192.168.1.53`, por eso resolvía.

Pero este otro:

```bash
curl https://immich.home.arpa
```

usa el DNS normal de la VM, o sea `/etc/resolv.conf`. Antes la VM de Immich no estaba usando bien tu DNS interno, por eso `curl` no resolvía.

Tu navegador sí abría Immich porque tu **PC/navegador** sí estaba resolviendo `immich.home.arpa`, seguramente por Pi-hole/Tailscale/DNS interno/caché. La VM de Immich es otra máquina distinta y tenía su DNS mal.

Ahora ya está perfecto:

```text
https://immich.home.arpa → 200 OK ✅
auth.home.arpa discovery → 200 OK ✅
```

Antes de seguir, haz que el contenedor de Immich también coja bien ese DNS:

```bash
cd /opt/stacks/immich || exit 1

echo "===== RECREAR IMMICH PARA QUE DOCKER COJA DNS ====="
docker compose up -d --force-recreate

sleep 15

echo
echo "===== TEST DNS DENTRO DE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'getent hosts auth.home.arpa || nslookup auth.home.arpa || true'

echo
echo "===== TEST HTTPS DESDE DENTRO DE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'wget -S --spider --no-check-certificate https://auth.home.arpa/realms/homelab/.well-known/openid-configuration 2>&1 | head -30 || true'

echo
echo "===== CONTENEDORES ====="
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -i -E 'immich|postgres|redis|NAME'
```

Si eso responde bien, seguimos con el cliente `immich` en Keycloak y luego activamos OAuth dentro de Immich.


Tienes razón, si ahora `admin-guillermo` ya no tiene OTP, usamos ese usuario admin directamente y dejamos de usar `keycloak-automation`.

Pega esto en **CT identity**:

```bash
cat > /root/scripts/keycloak-fix-immich-client-admin.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.parse
import urllib.request
import urllib.error

KEYCLOAK_URL = "http://10.10.10.74:8080"

ADMIN_REALM = "master"
TARGET_REALM = "homelab"

CLIENT_ID = "immich"

REDIRECT_URIS = [
    "https://immich.home.arpa/auth/login",
    "https://immich.home.arpa/user-settings",
    "app.immich:///oauth-callback",
]

WEB_ORIGINS = [
    "https://immich.home.arpa",
]

POST_LOGOUT = "https://immich.home.arpa/*"


def form_post(url, form):
    data = urllib.parse.urlencode(form).encode()

    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR login Keycloak HTTP {e.code}\n{detail}") from e


def request(method, url, token=None, data=None):
    headers = {}
    body = None

    if token:
        headers["Authorization"] = f"Bearer {token}"

    if data is not None:
        body = json.dumps(data).encode()
        headers["Content-Type"] = "application/json"

    req = urllib.request.Request(
        url,
        data=body,
        headers=headers,
        method=method,
    )

    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            raw = r.read().decode()

            if not raw:
                return None

            try:
                return json.loads(raw)
            except json.JSONDecodeError:
                return raw

    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR HTTP {e.code} en {url}\n{detail}") from e


def get_admin_token():
    print("===== LOGIN ADMIN KEYCLOAK =====")
    username = input("Usuario admin Keycloak [admin-guillermo]: ").strip() or "admin-guillermo"
    password = getpass.getpass("Password admin Keycloak: ")

    res = form_post(
        f"{KEYCLOAK_URL}/realms/{ADMIN_REALM}/protocol/openid-connect/token",
        {
            "grant_type": "password",
            "client_id": "admin-cli",
            "username": username,
            "password": password,
        },
    )

    return res["access_token"]


def get_client(token):
    res = request(
        "GET",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients?clientId={urllib.parse.quote(CLIENT_ID)}",
        token=token,
    )

    if res:
        return res[0]

    return None


def create_client(token):
    payload = {
        "clientId": CLIENT_ID,
        "name": "Immich",
        "enabled": True,
        "protocol": "openid-connect",
        "publicClient": False,
        "clientAuthenticatorType": "client-secret",
        "standardFlowEnabled": True,
        "implicitFlowEnabled": False,
        "directAccessGrantsEnabled": False,
        "serviceAccountsEnabled": False,
        "authorizationServicesEnabled": False,
        "frontchannelLogout": True,
        "rootUrl": "https://immich.home.arpa",
        "baseUrl": "https://immich.home.arpa",
        "redirectUris": REDIRECT_URIS,
        "webOrigins": WEB_ORIGINS,
        "attributes": {
            "post.logout.redirect.uris": POST_LOGOUT,
            "pkce.code.challenge.method": "S256",
        },
    }

    request(
        "POST",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients",
        token=token,
        data=payload,
    )

    return get_client(token)


def update_client(token, client):
    client_uuid = client["id"]

    payload = dict(client)

    payload.update({
        "clientId": CLIENT_ID,
        "name": "Immich",
        "enabled": True,
        "protocol": "openid-connect",
        "publicClient": False,
        "clientAuthenticatorType": "client-secret",
        "standardFlowEnabled": True,
        "implicitFlowEnabled": False,
        "directAccessGrantsEnabled": False,
        "serviceAccountsEnabled": False,
        "authorizationServicesEnabled": False,
        "frontchannelLogout": True,
        "rootUrl": "https://immich.home.arpa",
        "baseUrl": "https://immich.home.arpa",
        "redirectUris": REDIRECT_URIS,
        "webOrigins": WEB_ORIGINS,
    })

    attrs = payload.get("attributes") or {}
    attrs["post.logout.redirect.uris"] = POST_LOGOUT
    attrs["pkce.code.challenge.method"] = "S256"
    payload["attributes"] = attrs

    request(
        "PUT",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients/{client_uuid}",
        token=token,
        data=payload,
    )

    return get_client(token)


def get_client_secret(token, client_uuid):
    res = request(
        "GET",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients/{client_uuid}/client-secret",
        token=token,
    )

    return res["value"]


def main():
    print("===== PREFLIGHT KEYCLOAK =====")

    try:
        request("GET", f"{KEYCLOAK_URL}/realms/{TARGET_REALM}/.well-known/openid-configuration")
        print("Realm homelab OK")
    except Exception as e:
        raise SystemExit(f"ERROR: no responde Keycloak/realm homelab: {e}")

    token = get_admin_token()

    print()
    print("===== CLIENT IMMICH =====")

    client = get_client(token)

    if client:
        print("Client immich existe, actualizando...")
        client = update_client(token, client)
    else:
        print("Client immich no existe, creando...")
        client = create_client(token)

    if not client:
        raise SystemExit("ERROR: no se pudo crear/encontrar el client immich")

    secret = get_client_secret(token, client["id"])

    print()
    print("===== IMMICH CLIENT OK =====")
    print()
    print("Issuer URL:")
    print("https://auth.home.arpa/realms/homelab")
    print()
    print("Client ID:")
    print("immich")
    print()
    print("Client Secret para pegar en Immich:")
    print(secret)
    print()
    print("Redirect URIs configuradas:")
    for uri in REDIRECT_URIS:
        print(f"- {uri}")
    print()
    print("Web Origins:")
    for origin in WEB_ORIGINS:
        print(f"- {origin}")


if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/keycloak-fix-immich-client-admin.py
python3 /root/scripts/keycloak-fix-immich-client-admin.py
```

Cuando te pida:

```text
Usuario admin Keycloak [admin-guillermo]:
```

dale Enter si es ese.

Cuando te pida:

```text
Password admin Keycloak:
```

pon la contraseña de `admin-guillermo`.

Al final te sacará:

```text
Issuer URL
Client ID
Client Secret
```

Ese `Client Secret` lo pegas en Immich, pero no aquí.






Ahora toca **meter ese secret en Immich**.

## 1. Configurar OAuth en Immich

Entra como admin en:

```text
https://immich.home.arpa
```

Luego ve a:

```text
Administration
→ Settings
→ OAuth Authentication
```

Rellena así:

```text
Enabled: ON

Issuer URL:
https://auth.home.arpa/realms/homelab

Client ID:
immich

Client Secret:
el secret que acabas de copiar

Scope:
openid email profile

Signing Algorithm:
RS256

Storage Label Claim:
preferred_username

Button Text:
Login with Google

Auto Register:
ON

Auto Launch:
OFF

Mobile Redirect URI Override:
OFF
```

Las redirect URIs que hemos puesto cuadran con las que usa Immich para OAuth: web `https://immich.home.arpa/auth/login`, vinculación de cuenta `https://immich.home.arpa/user-settings` y móvil `app.immich:///oauth-callback`. ([Immich](https://docs.immich.app/administration/oauth?utm_source=chatgpt.com "OAuth Authentication"))

De momento **no actives Auto Launch**, así si algo falla puedes seguir entrando con el login normal.

## 2. Guardar y probar desde incógnito

Abre incógnito:

```text
https://immich.home.arpa
```

Debería salir un botón tipo:

```text
Login with Google
```

Flujo esperado:

```text
Immich
→ Keycloak auth.home.arpa
→ Google
→ vuelve a Immich
```

## 3. Si funciona

Cuando entre bien, en `root@immich` mira logs rápidos:

```bash
cd /opt/stacks/immich || exit 1

echo "===== LOGS IMMICH OAUTH ====="
docker logs immich-server --since=10m | grep -i -E 'oauth|oidc|auth|login|callback|error|warn' || true
```

Y hacemos snapshot/backup final.

## 4. Si falla

Pásame la pantalla/error y esta salida:

```bash
cd /opt/stacks/immich || exit 1

echo "===== LOGS IMMICH OAUTH ====="
docker logs immich-server --since=10m | grep -i -E 'oauth|oidc|auth|login|callback|error|warn|invalid|redirect' || true

echo
echo "===== TEST KEYCLOAK DESDE IMMICH ====="
docker exec immich-server sh -lc 'wget -S --spider --no-check-certificate https://auth.home.arpa/realms/homelab/.well-known/openid-configuration 2>&1 | head -40 || true'
```

Primero prueba con tu cuenta Google normal. No desactives todavía el login normal de Immich.







El error es bastante claro:

```text
Error in OAuth discovery: TypeError: fetch failed
```

Eso significa que **Immich Server no consigue leer**:

```text
https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
```

Desde tu navegador y desde la VM ya funciona, pero **el que tiene que llegar es el contenedor `immich-server`**. Casi seguro es por el certificado interno/self-signed del proxy, igual que nos pasó con Homarr.

## 1. Confirmar el fallo desde dentro del contenedor

En `root@immich` pega:

```bash
cd /opt/stacks/immich || exit 1

echo "===== TEST DESDE HOST ====="
curl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration

echo
echo "===== TEST DNS DESDE CONTENEDOR ====="
docker exec immich-server sh -lc 'getent hosts auth.home.arpa || nslookup auth.home.arpa || true'

echo
echo "===== TEST FETCH NODE DESDE CONTENEDOR ====="
docker exec immich-server sh -lc 'node -e "fetch(\"https://auth.home.arpa/realms/homelab/.well-known/openid-configuration\").then(r=>console.log(r.status)).catch(e=>console.error(e))"'

echo
echo "===== LOGS IMMICH ====="
docker logs immich-server --since=10m | grep -i -E 'oauth|oidc|auth|discovery|fetch|certificate|self|error|warn' || true
```

Si sale algo tipo:

```text
self-signed certificate
unable to verify
fetch failed
```

hacemos lo siguiente.

---

## 2. Meter el certificado del proxy dentro de Immich

Pega esto en `root@immich`:

```bash
cd /opt/stacks/immich || exit 1

echo "===== CREAR CARPETA CERTS ====="
mkdir -p /opt/stacks/immich/certs

echo
echo "===== EXTRAER CERTIFICADO DE AUTH.HOME.ARPA ====="
openssl s_client -showcerts \
  -connect auth.home.arpa:443 \
  -servername auth.home.arpa \
  </dev/null 2>/dev/null \
  | awk '/BEGIN CERTIFICATE/,/END CERTIFICATE/' \
  > /opt/stacks/immich/certs/home-arpa.crt

echo
echo "===== COMPROBAR CERTIFICADO ====="
ls -lh /opt/stacks/immich/certs/home-arpa.crt
grep -c "BEGIN CERTIFICATE" /opt/stacks/immich/certs/home-arpa.crt
```

Tiene que salir mínimo:

```text
1
```

---

## 3. Parchear `docker-compose.yml` de Immich

Este parche añade el certificado solo al contenedor `immich-server`.

```bash
cd /opt/stacks/immich || exit 1

echo "===== BACKUP COMPOSE ====="
cp docker-compose.yml docker-compose.yml.bak.oauth-ca.$(date +%F-%H%M)

echo
echo "===== PARCHEAR COMPOSE ====="
python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

cert_volume = "      - /opt/stacks/immich/certs/home-arpa.crt:/certs/home-arpa.crt:ro"
node_env = "      - NODE_EXTRA_CA_CERTS=/certs/home-arpa.crt"

if "NODE_EXTRA_CA_CERTS=/certs/home-arpa.crt" not in text:
    if "    environment:\n" in text.split("  immich-server:", 1)[1].split("\n  ", 1)[0]:
        text = text.replace(
            "  immich-server:\n",
            "  immich-server:\n",
            1
        )
    else:
        text = text.replace(
            "    env_file:\n      - .env\n",
            "    env_file:\n      - .env\n    environment:\n      - NODE_EXTRA_CA_CERTS=/certs/home-arpa.crt\n",
            1
        )

if cert_volume not in text:
    text = text.replace(
        "      - /etc/localtime:/etc/localtime:ro",
        "      - /etc/localtime:/etc/localtime:ro\n" + cert_volume,
        1
    )

p.write_text(text)
PY

echo
echo "===== VER CAMBIOS ====="
grep -n -E 'immich-server|env_file|environment|NODE_EXTRA_CA_CERTS|home-arpa.crt|volumes|localtime' docker-compose.yml
```

Si el `grep` enseña `NODE_EXTRA_CA_CERTS` y el volumen del certificado, seguimos.

---

## 4. Recrear Immich

```bash
cd /opt/stacks/immich || exit 1

echo "===== RECREAR IMMICH ====="
docker compose up -d --force-recreate immich-server

sleep 15

echo
echo "===== TEST FETCH NODE DESPUES ====="
docker exec immich-server sh -lc 'node -e "fetch(\"https://auth.home.arpa/realms/homelab/.well-known/openid-configuration\").then(r=>console.log(r.status)).catch(e=>console.error(e))"'

echo
echo "===== CONTENEDORES ====="
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' | grep -i -E 'immich|postgres|redis|NAME'
```

Lo bueno es que salga:

```text
200
```

---

## 5. Vuelve a Immich y guarda OAuth

En Immich, revisa:

```text
Issuer URL: https://auth.home.arpa/realms/homelab
Client ID: immich
Client Secret: el secret copiado
Scope: openid email profile
Signing Algorithm: RS256
Storage Label Claim: preferred_username
Role Claim: immich_role
Button Text: Login with Google
Auto Register: ON
Auto Launch: OFF
```

Pulsa **Guardar** abajo.

Luego prueba otra vez el botón:

```text
Login with OAuth
```

Si todavía falla, pásame la salida del bloque del paso 4 y estos logs:

```bash
cd /opt/stacks/immich || exit 1

docker logs immich-server --since=10m | grep -i -E 'oauth|oidc|auth|discovery|fetch|certificate|self|error|warn|redirect' || true
```


solo hay un problema que oues no me quiere hacer log out:  desde cualquier sitio pc navegador oculto y todo eso y le he metido el sirchatie y paece que ya no me deja acceder a otra cuenta sabes? ns porque pero solo está esa... algo has hecho mal
No es que “haya roto” el login: lo que estás viendo es el comportamiento normal de **Keycloak + Google**.

Cuando haces logout ahí:

```text
auth.home.arpa/realms/homelab/protocol/openid-connect/logout/logout-confirm
```

cierras sesión en **Keycloak**, pero **no necesariamente cierras la sesión de Google** del navegador. Entonces al volver a iniciar, Google puede reutilizar automáticamente la cuenta `sirchatie` que ya está abierta en ese navegador. Esto pasa mucho con Google; hay issues antiguos de Keycloak justo sobre que Google no enseña selector de cuenta si ya hay una sesión Google activa, y la solución típica sería pedir `prompt=select_account`, aunque Keycloak no siempre lo soporta directamente en el provider Google según versión. ([GitHub](https://github.com/keycloak/keycloak/issues/14258?utm_source=chatgpt.com "Google login - add prompt=select_account option #14258"))

Para poder elegir cuenta, tienes 3 opciones:

```text
Opción rápida:
usar otra ventana privada cerrando TODAS las privadas anteriores

Opción manual:
salir de la cuenta Google en google.com/accounts

Opción buena:
hacer que Keycloak/Google pregunte cuenta siempre
```

Pero para Immich ahora, lo primero es arreglar el error de OAuth discovery. Si ya hiciste el certificado y el contenedor puede hacer fetch, seguimos. Si no, pega esto en `root@immich`:

```bash
cd /opt/stacks/immich || exit 1

echo "===== TEST FETCH NODE DESDE IMMICH-SERVER ====="
docker exec immich-server sh -lc 'node -e "fetch(\"https://auth.home.arpa/realms/homelab/.well-known/openid-configuration\").then(r=>console.log(r.status)).catch(e=>console.error(e))"'
```

Si sale `200`, vuelve a Immich y pulsa **Guardar** en OAuth.

Si vuelve a salir `fetch failed`, usa el apaño que ya nos funcionó en Homarr: desactivar verificación TLS solo para Immich Server de momento.

```bash
cd /opt/stacks/immich || exit 1

echo "===== BACKUP COMPOSE ====="
cp docker-compose.yml docker-compose.yml.bak.oauth-tls.$(date +%F-%H%M)

echo
echo "===== AÑADIR NODE_TLS_REJECT_UNAUTHORIZED=0 AL IMMICH SERVER ====="
python3 - <<'PY'
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

service = "  immich-server:"
line = "      - NODE_TLS_REJECT_UNAUTHORIZED=0"

if line in text:
    print("Ya estaba puesto")
    raise SystemExit

start = text.index(service)
next_service = text.find("\n  ", start + len(service))
block = text[start:] if next_service == -1 else text[start:next_service]

if "    environment:" in block:
    block = block.replace("    environment:\n", "    environment:\n" + line + "\n", 1)
else:
    insert_after = "    env_file:\n      - .env\n"
    if insert_after in block:
        block = block.replace(insert_after, insert_after + "    environment:\n" + line + "\n", 1)
    else:
        block = block.replace(service + "\n", service + "\n    environment:\n" + line + "\n", 1)

if next_service == -1:
    text = text[:start] + block
else:
    text = text[:start] + block + text[next_service:]

p.write_text(text)
PY

echo
echo "===== RECREAR IMMICH SERVER ====="
docker compose up -d --force-recreate immich-server

sleep 15

echo
echo "===== TEST FETCH ====="
docker exec immich-server sh -lc 'node -e "fetch(\"https://auth.home.arpa/realms/homelab/.well-known/openid-configuration\").then(r=>console.log(r.status)).catch(e=>console.error(e))"'
```

Luego vuelve a Immich y deja OAuth así:

```text
Enabled: ON
Issuer URL: https://auth.home.arpa/realms/homelab
Client ID: immich
Client Secret: el secret de Keycloak
Scope: openid email profile
Signing Algorithm: RS256
Storage Label Claim: preferred_username
Role Claim: immich_role
Button Text: Login with Google
Auto Register: ON
Auto Launch: OFF
```

Sobre lo de elegir otra cuenta Google: para probar ahora mismo haz esto en el navegador:

```text
1. Cierra todas las ventanas privadas.
2. Abre una privada nueva.
3. Ve a https://accounts.google.com/logout
4. Luego entra a https://immich.home.arpa
5. Pulsa Login with OAuth.
```

Si sigue entrando directo con `sirchatie`, no es Immich: es sesión Google/Keycloak. Lo dejamos para después con `prompt=select_account` o con un flujo de Keycloak menos agresivo. Primero deja que Immich haga discovery y aparezca el login OAuth bien.



es como q si pero no funcinoa o tarda en salirse pero bueno, o es como que no te reredirige a immich se queda en keylock sabes? por si cierras y abres otra ventana si sale i¡q se ha cerrado la ventana: y otra pregunta entonces todo ys esta perfecto una ve ssolucinoado lo de reedirigir no ?? lueogo tengo ua preunta no se peude acceder a las fotos de otras cuentas no ?? y se ven entre ellos para poder compartir fotos de forma rapida y todo eso dentro de imich sin tener que sacarlas del servidor y  luego meterlas de nuevo en el mismo servidor diferente perfil ?? 



Sí: **lo del logout ahora mismo lo dejaría como “cosmético/no crítico”**. Si al cerrar sesión te deja en la pantalla de Keycloak de “You are logged out”, realmente la sesión de Keycloak se ha cerrado. Que no te redirija automáticamente a Immich es molesto, pero no rompe el sistema.

Para probar bien, lo importante es:

```text
1. Cerrar sesión.
2. Abrir immich.home.arpa otra vez.
3. Que te pida login.
4. Que puedas entrar con OAuth.
```

Si eso funciona, **Immich + Keycloak está bien**. Lo de elegir otra cuenta de Google depende también de la sesión activa de Google en el navegador. Si Google ya tiene abierta `sirchatie`, muchas veces te mete directo con esa cuenta. Para forzar elegir cuenta, más adelante miramos si tu versión de Immich ya permite parámetro `prompt=select_account`; Immich ha anunciado mejoras OAuth recientes como soporte de `prompt`, custom logout endpoint y back-channel logout, pero no lo tocaría ahora si ya funciona. ([Immich](https://immich.app/blog/2026-april-recap?utm_source=chatgpt.com "April recap | Immich Blog"))

Sobre las fotos: **no, una cuenta normal no debería ver las fotos privadas de otra cuenta**. Immich es multiusuario y cada usuario tiene su propia biblioteca, salvo que compartas algo explícitamente. Immich tiene soporte multiusuario, álbumes compartidos y partner sharing. ([GitHub](https://github.com/immich-app/immich?utm_source=chatgpt.com "immich-app/immich: High performance self-hosted photo ..."))

Lo bueno es que **sí puedes compartir fotos dentro de Immich sin sacarlas y volverlas a subir**:

```text
Opción 1: Álbum compartido
→ creas un álbum
→ metes fotos
→ lo compartes con otro usuario de Immich
→ le das permiso de Viewer o Editor
```

La documentación de Immich dice que los álbumes se pueden compartir entre usuarios de la misma instancia y que los usuarios compartidos pueden ver y añadir fotos/vídeos según permisos de viewer/editor. ([Immich](https://docs.immich.app/features/sharing?utm_source=chatgpt.com "Sharing"))

```text
Opción 2: Partner Sharing
→ compartes tu biblioteca entera con otro usuario
→ ese usuario puede ver tu biblioteca
```

Pero ojo: Partner Sharing es más fuerte, porque comparte toda la biblioteca no archivada/no eliminada, incluyendo metadatos como GPS. Además es unidireccional: si quieres ver la biblioteca del otro, él también tiene que compartir contigo. ([Immich](https://docs.immich.app/features/partner-sharing?utm_source=chatgpt.com "Partner Sharing"))

Yo para tu caso haría esto:

```text
Familia normal:
→ cada uno su cuenta de Immich
→ cada uno sus fotos privadas

Para compartir cosas concretas:
→ álbum compartido

Para pareja/padres si quieres compartir todo:
→ Partner Sharing, pero con cuidado

Para compartir fuera de casa:
→ enlace público con contraseña/expiración si hace falta
```

Conclusión: **sí, lo tienes prácticamente perfecto**. Solo queda pulir el logout/redirección, pero la seguridad y el uso real están bien: cada cuenta tiene sus fotos separadas, y para compartir no hace falta duplicar archivos ni descargarlos/subirlos otra vez.



Sí, yo corregiría **solo 2 cosas pequeñas** antes de darlo por cerrado:

```text
1. Pulir logout/redirección de Immich.
2. Hacer backup/snapshot final cuando quede probado.
```

Lo demás está bien.

El logout que ves no es grave: Keycloak sí cierra sesión, pero se queda en su pantalla de “You are logged out”. Para que redirija a Immich, Keycloak exige que `post_logout_redirect_uri` coincida con las URIs permitidas del cliente y que vaya con `client_id` o `id_token_hint`. ([Keycloak](https://www.keycloak.org/docs/latest/server_admin/index.html?utm_source=chatgpt.com "Server Administration Guide")) Immich documenta bien OAuth/Keycloak, pero en los ajustes normales de OAuth que tienes en pantalla no aparece un campo claro de “custom logout endpoint”, así que primero probamos si Keycloak ya redirige bien cuando se lo pedimos manualmente. ([Immich](https://docs.immich.app/administration/oauth "OAuth Authentication | Immich"))

## 1. En Keycloak, asegurar post logout de Immich

En **CT identity**, pega esto:

```bash
cat > /root/scripts/keycloak-fix-immich-logout-admin.py <<'PY'
#!/usr/bin/env python3
import json
import getpass
import urllib.parse
import urllib.request
import urllib.error

KEYCLOAK_URL = "http://10.10.10.74:8080"
ADMIN_REALM = "master"
TARGET_REALM = "homelab"
CLIENT_ID = "immich"

POST_LOGOUT_URIS = [
    "https://immich.home.arpa/*",
    "https://immich.home.arpa/auth/login",
]

def form_post(url, form):
    data = urllib.parse.urlencode(form).encode()
    req = urllib.request.Request(
        url,
        data=data,
        headers={"Content-Type": "application/x-www-form-urlencoded"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode())
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR login Keycloak HTTP {e.code}\n{detail}") from e

def request(method, url, token=None, data=None):
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
            try:
                return json.loads(raw)
            except json.JSONDecodeError:
                return raw
    except urllib.error.HTTPError as e:
        detail = e.read().decode(errors="ignore")
        raise SystemExit(f"ERROR HTTP {e.code} en {url}\n{detail}") from e

def get_admin_token():
    print("===== LOGIN ADMIN KEYCLOAK =====")
    username = input("Usuario admin Keycloak [admin-guillermo]: ").strip() or "admin-guillermo"
    password = getpass.getpass("Password admin Keycloak: ")

    res = form_post(
        f"{KEYCLOAK_URL}/realms/{ADMIN_REALM}/protocol/openid-connect/token",
        {
            "grant_type": "password",
            "client_id": "admin-cli",
            "username": username,
            "password": password,
        },
    )
    return res["access_token"]

def main():
    token = get_admin_token()

    clients = request(
        "GET",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients?clientId={urllib.parse.quote(CLIENT_ID)}",
        token=token,
    )

    if not clients:
        raise SystemExit("ERROR: no existe el cliente immich")

    client = clients[0]
    client_uuid = client["id"]

    attrs = client.get("attributes") or {}
    attrs["post.logout.redirect.uris"] = "##".join(POST_LOGOUT_URIS)
    client["attributes"] = attrs

    request(
        "PUT",
        f"{KEYCLOAK_URL}/admin/realms/{TARGET_REALM}/clients/{client_uuid}",
        token=token,
        data=client,
    )

    print()
    print("===== LOGOUT IMMICH OK =====")
    print("Valid post logout redirect URIs:")
    for uri in POST_LOGOUT_URIS:
        print(f"- {uri}")
    print()
    print("Prueba manual en navegador:")
    print("https://auth.home.arpa/realms/homelab/protocol/openid-connect/logout?client_id=immich&post_logout_redirect_uri=https%3A%2F%2Fimmich.home.arpa%2Fauth%2Flogin")

if __name__ == "__main__":
    main()
PY

chmod +x /root/scripts/keycloak-fix-immich-logout-admin.py
python3 /root/scripts/keycloak-fix-immich-logout-admin.py
```

## 2. Probar logout manual

Copia la URL que te imprime al final y pégala en el navegador:

```text
https://auth.home.arpa/realms/homelab/protocol/openid-connect/logout?client_id=immich&post_logout_redirect_uri=https%3A%2F%2Fimmich.home.arpa%2Fauth%2Flogin
```

Resultado bueno:

```text
Keycloak cierra sesión
→ vuelve a https://immich.home.arpa/auth/login
```

Si eso funciona, **Keycloak está perfecto**.

Si al pulsar logout dentro de Immich sigue quedándose en “You are logged out”, entonces el problema no es Keycloak: es que Immich no está mandando `post_logout_redirect_uri` al cerrar sesión. En ese caso yo lo dejaría así por ahora, porque es solo comodidad: sesión cerrada está cerrada.

## 3. Lo de elegir otra cuenta Google

Eso es otra cosa distinta. Aunque cierres Keycloak, Google puede seguir con una cuenta activa en el navegador. Más adelante podemos poner en Keycloak, en el proveedor Google, algo tipo:

```text
prompt=select_account
```

para que pregunte cuenta siempre. Pero no lo tocaría ahora si Immich ya entra bien.

## 4. Cuando lo pruebes, backup final

Si ya entra y sale bien, hacemos:

```bash
# En PVE
pct snapshot 109 immich-sso-ok-$(date +%F-%H%M) --description "Immich estable con OAuth Keycloak Google funcionando"
```

Y en `root@immich`:

```bash
cd /opt/stacks/immich

BACKUP_DIR="/opt/backups/immich/sso-ok-$(date +%F-%H%M)"
mkdir -p "$BACKUP_DIR"

cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml"
cp .env "$BACKUP_DIR/.env"
docker exec immich-postgres pg_dumpall -U postgres > "$BACKUP_DIR/immich-postgres-dump.sql"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' > "$BACKUP_DIR/docker-ps.txt"

ls -lh "$BACKUP_DIR"
```

Mi recomendación: probamos esa URL de logout manual. Si redirige, perfecto. Si Immich no la usa internamente, lo dejamos y hacemos backup final.



Claro, si es **VM** no se usa `pct`, se usa `qm`.

En el **host PVE**:

```bash
qm snapshot 109 immich-sso-ok-$(date +%F-%H%M) --description "Immich estable con OAuth Keycloak Google funcionando"
```

Comprobar snapshots de esa VM:

```bash
qm listsnapshot 109
```

Si quieres verificar antes que la VM 109 existe:

```bash
qm list | grep 109
```

Diferencia rápida:

```text
CT/LXC  → pct snapshot ID nombre
VM/QEMU → qm snapshot ID nombre
```

Así que para tu caso correcto:

```bash
qm snapshot 109 immich-sso-ok-$(date +%F-%H%M) --description "Immich estable con OAuth Keycloak Google funcionando"
qm listsnapshot 109
```

Y después dentro de `root@immich` haz el backup final interno también:

```bash
cd /opt/stacks/immich

BACKUP_DIR="/opt/backups/immich/sso-ok-$(date +%F-%H%M)"
mkdir -p "$BACKUP_DIR"

cp docker-compose.yml "$BACKUP_DIR/docker-compose.yml"
cp .env "$BACKUP_DIR/.env"
docker exec immich-postgres pg_dumpall -U postgres > "$BACKUP_DIR/immich-postgres-dump.sql"
docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}' > "$BACKUP_DIR/docker-ps.txt"

ls -lh "$BACKUP_DIR"
```

Con eso queda guardado por dos lados: snapshot de Proxmox + backup interno de Immich.



__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________
__________________

__________________
__________________
__________________
__________________
__________________
__________________
__________________

vamos con la musica:


## Lo que vamos a crear ahora

Hoy haría **solo esto**:

```
CT120 music - 10.10.10.82├── Navidrome├── Portainer Agent└── Acceso a música desde VM104 por NFS/bind mount
```

Y dejamos para otro día:

```
CT121 media-automation - 10.10.10.80CT122 downloads - 10.10.10.81JellyfinTransmissionRadarr/Sonarr/Lidarr
```

No merece la pena crear CTs vacíos todavía. Primero dejamos **música perfecta**.

---

# PASO 1 — Activar NFS en VM104 CasaOS/NAS

Entra por SSH a la VM104:

```
ssh guillermo@192.168.1.81
```

Primero comprobamos si NFS ya está instalado:

```
dpkg -l | grep nfs-kernel-server || echo "NFS server NO instalado"systemctl status nfs-server --no-pager || trueexportfs -v || true
```

Si sale que **no está instalado**, pega esto:

```
sudo apt updatesudo apt install -y nfs-kernel-server
```

Ahora prepara carpetas:

```
sudo mkdir -p /data/media/musicsudo mkdir -p /data/downloads/musicsudo chown -R guillermo:guillermo /data/media/music /data/downloads/musicsudo chmod -R 775 /data/media/music /data/downloads/music
```

Comparte `/data` por NFS solo al host Proxmox:

```
sudo cp /etc/exports /etc/exports.bak.$(date +%F-%H%M)cat <<'EOF' | sudo tee /etc/exports/data 192.168.1.200(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)EOFsudo exportfs -rasudo systemctl enable --now nfs-serversudo exportfs -v
```

Tiene que salir algo parecido a:

```
/data 192.168.1.200(...)
```


Sí, **exacto**, eso es lo que estábamos haciendo:

```text
VM104 CasaOS
└── /data real

PVE host
└── monta:
    192.168.1.81:/data → /mnt/casaos-data

CT120 music
└── Proxmox le pasa esa carpeta como:
    /data
```

Te lo paso otra vez ordenado. **No pegues todo en el mismo sitio**, porque cada bloque va en una máquina distinta.

---

# 1. En VM104 CasaOS/NAS

Entra por SSH:

```powershell
ssh guillermo@192.168.1.81
```

Comprueba si NFS ya está:

```bash
dpkg -l | grep nfs-kernel-server || echo "NFS server NO instalado"
systemctl status nfs-server --no-pager || true
exportfs -v || true
```

Si te dice que **NO instalado**, pega:

```bash
sudo apt update
sudo apt install -y nfs-kernel-server
```

Prepara carpetas:

```bash
sudo mkdir -p /data/media/music
sudo mkdir -p /data/downloads/music
sudo chown -R guillermo:guillermo /data/media/music /data/downloads/music
sudo chmod -R 775 /data/media/music /data/downloads/music
```

Exporta `/data` para que Proxmox pueda montarlo:

```bash
sudo cp /etc/exports /etc/exports.bak.$(date +%F-%H%M)

cat <<'EOF' | sudo tee /etc/exports
/data 192.168.1.200(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
EOF

sudo exportfs -ra
sudo systemctl enable --now nfs-server
sudo exportfs -v
```

Tiene que salir algo parecido a:

```text
/data 192.168.1.200(...)
```

---

# 2. En Proxmox PVE

Ahora ve a:

```text
pve > Shell
```

Instala cliente NFS:

```bash
apt update
apt install -y nfs-common
```

Crea el punto de montaje:

```bash
mkdir -p /mnt/casaos-data
```

Monta la carpeta de CasaOS:

```bash
mount -t nfs4 192.168.1.81:/data /mnt/casaos-data
```

Comprueba que ves los datos:

```bash
ls -la /mnt/casaos-data
ls -la /mnt/casaos-data/media
ls -la /mnt/casaos-data/media/music
```

Prueba escritura:

```bash
touch /mnt/casaos-data/media/music/test-desde-pve.txt
ls -la /mnt/casaos-data/media/music/test-desde-pve.txt
```

Ahora vuelve a la VM104 y comprueba:

```bash
ls -la /data/media/music/test-desde-pve.txt
```

Si aparece, perfecto.

Haz el montaje permanente en Proxmox:

```bash
grep -q "192.168.1.81:/data /mnt/casaos-data" /etc/fstab || cat >> /etc/fstab <<'EOF'
192.168.1.81:/data /mnt/casaos-data nfs4 rw,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60 0 0
EOF

systemctl daemon-reload
mount -a
df -h | grep casaos || true
```

---

# 3. Crear CT120 music

En Proxmox crea el CT así:

```text
CT ID: 120
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

Cuando arranque, entra al CT120 y prueba:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

---

# 4. Pasar `/data` al CT120

Ahora vuelve a:

```text
pve > Shell
```

Apaga el CT120:

```bash
pct shutdown 120 --timeout 60 || pct stop 120
```

Pásale la carpeta montada desde CasaOS:

```bash
pct set 120 -mp0 /mnt/casaos-data,mp=/data,backup=0
```

Arranca el CT:

```bash
pct start 120
```

Entra al CT120 y comprueba:

```bash
ls -la /data
ls -la /data/media/music
touch /data/media/music/test-desde-ct120.txt
ls -la /data/media/music/test-desde-ct120.txt
```

Ahora en VM104 debe aparecer también:

```bash
ls -la /data/media/music/test-desde-ct120.txt
```

Si aparece, ya está hecho:

```text
VM104: /data/media/music
PVE:   /mnt/casaos-data/media/music
CT120: /data/media/music
```

Es la misma carpeta vista desde tres sitios.

---

# 5. Resultado

Cuando metas música desde Windows en:

```text
\\192.168.1.81\data\media\music
```

Navidrome en CT120 la verá en:

```text
/data/media/music
```

Y luego dentro del contenedor Navidrome la montaremos como:

```text
/music
```

Cuando tengas hecho hasta el paso 4 y te salgan bien los `test-desde-pve.txt` y `test-desde-ct120.txt`, seguimos con Docker + Navidrome en CT120.


Vale, perfecto: **olvidamos CT120**. El CT de música será:

```text
CT 114 music - 10.10.10.82
```

La estructura queda:

```text
VM104 CasaOS
└── /data real

PVE
└── /mnt/casaos-data

CT114 music
└── /data
```

## Ahora usa estos comandos con 114

Primero deja el NFS permanente en **PVE**, si no lo hiciste aún:

```bash
grep -q "192.168.1.81:/data /mnt/casaos-data" /etc/fstab || cat >> /etc/fstab <<'EOF'
192.168.1.81:/data /mnt/casaos-data nfs4 rw,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60 0 0
EOF

systemctl daemon-reload
mount -a

findmnt /mnt/casaos-data
```

## Crear CT114 music

En Proxmox créalo así:

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

Cuando arranque, dentro del CT114 prueba red:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

## Pasar `/data` al CT114

En **PVE Shell**:

```bash
pct shutdown 114 --timeout 60 || pct stop 114
```

Añade el montaje:

```bash
pct set 114 -mp0 /mnt/casaos-data,mp=/data,backup=0
```

Arranca:

```bash
pct start 114
```

## Comprobar dentro del CT114

Entra al CT114 y pega:

```bash
ls -la /data
ls -la /data/media
ls -la /data/media/music

touch /data/media/music/test-desde-ct114.txt
ls -la /data/media/music/test-desde-ct114.txt
```

Y en CasaOS comprueba:

```bash
ls -la /data/media/music/test-desde-ct114.txt
```

Si aparece, ya está perfecto:

```text
VM104: /data/media/music
PVE:   /mnt/casaos-data/media/music
CT114: /data/media/music
```

Luego instalamos Docker + Navidrome en **CT114**.



Perfecto ✅ Eso significa que **ya está funcionando justo como queríamos**.

Lo de dentro del CT:

```text
nobody:nogroup
```

es normal en un CT unprivileged + NFS con `all_squash`. Lo importante es que en CasaOS aparece bien como:

```text
guillermo guillermo
```

Y eso ya te ha salido perfecto:

```text
CT114:  /data/media/music/test-desde-ct114.txt
VM104:  /data/media/music/test-desde-ct114.txt
```

Ahora sí: **Docker + Navidrome en CT114**.

---

## 1. Primero comprueba Internet en CT114

Dentro de `CT114 music`:

```bash
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

Si eso da OK, sigue.

---

## 2. Instalar Docker en CT114

Dentro de `CT114 music`, pega:

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

Tiene que salir Docker activo.

---

## 3. Crear Navidrome

Dentro del `CT114 music`:

```bash
mkdir -p /opt/stacks/navidrome
cd /opt/stacks/navidrome
```

Crea el compose:

```bash
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
```

Comprueba logs:

```bash
docker logs navidrome --tail=50
```

---

## 4. Abrir Navidrome

Desde el navegador, con Tailscale activo:

```text
http://10.10.10.82:4533
```

Ahí creas el usuario admin.

---

## 5. Meter música desde Windows

Desde Windows abre:

```text
\\192.168.1.81\data\media\music
```

Mete una canción o carpeta ahí.

Ejemplo:

```text
\\192.168.1.81\data\media\music\Estopa\Destrangis\01 - Vino Tinto.mp3
```

Navidrome la verá como:

```text
/music/Estopa/Destrangis/01 - Vino Tinto.mp3
```

Si no aparece al momento:

```bash
docker restart navidrome
```

---

## 6. Añadir Portainer Agent en CT114

Dentro del `CT114 music`:

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

Luego en Portainer añades:

```text
Name: CT114-music
Environment URL: tcp://10.10.10.82:9001
Tipo: Agent
```

---

## 7. Añadir a Homarr y Uptime Kuma

En Homarr:

```text
Nombre: Navidrome
URL: http://10.10.10.82:4533
Health check: HTTP
Health check URL: http://10.10.10.82:4533
```

En Uptime Kuma:

```text
Tipo: HTTP(s)
Nombre: Navidrome
URL: http://10.10.10.82:4533
```

---

## 8. Acuérdate de dejar NFS fijo en PVE

Si todavía no lo hiciste, en `pve > Shell` pega esto una vez:

```bash
grep -q "192.168.1.81:/data /mnt/casaos-data" /etc/fstab || cat >> /etc/fstab <<'EOF'
192.168.1.81:/data /mnt/casaos-data nfs4 rw,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60 0 0
EOF

systemctl daemon-reload
mount -a
findmnt /mnt/casaos-data
```

Con esto, al reiniciar Proxmox, volverá a montar CasaOS automáticamente.



Sí, exacto. Ahora para dejar **CT114 music/Navidrome** igual que los demás, faltan estos cierres:

```text
1. Proxy HTTPS con certificado:
   https://navidrome.home.arpa

2. DNS rewrite en AdGuard:
   navidrome.home.arpa → 192.168.1.82

3. Portainer Agent:
   CT114-music → tcp://10.10.10.82:9001

4. cAdvisor:
   métricas Docker para Prometheus/Grafana

5. socket-proxy:
   para que Homarr pueda ver contenedores del CT114

6. Prometheus:
   añadir 10.10.10.82:8089

7. Homarr:
   añadir Navidrome como app y añadir CT114 al widget Docker

8. Uptime Kuma:
   monitor HTTP(s)

9. Backup Proxmox:
   añadir CT114 a la tarea de backups
```

Es el mismo patrón de la Guía 3.0: los dominios `.home.arpa` apuntan al proxy `192.168.1.82`, los Proxy Hosts usan el dominio, IP real y puerto real del servicio, y luego se aplica el certificado `home-arpa-local` con Force SSL. La guía también marca que `socket-proxy` y `cAdvisor` deben integrarse en Homarr y Prometheus igual que en los demás servicios.

---

# 1. En CT114 music: instalar Portainer Agent, cAdvisor y socket-proxy

Entra en el CT114:

```bash
pct enter 114
```

O desde la consola de Proxmox del CT114.

Pega esto:

```bash
mkdir -p /opt/stacks/{portainer-agent,cadvisor,socket-proxy}
```

## Portainer Agent

```bash
cat > /opt/stacks/portainer-agent/docker-compose.yml <<'EOF'
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

cd /opt/stacks/portainer-agent
docker compose up -d
```

## cAdvisor

```bash
cat > /opt/stacks/cadvisor/docker-compose.yml <<'EOF'
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

cd /opt/stacks/cadvisor
docker compose up -d
```

## socket-proxy

```bash
cat > /opt/stacks/socket-proxy/docker-compose.yml <<'EOF'
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

cd /opt/stacks/socket-proxy
docker compose up -d
```

Comprobar:

```bash
docker ps

curl -I http://127.0.0.1:4533
curl -I http://127.0.0.1:8089
curl -s http://127.0.0.1:8089/metrics | head
curl -s http://10.10.10.82:2375/version | head
```

---

# 2. En Portainer: añadir CT114

En Portainer:

```text
Environments > Add environment > Docker Standalone > Agent
```

Datos:

```text
Name: CT114-music
Environment URL: tcp://10.10.10.82:9001
```

---

# 3. En AdGuard: DNS rewrite

En AdGuard:

```text
Filters / Filtros
→ DNS rewrites / Reescrituras DNS
→ Add DNS rewrite
```

Pon:

```text
Domain:
navidrome.home.arpa

Answer/IP:
192.168.1.82
```

Importante: apunta al **proxy**, no al CT114. Igual que el resto de `.home.arpa`.

Comprueba desde tu PC o desde PVE:

```bash
nslookup navidrome.home.arpa 192.168.1.53
```

Tiene que responder:

```text
192.168.1.82
```

---

# 4. En Nginx Proxy Manager: crear proxy host

Abre:

```text
https://npm.home.arpa
```

Ve a:

```text
Hosts > Proxy Hosts > Add Proxy Host
```

## Details

```text
Domain Names:
navidrome.home.arpa

Scheme:
http

Forward Hostname / IP:
10.10.10.82

Forward Port:
4533

Access List:
Publicly Accessible

Cache Assets:
OFF

Block Common Exploits:
ON

Websockets Support:
ON
```

## SSL

```text
SSL Certificate:
home-arpa-local

Force SSL:
ON

HTTP/2 Support:
ON

HSTS:
OFF
```

## Advanced

Déjalo vacío. Si quieres poner algo, solo esto:

```nginx
client_max_body_size 0;
```

Guarda y prueba:

```text
https://navidrome.home.arpa
```

En CT112 proxy puedes validar NPM:

```bash
docker restart nginx-proxy-manager
sleep 10
docker exec nginx-proxy-manager nginx -t
docker exec nginx-proxy-manager grep -R "navidrome.home.arpa" /data/nginx/proxy_host /data/nginx/default_host 2>/dev/null || echo "No aparece navidrome.home.arpa"
```

---

# 5. En CT105 monitoring: añadir CT114 a Prometheus

Entra en CT105:

```bash
pct enter 105
```

Pega:

```bash
cp /opt/stacks/monitoring/prometheus/prometheus.yml /opt/stacks/monitoring/prometheus/prometheus.yml.bak.$(date +%F-%H%M)

grep -q "10.10.10.82:8089" /opt/stacks/monitoring/prometheus/prometheus.yml || python3 - <<'PY'
from pathlib import Path

p = Path("/opt/stacks/monitoring/prometheus/prometheus.yml")
text = p.read_text()

block = '''
      - targets:
          - "10.10.10.82:8089"
        labels:
          host: "CT114-music"
'''

if 'job_name: "cadvisor"' not in text:
    raise SystemExit("ERROR: No encuentro job_name cadvisor en prometheus.yml. Pásame el archivo.")

# Lo añadimos al final del bloque cadvisor, antes de que termine el archivo.
text = text.rstrip() + "\n" + block + "\n"
p.write_text(text)
PY

docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
sleep 15
curl -I http://127.0.0.1:9090/-/healthy
```

Ahora abre:

```text
http://10.10.10.50:9090/targets
```

Busca:

```text
CT114-music
10.10.10.82:8089
UP
```

Si Prometheus da error de YAML, no sigas tocando: pásame el `prometheus.yml` y lo arreglamos limpio.

---

# 6. En Homarr: añadir CT114 al widget Docker

Esto depende de cómo tengas ahora el compose de `homarr-v1`, pero el patrón de la guía es añadir el host al `DOCKER_HOSTNAMES` y el puerto al `DOCKER_PORTS`. La guía indica que Homarr usa variables tipo `DOCKER_HOSTNAMES` y `DOCKER_PORTS` para ver los socket-proxy de los entornos Docker.

En CT101 dashboard:

```bash
pct enter 101
```

Ve al stack:

```bash
cd /opt/stacks/homarr-v1
cp docker-compose.yml docker-compose.yml.bak.$(date +%F-%H%M)
```

Mira qué tienes ahora:

```bash
grep -E "DOCKER_HOSTNAMES|DOCKER_PORTS" docker-compose.yml
```

Si te sale algo como:

```text
DOCKER_HOSTNAMES=10.10.10.50,10.10.10.60,...
DOCKER_PORTS=2375,2375,...
```

añade `10.10.10.82` al final de `DOCKER_HOSTNAMES` y otro `2375` al final de `DOCKER_PORTS`.

Ejemplo:

```text
DOCKER_HOSTNAMES=10.10.10.50,10.10.10.60,10.10.10.40,10.10.10.65,10.10.10.30,10.10.10.70,10.10.10.73,192.168.1.82,10.10.10.74,10.10.10.82
DOCKER_PORTS=2375,2375,2375,2375,2375,2375,2375,2375,2375,2375
```

Luego:

```bash
docker compose up -d
docker logs homarr-v1 --tail=80
```

Abre:

```text
https://homarr.home.arpa
```

Y comprueba que aparecen contenedores del CT114:

```text
navidrome
portainer-agent
cadvisor
socket-proxy
```

---

# 7. En Homarr: añadir app visual Navidrome

En Homarr añade app:

```text
Nombre:
Navidrome

URL:
https://navidrome.home.arpa

Health check:
HTTP

Health check URL:
http://10.10.10.82:4533
```

Yo usaría URL pública bonita para abrir, pero health check interno por IP/puerto.

---

# 8. En Uptime Kuma: monitor Navidrome

En Kuma:

```text
Add New Monitor
```

Pon:

```text
Tipo:
HTTP(s)

Nombre:
Navidrome

URL:
https://navidrome.home.arpa
```

Si falla por certificado local, usa como monitor interno:

```text
URL:
http://10.10.10.82:4533
```

---

# 9. Añadir CT114 al backup de Proxmox

En Proxmox:

```text
Datacenter > Backup > tu tarea diaria > Edit
```

Añade:

```text
114
```

La lista debería quedar incluyendo:

```text
100,101,102,103,104,105,106,107,108,109,110,111,112,113,114
```

Recuerda: el CT114 **no debe guardar la música en su backup**, porque `/data` va con:

```text
backup=0
```

Eso está bien. La música vive en VM104/CasaOS, no dentro del CT114.

---

## Estado final esperado

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
├── Prometheus/Grafana
│   └── CT114-music UP
├── Homarr
│   └── app + Docker containers
├── Uptime Kuma
│   └── monitor Navidrome
└── Backup Proxmox
    └── CT114 incluido, pero /data excluido
```


para que cuando se encienda el servidor tmb se encienda el ct100 el tailscale, asi  nada mas encenderlo ya tenemo,s conexino sabes?? q si se reinicia el server los ct no se encenden y perdemos la conexino  por vpn 

pct set 100 --onboot 1
pct set 100 --startup order=1,up=30

systemctl enable pve-guests.service

pct config 100 | grep -E "onboot|startup"
systemctl is-enabled pve-guests.service


¡Hola! He leído y entendido perfectamente tus archivos. Tienes la arquitectura súper bien planteada. Me encanta cómo has separado los servicios por CTs, usando la red privada `vmbr10` (`10.10.10.x`) saliendo por el Tailscale Gateway y pasando el disco real de CasaOS vía NFS (`/mnt/casaos-data` a `/data`). Es un setup muy limpio y profesional.

Entendido lo de Github: de momento nos centramos en dejar tu homelab funcionando y documentado en tu `sucio.txt` para que lo tengas tú claro.

Para cumplir tu objetivo (que **Deemix** descargue música y **Navidrome** la vea al instante sin que tengas que mover archivos a mano), la mejor estrategia es seguir tu estructura y crear el **CT de descargas**. Le pasaremos a este nuevo CT la misma ruta del NAS por NFS y le diremos a Deemix que guarde todo directamente en la carpeta de música.

Aquí tienes el paso a paso exacto para copiar y pegar:

---

### 1. Crear el CT 115 - downloads

En Proxmox, crea un contenedor nuevo con estos datos (vamos a usar la IP `10.10.10.83` para descargas):

Plaintext

```
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

Cuando arranque, entra en la consola del **CT 115 downloads** y comprueba que tiene internet:

Bash

```
ip a
ping -c 3 google.com
```

---

### 2. Pasar la carpeta de CasaOS al CT 115 (El truco de la sincronización)

Queremos que Deemix pueda escribir en `/data` igual que Navidrome. Para eso, desde el **PVE > Shell** (el host principal de Proxmox), ejecuta:

Bash

```
# Apagar el CT primero
pct shutdown 115 --timeout 60 || pct stop 115

# Pasar el montaje NFS de CasaOS al CT de descargas
pct set 115 -mp0 /mnt/casaos-data,mp=/data,backup=0

# Arrancarlo de nuevo
pct start 115
```

Para confirmar, entra en la consola del **CT 115** y comprueba que ves la música:

Bash

```
ls -la /data/media/music
```

---

### 3. Instalar Docker en el CT 115

Dentro de la consola del **CT 115 downloads**, instala Docker con tu script habitual:

Bash

```
apt update
apt install -y ca-certificates curl gnupg lsb-release nano htop git

install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
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

---

### 4. Instalar Deemix

Ahora montamos Deemix. Fíjate en el volumen: le decimos que su carpeta de `/downloads` interna sea realmente tu `/data/media/music`.

En el **CT 115 downloads**:

Bash

```
mkdir -p /opt/stacks/deemix/config
cd /opt/stacks/deemix

cat > docker-compose.yml <<'EOF'
services:
  deemix:
    image: registry.gitlab.com/bockiii/deemix-docker:latest
    container_name: deemix
    restart: unless-stopped
    ports:
      - "6595:6595"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Madrid
    volumes:
      - /opt/stacks/deemix/config:/config
      - /data/media/music:/downloads
EOF

docker compose up -d
docker ps
```

---

### 5. Añadir el Portainer Agent (Para seguir tu estándar)

En el mismo **CT 115 downloads**, instala el agente para poder verlo desde tu CT102 de Portainer:

Bash

```
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
```

_Luego ve a Portainer y añade el entorno como siempre: `Name: CT115-downloads` -> `URL: tcp://10.10.10.83:9001`._

---

### 6. Configurar Deemix y ver la magia

1. Conéctate a Deemix desde tu navegador con Tailscale activo: `http://10.10.10.83:6595`
    
2. En los **Ajustes (Settings)** de Deemix, necesitas poner tu ARL (tu token de inicio de sesión de Deezer).
    
3. Ve a la configuración de descarga en Deemix y asegúrate de que la ruta de descargas (Download Path) es `/downloads`.
    
4. Descarga cualquier álbum o canción.
    

**¿Qué va a pasar?**

Deemix descargará la música dentro de su carpeta `/downloads`, la cual está enlazada directamente a `/data/media/music` (que físicamente es el NFS de tu VM104 CasaOS). Como Navidrome (en el CT 114) está escaneando constantemente esa misma carpeta `/data/media/music`, ¡la canción aparecerá automáticamente en tu interfaz de Navidrome a los pocos minutos de descargarse! Todo 100% automatizado sin tener que mover un solo archivo.





Vale, sí. Vamos a limpiar **solo los `beszel-agent` que están mal**, sin tocar el **Beszel Hub** del CT105.

Desde **Proxmox > pve > Shell**, pega primero esto para ver qué hay:

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

Ahora borra **solo el agent** de los que están en rojo:

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

**Importante:** en el CT105 esto **no borra el panel Beszel**, solo borra el `beszel-agent`. El hub debería seguir vivo.

Comprueba CT105:

```bash
pct exec 105 -- bash -lc 'docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}" | grep -i beszel'
```

Lo normal sería ver algo tipo:

```text
beszel       henrygd/beszel       Up...
```

Si aparece solo `beszel` o `beszel-hub`, perfecto. Si aparece todavía `beszel-agent`, lo quitamos a mano.

Después entra en **Beszel** y borra las entradas rojas:

```text
CT101-dashboard
CT105-monitoring
CT114-Music
CT115-downloads
```

Luego las vuelves a añadir desde:

```text
Beszel > + Agregar Sistema
```

Y el compose que te dé Beszel lo pegas en **Portainer**, pero en el environment correcto:

```text
CT101-dashboard  → stack beszel-agent
CT105-monitoring → stack beszel-agent
CT114-music      → stack beszel-agent
CT115-downloads  → stack beszel-agent
```

No metas el agent de CT101 dentro de CT105 ni al revés. Cada stack en su environment.


es mas facil abrir beszel y conectarlos con el yml para portainer que es copiar y peegar en un nuevo stack en cada CT o VM
y para los que falle pues pones esto en vez el copia y pega y si ya exixtia pues haces esto: docker rm -f beszel-agent  que habiamos creado alguno por consola por error:


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
      KEY: 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJeeqAA7ghNT2vMIC8zS5gbZyzJt8sOSvXtED/DFa59Y'
      TOKEN: 11771e-65f6fc25-11167-31ff311a7
      HUB_URL: http://10.10.10.50:8090

volumes:
  beszel_agent_data:



_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________


_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
__________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

______________________________________________________________________________________________________________________________________________________________________________________________________________________________________________

_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
_______________________________________________________________________________________________________________________
____________________________________________________________________________________









Perfecto, vamos **manual y tranquilo**. Empezamos solo con **Nextcloud**, porque es menos delicado que Vaultwarden.

Tu guía ya tiene `auth.home.arpa` como Keycloak, realm `homelab`, y ya tienes SSO funcionando en Grafana/Homarr/Immich; Immich quedó con issuer `https://auth.home.arpa/realms/homelab`, client `immich` y botón `Login with Google`. La idea ahora es copiar ese modelo para Nextcloud.

Nextcloud recomienda usar la app **OpenID Connect user backend** para autenticar usuarios contra proveedores OIDC externos, como Keycloak. ([Nextcloud](https://docs.nextcloud.com/server/stable/admin_manual/configuration_user/user_auth_oidc.html "User authentication with OpenID Connect — Nextcloud latest Administration Manual latest documentation")) Keycloak, por su parte, publica la configuración OIDC del realm en el endpoint `/.well-known/openid-configuration`, que en tu caso será el del realm `homelab`. ([Keycloak](https://www.keycloak.org/securing-apps/oidc-layers "Securing applications and services with OpenID Connect - Keycloak"))

---

# 1. Antes de tocar nada: snapshot

En **PVE > Shell** pega:

```bash
pct snapshot 108 pre-nextcloud-sso-$(date +%F-%H%M)
pct snapshot 113 pre-nextcloud-client-$(date +%F-%H%M)
```

Así si algo sale mal, volvemos atrás.

---

# 2. Crear client manual en Keycloak

Abre Keycloak:

```text
https://auth.home.arpa
```

Entra con tu admin y ve al realm:

```text
homelab
```

Luego:

```text
Clients
→ Create client
```

Rellena así.

## Pantalla 1

```text
Client type: OpenID Connect
Client ID: nextcloud
Name: Nextcloud
Description: Nextcloud SSO
```

Dale a:

```text
Next
```

## Pantalla 2

Activa/deja así:

```text
Client authentication: ON
Authorization: OFF
Authentication flow:
  Standard flow: ON
  Direct access grants: OFF
  Implicit flow: OFF
  Service accounts roles: OFF
```

Dale a:

```text
Next
```

## Pantalla 3

Pon exactamente:

```text
Root URL:
https://nextcloud.home.arpa

Home URL:
https://nextcloud.home.arpa

Valid redirect URIs:
https://nextcloud.home.arpa/*

Valid post logout redirect URIs:
https://nextcloud.home.arpa/*

Web origins:
https://nextcloud.home.arpa
```

Guarda con:

```text
Save
```

---

# 3. Copiar el client secret

Dentro del client `nextcloud`, entra en:

```text
Credentials
```

Copia el valor de:

```text
Client secret
```

No me lo pegues aquí. Guárdalo temporalmente en un bloc de notas o en Vaultwarden.

---


No, **ahí no**.

Esa pantalla de **“Clientes OAuth 2.0”** es para lo contrario:

```text
Apps externas → piden acceso a Nextcloud
```

Nosotros queremos esto:

```text
Nextcloud → usa Keycloak/Google para iniciar sesión
```

Así que necesitas ir a la **app de OpenID Connect**, no a “Clientes OAuth 2.0”.

Haz esto:

```text
Arriba a la izquierda, icono de tu usuario / menú
→ Aplicaciones / Apps
→ Buscar
→ OpenID Connect user backend
→ Instalar / Activar
```

Puede salir con alguno de estos nombres:

```text
OpenID Connect user backend
user_oidc
```

Después de instalarla, vuelve a:

```text
Ajustes de administración
```

y debería aparecer una sección nueva tipo:

```text
OpenID Connect
```

o

```text
Inicio de sesión OpenID Connect
```

Ahí es donde meteremos:

```text
Client ID: nextcloud
Client Secret: el de Keycloak
Discovery URL: https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
Scope: openid email profile
```

Si no encuentras la app desde la web, la instalamos rápido desde Proxmox con esto:

```bash
pct exec 108 -- bash -lc '
docker exec -u www-data nextcloud php occ app:install user_oidc || true
docker exec -u www-data nextcloud php occ app:enable user_oidc
'
```



Sí, **así está casi perfecto**, pero hay **2 detalles importantes** antes de darle a **Enviar**.

Primero: has pegado aquí el **client secret**. No pasa nada para seguir, pero cuando terminemos y funcione, **regeneramos ese secret en Keycloak** y lo cambias en Nextcloud. Así queda limpio.

Ahora revisa esto:

## 1. En Keycloak, el redirect tiene que permitir esta URL

Nextcloud te está diciendo que el callback real es:

```text
https://nextcloud.home.arpa/apps/user_oidc/code
```

En Keycloak, en el client `nextcloud`, deja en **Valid redirect URIs**:

```text
https://nextcloud.home.arpa/apps/user_oidc/code
https://nextcloud.home.arpa/*
```

Con el wildcard ya debería valer, pero mejor deja también la URL exacta.

---

## 2. En Nextcloud deja los campos así

Lo que tienes está bien:

```text
Identificador:
keycloak

ID de cliente:
nextcloud

Secreto de cliente:
el secret de Keycloak

Endpoint para descubrimiento:
https://auth.home.arpa/realms/homelab/.well-known/openid-configuration

Ámbito:
openid email profile
```

En **Mapeado de IDs de usuarios**, puedes dejar:

```text
sub
```

Eso está bien para evitar conflictos con tu usuario local `guillermo`. Más adelante, si queremos nombres más bonitos, lo cambiamos, pero para la primera prueba yo lo dejaría en `sub`.

En **Concesiones adicionales**, si de verdad está escrito:

```text
claim1 claim2 claim3
```

bórralo y déjalo vacío.

Los demás campos tipo:

```text
Mapeado de cuotas: quota
Mapeado de grupos: groups
```

pueden quedarse así.

---

## 3. Dale a Enviar

Dale a:

```text
Enviar
```

Después debería aparecer en:

```text
Proveedores registrados
```

algo como:

```text
keycloak / Login with Google / nextcloud
```

---

## 4. Prueba en incógnito

No cierres tu sesión actual.

Abre una ventana de incógnito y entra:

```text
https://nextcloud.home.arpa
```

Debería aparecer el login normal y también el botón OIDC/Keycloak.

Pulsa el botón y el flujo debería ser:

```text
Nextcloud → Keycloak → Google → Nextcloud
```

---

## 5. Luego regeneramos el secret

Cuando funcione, hacemos esto:

```text
Keycloak → Clients → nextcloud → Credentials → Regenerate secret
```

Copias el nuevo y lo actualizas en Nextcloud. Así el secret que se ha pegado aquí queda invalidado.

Vale, esto confirma algo importante:

```text
Desde tu navegador SÍ se abre el discovery de Keycloak.
Desde Nextcloud NO lo puede alcanzar.
```

O sea, **Keycloak está bien**. El problema está en que el **CT108/Nextcloud no resuelve o no llega a `auth.home.arpa`**.

Y sí: el error exacto es este:

```text
The discovery endpoint is not reachable
```

Casi seguro es **DNS dentro del CT108**, porque Nextcloud está en red privada y seguramente sigue usando `1.1.1.1`, que no sabe resolver dominios `.home.arpa`.

---

## 1. Arreglar DNS del CT108 Nextcloud

En **PVE > Shell**, pega esto:

```bash
pct set 108 --nameserver 192.168.1.53 --searchdomain home.arpa

pct exec 108 -- bash -lc '
cat > /etc/resolv.conf <<EOF
search home.arpa
nameserver 192.168.1.53
nameserver 1.1.1.1
EOF

echo "===== DNS CT108 ====="
cat /etc/resolv.conf

echo "===== Resolver auth.home.arpa desde CT108 ====="
getent hosts auth.home.arpa || true
'
```

Tiene que salir algo tipo:

```text
192.168.1.82 auth.home.arpa
```

o la IP donde tengas el proxy/Keycloak publicado.

---

## 2. Reiniciar solo el contenedor Nextcloud

Ahora reinicia Nextcloud para que Docker coja bien DNS:

```bash
pct exec 108 -- bash -lc '
cd /opt/stacks/nextcloud
docker compose restart nextcloud
sleep 10

echo "===== Resolver auth.home.arpa desde contenedor nextcloud ====="
docker exec nextcloud getent hosts auth.home.arpa || true
'
```

También debería resolver.

---

## 3. Probar el discovery desde CT108

Pega:

```bash
pct exec 108 -- bash -lc '
apt update >/dev/null 2>&1
apt install -y curl >/dev/null 2>&1

echo "===== Discovery desde CT108 ====="
curl -k -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
'
```

Lo bueno sería ver:

```text
HTTP/2 200
```

o:

```text
HTTP/1.1 200 OK
```

---

## 4. Vuelve a Nextcloud y pulsa Enviar otra vez

Antes de enviar, deja así:

```text
Endpoint para descubrimiento:
https://auth.home.arpa/realms/homelab/.well-known/openid-configuration

Ámbito:
openid email profile

Concesiones adicionales:
VACÍO
```

Y dale a:

```text
Enviar
```

---

## 5. Importante sobre el secret

Has pegado el secret en el chat. Para seguir probando no pasa nada, pero cuando funcione hacemos esto:

```text
Keycloak → Clients → nextcloud → Credentials → Regenerate secret
```

Luego actualizas ese nuevo secret en Nextcloud. Así el secret pegado queda invalidado.

Primero arreglamos el DNS y probamos de nuevo.




con esto ya si funcinonó:
Perfecto, ya está clarísimo:

```text
DNS dentro del contenedor: OK
Con -k: OK
Sin -k: falla por certificado self-signed
```

O sea, **no es Keycloak ni el client**. Es solo que el contenedor de Nextcloud **no confía en el certificado de `auth.home.arpa`**.

Vamos a arreglarlo.

## 1. Primero prueba el ajuste correcto de la app

Antes lo pusimos como config del sistema, pero esta app suele leerlo como config de app. En **PVE > Shell** pega:

```bash
pct exec 108 -- bash -lc '
docker exec -u www-data nextcloud php occ config:app:set user_oidc httpclient.allowselfsigned --value=true
docker exec -u www-data nextcloud php occ config:app:get user_oidc httpclient.allowselfsigned

cd /opt/stacks/nextcloud
docker compose restart nextcloud
'
```

Espera 15-20 segundos y vuelve a darle a **Enviar** en Nextcloud.

Si funciona, perfecto.

---

## 2. Si sigue fallando, mete el certificado dentro del contenedor

Como ya hemos confirmado que `curl -k` funciona y `curl` normal falla, esta es la solución directa.

En **PVE > Shell** pega:

```bash
pct exec 108 -- bash -lc '
docker exec -u root nextcloud bash -lc "
apt-get update >/dev/null
apt-get install -y ca-certificates openssl curl >/dev/null

echo | openssl s_client -showcerts -connect auth.home.arpa:443 -servername auth.home.arpa 2>/dev/null \
  | sed -ne \"/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p\" \
  > /usr/local/share/ca-certificates/home-arpa-auth.crt

update-ca-certificates

echo \"===== Prueba SIN -k después de importar certificado =====\"
curl -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
"

cd /opt/stacks/nextcloud
docker compose restart nextcloud
'
```

Tiene que acabar con algo como:

```text
HTTP/1.1 200 OK
```

---

## 3. Vuelve a Nextcloud y dale a Enviar

Antes revisa:

```text
Endpoint para descubrimiento:
https://auth.home.arpa/realms/homelab/.well-known/openid-configuration

Ámbito:
openid email profile

Concesiones adicionales:
vacío

Mapeado de IDs de usuarios:
sub
```

Y dale a:

```text
Enviar
```

---

## 4. Si ahora registra el proveedor

Abre incógnito:

```text
https://nextcloud.home.arpa
```

Prueba el botón de OpenID/Keycloak.

Si te sale error de `redirect_uri`, entonces falta esto en Keycloak:

```text
Client nextcloud
→ Settings
→ Valid redirect URIs:

https://nextcloud.home.arpa/apps/user_oidc/code
https://nextcloud.home.arpa/*
```

Primero haz el bloque 1. Si no funciona, haz el bloque 2.



Vamos. Para Vaultwarden vamos **manual en Keycloak** y **sin forzar SSO_ONLY**. Así no te quedas fuera del gestor de contraseñas.

La guía actual tiene Vaultwarden en **CT106**, IP `10.10.10.60`, usando **Tailscale Serve HTTPS** con `https://vaultwarden.tailfcb362.ts.net`, y con `DOMAIN` ya configurado hacia ese dominio. Además, Vaultwarden ahora soporta SSO por OpenID Connect con variables como `SSO_ENABLED`, `SSO_ONLY`, `SSO_AUTHORITY`, `SSO_CLIENT_ID` y `SSO_CLIENT_SECRET`; su plantilla indica que `SSO_AUTHORITY` no debe llevar `/.well-known/openid-configuration` ni barra final.

---

## 1. Snapshot antes de tocar Vaultwarden

En **PVE > Shell**:

```
pct snapshot 106 pre-vaultwarden-sso-$(date +%F-%H%M)pct snapshot 113 pre-vaultwarden-client-$(date +%F-%H%M)
```

---

## 2. Crear client manual en Keycloak

Entra en:

```
https://auth.home.arpa
```

Realm:

```
homelab
```

Ve a:

```
Clients → Create client
```

### Pantalla 1

```
Client type: OpenID ConnectClient ID: vaultwardenName: Vaultwarden
```

### Pantalla 2

Déjalo así:

```
Client authentication: ONAuthorization: OFFAuthentication flow:Standard flow: ONDirect access grants: OFFImplicit flow: OFFService accounts roles: OFF
```

### Pantalla 3

Aquí es lo importante. Pon:

```
Root URL:https://vaultwarden.tailfcb362.ts.netHome URL:https://vaultwarden.tailfcb362.ts.netValid redirect URIs:https://vaultwarden.tailfcb362.ts.net/identity/connect/oidc-signinhttps://vaultwarden.tailfcb362.ts.net/*Valid post logout redirect URIs:https://vaultwarden.tailfcb362.ts.net/*Web origins:https://vaultwarden.tailfcb362.ts.net
```

Guarda.

Vaultwarden usa un callback con este formato:

```
https://TU_DOMINIO/identity/connect/oidc-signin
```

Authelia documenta exactamente ese patrón de redirect URI para Vaultwarden, derivado de la URL raíz de la app.

---

## 3. Copiar el client secret

Dentro del client `vaultwarden`:

```
Credentials → Client secret
```

Cópialo, pero **no lo pegues aquí**.





Vale, no pasa nada. Se ha roto el `docker-compose.yml` porque el bloque se pegó raro/truncado, y Vaultwarden ahora está arrancando con `SSO_ENABLED=true` pero **sin leer bien** estas 3 variables:

```text
SSO_CLIENT_ID
SSO_CLIENT_SECRET
SSO_AUTHORITY
```

Lo arreglamos reescribiendo el compose limpio.

Además: has pegado el secret en el chat. Cuando funcione, **regeneramos el secret en Keycloak** igual que hicimos con Nextcloud.

## 1. Reparar Vaultwarden

En **PVE > Shell**, pega este bloque. Cuando te pida el secret, pégalo ahí y pulsa Enter. **No lo metas dentro del comando.**

```bash
pct exec 106 -- bash -lc '
cd /opt/stacks/vaultwarden || exit 1

echo "===== Backup del compose roto ====="
cp docker-compose.yml docker-compose.yml.bak.fix-sso-$(date +%F-%H%M)

echo "===== Recuperando ADMIN_TOKEN existente ====="
ADMIN_TOKEN="$(grep -E "^[[:space:]]*-[[:space:]]*ADMIN_TOKEN=" docker-compose.yml 2>/dev/null | tail -n1 | sed "s/.*ADMIN_TOKEN=//")"

if [ -z "$ADMIN_TOKEN" ]; then
  for f in $(ls -t docker-compose.yml.bak* 2>/dev/null); do
    ADMIN_TOKEN="$(grep -E "^[[:space:]]*-[[:space:]]*ADMIN_TOKEN=" "$f" 2>/dev/null | tail -n1 | sed "s/.*ADMIN_TOKEN=//")"
    [ -n "$ADMIN_TOKEN" ] && break
  done
fi

if [ -z "$ADMIN_TOKEN" ]; then
  echo "ERROR: No he podido recuperar ADMIN_TOKEN. Paro para no romper el panel admin."
  exit 1
fi

echo "Pega ahora el CLIENT SECRET nuevo/actual de Keycloak para vaultwarden y pulsa Enter:"
read -s VW_CLIENT_SECRET

if [ -z "$VW_CLIENT_SECRET" ]; then
  echo "ERROR: El client secret está vacío."
  exit 1
fi

cat > docker-compose.yml <<EOF
services:
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - TZ=Europe/Madrid
      - DOMAIN=https://vaultwarden.tailfcb362.ts.net
      - SIGNUPS_ALLOWED=false
      - INVITATIONS_ALLOWED=false
      - WEBSOCKET_ENABLED=true
      - ADMIN_TOKEN=$ADMIN_TOKEN
      - SSO_ENABLED=true
      - SSO_ONLY=false
      - SSO_AUTHORITY=https://auth.home.arpa/realms/homelab
      - SSO_SCOPES=openid email profile offline_access
      - SSO_PKCE=true
      - SSO_CLIENT_ID=vaultwarden
      - SSO_CLIENT_SECRET=$VW_CLIENT_SECRET
      - SSO_SIGNUPS_MATCH_EMAIL=true
      - SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION=false
      - SSO_CLIENT_CACHE_EXPIRATION=600
    volumes:
      - /opt/stacks/vaultwarden/data:/data
EOF

echo "===== Variables sensibles ocultas ====="
grep -E "DOMAIN=|SSO_|SIGNUPS_ALLOWED|ADMIN_TOKEN" docker-compose.yml \
  | sed -E "s/(ADMIN_TOKEN=).+/\1********/; s/(SSO_CLIENT_SECRET=).+/\1********/"

echo "===== Reiniciando Vaultwarden ====="
docker compose up -d

sleep 8

echo "===== Estado ====="
docker ps --filter name=vaultwarden

echo "===== Logs ====="
docker logs vaultwarden --tail=80
'
```

---

## 2. Qué tiene que pasar

Ya no debería salir:

```text
SSO_CLIENT_ID, SSO_CLIENT_SECRET and SSO_AUTHORITY must be set
```

Si sale algo de certificado, será el mismo problema que Nextcloud con `auth.home.arpa`, y lo arreglamos después.

---

## 3. Probar web

Cuando el contenedor quede `Up`, abre:

```text
https://vaultwarden.tailfcb362.ts.net
```

Debe seguir funcionando el login normal, y debería aparecer opción de SSO.

Recuerda: en Vaultwarden **no ponemos** todavía:

```text
SSO_ONLY=true
```

Lo dejamos en:

```text
SSO_ONLY=false
```

Así no te quedas fuera.




root@pve:~# pct exec 106 -- bash -lc '
cd /opt/stacks/vaultwarden || exit 1

cp docker-compose.yml docker-compose.yml.bak.fix-internal-auth-$(date +%F-%H%M)

python3 
from pathlib import Path

p = Path("docker-compose.yml")
text = p.read_text()

# Quitar variables previas si existían
remove_prefixes = [
    "      - HTTP_REQUEST_BLOCK_NON_GLOBAL_IPS=",
    "      - HTTP_REQUEST_BLOCK_REGEX=",
    "      - SSL_CERT_FILE=",
]
lines = []
for line in text.splitlines():
    if any(line.startswith(prefix) for prefix in remove_prefixes):
        continue
    lines.append(line)

docker compose up -dLIENT_SECRET=).+/\1********/"T_FILE" docker-compose.yml 
===== Compose relevante =====
    image: vaultwarden/server:latest
      - DOMAIN=https://vaultwarden.tailfcb362.ts.net
      - SSO_ENABLED=true
      - SSO_ONLY=false
      - SSO_AUTHORITY=https://auth.home.arpa/realms/homelab
      - SSO_SCOPES=openid email profile offline_access
      - SSO_PKCE=true
      - SSO_CLIENT_ID=vaultwarden
      - SSO_CLIENT_SECRET=********
      - SSO_SIGNUPS_MATCH_EMAIL=true
      - SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION=false
      - SSO_CLIENT_CACHE_EXPIRATION=600
      - HTTP_REQUEST_BLOCK_NON_GLOBAL_IPS=false
      - HTTP_REQUEST_BLOCK_REGEX=
      - SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
[+] up 1/1
 ✔ Container vaultwarden Started                                        0.9s
root@pve:~# pct exec 106 -- bash -lc '
docker exec -u root vaultwarden bash -lc "
apt-get update >/dev/null
apt-get install -y ca-certificates openssl curl >/dev/null

echo | openssl s_client -showcerts -connect auth.home.arpa:443 -servername auth.home.arpa 2>/dev/null \
  | sed -ne \"/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p\" \ 
  > /usr/local/share/ca-certificates/home-arpa-auth.crt

update-ca-certificates

echo \"===== Discovery sin -k =====\"
curl -I --max-time 10 https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
"

docker restart vaultwarden
sleep 8

echo "===== Logs recientes ====="
docker logs vaultwarden --tail=60
'
Updating certificates in /etc/ssl/certs...
rehash: warning: skipping ca-certificates.crt, it does not contain exactly one certificate or CRL
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.
===== Discovery sin -k =====
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--      0     0    0     0    0     0     HTTP/1.1 200 OK
Server: openresty
Date: Wed, 13 May 2026 11:04:55 GMT
Content-Type: application/json
Connection: keep-alive
Cache-Control: no-cache, must-revalidate, no-transform, no-store
Referrer-Policy: no-referrer
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Robots-Tag: none
X-Served-By: auth.home.arpa

 0      0 --:--:-- --:--:-- --:--:--     0
vaultwarden
===== Logs recientes =====
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.36.0                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/

[NOTICE] You are using a plain text `ADMIN_TOKEN` which is insecure.
Please generate a secure Argon2 PHC string by using `vaultwarden hash` or `argon2`.
See: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page#secure-the-admin_token

[2026-05-13 13:04:37.999][start][INFO] Rocket has launched from http://0.0.0.0:80
[2026-05-13 13:04:56.012][vaultwarden][INFO] Received SIGTERM, initiating graceful shutdown
[2026-05-13 13:04:56.015][vaultwarden][INFO] Vaultwarden process exited!
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.36.0                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/

[NOTICE] You are using a plain text `ADMIN_TOKEN` which is insecure.
Please generate a secure Argon2 PHC string by using `vaultwarden hash` or `argon2`.
See: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page#secure-the-admin_token

[2026-05-13 13:04:56.810][start][INFO] Rocket has launched from http://0.0.0.0:80
root@pve:~# pct exec 106 -- bash -lc '
docker logs vaultwarden --since=3m
'
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.36.0                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/

[NOTICE] You are using a plain text `ADMIN_TOKEN` which is insecure.
Please generate a secure Argon2 PHC string by using `vaultwarden hash` or `argon2`.
See: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page#secure-the-admin_token

[2026-05-13 13:04:37.999][start][INFO] Rocket has launched from http://0.0.0.0:80
[2026-05-13 13:04:56.012][vaultwarden][INFO] Received SIGTERM, initiating graceful shutdown
[2026-05-13 13:04:56.015][vaultwarden][INFO] Vaultwarden process exited!
/--------------------------------------------------------------------\
|                        Starting Vaultwarden                        |
|                           Version 1.36.0                           |
|--------------------------------------------------------------------|
| This is an *unofficial* Bitwarden implementation, DO NOT use the   |
| official channels to report bugs/features, regardless of client.   |
| Send usage/configuration questions or feature requests to:         |
|   https://github.com/dani-garcia/vaultwarden/discussions or        |
|   https://vaultwarden.discourse.group/                             |
| Report suspected bugs/issues in the software itself at:            |
|   https://github.com/dani-garcia/vaultwarden/issues/new            |
\--------------------------------------------------------------------/

[NOTICE] You are using a plain text `ADMIN_TOKEN` which is insecure.
Please generate a secure Argon2 PHC string by using `vaultwarden hash` or `argon2`.
See: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-admin-page#secure-the-admin_token

[2026-05-13 13:04:56.810][start][INFO] Rocket has launched from http://0.0.0.0:80
[2026-05-13 13:05:21.417][request][INFO] GET /api/config
[2026-05-13 13:05:21.417][response][INFO] (config) GET /api/config => 200 OK
[2026-05-13 13:05:45.744][request][INFO] POST /api/organizations/domain/sso/verified
[2026-05-13 13:05:45.744][response][INFO] (get_org_domain_sso_verified) POST /api/organizations/domain/sso/verified => 200 OK
[2026-05-13 13:05:45.768][request][INFO] GET /identity/sso/prevalidate?domainHint=00000000-01DC-01DC-
[2026-05-13 13:05:45.775][response][INFO] (prevalidate) GET /identity/sso/prevalidate => 200 OK
[2026-05-13 13:05:45.817][request][INFO] GET /identity/connect/authorize?client_id=web&redirect_uri=htt
[2026-05-13 13:05:45.829][vaultwarden::sso_client][ERROR] Failed to discover OpenID provider: Request failed
[2026-05-13 13:05:45.829][response][INFO] (authorize) GET /identity/connect/authorize?<data..> => 400 Bad Request
[2026-05-13 13:06:07.609][request][INFO] POST /identity/accounts/prelogin/password
[2026-05-13 13:06:07.614][response][INFO] (prelogin_password) POST /identity/accounts/prelogin/password => 200 OK
[2026-05-13 13:06:07.616][request][INFO] GET /api/devices/knowndevice
[2026-05-13 13:06:07.619][response][INFO] (get_known_device) GET /api/devices/knowndevice => 200 OK
[2026-05-13 13:06:17.468][request][INFO] POST /identity/connect/token
[2026-05-13 13:06:17.812][vaultwarden::api::identity][INFO] User Guillermo logged in successfully. IP: 172.18.0.1
[2026-05-13 13:06:17.813][response][INFO] (login) POST /identity/connect/token => 200 OK
[2026-05-13 13:06:17.867][request][INFO] GET /api/sync?excludeDomains=true
[2026-05-13 13:06:17.869][request][INFO] GET /api/config
[2026-05-13 13:06:17.870][response][INFO] (config) GET /api/config => 200 OK
[2026-05-13 13:06:17.903][response][INFO] (sync) GET /api/sync?<data..> => 200 OK
[2026-05-13 13:06:17.923][request][INFO] GET /notifications/hub?access_token=eyJ0eXAiOiJKV1QiL
[2026-05-13 13:06:17.923][vaultwarden::api::notifications][INFO] Accepting Rocket WS connection from 172.18.0.1
[2026-05-13 13:06:17.924][response][INFO] (websockets_hub) GET /notifications/hub?<data..> => 200 OK
[2026-05-13 13:06:18.108][request][INFO] GET /api/accounts/profile
[2026-05-13 13:06:18.110][response][INFO] (profile) GET /api/accounts/profile => 200 OK
[2026-05-13 13:06:21.624][request][INFO] GET /api/accounts/revision-date
[2026-05-13 13:06:21.625][request][INFO] GET /api/accounts/revision-date
[2026-05-13 13:06:21.627][request][INFO] GET /api/auth-requests/pending
[2026-05-13 13:06:21.628][response][INFO] (revision_date) GET /api/accounts/revision-date => 200 OK
[2026-05-13 13:06:21.628][request][INFO] GET /api/accounts/profile
[2026-05-13 13:06:21.632][response][INFO] (revision_date) GET /api/accounts/revision-date => 200 OK
[2026-05-13 13:06:21.636][response][INFO] (profile) GET /api/accounts/profile => 200 OK
[2026-05-13 13:06:21.639][response][INFO] (get_auth_requests_pending) GET /api/auth-requests/pending => 200 OK
[2026-05-13 13:06:21.741][request][INFO] GET /icons/40develophelp.zendesk.com/icon.png
[2026-05-13 13:06:21.744][vaultwarden::api::icons][WARN] Blocked address: 40develophelp.zendesk.com
[2026-05-13 13:06:21.744][response][INFO] (icon_internal) GET /icons/<host>/icon.png => 200 OK
[2026-05-13 13:06:21.744][request][INFO] GET /icons/127.0.0.1/icon.png
[2026-05-13 13:06:21.744][vaultwarden::api::icons][WARN] Blocked address: 127.0.0.1
[2026-05-13 13:06:21.744][response][INFO] (icon_internal) GET /icons/<host>/icon.png => 200 OK
[2026-05-13 13:06:21.749][request][INFO] GET /icons/192.168.1.79/icon.png
[2026-05-13 13:06:21.749][vaultwarden::api::icons][WARN] Blocked address: 192.168.1.79
[2026-05-13 13:06:21.750][response][INFO] (icon_internal) GET /icons/<host>/icon.png => 200 OK
[2026-05-13 13:06:21.750][request][INFO] GET /icons/192.168.1.200/icon.png
[2026-05-13 13:06:21.751][vaultwarden::api::icons][WARN] Blocked address: 192.168.1.200
[2026-05-13 13:06:21.751][response][INFO] (icon_internal) GET /icons/<host>/icon.png => 200 OK
[2026-05-13 13:06:21.752][request][INFO] GET /icons/account.battle.net/icon.png
[2026-05-13 13:06:21.752][vaultwarden::api::icons][WARN] Blocked address: account.battle.net
[2026-05-13 13:06:21.752][response][INFO] (icon_internal) GET /icons/<host>/icon.png => 200 OK
[2026-05-13 13:06:23.777][vaultwarden::api::notifications][INFO] Closing WS connection from 172.18.0.1
root@pve:~# 







Vale, lo dejamos **abierto**. Como está detrás de Tailscale y es familiar, es aceptable para tu caso, aunque no sea lo más estricto.

Hazlo así para dejarlo abierto pero controlado:

```text
✅ Registros abiertos
❌ Invitaciones abiertas a cualquiera: no
✅ Solo tú puedes crear organizaciones
✅ Tu madre y tu hermano pueden registrarse cuando quieran
```

Vaultwarden tiene variables para esto: `SIGNUPS_ALLOWED`, `INVITATIONS_ALLOWED` y `ORG_CREATION_USERS`. Además, avisa que si cambias cosas desde el panel admin, pueden quedar guardadas en `data/config.json` y pisar variables del compose. ([GitHub](https://raw.githubusercontent.com/dani-garcia/vaultwarden/main/.env.template?utm_source=chatgpt.com "https://raw.githubusercontent.com/dani-garcia/vaul..."))

## 1. Dejar registros abiertos

En **PVE > Shell**, pega esto cambiando `TU_EMAIL_ADMIN` por tu email real de Vaultwarden:

```bash
pct exec 106 -- bash -lc '
cd /opt/stacks/vaultwarden || exit 1

ADMIN_EMAIL="TU_EMAIL_ADMIN"

cp docker-compose.yml docker-compose.yml.bak.signups-open-family-$(date +%F-%H%M)

python3 - <<PY
from pathlib import Path

admin = "'"$ADMIN_EMAIL"'"
p = Path("docker-compose.yml")
text = p.read_text()

remove = [
    "      - SIGNUPS_ALLOWED=",
    "      - INVITATIONS_ALLOWED=",
    "      - ORG_CREATION_USERS=",
]

lines = []
for line in text.splitlines():
    if any(line.startswith(x) for x in remove):
        continue
    lines.append(line)

text = "\n".join(lines)

insert = f"""      - SIGNUPS_ALLOWED=true
      - INVITATIONS_ALLOWED=false
      - ORG_CREATION_USERS={admin}"""

text = text.replace("      - DOMAIN=https://vaultwarden.tailfcb362.ts.net",
                    "      - DOMAIN=https://vaultwarden.tailfcb362.ts.net\n" + insert,
                    1)

p.write_text(text + "\n")
PY

if [ -f data/config.json ]; then
  cp data/config.json data/config.json.bak.signups-open-family-$(date +%F-%H%M)

  python3 - <<PY
import json
from pathlib import Path

admin = "'"$ADMIN_EMAIL"'"
p = Path("data/config.json")

try:
    cfg = json.loads(p.read_text())
except Exception:
    cfg = {}

cfg["signups_allowed"] = True
cfg["invitations_allowed"] = False
cfg["org_creation_users"] = admin

p.write_text(json.dumps(cfg, indent=2, sort_keys=True) + "\n")
PY
fi

docker compose up -d
sleep 5

echo "===== Compose ====="
grep -E "SIGNUPS_ALLOWED|INVITATIONS_ALLOWED|ORG_CREATION_USERS" docker-compose.yml

echo
echo "===== Config.json ====="
grep -E "signups_allowed|invitations_allowed|org_creation_users" data/config.json 2>/dev/null || true
'
```

Con esto, tu madre y tu hermano podrán entrar a:

```text
https://vaultwarden.tailfcb362.ts.net
```

y darle a:

```text
Crear cuenta
```

---

# 2. Cómo compartir contraseñas

En Vaultwarden **no se comparte desde tu caja fuerte personal directamente**. Se comparte mediante una **Organización** y **Colecciones**.

La idea es:

```text
Tu caja fuerte personal
├── Tus contraseñas privadas
└── No las ve nadie

Organización Familia
├── Colección Streaming
│   ├── Netflix
│   ├── Disney+
│   └── Prime Video
├── Colección Casa
│   ├── WiFi
│   └── Router
└── Colección Servidor
    ├── Proxmox
    └── Homarr
```

Las organizaciones permiten compartir credenciales con otros miembros, y las colecciones sirven para controlar qué grupo de contraseñas ve cada persona. ([MassiveGRID](https://www.massivegrid.com/blog/self-host-vaultwarden-ubuntu-vps/?utm_source=chatgpt.com "Self-Host Vaultwarden (Bitwarden) on Ubuntu VPS"))

## 3. Crear la organización “Familia”

Entra con tu cuenta en Vaultwarden:

```text
https://vaultwarden.tailfcb362.ts.net
```

Busca algo tipo:

```text
Organizaciones
→ Nueva organización
```

Pon:

```text
Nombre:
Familia

Email de facturación:
tu email
```

Si pregunta tipo/plan, elige lo básico/self-hosted que te deje.

---

## 4. Crear colecciones

Dentro de la organización `Familia`, crea colecciones:

```text
Streaming
Casa
Familia
Servidor
```

Yo empezaría con estas:

```text
Streaming → cuentas compartidas de Netflix, Disney, Spotify, etc.
Casa      → WiFi, router, domótica
Familia   → cosas comunes
Servidor  → solo para ti, no para tu madre/hermano
```

---

## 5. Invitar a tu madre y hermano

Primero que ellos creen su cuenta normal.

Luego tú vas a:

```text
Organización Familia
→ Miembros
→ Invitar miembro
```

Pones su email exacto.

Permisos recomendados:

```text
Tu madre:
Tipo: Usuario
Colecciones: Streaming, Casa, Familia

Tu hermano:
Tipo: Usuario
Colecciones: Streaming, Casa, Familia

Tú:
Tipo: Propietario / Owner
Colecciones: todas
```

Sin SMTP, Vaultwarden puede aceptar invitaciones en organizaciones directamente después de invitar, aunque se sigue usando email como identificador de login. ([GitHub](https://github.com/dani-garcia/vaultwarden/discussions/2471?utm_source=chatgpt.com "adding users without email #2471 - dani-garcia vaultwarden")) También se puede invitar desde `Organization → Members → Invite User`, y luego usar carpetas/colecciones compartidas. ([vaultwarden.discourse.group](https://vaultwarden.discourse.group/t/adding-a-user-to-a-self-hosted-instance/3521?utm_source=chatgpt.com "Adding a User to a Self Hosted Instance - Help"))

---

## 6. Compartir una contraseña concreta

Para compartir, por ejemplo Netflix:

```text
Añadir elemento
→ Tipo: Login
→ Nombre: Netflix
→ Usuario/email
→ Contraseña
→ Organización: Familia
→ Colección: Streaming
→ Guardar
```

Si ya tienes una contraseña en tu caja personal:

```text
Abrir elemento
→ Menú / opciones
→ Mover a organización
→ Familia
→ Colección Streaming
```

Ojo: al moverlo a la organización, deja de ser solo tuyo y pasa a estar compartido con quien tenga acceso a esa colección.

---

## 7. Regla simple para no liarte

Usa esto:

```text
Privado tuyo → Caja fuerte personal
Compartido familiar → Organización Familia
```

Y dentro de `Familia`:

```text
Streaming → todos
Casa → todos
Servidor → solo tú
```

Así tu madre no ve cosas del servidor, pero sí Netflix/WiFi/cuentas familiares.



