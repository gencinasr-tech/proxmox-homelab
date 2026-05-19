# CT115 - Downloads / Music Downloader

## Descripción General

**CT115 Downloads** es un contenedor LXC dedicado a la descarga de música legal hacia el servidor Navidrome. Utiliza Deemix Docker para descargar música directamente en `/data/media/music`, la misma ruta que lee Navidrome desde CT114.

### Arquitectura de Almacenamiento Compartido

```
VM104 CasaOS (NAS)
└── /data/media/music (NFS export)
    ├── CT114 music (mount point: /data)
    │   └── Navidrome lee música
    └── CT115 downloads (mount point: /data)
        └── Deemix descarga música
```

### Información del Contenedor

| Parámetro | Valor |
|-----------|-------|
| **ID** | 115 |
| **Hostname** | downloads |
| **OS** | Debian 13 (Trixie) |
| **Tipo** | LXC Unprivileged |
| **IP Privada** | 10.10.10.83/24 |
| **Gateway** | 10.10.10.87 (CT100 Tailscale) |
| **DNS** | 1.1.1.1 |
| **vCPU** | 2 cores |
| **RAM** | 2048 MB |
| **Swap** | 1024 MB |
| **Disco** | 12 GB |
| **Bridge** | vmbr10 (Red Privada) |

### Servicios Desplegados

| Servicio | Puerto | Acceso |
|----------|--------|--------|
| **Deemix** | 6595 | http://10.10.10.83:6595 |
| **Portainer Agent** | 9001 | tcp://10.10.10.83:9001 |
| **cAdvisor** | 8089 | http://10.10.10.83:8089 |
| **socket-proxy** | 2375 | tcp://10.10.10.83:2375 |
| **Beszel Agent** | 45876 | Conecta a CT105 |

### Acceso Web

- **Directo**: http://10.10.10.83:6595
- **Dominio (opcional)**: https://downloads.home.arpa

---

## Tabla de Contenidos

