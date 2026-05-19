# CT107 - Paperless-ngx (Document Management)

Sistema de gestión documental con OCR, etiquetado automático y búsqueda avanzada para digitalizar y organizar documentos.

## 📋 Información del Contenedor

- **ID:** CT107
- **Hostname:** paperless
- **IP Privada:** 10.10.10.40
- **OS:** Debian 12
- **Recursos:** 1 CPU, 1GB RAM, 16GB disco
- **Red:** vmbr10 (Red Privada)
- **Gateway:** 10.10.10.87

## 🎯 Propósito

Paperless-ngx proporciona:
- 📄 Digitalización y archivo de documentos
- 🔍 OCR multiidioma (español e inglés)
- 🏷️ Etiquetado y categorización automática
- 📊 Búsqueda de texto completo
- 📧 Importación por email
- 📱 App móvil para escaneo
- 🔐 Control de acceso por usuario
- 💾 Exportación y backup automático

## 🔒 Seguridad

- **Criticidad:** ALTA (documentos personales/fiscales)
- **Acceso:** HTTPS vía proxy (https://paperless.home.arpa)
- **Backups:** Diarios automáticos
- **Cifrado:** Opcional para documentos sensibles

---

## 🧱 Instalación Paso a Paso

### 1. Crear el Contenedor en Proxmox

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
CT ID: 107
Hostname: paperless
Template: debian-12-standard
Disco: 16 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Red: vmbr10
IP: 10.10.10.40/24
Gateway: 10.10.10.87
DNS: 192.168.1.53
Opciones: Unprivileged + Nesting habilitado
```

### 2. Verificar Conectividad

Acceder al contenedor:

```bash
pct enter 107

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
mkdir -p /opt/stacks/paperless/{data,media,export,consume,postgres}
chmod 755 /opt/stacks/paperless
cd /opt/stacks/paperless
```

### 5. Generar Contraseñas

```bash
# Generar contraseña de admin
PAPERLESS_ADMIN_PASSWORD="$(openssl rand -base64 18)"

# Generar secret key
PAPERLESS_SECRET_KEY="$(openssl rand -base64 42)"

# Mostrar y guardar (IMPORTANTE: guardar en Vaultwarden)
echo "=== CONTRASEÑAS GENERADAS ==="
echo "PAPERLESS_ADMIN_PASSWORD: $PAPERLESS_ADMIN_PASSWORD"
echo "PAPERLESS_SECRET_KEY: $PAPERLESS_SECRET_KEY"
echo "=== GUARDAR EN VAULTWARDEN ==="

# Guardar en archivo temporal
cat > /root/CT107-paperless-passwords.txt <<EOF
PAPERLESS_ADMIN_PASSWORD=$PAPERLESS_ADMIN_PASSWORD
PAPERLESS_SECRET_KEY=$PAPERLESS_SECRET_KEY
EOF
chmod 600 /root/CT107-paperless-passwords.txt
```

### 6. Crear Docker Compose

```bash
cd /opt/stacks/paperless

cat > docker-compose.yml <<EOF
services:
  broker:
    image: docker.io/library/redis:7
    container_name: paperless-redis
    restart: unless-stopped
    networks:
      - paperless

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
    networks:
      - paperless

  webserver:
    image: ghcr.io/paperless-ngx/paperless-ngx:latest
    container_name: paperless
    restart: unless-stopped
    ports:
      - "10.10.10.40:8000:8000"
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
      PAPERLESS_SECRET_KEY: $PAPERLESS_SECRET_KEY
      
      PAPERLESS_TIME_ZONE: Europe/Madrid
      PAPERLESS_OCR_LANGUAGES: spa eng
      PAPERLESS_OCR_LANGUAGE: spa
      
      PAPERLESS_URL: https://paperless.home.arpa
      PAPERLESS_TRUSTED_PROXIES: 192.168.1.82
      PAPERLESS_USE_X_FORWARD_HOST: "true"
      PAPERLESS_USE_X_FORWARD_PORT: "true"
      
      PAPERLESS_ENABLE_HTTP_REMOTE_USER: "false"
      PAPERLESS_FILENAME_FORMAT: "{created_year}/{correspondent}/{title}"
      PAPERLESS_CONSUMER_POLLING: "60"
      
    depends_on:
      - broker
      - db
    networks:
      - paperless

networks:
  paperless:
    driver: bridge
EOF

# Levantar servicios
docker compose up -d

# Verificar
docker ps
docker logs -f paperless
```

Esperar a que aparezca:

```
[INFO] Starting Paperless-ngx...
[INFO] Applying database migrations...
[INFO] Creating superuser...
[INFO] Starting web server...
```

### 7. Instalar Portainer Agent

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
- Name: `CT107-paperless`
- Environment URL: `tcp://10.10.10.40:9001`

---

## ⚙️ Configuración de DNS y Proxy

### 1. Configurar DNS en AdGuard Home

Asegurar que existe el DNS Rewrite:
- **Dominio:** `paperless.home.arpa`
- **IP:** `192.168.1.82` (Nginx Proxy Manager)

### 2. Configurar Proxy en Nginx Proxy Manager

Acceder a `http://192.168.1.82:81` y crear Proxy Host:

**Detalles:**
- **Domain Names:** `paperless.home.arpa`
- **Scheme:** `http`
- **Forward Hostname/IP:** `10.10.10.40`
- **Forward Port:** `8000`
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

client_max_body_size 100M;
proxy_read_timeout 300s;
proxy_send_timeout 300s;
```

**Guardar y verificar:**

```bash
curl -k -I https://paperless.home.arpa
```

---

## 🔐 Configuración Inicial

### Primer Acceso

1. Acceder a `https://paperless.home.arpa`
2. Login con:
   - **Usuario:** `root`
   - **Contraseña:** (valor de `PAPERLESS_ADMIN_PASSWORD`)

### Configuración Básica

1. Ir a **Settings** (icono de engranaje)

**General:**
- **Language:** Español
- **Date format:** DD/MM/YYYY
- **Time zone:** Europe/Madrid

**Documents:**
- **Filename format:** `{created_year}/{correspondent}/{title}`
- **Storage path:** (dejar por defecto)

**OCR:**
- **OCR language:** Spanish
- **OCR mode:** Skip (si ya tiene texto) / Redo (forzar OCR)

**Notifications:**
- Configurar email si se desea (opcional)

2. Click **Save**

---

## 📄 Uso Básico

### Subir Documentos

**Método 1: Interfaz Web**

1. Click en **Upload** (botón +)
2. Arrastrar archivos o click para seleccionar
3. Soporta: PDF, JPG, PNG, TIFF, etc.
4. Click **Upload**

**Método 2: Carpeta de Consumo**

```bash
# Copiar archivos a la carpeta consume
cp documento.pdf /opt/stacks/paperless/consume/

# Paperless los procesará automáticamente cada 60 segundos
```

**Método 3: App Móvil**

1. Instalar app "Paperless Mobile" (Android/iOS)
2. Configurar servidor: `https://paperless.home.arpa`
3. Login
4. Usar cámara para escanear documentos

### Organizar Documentos

**Correspondientes (Remitentes):**

1. Ir a **Correspondents**
2. Click **Add correspondent**
3. **Name:** Nombre de la empresa/persona
4. **Matching algorithm:** Auto (aprende de documentos anteriores)
5. Click **Save**

**Tipos de Documento:**

1. Ir a **Document types**
2. Click **Add document type**
3. **Name:** Factura, Contrato, Recibo, etc.
4. Click **Save**

**Etiquetas:**

1. Ir a **Tags**
2. Click **Add tag**
3. **Name:** Impuestos, Personal, Trabajo, etc.
4. **Color:** Seleccionar color
5. Click **Save**

### Buscar Documentos

**Búsqueda Simple:**
- Escribir en la barra de búsqueda
- Busca en título, contenido OCR, etiquetas

**Búsqueda Avanzada:**
- Click en **Advanced search**
- Filtrar por:
  - Correspondent
  - Document type
  - Tags
  - Date range
  - Custom fields

**Búsqueda por Contenido:**
```
content:factura 2024
```

**Búsqueda por Fecha:**
```
created:[2024-01-01 to 2024-12-31]
```

---

## 👥 Gestión de Usuarios

### Crear Usuario

1. Ir a **Settings** → **Users**
2. Click **Add user**
3. Configurar:
   - **Username:** nombre_usuario
   - **Email:** email@example.com
   - **Password:** contraseña segura
   - **Groups:** Seleccionar grupos
   - **Permissions:** Configurar permisos
4. Click **Save**

### Grupos y Permisos

**Grupos predefinidos:**
- **Admins:** Control total
- **Users:** Acceso normal a documentos

**Permisos personalizados:**
- Ver documentos
- Añadir documentos
- Editar documentos
- Eliminar documentos
- Ver configuración
- Editar configuración

### Compartir Documentos

1. Abrir documento
2. Click en **Share**
3. Seleccionar usuarios o grupos
4. Establecer permisos (ver/editar)
5. Click **Save**

---

## 🤖 Automatización

### Reglas de Procesamiento

1. Ir a **Settings** → **Workflows**
2. Click **Add workflow**
3. Configurar:

**Trigger (Disparador):**
- Document added
- Document updated
- Scheduled

**Conditions (Condiciones):**
- Correspondent is...
- Title contains...
- Content contains...
- Date is...

**Actions (Acciones):**
- Set correspondent
- Set document type
- Add tags
- Set custom fields
- Send notification

**Ejemplo: Auto-clasificar facturas**

```
Trigger: Document added
Condition: Content contains "FACTURA"
Actions:
  - Set document type: Factura
  - Add tag: Contabilidad
  - Set correspondent: (extraer de contenido)
```

### Importación por Email

Configurar en `docker-compose.yml`:

```yaml
environment:
  PAPERLESS_EMAIL_TASK_CRON: "*/15 * * * *"
  PAPERLESS_EMAIL_HOST: imap.gmail.com
  PAPERLESS_EMAIL_PORT: 993
  PAPERLESS_EMAIL_HOST_USER: tu-email@gmail.com
  PAPERLESS_EMAIL_HOST_PASSWORD: tu-app-password
  PAPERLESS_EMAIL_USE_SSL: "true"
```

Reiniciar:

```bash
docker compose up -d
```

Enviar documentos a tu email con asunto específico y Paperless los importará automáticamente.

---

## 💾 Backups

### Backup Manual

```bash
# Backup completo
cd /opt/stacks/paperless
tar -czf /root/paperless-backup-$(date +%F).tar.gz data/ media/ postgres/

# Backup solo de documentos
tar -czf /root/paperless-media-$(date +%F).tar.gz media/
```

### Backup Automático

```bash
# Crear script de backup
cat > /root/scripts/backup-paperless.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/paperless"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup de PostgreSQL
docker exec paperless-db pg_dump -U paperless paperless > $BACKUP_DIR/paperless-db-$DATE.sql

# Backup de archivos
tar -czf $BACKUP_DIR/paperless-data-$DATE.tar.gz -C /opt/stacks/paperless data/ media/

# Mantener solo los últimos 30 backups
find $BACKUP_DIR -name "paperless-*" -mtime +30 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /root/scripts/backup-paperless.sh

# Añadir a crontab (diario a las 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /root/scripts/backup-paperless.sh") | crontab -
```

### Exportar Documentos

Desde la interfaz web:

1. Seleccionar documentos
2. Click en **Actions** → **Download**
3. Seleccionar formato:
   - **Original:** Archivo original
   - **Archive:** PDF/A (preservación a largo plazo)
   - **Both:** Ambos

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Paperless
   - **URL:** `https://paperless.home.arpa`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs en tiempo real
docker logs -f paperless

# Ver logs de OCR
docker logs paperless | grep -i ocr

# Ver logs de consumo
docker logs paperless | grep -i consume
```

### Estadísticas

En la interfaz web:

1. Ir a **Dashboard**
2. Ver:
   - Total de documentos
   - Documentos por mes
   - Documentos por correspondent
   - Documentos por tipo
   - Espacio utilizado

---

## ✅ Verificación

### Test de Subida

1. Subir un PDF de prueba
2. Verificar que aparece en la lista
3. Verificar que el OCR extrajo el texto
4. Buscar una palabra del documento

### Test de OCR

1. Subir una imagen escaneada
2. Esperar a que se procese
3. Abrir el documento
4. Verificar que el texto es seleccionable

### Test de Búsqueda

1. Buscar una palabra específica
2. Verificar que encuentra documentos
3. Probar búsqueda avanzada con filtros

---

## 🆘 Troubleshooting

### OCR no funciona

**Causa:** Idiomas OCR no instalados.

**Solución:**

```bash
# Verificar idiomas instalados
docker exec paperless tesseract --list-langs

# Si falta español, reinstalar
docker compose down
docker compose up -d
```

### Documentos no se procesan

**Causa:** Permisos incorrectos en carpeta consume.

**Solución:**

```bash
# Verificar permisos
ls -la /opt/stacks/paperless/consume

# Corregir permisos
chmod 777 /opt/stacks/paperless/consume
docker restart paperless
```

### Error de base de datos

**Causa:** PostgreSQL no arrancó correctamente.

**Solución:**

```bash
# Verificar logs
docker logs paperless-db

# Reiniciar base de datos
docker restart paperless-db
docker restart paperless
```

### No puedo acceder desde la web

**Causa:** Proxy no configurado correctamente.

**Solución:**

1. Verificar DNS:
   ```bash
   nslookup paperless.home.arpa
   ```

2. Verificar proxy en NPM

3. Verificar que el contenedor está corriendo:
   ```bash
   docker ps | grep paperless
   ```

---

## 🔗 Recursos Relacionados

- [CT112 - Nginx Proxy Manager](../04-core-services/ct112-proxy.md)
- [Red Privada](../03-networking/private-network.md)
- [Backups](../06-storage-backup/local-backups.md)
- [SSO en Paperless](../09-authentication/) (próximamente)

---

## 📚 Referencias

- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Paperless-ngx GitHub](https://github.com/paperless-ngx/paperless-ngx)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
