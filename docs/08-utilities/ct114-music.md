# CT114 - Navidrome (Music Server)

Servidor de música personal con streaming, compatible con clientes Subsonic/Airsonic.

## 📋 Información del Contenedor

- **ID:** CT114
- **Hostname:** music
- **IP Privada:** 10.10.10.82
- **OS:** Debian 13
- **Recursos:** 1 CPU, 1GB RAM, 12GB disco
- **Red:** vmbr10 (Red Privada)
- **Gateway:** 10.10.10.87
- **Almacenamiento:** NFS desde VM104 CasaOS

## 🎯 Propósito

Navidrome proporciona:
- 🎵 Servidor de música personal
- 📱 Streaming a cualquier dispositivo
- 🎧 Compatible con clientes Subsonic/Airsonic
- 📊 Scrobbling a Last.fm
- 🎨 Descarga automática de carátulas
- 📻 Radio y listas inteligentes
- 👥 Múltiples usuarios con bibliotecas separadas
- 🌐 Acceso web y apps móviles

## 🔒 Seguridad

- **Criticidad:** MEDIA
- **Acceso:** HTTPS vía proxy (https://navidrome.home.arpa)
- **Almacenamiento:** Música en VM104 vía NFS (no se pierde si se borra el CT)

---

## 📁 Arquitectura de Almacenamiento

La música NO se guarda dentro del CT114, sino en VM104 CasaOS/NAS:

```
VM104 CasaOS/NAS
└── /data/media/music          (almacenamiento real)

Proxmox Host (PVE)
└── /mnt/casaos-data/media/music  (montaje NFS)

CT114 Music
└── /data/media/music          (bind mount desde PVE)

Navidrome Container
└── /music                     (volumen desde CT)
```

**Ventajas:**
- ✅ La música persiste aunque se borre el CT
- ✅ Accesible desde Windows vía Samba
- ✅ Backups centralizados en VM104
- ✅ Fácil de gestionar archivos

---

## 🧱 Instalación Paso a Paso

### 1. Configurar NFS en VM104 CasaOS

**Acceder a VM104:**

```bash
ssh guillermo@192.168.1.81
```

**Instalar NFS Server:**

```bash
# Verificar si ya está instalado
dpkg -l | grep nfs-kernel-server

# Si no está, instalar
sudo apt update
sudo apt install -y nfs-kernel-server
```

**Crear Directorios:**

```bash
sudo mkdir -p /data/media/music
sudo mkdir -p /data/downloads/music

sudo chown -R guillermo:guillermo /data/media/music /data/downloads/music
sudo chmod -R 775 /data/media/music /data/downloads/music
```

**Configurar Exportación NFS:**

```bash
# Backup de configuración actual
sudo cp /etc/exports /etc/exports.bak.$(date +%F-%H%M)

# Configurar exportación (solo para Proxmox host)
cat <<'EOF' | sudo tee /etc/exports
/data 192.168.1.200(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
EOF

# Aplicar cambios
sudo exportfs -ra
sudo systemctl enable --now nfs-server

# Verificar
sudo exportfs -v
```

**Salida esperada:**
```
/data 192.168.1.200(rw,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
```

### 2. Montar NFS en Proxmox Host

**Desde el host Proxmox (no desde ningún CT):**

```bash
# Instalar cliente NFS
apt update
apt install -y nfs-common

# Crear punto de montaje
mkdir -p /mnt/casaos-data

# Montar NFS
mount -t nfs4 192.168.1.81:/data /mnt/casaos-data

# Verificar
ls -la /mnt/casaos-data
ls -la /mnt/casaos-data/media
ls -la /mnt/casaos-data/media/music
```

**Prueba de escritura:**

```bash
touch /mnt/casaos-data/media/music/test-desde-pve.txt
ls -la /mnt/casaos-data/media/music/test-desde-pve.txt
```

**Verificar en VM104:**

```bash
# Desde VM104
ls -la /data/media/music/test-desde-pve.txt
```

**Hacer montaje permanente:**

```bash
# Añadir a fstab
grep -q "192.168.1.81:/data /mnt/casaos-data" /etc/fstab || cat >> /etc/fstab <<'EOF'
192.168.1.81:/data /mnt/casaos-data nfs4 rw,_netdev,nofail,x-systemd.automount,x-systemd.idle-timeout=60 0 0
EOF

# Recargar systemd
systemctl daemon-reload

# Montar todo
mount -a

# Verificar
findmnt /mnt/casaos-data
```

### 3. Crear el Contenedor CT114

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
CT ID: 114
Hostname: music
Template: debian-13-standard
Disco: 12 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Red: vmbr10
IP: 10.10.10.82/24
Gateway: 10.10.10.87
DNS: 192.168.1.53
Opciones: Unprivileged + Nesting habilitado
Start at boot: ✅ ON
```

### 4. Pasar /data al CT114

**Desde el host Proxmox:**

```bash
# Detener el CT
pct shutdown 114 --timeout 60 || pct stop 114

# Añadir bind mount (backup=0 para no incluir en backups del CT)
pct set 114 -mp0 /mnt/casaos-data,mp=/data,backup=0

# Iniciar el CT
pct start 114
```

**Verificar dentro del CT:**

```bash
pct enter 114

ls -la /data
ls -la /data/media
ls -la /data/media/music

# Prueba de escritura
touch /data/media/music/test-desde-ct114.txt
ls -la /data/media/music/test-desde-ct114.txt
```

**Verificar en VM104:**

```bash
# Desde VM104
ls -la /data/media/music/test-desde-ct114.txt
```

**Nota:** Si aparece `nobody:nogroup` en el CT, es normal (unprivileged + NFS + all_squash). Lo importante es que en VM104 aparezca como `guillermo:guillermo`.

### 5. Verificar Conectividad

```bash
# Dentro del CT114
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 6. Instalar Docker y Docker Compose

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar dependencias
apt install -y ca-certificates curl gnupg lsb-release nano htop git

# Añadir repositorio de Docker
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Habilitar y arrancar
systemctl enable --now docker

# Verificar instalación
docker --version
docker compose version
systemctl status docker --no-pager
```

### 7. Instalar Navidrome

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
      - "10.10.10.82:4533:4533"
    environment:
      - ND_SCANSCHEDULE=1h
      - ND_LOGLEVEL=info
      - ND_SESSIONTIMEOUT=24h
      - ND_ENABLESHARING=true
      - ND_BASEURL=https://navidrome.home.arpa
      - TZ=Europe/Madrid
    volumes:
      - /opt/stacks/navidrome/data:/data
      - /data/media/music:/music:ro
EOF

docker compose up -d

# Verificar
docker ps
docker logs -f navidrome
```

**Acceso interno provisional:** `http://10.10.10.82:4533`

### 8. Configuración Inicial

1. Acceder a `http://10.10.10.82:4533`
2. Crear usuario administrador:
   - **Username:** admin
   - **Password:** contraseña segura
   - **Name:** Tu nombre
3. Click **Create Admin User**

### 9. Instalar Portainer Agent

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

**Añadir en Portainer:**
- Name: `CT114-music`
- Environment URL: `tcp://10.10.10.82:9001`

---

## ⚙️ Configuración de DNS y Proxy

### 1. Configurar DNS en AdGuard Home

Asegurar que existe el DNS Rewrite:
- **Dominio:** `navidrome.home.arpa`
- **IP:** `192.168.1.82` (Nginx Proxy Manager)

### 2. Configurar Proxy en Nginx Proxy Manager

Acceder a `http://192.168.1.82:81` y crear Proxy Host:

**Detalles:**
- **Domain Names:** `navidrome.home.arpa`
- **Scheme:** `http`
- **Forward Hostname/IP:** `10.10.10.82`
- **Forward Port:** `4533`
- **Cache Assets:** OFF
- **Block Common Exploits:** ON
- **Websockets Support:** ON

**SSL:**
- **SSL Certificate:** `home-arpa-local` (certificado wildcard local)
- **Force SSL:** ON
- **HTTP/2 Support:** ON

**Guardar y verificar:**

```bash
curl -k -I https://navidrome.home.arpa
```

---

## 🎵 Añadir Música

### Desde Windows (Samba)

1. Abrir Explorador de Windows
2. En la barra de dirección: `\\192.168.1.81\data\media\music`
3. Copiar archivos de música (MP3, FLAC, etc.)
4. Navidrome escaneará automáticamente cada hora

### Desde Linux/Mac

```bash
# Montar Samba
sudo mkdir -p /mnt/casaos-music
sudo mount -t cifs //192.168.1.81/data /mnt/casaos-music -o username=guillermo,password=TU_PASSWORD

# Copiar música
cp -r ~/Music/* /mnt/casaos-music/media/music/
```

### Forzar Escaneo Manual

1. Login en Navidrome
2. Ir a **Settings** (icono de engranaje)
3. Click en **Scan Library Now**

---

## 📱 Clientes

### Web

Acceder directamente a `https://navidrome.home.arpa`

### Android

**Apps recomendadas:**
- **Symfonium** (de pago, mejor experiencia)
- **Subtracks** (gratis)
- **DSub** (gratis)

**Configuración:**
1. Instalar app
2. **Server:** `https://navidrome.home.arpa`
3. **Username:** tu usuario
4. **Password:** tu contraseña
5. **Type:** Subsonic

### iOS

**Apps recomendadas:**
- **play:Sub** (de pago)
- **substreamer** (gratis)

**Configuración:** Igual que Android

### Desktop

**Apps recomendadas:**
- **Sonixd** (Windows/Mac/Linux)
- **Sublime Music** (Linux)

---

## 👥 Gestión de Usuarios

### Crear Usuario

1. Login como admin
2. Ir a **Settings** → **Users**
3. Click **Create User**
4. Configurar:
   - **Username:** nombre_usuario
   - **Name:** Nombre completo
   - **Email:** email@example.com
   - **Password:** contraseña
   - **Is Admin:** OFF (a menos que sea admin)
5. Click **Save**

### Permisos

- **Admin:** Puede gestionar usuarios, configuración y biblioteca
- **User:** Solo puede reproducir música y gestionar sus playlists

---

## 🎨 Configuración Avanzada

### Last.fm Scrobbling

1. Ir a **Settings** → **Last.fm**
2. Click **Link Account**
3. Autorizar en Last.fm
4. Navidrome enviará automáticamente lo que escuchas

### Listas Inteligentes

1. Ir a **Playlists**
2. Click **New Smart Playlist**
3. Configurar reglas:
   - Género = Rock
   - Año > 2000
   - Rating > 4
4. Click **Save**

### Compartir Música

1. Abrir una canción/álbum/playlist
2. Click en **Share**
3. Configurar:
   - **Expiration:** Fecha de expiración
   - **Max plays:** Número máximo de reproducciones
4. Copiar enlace público

---

## 💾 Backups

### Backup de Configuración

```bash
# Backup de datos de Navidrome (playlists, ratings, etc.)
cd /opt/stacks/navidrome
tar -czf /root/navidrome-backup-$(date +%F).tar.gz data/
```

**Nota:** La música NO necesita backup desde el CT porque está en VM104.

### Backup de Música (desde VM104)

Ver documentación de [VM104 CasaOS](../06-storage-backup/vm104-casaos.md)

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Navidrome
   - **URL:** `https://navidrome.home.arpa`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs en tiempo real
docker logs -f navidrome

# Ver últimas 100 líneas
docker logs --tail 100 navidrome
```

---

## ✅ Verificación

### Test de Acceso

1. Acceder a `https://navidrome.home.arpa`
2. Login con tu cuenta
3. Verificar que aparece la biblioteca de música

### Test de Reproducción

1. Seleccionar una canción
2. Click en Play
3. Verificar que reproduce correctamente

### Test de App Móvil

1. Configurar app móvil
2. Descargar una canción para offline
3. Verificar que funciona sin conexión

---

## 🆘 Troubleshooting

### No aparece música en Navidrome

**Causa:** Música no está en la carpeta correcta o no se ha escaneado.

**Solución:**

1. Verificar que la música está en `/data/media/music`:
   ```bash
   ls -la /data/media/music
   ```

2. Forzar escaneo desde la web

3. Ver logs:
   ```bash
   docker logs navidrome | grep -i scan
   ```

### Error de permisos al acceder a /music

**Causa:** Problema con NFS o bind mount.

**Solución:**

1. Verificar montaje NFS en Proxmox:
   ```bash
   findmnt /mnt/casaos-data
   ```

2. Verificar bind mount en CT:
   ```bash
   pct config 114 | grep mp0
   ```

3. Reiniciar CT:
   ```bash
   pct reboot 114
   ```

### Navidrome no arranca

**Causa:** Problema con Docker o configuración.

**Solución:**

```bash
# Ver logs
docker logs navidrome

# Reiniciar contenedor
cd /opt/stacks/navidrome
docker compose restart

# Si persiste, recrear
docker compose down
docker compose up -d
```

---

## 🔗 Recursos Relacionados

- [VM104 - CasaOS/NAS](../06-storage-backup/vm104-casaos.md)
- [CT115 - Downloads](ct115-downloads.md)
- [Red Privada](../03-networking/private-network.md)

---

## 📚 Referencias

- [Navidrome Documentation](https://www.navidrome.org/docs/)
- [Subsonic API](http://www.subsonic.org/pages/api.jsp)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