1. [Prerequisitos](#prerequisitos)
2. [Creación del Contenedor](#creación-del-contenedor)
3. [Configuración de Red](#configuración-de-red)
4. [Montaje de Almacenamiento NFS](#montaje-de-almacenamiento-nfs)
5. [Instalación de Docker](#instalación-de-docker)
6. [Deemix Music Downloader](#deemix-music-downloader)
7. [Portainer Agent](#portainer-agent)
8. [cAdvisor para Prometheus](#cadvisor-para-prometheus)
9. [Socket Proxy para Homarr](#socket-proxy-para-homarr)
10. [Beszel Agent](#beszel-agent)
11. [DNS y Proxy Reverso](#dns-y-proxy-reverso)
12. [Integración con Monitorización](#integración-con-monitorización)
13. [Backups](#backups)
14. [Troubleshooting](#troubleshooting)

---

## Prerequisitos

### Servicios Requeridos

Antes de instalar CT115, asegúrate de tener:

- ✅ **VM104 CasaOS** funcionando con NFS export en `/data`
- ✅ **CT114 Music** con Navidrome leyendo `/data/media/music`
- ✅ **CT100 Tailscale** como gateway (10.10.10.87)
- ✅ **CT103 DNS** (AdGuard Home) en 192.168.1.53
- ✅ **CT112 Proxy** (Nginx Proxy Manager) en 192.168.1.82
- ✅ **CT102 Portainer** en 192.168.1.81
- ✅ **CT105 Monitoring** con Prometheus/Grafana

### Verificación de NFS

Desde el host Proxmox:

```bash
showmount -e 192.168.1.84
```

Debe mostrar:

```
Export list for 192.168.1.84:
/data *
```

---

## Creación del Contenedor

### 1. Crear CT115 desde Proxmox Web UI

En Proxmox Web UI:

```
Datacenter > pve > Create CT
```

**General:**
```
CT ID: 115
Hostname: downloads
Unprivileged container: ✓
Nesting: ✓
Start at boot: ✓
```

**Template:**
```
Storage: local
Template: debian-13-standard_13.0-1_amd64.tar.zst
```

**Disks:**
```
Storage: local-lvm
Disk size: 12 GB
```

**CPU:**
```
Cores: 2
```

**Memory:**
```
Memory (MiB): 2048
Swap (MiB): 1024
```

**Network:**
```
Bridge: vmbr10
IPv4/CIDR: 10.10.10.83/24
Gateway (IPv4): 10.10.10.87
IPv6: SLAAC (o dejar vacío)
```

**DNS:**
```
DNS domain: (dejar vacío)
DNS servers: 1.1.1.1
```

### 2. Iniciar el Contenedor

```bash
pct start 115
```

### 3. Acceder al Contenedor

```bash
pct enter 115
```

---

## Configuración de Red

### 1. Verificar Conectividad

Dentro del CT115:

```bash
# Verificar IP asignada
ip addr show eth0

# Verificar gateway
ip route

# Ping al gateway Tailscale
ping -c 3 10.10.10.87

# Ping a Internet
ping -c 3 1.1.1.1
ping -c 3 google.com

# Verificar DNS
nslookup google.com
```

### 2. Configurar Hostname

```bash
hostnamectl set-hostname downloads
echo "downloads" > /etc/hostname
```

### 3. Actualizar Sistema

```bash
apt update && apt upgrade -y
```

---

## Montaje de Almacenamiento NFS

### 1. Detener el Contenedor

Desde el host Proxmox (`pve > Shell`):

```bash
pct shutdown 115 --timeout 60
```

Si no se detiene:

```bash
pct stop 115
```

### 2. Montar `/data` desde VM104

```bash
pct set 115 -mp0 /mnt/casaos-data,mp=/data,backup=0
```

**Explicación:**
- `-mp0`: Mount point 0
- `/mnt/casaos-data`: Ruta en el host Proxmox (NFS mount de VM104)
- `mp=/data`: Ruta dentro del CT115
- `backup=0`: Excluir del backup (la música vive en VM104)

### 3. Iniciar el Contenedor

```bash
pct start 115
```

### 4. Verificar Montaje

Dentro del CT115:

```bash
pct enter 115

# Verificar que /data está montado
df -h | grep /data
ls -la /data
ls -la /data/media/music

# Crear archivo de prueba
touch /data/media/music/test-desde-ct115.txt
ls -la /data/media/music/test-desde-ct115.txt
```

### 5. Verificar desde VM104

Desde VM104 CasaOS:

```bash
ls -la /data/media/music/test-desde-ct115.txt
```

Debe aparecer el archivo creado desde CT115.

### 6. Limpiar Archivo de Prueba

```bash
rm /data/media/music/test-desde-ct115.txt
```

---

## Instalación de Docker

### 1. Instalar Dependencias

Dentro del CT115:

```bash
apt update
apt install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  nano \
  htop \
  git
```

### 2. Añadir Repositorio de Docker

```bash
# Crear directorio para keyrings
install -m 0755 -d /etc/apt/keyrings

# Descargar GPG key de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Dar permisos de lectura
chmod a+r /etc/apt/keyrings/docker.gpg

# Añadir repositorio
cat > /etc/apt/sources.list.d/docker.sources <<'EOF'
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: trixie
Components: stable
Signed-By: /etc/apt/keyrings/docker.gpg
EOF
```

### 3. Instalar Docker

```bash
apt update
apt install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

### 4. Habilitar y Verificar Docker

```bash
# Habilitar Docker al inicio
systemctl enable --now docker

# Verificar versión
docker version
docker compose version

# Verificar estado
systemctl status docker
```

**Salida esperada:**

```
Docker version 27.x.x
Docker Compose version v2.x.x
● docker.service - Docker Application Container Engine
     Loaded: loaded
     Active: active (running)
```

---

## Deemix Music Downloader

### 1. Crear Directorio del Stack

```bash
mkdir -p /opt/stacks/music-downloader/config
cd /opt/stacks/music-downloader
```

### 2. Crear docker-compose.yml

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
```

**Explicación de Volúmenes:**
- `/config`: Configuración de Deemix
- `/downloads`: Mapea a `/data/media/music` (compartido con Navidrome)

### 3. Iniciar el Servicio

```bash
docker compose up -d
```

### 4. Verificar Estado

```bash
docker ps
docker logs music-downloader
```

### 5. Acceder a Deemix

Abrir en navegador:

```
http://10.10.10.83:6595
```

### 6. Configurar Ruta de Descarga

En la interfaz web de Deemix:

```
Settings > Download path: /downloads
```

**Importante:** La ruta `/downloads` dentro del contenedor equivale a `/data/media/music` en el host, que es la misma ruta que lee Navidrome desde CT114.

### 7. Configuración Recomendada

**Download Settings:**
```
Download path: /downloads
Create folder structure: ✓
Folder structure: %artist%/%album%/
File format: %artist% - %title%
```

**Quality Settings:**
```
Preferred quality: FLAC (si está disponible)
Fallback quality: MP3 320kbps
```

### 8. Verificar Descarga

Después de descargar música:

```bash
# Desde CT115
ls -la /data/media/music/

# Desde CT114 (Navidrome)
pct enter 114
ls -la /data/media/music/
```

La música debe aparecer en ambos contenedores.

### 9. Escanear en Navidrome

Acceder a Navidrome:

```
https://navidrome.home.arpa
```

Ir a:

```
Settings > Scan Library Now
```

La nueva música aparecerá automáticamente.

---

## Portainer Agent

### 1. Crear Stack de Portainer Agent

```bash
mkdir -p /opt/stacks/portainer-agent
cd /opt/stacks/portainer-agent
```

### 2. Crear docker-compose.yml

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

### 3. Iniciar el Servicio

```bash
docker compose up -d
```

### 4. Verificar Estado

```bash
docker ps | grep portainer-agent
docker logs portainer-agent
```

### 5. Añadir a Portainer

Acceder a Portainer:

```
https://portainer.home.arpa
```

Ir a:

```
Environments > Add environment
```

**Configuración:**
```
Name: CT115-downloads
Environment URL: tcp://10.10.10.83:9001
Environment type: Docker Standalone
```

Click en **Connect**.

### 6. Verificar Conexión

En Portainer, el environment **CT115-downloads** debe aparecer en verde con el estado **Connected**.

---

## cAdvisor para Prometheus

### 1. Crear Stack de cAdvisor

```bash
mkdir -p /opt/stacks/cadvisor
cd /opt/stacks/cadvisor
```

### 2. Crear docker-compose.yml

```bash
cat > docker-compose.yml <<'EOF'
services:
  cadvisor:
    image: ghcr.io/google/cadvisor:v0.56.2
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
```

### 3. Iniciar el Servicio

```bash
docker compose up -d
```

### 4. Verificar Métricas

```bash
curl -s http://127.0.0.1:8089/metrics | head -20
```

### 5. Añadir a Prometheus

Acceder a CT105:

```bash
pct enter 105
cd /opt/stacks/monitoring
nano prometheus.yml
```

Buscar el job `cadvisor` y añadir CT115:

```yaml
  - job_name: 'cadvisor'
    static_configs:
      - targets:
          - "10.10.10.50:8089"
        labels:
          host: "CT101-dashboard"
      - targets:
          - "10.10.10.50:8090"
        labels:
          host: "CT105-monitoring"
      - targets:
          - "10.10.10.82:8089"
        labels:
          host: "CT114-music"
      - targets:
          - "10.10.10.83:8089"
        labels:
          host: "CT115-downloads"
```

### 6. Validar y Reiniciar Prometheus

```bash
docker exec prometheus promtool check config /etc/prometheus/prometheus.yml
docker restart prometheus
```

### 7. Verificar en Grafana

Acceder a Grafana:

```
https://grafana.home.arpa
```

Ir al dashboard **Docker Containers** y verificar que aparecen las métricas de **CT115-downloads**.

---

## Socket Proxy para Homarr

### 1. Crear Stack de socket-proxy

```bash
mkdir -p /opt/stacks/socket-proxy
cd /opt/stacks/socket-proxy
```

### 2. Crear docker-compose.yml

```bash
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
```

### 3. Iniciar el Servicio

```bash
docker compose up -d
```

### 4. Verificar Conexión

```bash
curl -s http://10.10.10.83:2375/version | jq
```

### 5. Añadir a Homarr

Acceder a CT101:

```bash
pct enter 101
cd /opt/stacks/homarr
nano docker-compose.yml
```

Buscar la sección de variables de entorno de Homarr y actualizar:

```yaml
    environment:
      # ... otras variables ...
      - DOCKER_HOSTNAMES=10.10.10.50,10.10.10.82,10.10.10.83
      - DOCKER_PORTS=2375,2375,2375
```

### 6. Reiniciar Homarr

```bash
docker restart homarr
```

### 7. Verificar en Homarr

Acceder a Homarr:

```
https://homarr.home.arpa
```

En el widget de Docker, deben aparecer los contenedores de **CT115-downloads**.

---

## Beszel Agent

### 1. Acceder a Beszel Hub

Abrir en navegador:

```
http://10.10.10.50:8090
```

### 2. Crear Sistema en Beszel

```
Beszel > + Add System
```

**Configuración:**
```
Name: CT115-downloads
Host: 10.10.10.83
Port: 45876
```

Beszel generará un comando Docker Compose con una KEY única.

### 3. Copiar el Compose Generado

Beszel mostrará algo como:

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
      KEY: 'ssh-ed25519 AAAAC3...'
      TOKEN: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'
      HUB_URL: http://10.10.10.50:8090

volumes:
  beszel_agent_data:
```

### 4. Crear Stack en Portainer

Acceder a Portainer:

```
https://portainer.home.arpa
```

Ir a:

```
Environments > CT115-downloads > Stacks > Add stack
```

**Configuración:**
```
Name: beszel-agent
Build method: Web editor
```

Pegar el compose generado por Beszel.

Click en **Deploy the stack**.

### 5. Verificar Estado

En Beszel Hub, el sistema **CT115-downloads** debe aparecer en verde con métricas de CPU, RAM y disco.

---

## DNS y Proxy Reverso

### 1. Configurar DNS Rewrite en AdGuard

Acceder a AdGuard Home:

```
https://adguard.home.arpa
```

Ir a:

```
Filters > DNS rewrites > Add DNS rewrite
```

**Configuración:**
```
Domain: downloads.home.arpa
Answer/IP: 192.168.1.82
```

### 2. Verificar DNS

Desde cualquier máquina en la red:

```bash
nslookup downloads.home.arpa 192.168.1.53
```

Debe responder:

```
Name:   downloads.home.arpa
Address: 192.168.1.82
```

### 3. Configurar Proxy en Nginx Proxy Manager

Acceder a Nginx Proxy Manager:

```
https://proxy.home.arpa
```

Ir a:

```
Hosts > Proxy Hosts > Add Proxy Host
```

**Details:**
```
Domain Names: downloads.home.arpa
Scheme: http
Forward Hostname / IP: 10.10.10.83
Forward Port: 6595
Cache Assets: ✓
Block Common Exploits: ✓
Websockets Support: ✓
Access List: Publicly Accessible
```

**SSL:**
```
SSL Certificate: home-arpa-local
Force SSL: ✓
HTTP/2 Support: ✓
HSTS Enabled: ✗
HSTS Subdomains: ✗
```

**Advanced (opcional):**
```nginx
# Aumentar timeout para descargas largas
proxy_read_timeout 3600s;
proxy_connect_timeout 3600s;
proxy_send_timeout 3600s;
```

Click en **Save**.

### 4. Verificar Acceso

Abrir en navegador:

```
https://downloads.home.arpa
```

Debe cargar la interfaz de Deemix con certificado SSL válido.

---

## Integración con Monitorización

### 1. Añadir a Homarr

Acceder a Homarr:

```
https://homarr.home.arpa
```

**Añadir App:**
```
Nombre: Downloads
URL: https://downloads.home.arpa
Icono: mdi:download
Health check: HTTP
Health check URL: http://10.10.10.83:6595
```

### 2. Añadir a Uptime Kuma

Acceder a Uptime Kuma:

```
https://kuma.home.arpa
```

**Crear Monitor:**
```
Monitor Type: HTTP(s)
Friendly Name: Downloads
URL: http://10.10.10.83:6595
Heartbeat Interval: 60 seconds
Retries: 3
```

Si falla por certificado autofirmado, usar la URL directa sin HTTPS.

### 3. Verificar en Grafana

Acceder a Grafana:

```
https://grafana.home.arpa
```

Ir al dashboard **Docker Containers** y verificar:

- CPU usage de `music-downloader`
- Memory usage de `music-downloader`
- Network I/O durante descargas

---

## Backups

### 1. Añadir CT115 a Backup Schedule

Acceder a Proxmox Web UI:

```
Datacenter > Backup
```

Editar la tarea de backup diaria y añadir **115** a la lista de VMs/CTs.

**Lista actualizada:**
```
100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115
```

### 2. Configuración de Backup

**Importante:**
- El backup incluye el sistema y la configuración de CT115
- `/data` está excluido (`backup=0`) porque la música vive en VM104
- La música se respalda con el backup de VM104 CasaOS

### 3. Verificar Configuración

```bash
pct config 115 | grep mp0
```

Debe mostrar:

```
mp0: /mnt/casaos-data,mp=/data,backup=0
```

### 4. Backup Manual (Opcional)

Para hacer un backup manual:

```bash
vzdump 115 --mode snapshot --compress zstd --storage local
```

---

## Troubleshooting

### Problema: No se puede acceder a Deemix

**Síntomas:**
```
curl: (7) Failed to connect to 10.10.10.83 port 6595
```

**Solución:**

```bash
# Verificar que el contenedor está corriendo
docker ps | grep music-downloader

# Ver logs
docker logs music-downloader

# Reiniciar si es necesario
cd /opt/stacks/music-downloader
docker compose restart

# Verificar puerto
ss -tlnp | grep 6595
```

---

### Problema: La música no aparece en Navidrome

**Síntomas:**
- Música descargada en CT115
- No aparece en Navidrome (CT114)

**Solución:**

```bash
# Verificar que /data está montado en ambos CTs
pct enter 115
ls -la /data/media/music/

pct enter 114
ls -la /data/media/music/

# Verificar permisos
ls -la /data/media/music/ | head

# Forzar escaneo en Navidrome
# Acceder a https://navidrome.home.arpa
# Settings > Scan Library Now
```

---

### Problema: Permisos de escritura en /data

**Síntomas:**
```
Permission denied: /downloads
```

**Solución:**

```bash
# Desde VM104 CasaOS
chown -R 1000:1000 /data/media/music
chmod -R 755 /data/media/music

# Verificar desde CT115
pct enter 115
touch /data/media/music/test.txt
rm /data/media/music/test.txt
```

---

### Problema: Deemix no puede descargar

**Síntomas:**
- Error al intentar descargar música
- "ARL token invalid"

**Solución:**

Deemix requiere un ARL token válido de Deezer. Este token debe obtenerse de una cuenta Deezer válida.

**Pasos:**
1. Acceder a Deemix: http://10.10.10.83:6595
2. Ir a Settings
3. Pegar el ARL token en el campo correspondiente
4. Guardar configuración

**Nota:** No se documentan tokens reales por seguridad.

---

### Problema: Portainer Agent no conecta

**Síntomas:**
```
Error: Unable to connect to the Docker environment
```

**Solución:**

```bash
# Verificar que el agent está corriendo
docker ps | grep portainer-agent

# Ver logs
docker logs portainer-agent

# Verificar puerto
ss -tlnp | grep 9001

# Reiniciar agent
cd /opt/stacks/portainer-agent
docker compose restart

# Verificar conectividad desde Portainer
# Desde CT102
curl -v http://10.10.10.83:9001
```

---

### Problema: cAdvisor no reporta métricas

**Síntomas:**
- cAdvisor corriendo pero sin métricas en Grafana

**Solución:**

```bash
# Verificar métricas localmente
curl -s http://127.0.0.1:8089/metrics | grep container_

# Verificar configuración de Prometheus
pct enter 105
cd /opt/stacks/monitoring
cat prometheus.yml | grep -A 5 "10.10.10.83"

# Verificar targets en Prometheus
# Acceder a http://10.10.10.50:9090/targets
# Buscar CT115-downloads

# Reiniciar Prometheus si es necesario
docker restart prometheus
```

---

### Problema: Socket Proxy no responde

**Síntomas:**
```
curl: (7) Failed to connect to 10.10.10.83 port 2375
```

**Solución:**

```bash
# Verificar contenedor
docker ps | grep socket-proxy

# Ver logs
docker logs socket-proxy

# Verificar puerto
ss -tlnp | grep 2375

# Reiniciar
cd /opt/stacks/socket-proxy
docker compose restart

# Verificar desde Homarr
# Desde CT101
curl -s http://10.10.10.83:2375/version | jq
```

---

### Problema: Beszel Agent desconectado

**Síntomas:**
- Agent aparece en rojo en Beszel Hub

**Solución:**

```bash
# Verificar contenedor
docker ps | grep beszel-agent

# Ver logs
docker logs beszel-agent

# Verificar variables de entorno
docker inspect beszel-agent | grep -A 10 Env

# Recrear agent con nueva KEY desde Beszel Hub
# 1. Eliminar sistema en Beszel Hub
# 2. Crear nuevo sistema
# 3. Copiar nuevo compose
# 4. Actualizar stack en Portainer
```

---

### Problema: Disco lleno en CT115

**Síntomas:**
```
No space left on device
```

**Solución:**

```bash
# Verificar uso de disco
df -h

# Limpiar imágenes Docker no usadas
docker system prune -a

# Limpiar logs de Docker
truncate -s 0 /var/lib/docker/containers/*/*-json.log

# Si /data está lleno, limpiar desde VM104
# La música vive en VM104, no en CT115
```

---

### Problema: Descargas muy lentas

**Síntomas:**
- Descargas de música extremadamente lentas

**Solución:**

```bash
# Verificar uso de CPU/RAM
htop

# Verificar uso de red
iftop

# Verificar I/O de disco
iotop

# Aumentar recursos si es necesario
# Desde Proxmox Web UI:
# CT115 > Resources > Edit
# Aumentar CPU cores o RAM
```

---

### Problema: No se puede acceder por dominio

**Síntomas:**
```
downloads.home.arpa no resuelve
```

**Solución:**

```bash
# Verificar DNS
nslookup downloads.home.arpa 192.168.1.53

# Verificar DNS rewrite en AdGuard
# Acceder a https://adguard.home.arpa
# Filters > DNS rewrites
# Debe existir: downloads.home.arpa -> 192.168.1.82

# Verificar proxy en Nginx Proxy Manager
# Acceder a https://proxy.home.arpa
# Hosts > Proxy Hosts
# Debe existir: downloads.home.arpa -> 10.10.10.83:6595

# Limpiar caché DNS local
ipconfig /flushdns  # Windows
sudo systemd-resolve --flush-caches  # Linux
```

---

## Comandos Útiles

### Gestión del Contenedor

```bash
# Iniciar CT115
pct start 115

# Detener CT115
pct shutdown 115 --timeout 60

# Forzar detención
pct stop 115

# Acceder a CT115
pct enter 115

# Ver configuración
pct config 115

# Ver uso de recursos
pct status 115
```

### Gestión de Docker

```bash
# Ver todos los contenedores
docker ps -a

# Ver logs de un contenedor
docker logs -f music-downloader

# Reiniciar un contenedor
docker restart music-downloader

# Ver uso de recursos
docker stats

# Limpiar sistema
docker system prune -a
```

### Verificación de Servicios

```bash
# Verificar todos los puertos
ss -tlnp

# Verificar servicio específico
curl -I http://10.10.10.83:6595

# Verificar montaje NFS
df -h | grep /data

# Verificar permisos
ls -la /data/media/music/
```

### Monitorización

```bash
# Ver uso de CPU/RAM
htop

# Ver uso de disco
df -h

# Ver uso de red
iftop

# Ver I/O de disco
iotop

# Ver logs del sistema
journalctl -f
```

---

## Resumen de Configuración

### Estado Final de CT115

```
CT115 downloads - 10.10.10.83
├── Deemix Music Downloader
│   ├── Directo: http://10.10.10.83:6595
│   └── Dominio: https://downloads.home.arpa
├── /data montado desde VM104 CasaOS
│   └── /data/media/music (compartido con CT114)
├── Portainer Agent
│   └── tcp://10.10.10.83:9001
├── cAdvisor
│   └── http://10.10.10.83:8089
├── socket-proxy
│   └── tcp://10.10.10.83:2375
├── Beszel Agent
│   └── Conecta a http://10.10.10.50:8090
├── Prometheus/Grafana
│   └── CT115-downloads monitoreado
├── Homarr
│   └── App + Docker containers
├── Uptime Kuma
│   └── Monitor Downloads
└── Backup Proxmox
    └── CT115 incluido, /data excluido
```

### Arquitectura Completa Music + Downloads

```
VM104 CasaOS (192.168.1.84)
└── /data/media/music (NFS export)
    │
    ├── CT114 music (10.10.10.82)
    │   └── Navidrome
    │       ├── Lee música desde /data/media/music
    │       └── https://navidrome.home.arpa
    │
    └── CT115 downloads (10.10.10.83)
        └── Deemix
            ├── Descarga música a /data/media/music
            └── https://downloads.home.arpa
```

### Flujo de Trabajo

1. **Descargar música** en CT115 (Deemix)
2. **Música guardada** en `/data/media/music` (VM104 NFS)
3. **Escanear biblioteca** en Navidrome (CT114)
4. **Reproducir música** desde cualquier cliente Subsonic

---

## Próximos Pasos

Con CT115 completado, el homelab tiene:

- ✅ **14 LXC Containers** funcionando
- ✅ **2 VMs** (CasaOS + Immich)
- ✅ **Monitorización completa** (Prometheus, Grafana, Uptime Kuma, Beszel)
- ✅ **Gestión centralizada** (Portainer, Homarr)
- ✅ **SSO/Identity Provider** (Keycloak)
- ✅ **Servicios de productividad** (Vaultwarden, Paperless, Nextcloud, Immich)
- ✅ **Servicios multimedia** (Navidrome + Deemix)

**Documentación relacionada:**
- [CT114 Music/Navidrome](ct114-music.md)
- [VM104 CasaOS](../06-storage-backup/vm104-casaos.md)
- [CT105 Monitoring](../05-management/ct105-monitoring.md)
- [CT102 Portainer](../05-management/ct102-portainer.md)

---

## Referencias

- [Deemix Docker](https://gitlab.com/Bockiii/deemix-docker)
- [Navidrome](https://www.navidrome.org/)
- [Portainer Agent](https://docs.portainer.io/admin/environments/add/docker/agent)
- [cAdvisor](https://github.com/google/cadvisor)
- [Beszel](https://github.com/henrygd/beszel)
