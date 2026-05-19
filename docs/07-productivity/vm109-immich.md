# VM109 - Immich (Photo Management)

Plataforma de gestión de fotos y videos autoalojada con IA, reconocimiento facial y backup automático desde móviles.

## 📋 Información de la VM

- **ID:** VM109
- **Hostname:** immich
- **IP Privada:** 10.10.10.30
- **OS:** Debian 13
- **Recursos:** 2 CPU, 4GB RAM, 64GB disco
- **Red:** vmbr10 (Red Privada)
- **Gateway:** 10.10.10.87

## 🎯 Propósito

Immich proporciona:
- 📸 Backup automático de fotos y videos desde móvil
- 🤖 Reconocimiento facial con IA
- 🏷️ Etiquetado automático de objetos
- 🔍 Búsqueda por contenido visual
- 📍 Organización por ubicación (mapa)
- 📅 Línea de tiempo de recuerdos
- 🎬 Reproducción de videos
- 👥 Compartir álbumes con familia
- 📱 Apps móviles nativas (Android/iOS)

## 🔒 Seguridad

- **Criticidad:** ALTA (fotos personales/familiares)
- **Acceso:** HTTPS vía proxy (https://immich.home.arpa)
- **Autenticación:** SSO con Keycloak + local
- **Backups:** Diarios automáticos
- **Privacidad:** Todo procesado localmente (sin cloud)

---

## 🧱 Instalación Paso a Paso

### 1. Crear la VM en Proxmox

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
VM ID: 109
Nombre: immich
ISO: debian-13.0.0-amd64-netinst.iso
Sistema: Linux 6.x
Machine: q35
BIOS: OVMF (UEFI)
Disco EFI: Añadir disco EFI
Disco: 64 GB (VirtIO Block)
CPU: 2 cores (host)
RAM: 4096 MB
Red: vmbr10, modelo VirtIO
```

### 2. Instalar Debian 13

Arrancar la VM y seguir el instalador:

**Configuración de red:**
- **Hostname:** immich
- **Domain:** (dejar vacío)
- **IP:** 10.10.10.30
- **Netmask:** 255.255.255.0
- **Gateway:** 10.10.10.87
- **DNS:** 192.168.1.53

**Usuarios:**
- **Root password:** (establecer contraseña segura)
- **Usuario:** guillermo
- **Password:** (establecer contraseña segura)

**Particionado:**
- Guided - use entire disk
- All files in one partition

**Software:**
- ❌ Debian desktop environment
- ❌ GNOME
- ✅ SSH server
- ✅ Standard system utilities

### 3. Configuración Post-Instalación

Acceder a la VM:

```bash
# Desde Proxmox host
qm enter 109

# O por SSH
ssh guillermo@10.10.10.30
```

Actualizar sistema:

```bash
su -
apt update && apt upgrade -y
apt install -y sudo curl wget git vim
usermod -aG sudo guillermo
exit
```

Relogin para aplicar cambios de grupo.

### 4. Instalar Docker y Docker Compose

```bash
# Instalar dependencias
sudo apt install -y ca-certificates curl gnupg lsb-release

# Añadir repositorio de Docker
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Añadir usuario al grupo docker
sudo usermod -aG docker $USER

# Relogin para aplicar cambios
exit
# Volver a conectar por SSH
```

Verificar instalación:

```bash
docker --version
docker compose version
```

### 5. Preparar Estructura de Directorios

```bash
sudo mkdir -p /opt/stacks/immich/{library,postgres,model-cache}
sudo chown -R $USER:$USER /opt/stacks/immich
cd /opt/stacks/immich
```

### 6. Generar Contraseña de Base de Datos

```bash
# Generar contraseña segura
DB_PASSWORD="$(openssl rand -base64 24)"

# Mostrar y guardar (IMPORTANTE: guardar en Vaultwarden)
echo "=== CONTRASEÑA GENERADA ==="
echo "DB_PASSWORD: $DB_PASSWORD"
echo "=== GUARDAR EN VAULTWARDEN ==="

# Guardar en archivo temporal
echo "DB_PASSWORD=$DB_PASSWORD" > ~/VM109-immich-password.txt
chmod 600 ~/VM109-immich-password.txt
```

### 7. Crear Archivo .env

```bash
cd /opt/stacks/immich

cat > .env <<EOF
# Rutas de almacenamiento
UPLOAD_LOCATION=/opt/stacks/immich/library
DB_DATA_LOCATION=/opt/stacks/immich/postgres

# Versión de Immich
IMMICH_VERSION=release

# Base de datos
DB_PASSWORD=$DB_PASSWORD
DB_USERNAME=postgres
DB_DATABASE_NAME=immich

# Configuración
TZ=Europe/Madrid
EOF

chmod 600 .env
```

### 8. Crear Docker Compose

```bash
cat > docker-compose.yml <<'EOF'
services:
  immich-server:
    container_name: immich-server
    image: ghcr.io/immich-app/immich-server:${IMMICH_VERSION}
    restart: unless-stopped
    volumes:
      - ${UPLOAD_LOCATION}:/usr/src/app/upload
      - /etc/localtime:/etc/localtime:ro
    env_file:
      - .env
    ports:
      - "10.10.10.30:2283:2283"
    depends_on:
      - redis
      - database
    environment:
      # Deshabilitar verificación SSL para certificados autofirmados
      NODE_TLS_REJECT_UNAUTHORIZED: "0"
    networks:
      - immich

  immich-machine-learning:
    container_name: immich-machine-learning
    image: ghcr.io/immich-app/immich-machine-learning:${IMMICH_VERSION}
    restart: unless-stopped
    volumes:
      - /opt/stacks/immich/model-cache:/cache
    env_file:
      - .env
    networks:
      - immich

  redis:
    container_name: immich-redis
    image: docker.io/redis:7-alpine
    restart: unless-stopped
    networks:
      - immich

  database:
    container_name: immich-postgres
    image: ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_USER: ${DB_USERNAME}
      POSTGRES_DB: ${DB_DATABASE_NAME}
      POSTGRES_INITDB_ARGS: '--data-checksums'
    volumes:
      - ${DB_DATA_LOCATION}:/var/lib/postgresql/data
    networks:
      - immich

networks:
  immich:
    driver: bridge
EOF

# Levantar servicios
docker compose up -d

# Verificar
docker ps
docker logs -f immich-server
```

Esperar a que aparezca:

```
Immich Server is listening on 0.0.0.0:2283
```

**Acceso interno provisional:** `http://10.10.10.30:2283`

### 9. Crear Usuario Administrador

1. Acceder a `http://10.10.10.30:2283`
2. Click en **Getting Started**
3. Crear cuenta de administrador:
   - **Email:** tu-email@example.com
   - **Password:** contraseña segura
   - **First name:** Tu nombre
   - **Last name:** Tu apellido
4. Click **Sign Up**

### 10. Instalar Portainer Agent

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
- Name: `VM109-immich`
- Environment URL: `tcp://10.10.10.30:9001`

---

## ⚙️ Configuración de DNS y Proxy

### 1. Configurar DNS en AdGuard Home

Asegurar que existe el DNS Rewrite:
- **Dominio:** `immich.home.arpa`
- **IP:** `192.168.1.82` (Nginx Proxy Manager)

### 2. Configurar Proxy en Nginx Proxy Manager

Acceder a `http://192.168.1.82:81` y crear Proxy Host:

**Detalles:**
- **Domain Names:** `immich.home.arpa`
- **Scheme:** `http`
- **Forward Hostname/IP:** `10.10.10.30`
- **Forward Port:** `2283`
- **Cache Assets:** OFF
- **Block Common Exploits:** ON
- **Websockets Support:** ON

**SSL:**
- **SSL Certificate:** `home-arpa-local` (certificado wildcard local)
- **Force SSL:** ON
- **HTTP/2 Support:** ON

**Advanced (Custom Nginx Configuration):**

```nginx
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header Host $host;

client_max_body_size 50000M;
proxy_read_timeout 600s;
proxy_send_timeout 600s;
proxy_buffering off;
proxy_request_buffering off;
```

**Guardar y verificar:**

```bash
curl -k -I https://immich.home.arpa
```

---

## 🔐 Configuración Inicial

### Configuración Básica

1. Login en `https://immich.home.arpa`
2. Ir a **Administration** (icono de engranaje)

**Server Settings:**
- **External domain:** `https://immich.home.arpa`
- **Welcome message:** Personalizar mensaje de bienvenida

**Machine Learning:**
- **Facial Recognition:** ✅ ON
- **Smart Search:** ✅ ON
- **Duplicate Detection:** ✅ ON

**Storage:**
- **Storage template:** `{{y}}/{{y}}-{{MM}}-{{dd}}/{{filename}}`

**Thumbnail:**
- **Quality:** High
- **Format:** WebP

3. Click **Save**

### Configurar Biblioteca

1. Ir a **Administration** → **Libraries**
2. La biblioteca por defecto ya está creada
3. Configurar:
   - **Name:** My Photos
   - **Import paths:** (dejar por defecto)
   - **Scan settings:** Configurar según preferencias

---

## 📱 Configuración de App Móvil

### Android

1. Instalar desde [Google Play Store](https://play.google.com/store/apps/details?id=app.alextran.immich)
2. Abrir la app
3. **Server URL:** `https://immich.home.arpa`
4. Click **Login**
5. Login con Keycloak o usuario local
6. Autorizar la app

**Configurar Backup Automático:**
1. Ir a **Backup** (tab inferior)
2. **Enable Backup:** ✅ ON
3. **Select Albums:** Elegir álbumes a respaldar (Camera, Screenshots, etc.)
4. **Backup over WiFi only:** ✅ ON (recomendado)
5. **Background Backup:** ✅ ON
6. **Foreground Backup:** ✅ ON

### iOS

1. Instalar desde [Apple App Store](https://apps.apple.com/app/immich/id1613945652)
2. Seguir los mismos pasos que Android

**Nota:** El dispositivo debe estar en la red local o conectado a Tailscale.

---

## 👥 Gestión de Usuarios

### Crear Usuario

1. Ir a **Administration** → **Users**
2. Click **Create User**
3. Configurar:
   - **Email:** email@example.com
   - **Password:** contraseña segura
   - **Name:** Nombre completo
   - **Storage quota:** Establecer límite (ej: 100GB)
4. Click **Create**

### Roles

| Rol | Permisos |
|-----|----------|
| **Admin** | Control total, gestión de usuarios, configuración |
| **User** | Subir fotos, crear álbumes, compartir |

Para promover a admin:
1. Ir a **Administration** → **Users**
2. Click en el usuario
3. Toggle **Admin** → ON
4. Click **Save**

---

## 📸 Uso Básico

### Subir Fotos Manualmente

1. Click en **Upload** (botón +)
2. Seleccionar fotos/videos
3. Click **Upload**

### Crear Álbumes

1. Ir a **Albums**
2. Click **Create Album**
3. **Album name:** Nombre del álbum
4. Seleccionar fotos
5. Click **Create**

### Compartir Álbumes

1. Abrir álbum
2. Click en **Share** (icono de compartir)
3. Seleccionar usuarios
4. Establecer permisos (ver/editar)
5. Click **Add**

### Búsqueda

**Búsqueda por texto:**
- Buscar objetos: "perro", "playa", "montaña"
- Buscar personas: nombres de personas reconocidas
- Buscar ubicaciones: nombres de ciudades

**Búsqueda por fecha:**
- Usar el calendario para navegar por fechas

**Búsqueda por ubicación:**
- Ir a **Map** para ver fotos en mapa

### Personas (Reconocimiento Facial)

1. Ir a **Explore** → **People**
2. Immich detecta caras automáticamente
3. Click en una cara
4. **Name this person:** Introducir nombre
5. Click **Save**
6. Immich agrupa todas las fotos de esa persona

---

## 🤖 Machine Learning

### Modelos de IA

Immich descarga y usa varios modelos de IA:

**CLIP (Smart Search):**
- Búsqueda semántica de imágenes
- Permite buscar por descripción natural

**Facial Recognition:**
- Detección y reconocimiento de caras
- Agrupación automática de personas

**Object Detection:**
- Detección de objetos en fotos
- Etiquetado automático

### Gestión de Modelos

1. Ir a **Administration** → **Machine Learning**
2. Ver modelos descargados
3. Configurar:
   - **Facial Recognition Model:** buffalo_l (recomendado)
   - **CLIP Model:** ViT-B-32__openai
   - **Enabled:** ✅ ON para todos

### Reindexar Fotos

Si cambias modelos o configuración:

1. Ir a **Administration** → **Jobs**
2. Click en **Run** para:
   - **Smart Search**
   - **Face Detection**
   - **Facial Recognition**

---

## 💾 Backups

### Backup Manual

```bash
# Backup de base de datos
docker exec immich-postgres pg_dumpall -U postgres > ~/immich-db-$(date +%F).sql

# Backup de fotos
sudo tar -czf ~/immich-library-$(date +%F).tar.gz -C /opt/stacks/immich library/

# Backup de configuración
cp /opt/stacks/immich/.env ~/immich-env-$(date +%F).env
cp /opt/stacks/immich/docker-compose.yml ~/immich-compose-$(date +%F).yml
```

### Backup Automático

```bash
# Crear script de backup
cat > ~/scripts/backup-immich.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="$HOME/backups/immich"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup de base de datos
docker exec immich-postgres pg_dumpall -U postgres > $BACKUP_DIR/immich-db-$DATE.sql

# Backup de fotos (incremental)
rsync -av --delete /opt/stacks/immich/library/ $BACKUP_DIR/library/

# Mantener solo los últimos 7 backups de DB
find $BACKUP_DIR -name "immich-db-*.sql" -mtime +7 -delete

echo "Backup completado: $DATE"
EOF

chmod +x ~/scripts/backup-immich.sh

# Añadir a crontab (diario a las 3 AM)
(crontab -l 2>/dev/null; echo "0 3 * * * $HOME/scripts/backup-immich.sh") | crontab -
```

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Immich
   - **URL:** `https://immich.home.arpa`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs de Immich
docker logs -f immich-server

# Ver logs de Machine Learning
docker logs immich-machine-learning

# Ver logs de base de datos
docker logs immich-postgres
```

### Estadísticas

En la interfaz web:

1. Ir a **Administration** → **Server Stats**
2. Ver:
   - Total de fotos y videos
   - Espacio utilizado
   - Usuarios activos
   - Estado de jobs de ML

---

## ✅ Verificación

### Test de Subida

1. Subir una foto de prueba
2. Verificar que aparece en la galería
3. Verificar que se procesa con ML (búsqueda funciona)

### Test de App Móvil

1. Configurar app móvil
2. Subir una foto desde el móvil
3. Verificar que aparece en la web

### Test de Reconocimiento Facial

1. Subir fotos con caras
2. Esperar a que se procesen
3. Ir a **People**
4. Verificar que detecta caras
5. Nombrar una persona
6. Verificar que agrupa correctamente

---

## 🆘 Troubleshooting

### Machine Learning no funciona

**Causa:** Modelos no descargados o contenedor no arrancó.

**Solución:**

```bash
# Verificar logs
docker logs immich-machine-learning

# Reiniciar contenedor
docker restart immich-machine-learning

# Verificar espacio en disco
df -h
```

### Fotos no se suben desde móvil

**Causa:** App no puede conectar al servidor.

**Solución:**

1. Verificar que el móvil está en la red local o Tailscale
2. Verificar URL del servidor en la app
3. Verificar que el puerto está abierto:
   ```bash
   curl -k -I https://immich.home.arpa
   ```

### Error de base de datos

**Causa:** PostgreSQL no arrancó correctamente.

**Solución:**

```bash
# Verificar logs
docker logs immich-postgres

# Reiniciar base de datos
docker restart immich-postgres
docker restart immich-server
```

### Búsqueda no funciona

**Causa:** Índice de búsqueda no creado.

**Solución:**

1. Ir a **Administration** → **Jobs**
2. Click en **Run** para **Smart Search**
3. Esperar a que termine el job

---

## 🔗 Recursos Relacionados

- [SSO en Immich](../09-authentication/sso-immich.md)
- [CT112 - Nginx Proxy Manager](../04-core-services/ct112-proxy.md)
- [Red Privada](../03-networking/private-network.md)
- [Backups](../06-storage-backup/local-backups.md)

---

## 📚 Referencias

- [Immich Documentation](https://immich.app/docs)
- [Immich GitHub](https://github.com/immich-app/immich)
- [Immich Mobile App](https://immich.app/docs/install/mobile)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
