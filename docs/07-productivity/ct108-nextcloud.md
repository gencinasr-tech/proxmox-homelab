# CT108 - Nextcloud (Cloud Storage)

Plataforma de almacenamiento en la nube autoalojada con sincronización de archivos, calendario, contactos y colaboración.

## 📋 Información del Contenedor

- **ID:** CT108
- **Hostname:** nextcloud
- **IP Privada:** 10.10.10.65
- **OS:** Debian 12
- **Recursos:** 2 CPU, 2GB RAM, 32GB disco
- **Red:** vmbr10 (Red Privada)
- **Gateway:** 10.10.10.87

## 🎯 Propósito

Nextcloud proporciona:
- ☁️ Almacenamiento en la nube privado
- 📁 Sincronización de archivos entre dispositivos
- 📅 Calendario y contactos (CalDAV/CardDAV)
- 📝 Edición colaborativa de documentos
- 💬 Chat y videollamadas (Talk)
- 📧 Cliente de correo
- 🔐 Compartir archivos con control de acceso
- 📱 Apps móviles y de escritorio
- 🔌 Extensible con apps

## 🔒 Seguridad

- **Criticidad:** ALTA (datos personales)
- **Acceso:** HTTPS vía proxy (https://nextcloud.home.arpa)
- **Autenticación:** SSO con Keycloak + local
- **Cifrado:** Opcional end-to-end
- **Backups:** Diarios automáticos

---

## 🧱 Instalación Paso a Paso

### 1. Crear el Contenedor en Proxmox

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
CT ID: 108
Hostname: nextcloud
Template: debian-12-standard
Disco: 32 GB
CPU: 2 cores
RAM: 2048 MB
Swap: 1024 MB
Red: vmbr10
IP: 10.10.10.65/24
Gateway: 10.10.10.87
DNS: 192.168.1.53
Opciones: Unprivileged + Nesting habilitado
```

### 2. Verificar Conectividad

Acceder al contenedor:

```bash
pct enter 108

# Verificar red
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 3. Instalar Docker y Docker Compose

```bash
# Actualizar sistema
apt update && apt upgrade -y

# Instalar dependencias
apt install -y ca-certificates curl gnupg lsb-release

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

# Verificar instalación
docker --version
docker compose version
```

### 4. Preparar Estructura de Directorios

```bash
mkdir -p /opt/stacks/nextcloud/{nextcloud,db,redis}
chmod 755 /opt/stacks/nextcloud
cd /opt/stacks/nextcloud
```

### 5. Generar Contraseñas

```bash
# Generar contraseñas seguras
MYSQL_ROOT_PASSWORD="$(openssl rand -base64 24)"
MYSQL_PASSWORD="$(openssl rand -base64 24)"
NEXTCLOUD_ADMIN_PASSWORD="$(openssl rand -base64 18)"

# Mostrar y guardar (IMPORTANTE: guardar en Vaultwarden)
echo "=== CONTRASEÑAS GENERADAS ==="
echo "MYSQL_ROOT_PASSWORD: $MYSQL_ROOT_PASSWORD"
echo "MYSQL_PASSWORD: $MYSQL_PASSWORD"
echo "NEXTCLOUD_ADMIN_PASSWORD: $NEXTCLOUD_ADMIN_PASSWORD"
echo "=== GUARDAR EN VAULTWARDEN ==="

# Guardar en archivo temporal
cat > /root/CT108-nextcloud-passwords.txt <<EOF
MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
MYSQL_PASSWORD=$MYSQL_PASSWORD
NEXTCLOUD_ADMIN_PASSWORD=$NEXTCLOUD_ADMIN_PASSWORD
EOF
chmod 600 /root/CT108-nextcloud-passwords.txt
```

### 6. Crear Docker Compose

```bash
cd /opt/stacks/nextcloud

cat > docker-compose.yml <<EOF
services:
  db:
    image: mariadb:11
    container_name: nextcloud-db
    restart: unless-stopped
    command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW --innodb-file-per-table=1 --skip-innodb-read-only-compressed
    environment:
      MYSQL_ROOT_PASSWORD: "$MYSQL_ROOT_PASSWORD"
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: "$MYSQL_PASSWORD"
    volumes:
      - /opt/stacks/nextcloud/db:/var/lib/mysql
    networks:
      - nextcloud

  redis:
    image: redis:7-alpine
    container_name: nextcloud-redis
    restart: unless-stopped
    command: redis-server --requirepass redis_password_change_me
    volumes:
      - /opt/stacks/nextcloud/redis:/data
    networks:
      - nextcloud

  nextcloud:
    image: nextcloud:apache
    container_name: nextcloud
    restart: unless-stopped
    depends_on:
      - db
      - redis
    ports:
      - "10.10.10.65:8088:80"
    environment:
      # Base de datos
      MYSQL_HOST: db
      MYSQL_DATABASE: nextcloud
      MYSQL_USER: nextcloud
      MYSQL_PASSWORD: "$MYSQL_PASSWORD"
      
      # Admin inicial
      NEXTCLOUD_ADMIN_USER: guillermo
      NEXTCLOUD_ADMIN_PASSWORD: "$NEXTCLOUD_ADMIN_PASSWORD"
      
      # Dominios confiables
      NEXTCLOUD_TRUSTED_DOMAINS: "10.10.10.65 nextcloud.home.arpa nextcloud"
      
      # Redis
      REDIS_HOST: redis
      REDIS_HOST_PASSWORD: redis_password_change_me
      
      # PHP
      PHP_MEMORY_LIMIT: 1024M
      PHP_UPLOAD_LIMIT: 10G
      
      # Timezone
      TZ: Europe/Madrid
      
    volumes:
      - /opt/stacks/nextcloud/nextcloud:/var/www/html
    networks:
      - nextcloud

networks:
  nextcloud:
    driver: bridge
EOF

# Levantar servicios
docker compose up -d

# Verificar
docker ps
docker logs -f nextcloud
```

Esperar a que aparezca:

```
Nextcloud was successfully installed
```

**Acceso interno provisional:** `http://10.10.10.65:8088`

### 7. Configurar para Proxy HTTPS

Configurar trusted domains y proxy settings:

```bash
# Añadir dominios confiables
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 2 --value=10.10.10.65
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 3 --value=192.168.1.82

# Configurar proxy
docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value=192.168.1.82
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value=nextcloud.home.arpa
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value=https
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value=https://nextcloud.home.arpa

# Verificar configuración
docker exec -u www-data nextcloud php occ config:system:get trusted_domains
```

### 8. Instalar Portainer Agent

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
- Name: `CT108-nextcloud`
- Environment URL: `tcp://10.10.10.65:9001`

---

## ⚙️ Configuración de DNS y Proxy

### 1. Configurar DNS en AdGuard Home

Asegurar que existe el DNS Rewrite:
- **Dominio:** `nextcloud.home.arpa`
- **IP:** `192.168.1.82` (Nginx Proxy Manager)

### 2. Configurar Proxy en Nginx Proxy Manager

Acceder a `http://192.168.1.82:81` y crear Proxy Host:

**Detalles:**
- **Domain Names:** `nextcloud.home.arpa`
- **Scheme:** `http`
- **Forward Hostname/IP:** `10.10.10.65`
- **Forward Port:** `8088`
- **Cache Assets:** OFF
- **Block Common Exploits:** OFF (importante para Nextcloud)
- **Websockets Support:** ON

**SSL:**
- **SSL Certificate:** `home-arpa-local` (certificado wildcard local)
- **Force SSL:** ON
- **HTTP/2 Support:** ON
- **HSTS Enabled:** ON

**Advanced (Custom Nginx Configuration):**

```nginx
proxy_set_header X-Forwarded-Proto https;
proxy_set_header X-Forwarded-Port 443;
proxy_set_header X-Forwarded-Host $host;
proxy_set_header Host $host;

client_max_body_size 10G;
client_body_buffer_size 400M;

proxy_connect_timeout 3600s;
proxy_read_timeout 3600s;
proxy_send_timeout 3600s;
proxy_buffering off;
proxy_request_buffering off;
```

**Guardar y verificar:**

```bash
curl -k -I https://nextcloud.home.arpa
```

---

## 🔐 Configuración Inicial

### Primer Acceso

1. Acceder a `https://nextcloud.home.arpa`
2. Login con:
   - **Usuario:** `guillermo`
   - **Contraseña:** (valor de `NEXTCLOUD_ADMIN_PASSWORD`)

### Configuración Básica

**1. Instalar Apps Recomendadas:**

Ir a **Apps** (icono de cuadrícula) y habilitar:
- ✅ Calendar
- ✅ Contacts
- ✅ Tasks
- ✅ Notes
- ✅ Deck (tableros Kanban)
- ✅ Talk (chat y videollamadas)
- ✅ Mail (cliente de correo)
- ✅ Photos (galería de fotos)
- ✅ Memories (línea de tiempo de fotos)

**2. Configurar Ajustes Básicos:**

Ir a **Settings** → **Administration** → **Basic settings**:
- **Email server:** Configurar SMTP (opcional)
- **Phone region:** ES
- **Background jobs:** Cron (recomendado)

**3. Configurar Cron:**

```bash
# Añadir cron job para Nextcloud
docker exec -u www-data nextcloud php occ background:cron

# Añadir a crontab del host
(crontab -l 2>/dev/null; echo "*/5 * * * * docker exec -u www-data nextcloud php occ background:cron") | crontab -
```

**4. Optimizar Rendimiento:**

```bash
# Habilitar caché de memoria
docker exec -u www-data nextcloud php occ config:system:set memcache.local --value='\OC\Memcache\APCu'
docker exec -u www-data nextcloud php occ config:system:set memcache.distributed --value='\OC\Memcache\Redis'
docker exec -u www-data nextcloud php occ config:system:set memcache.locking --value='\OC\Memcache\Redis'
docker exec -u www-data nextcloud php occ config:system:set redis host --value=redis
docker exec -u www-data nextcloud php occ config:system:set redis port --value=6379
docker exec -u www-data nextcloud php occ config:system:set redis password --value=redis_password_change_me

# Reiniciar Nextcloud
docker restart nextcloud
```

---

## 📱 Configuración de Clientes

### Desktop Client (Windows/Mac/Linux)

1. Descargar desde [nextcloud.com/install](https://nextcloud.com/install/#install-clients)
2. Instalar y abrir
3. **Server address:** `https://nextcloud.home.arpa`
4. Click **Next**
5. Se abre el navegador
6. Login con Keycloak o usuario local
7. Autorizar el cliente
8. Seleccionar carpetas a sincronizar
9. Click **Connect**

### App Móvil (Android/iOS)

1. Instalar desde:
   - [Google Play Store](https://play.google.com/store/apps/details?id=com.nextcloud.client)
   - [Apple App Store](https://apps.apple.com/app/nextcloud/id1125420102)

2. Abrir la app
3. **Server address:** `https://nextcloud.home.arpa`
4. Click **Login**
5. Login con Keycloak o usuario local
6. Autorizar la app
7. Configurar sincronización automática de fotos (opcional)

### WebDAV

Para acceder vía WebDAV:

**URL:**
```
https://nextcloud.home.arpa/remote.php/dav/files/USERNAME/
```

**Autenticación:**
- Usar un **App Password** generado en Nextcloud
- Ir a **Settings** → **Security** → **Devices & sessions**
- Click en **Create new app password**
- Usar ese password en lugar de la contraseña principal

---

## 👥 Gestión de Usuarios

### Crear Usuario

1. Ir a **Settings** → **Users**
2. Click en **New user**
3. Configurar:
   - **Username:** nombre_usuario
   - **Display name:** Nombre Completo
   - **Email:** email@example.com
   - **Groups:** Seleccionar grupos
   - **Quota:** Establecer límite de almacenamiento
4. Click **Create**

### Grupos

**Grupos predefinidos:**
- **admin:** Administradores con acceso total
- **users:** Usuarios normales

**Crear grupo personalizado:**
1. Ir a **Settings** → **Users**
2. En la barra lateral, click en **Add group**
3. **Group name:** familia, trabajo, etc.
4. Click **Create**

### Cuotas de Almacenamiento

```bash
# Establecer cuota para un usuario
docker exec -u www-data nextcloud php occ user:setting username files quota "100 GB"

# Establecer cuota para un grupo
docker exec -u www-data nextcloud php occ user:setting --group familia files quota "500 GB"

# Sin límite
docker exec -u www-data nextcloud php occ user:setting username files quota "none"

# Ver cuota de un usuario
docker exec -u www-data nextcloud php occ user:info username
```

---

## 📁 Compartir Archivos

### Compartir con Usuarios Internos

1. Click derecho en archivo/carpeta
2. Click en **Share**
3. Buscar usuario o grupo
4. Establecer permisos:
   - 👁️ Can view
   - ✏️ Can edit
   - 🗑️ Can delete
   - 📤 Can share
5. Click **Share**

### Compartir con Enlace Público

1. Click derecho en archivo/carpeta
2. Click en **Share**
3. Click en **Share link**
4. Configurar:
   - 🔒 **Password protect:** Opcional
   - 📅 **Set expiration date:** Opcional
   - ✏️ **Allow editing:** Opcional
   - 📁 **Allow upload and editing:** Para carpetas
5. Copiar enlace

### Compartir por Email

1. Compartir archivo/carpeta
2. Introducir email del destinatario
3. Nextcloud enviará invitación por email
4. El destinatario puede acceder sin cuenta

---

## 🔌 Apps Útiles

### Instalar Apps

1. Ir a **Apps** (icono de cuadrícula)
2. Buscar app
3. Click en **Download and enable**

**Apps recomendadas:**

**Productividad:**
- **Deck:** Tableros Kanban estilo Trello
- **Tasks:** Gestor de tareas
- **Notes:** Notas con Markdown
- **Bookmarks:** Marcadores

**Colaboración:**
- **Talk:** Chat y videollamadas
- **Circles:** Grupos y equipos
- **Forms:** Formularios y encuestas

**Multimedia:**
- **Photos:** Galería de fotos mejorada
- **Memories:** Línea de tiempo de fotos con IA
- **Music:** Reproductor de música
- **Video Player:** Reproductor de video

**Seguridad:**
- **Two-Factor TOTP Provider:** 2FA con TOTP
- **Brute-force settings:** Protección contra ataques
- **End-to-End Encryption:** Cifrado E2E

---

## 💾 Backups

### Backup Manual

```bash
# Activar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --on

# Backup de base de datos
docker exec nextcloud-db mysqldump -u nextcloud -p$MYSQL_PASSWORD nextcloud > /root/nextcloud-db-$(date +%F).sql

# Backup de archivos
tar -czf /root/nextcloud-data-$(date +%F).tar.gz -C /opt/stacks/nextcloud nextcloud/

# Desactivar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --off
```

### Backup Automático

```bash
# Crear script de backup
cat > /root/scripts/backup-nextcloud.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/nextcloud"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Activar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --on

# Backup de base de datos
docker exec nextcloud-db mysqldump -u nextcloud -pPASSWORD nextcloud > $BACKUP_DIR/nextcloud-db-$DATE.sql

# Backup de archivos (solo config y data)
tar -czf $BACKUP_DIR/nextcloud-data-$DATE.tar.gz -C /opt/stacks/nextcloud nextcloud/config nextcloud/data

# Desactivar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --off

# Mantener solo los últimos 7 backups
find $BACKUP_DIR -name "nextcloud-*" -mtime +7 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /root/scripts/backup-nextcloud.sh

# Añadir a crontab (diario a las 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /root/scripts/backup-nextcloud.sh") | crontab -
```

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Nextcloud
   - **URL:** `https://nextcloud.home.arpa`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs de Nextcloud
docker logs -f nextcloud

# Ver logs de base de datos
docker logs nextcloud-db

# Ver logs internos de Nextcloud
docker exec nextcloud tail -f /var/www/html/data/nextcloud.log
```

### Estadísticas

En la interfaz web:

1. Ir a **Settings** → **Administration** → **Overview**
2. Ver:
   - Versión de Nextcloud
   - Usuarios activos
   - Espacio utilizado
   - Advertencias de seguridad

---

## ✅ Verificación

### Test de Subida

1. Login en Nextcloud
2. Subir un archivo de prueba
3. Verificar que aparece en la lista
4. Descargar el archivo

### Test de Sincronización

1. Configurar cliente de escritorio
2. Crear un archivo en la carpeta sincronizada
3. Verificar que aparece en la web
4. Editar el archivo desde la web
5. Verificar que se actualiza en el escritorio

### Test de Compartir

1. Compartir un archivo con otro usuario
2. Verificar que el usuario recibe notificación
3. Verificar que puede acceder al archivo

---

## 🆘 Troubleshooting

### Error: "Trusted domain error"

**Causa:** El dominio no está en la lista de trusted domains.

**Solución:**

```bash
# Añadir dominio
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 4 --value=nuevo-dominio.com

# Ver lista actual
docker exec -u www-data nextcloud php occ config:system:get trusted_domains
```

### Error: "Database is locked"

**Causa:** Problema con la base de datos.

**Solución:**

```bash
# Reiniciar base de datos
docker restart nextcloud-db
docker restart nextcloud

# Reparar base de datos
docker exec -u www-data nextcloud php occ maintenance:repair
```

### Archivos no se sincronizan

**Causa:** Cliente desconectado o problema de permisos.

**Solución:**

1. Verificar conexión del cliente
2. Verificar permisos de archivos:
   ```bash
   docker exec nextcloud chown -R www-data:www-data /var/www/html/data
   ```
3. Reiniciar cliente

### Error: "504 Gateway Timeout"

**Causa:** Timeout en el proxy para archivos grandes.

**Solución:**

Aumentar timeouts en Nginx Proxy Manager (ver sección de configuración de proxy).

---

## 🔗 Recursos Relacionados

- [SSO en Nextcloud](../09-authentication/sso-nextcloud.md)
- [CT112 - Nginx Proxy Manager](../04-core-services/ct112-proxy.md)
- [Red Privada](../03-networking/private-network.md)
- [Backups](../06-storage-backup/local-backups.md)

---

## 📚 Referencias

- [Nextcloud Documentation](https://docs.nextcloud.com/)
- [Nextcloud Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
- [Nextcloud Apps](https://apps.nextcloud.com/)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
