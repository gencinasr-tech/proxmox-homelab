# CT102 - Portainer (Docker Management)

Plataforma de gestión centralizada para todos los contenedores Docker del homelab.

## 📋 Información del Contenedor

- **ID:** CT102
- **Hostname:** portainer
- **IP LAN:** 192.168.1.80
- **OS:** Debian 12
- **Recursos:** 1 CPU, 1GB RAM, 12GB disco
- **Red:** vmbr0 (Red LAN)
- **Gateway:** 192.168.1.1

## 🎯 Propósito

Portainer proporciona:
- 🐳 Gestión centralizada de Docker
- 📊 Visualización de contenedores, imágenes, volúmenes y redes
- 🚀 Despliegue de stacks con Docker Compose
- 👥 Control de acceso por equipos y usuarios
- 📈 Monitoreo de recursos en tiempo real
- 🔄 Actualización de contenedores
- 📝 Logs y consola de contenedores
- 🌐 Gestión de múltiples entornos Docker

## 🔒 Seguridad

- **Criticidad:** CRÍTICA (acceso a todos los contenedores)
- **Acceso:** HTTPS (https://portainer.home.arpa)
- **Autenticación:** Usuario/contraseña + 2FA opcional
- **Backups:** Configuración y datos

---

## 🧱 Instalación Paso a Paso

### 1. Crear el Contenedor en Proxmox

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
CT ID: 102
Hostname: portainer
Template: debian-12-standard
Disco: 12 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Red: vmbr0
IP: 192.168.1.80/24
Gateway: 192.168.1.1
DNS: 192.168.1.53
Opciones: Unprivileged + Nesting habilitado
```

### 2. Verificar Conectividad

Acceder al contenedor:

```bash
pct enter 102

# Verificar red
ip a
ip route
ping -c 3 192.168.1.1
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

### 4. Instalar Portainer CE

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
      - "8000:8000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/stacks/portainer/data:/data
    environment:
      - TZ=Europe/Madrid
EOF

docker compose up -d

# Verificar
docker ps
docker logs -f portainer
```

**Acceso inicial:** `https://192.168.1.80:9443`

### 5. Configuración Inicial

1. Acceder a `https://192.168.1.80:9443`
2. Aceptar el certificado autofirmado (temporal)
3. Crear usuario administrador:
   - **Username:** admin
   - **Password:** contraseña muy segura (mínimo 12 caracteres)
4. Click **Create user**

5. En la pantalla de bienvenida:
   - Seleccionar **Get Started**
   - Portainer detecta automáticamente el Docker local

---

## 🔗 Añadir Entornos Docker

Portainer puede gestionar múltiples entornos Docker remotos usando **Portainer Agent**.

### 1. Instalar Portainer Agent en Cada Contenedor/VM

**Ejecutar en cada CT/VM con Docker:**

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

### 2. Añadir Entornos en Portainer

Para cada entorno:

1. Login en Portainer
2. Ir a **Environments** → **Add environment**
3. Seleccionar **Agent**
4. Configurar:
   - **Name:** Nombre descriptivo (ej: `CT101-dashboard`)
   - **Environment URL:** `tcp://IP:9001` (ej: `tcp://192.168.1.79:9001`)
5. Click **Add environment**

### 3. Lista de Entornos a Añadir

**Red LAN (vmbr0):**
- `CT101-dashboard` → `tcp://192.168.1.79:9001`
- `CT102-portainer` → `tcp://192.168.1.80:9001` (local, ya existe)
- `VM104-casaos-nas` → `tcp://192.168.1.81:9001`

**Red Privada (vmbr10):**
- `CT105-monitoring` → `tcp://10.10.10.50:9001`
- `CT106-vaultwarden` → `tcp://10.10.10.60:9001`
- `CT107-paperless` → `tcp://10.10.10.40:9001`
- `CT108-nextcloud` → `tcp://10.10.10.65:9001`
- `VM109-immich` → `tcp://10.10.10.30:9001`
- `CT110-tools` → `tcp://10.10.10.70:9001`
- `CT113-identity` → `tcp://10.10.10.74:9001`
- `CT114-music` → `tcp://10.10.10.82:9001`
- `CT115-downloads` → `tcp://10.10.10.83:9001`

**Nota:** Para acceder a la red privada desde CT102 (LAN), necesitas configurar rutas estáticas (ver sección de Networking).

---

## 🚀 Uso Básico

### Gestionar Contenedores

1. Seleccionar entorno en el menú lateral
2. Ir a **Containers**
3. Ver lista de contenedores con estado, recursos, puertos

**Acciones disponibles:**
- ▶️ Start / ⏸️ Stop / 🔄 Restart
- 📊 Stats (uso de CPU, RAM, red)
- 📝 Logs (ver logs en tiempo real)
- 🖥️ Console (acceder a shell del contenedor)
- 🔍 Inspect (ver configuración completa)
- ✏️ Duplicate/Remove

### Desplegar Stacks

1. Seleccionar entorno
2. Ir a **Stacks** → **Add stack**
3. Configurar:
   - **Name:** Nombre del stack
   - **Build method:** 
     - **Web editor:** Pegar docker-compose.yml
     - **Upload:** Subir archivo
     - **Repository:** Desde Git
4. Pegar o escribir el docker-compose.yml
5. Click **Deploy the stack**

**Ejemplo de stack:**

```yaml
services:
  nginx:
    image: nginx:alpine
    container_name: nginx-test
    restart: unless-stopped
    ports:
      - "8080:80"
```

### Gestionar Imágenes

1. Ir a **Images**
2. Ver lista de imágenes descargadas
3. Acciones:
   - 🔽 Pull (descargar nueva imagen)
   - 🗑️ Remove (eliminar imagen)
   - 🏷️ Tag (etiquetar imagen)

### Gestionar Volúmenes

1. Ir a **Volumes**
2. Ver lista de volúmenes
3. Acciones:
   - ➕ Add volume
   - 🗑️ Remove volume
   - 🔍 Browse (explorar contenido)

### Gestionar Redes

1. Ir a **Networks**
2. Ver lista de redes Docker
3. Acciones:
   - ➕ Add network
   - 🗑️ Remove network
   - 🔍 Inspect

---

## 👥 Gestión de Usuarios y Equipos

### Crear Usuario

1. Ir a **Users** → **Add user**
2. Configurar:
   - **Username:** nombre_usuario
   - **Password:** contraseña segura
   - **Role:** 
     - **Administrator:** Acceso total
     - **User:** Acceso limitado
3. Click **Create user**

### Crear Equipo

1. Ir a **Teams** → **Add team**
2. **Name:** Nombre del equipo (ej: `Familia`, `Desarrollo`)
3. Click **Create team**

4. Añadir usuarios al equipo:
   - Click en el equipo
   - **Add user to team**
   - Seleccionar usuarios
   - Click **Add**

### Asignar Permisos

1. Ir a **Environments**
2. Click en un entorno
3. **Access control**
4. Añadir equipos/usuarios con permisos específicos

---

## 🔐 Seguridad

### Habilitar 2FA

1. Ir a **My account** (icono de usuario)
2. **Two-factor authentication**
3. Click **Enable**
4. Escanear QR con app de autenticación (Google Authenticator, Authy)
5. Introducir código de verificación
6. Guardar códigos de recuperación

### Cambiar Contraseña

1. Ir a **My account**
2. **Change password**
3. Introducir contraseña actual y nueva
4. Click **Change password**

### Configurar HTTPS con Certificado Válido

Ver sección de configuración de proxy más abajo.

---

## ⚙️ Configuración de DNS y Proxy

### 1. Configurar DNS en AdGuard Home

Asegurar que existe el DNS Rewrite:
- **Dominio:** `portainer.home.arpa`
- **IP:** `192.168.1.82` (Nginx Proxy Manager)

### 2. Configurar Proxy en Nginx Proxy Manager

Acceder a `http://192.168.1.82:81` y crear Proxy Host:

**Detalles:**
- **Domain Names:** `portainer.home.arpa`
- **Scheme:** `https`
- **Forward Hostname/IP:** `192.168.1.80`
- **Forward Port:** `9443`
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

# Importante para Portainer
proxy_http_version 1.1;
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection "upgrade";
```

**Guardar y verificar:**

```bash
curl -k -I https://portainer.home.arpa
```

---

## 🔄 Actualizar Portainer

### Método 1: Desde Portainer UI

1. Ir a **Containers**
2. Seleccionar contenedor `portainer`
3. Click en **Recreate**
4. **Pull latest image:** ✅ ON
5. Click **Recreate**

### Método 2: Desde CLI

```bash
cd /opt/stacks/portainer

# Pull nueva imagen
docker compose pull

# Recrear contenedor
docker compose up -d

# Verificar
docker ps
docker logs portainer
```

---

## 💾 Backups

### Backup Manual

```bash
# Backup de datos de Portainer
cd /opt/stacks/portainer
tar -czf /root/portainer-backup-$(date +%F).tar.gz data/

# Backup de configuración
cp docker-compose.yml /root/portainer-compose-$(date +%F).yml
```

### Backup Automático

```bash
# Crear script de backup
cat > /root/scripts/backup-portainer.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/portainer"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup de datos
tar -czf $BACKUP_DIR/portainer-data-$DATE.tar.gz -C /opt/stacks/portainer data/

# Backup de configuración
cp /opt/stacks/portainer/docker-compose.yml $BACKUP_DIR/docker-compose-$DATE.yml

# Mantener solo los últimos 30 backups
find $BACKUP_DIR -name "portainer-*" -mtime +30 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /root/scripts/backup-portainer.sh

# Añadir a crontab (diario a las 3 AM)
(crontab -l 2>/dev/null; echo "0 3 * * * /root/scripts/backup-portainer.sh") | crontab -
```

### Restaurar Backup

```bash
# Detener Portainer
cd /opt/stacks/portainer
docker compose down

# Restaurar datos
tar -xzf /root/backups/portainer/portainer-data-FECHA.tar.gz -C /opt/stacks/portainer/

# Reiniciar Portainer
docker compose up -d
```

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Portainer
   - **URL:** `https://portainer.home.arpa`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs en tiempo real
docker logs -f portainer

# Ver últimas 100 líneas
docker logs --tail 100 portainer

# Buscar errores
docker logs portainer | grep -i error
```

---

## ✅ Verificación

### Test de Acceso

1. Acceder a `https://portainer.home.arpa`
2. Login con tu cuenta
3. Verificar que aparecen todos los entornos

### Test de Gestión

1. Seleccionar un entorno
2. Ir a **Containers**
3. Verificar que aparecen los contenedores
4. Intentar ver logs de un contenedor
5. Verificar que funciona

### Test de Despliegue

1. Crear un stack de prueba
2. Desplegarlo
3. Verificar que se crea correctamente
4. Eliminarlo

---

## 🆘 Troubleshooting

### No puedo acceder a Portainer

**Causa:** Servicio no está corriendo o problema de red.

**Solución:**

```bash
# Verificar que el contenedor está corriendo
docker ps | grep portainer

# Si no está corriendo, iniciarlo
cd /opt/stacks/portainer
docker compose up -d

# Verificar logs
docker logs portainer
```

### No puedo añadir entorno remoto

**Causa:** Portainer Agent no está corriendo o problema de red.

**Solución:**

1. Verificar que el agent está corriendo en el entorno remoto:
   ```bash
   docker ps | grep portainer-agent
   ```

2. Verificar conectividad:
   ```bash
   # Desde CT102
   curl http://IP_REMOTA:9001
   ```

3. Si es un entorno en red privada, verificar rutas estáticas

### Error: "Unable to connect to the Docker endpoint"

**Causa:** Problema con el socket de Docker.

**Solución:**

```bash
# Verificar permisos del socket
ls -la /var/run/docker.sock

# Reiniciar Docker
systemctl restart docker

# Reiniciar Portainer
docker restart portainer
```

### Contenedores no aparecen en Portainer

**Causa:** Portainer no tiene acceso al socket de Docker.

**Solución:**

Verificar que el volumen está montado correctamente en docker-compose.yml:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

---

## 🔗 Recursos Relacionados

- [CT101 - Dashboard](ct101-dashboards.md)
- [CT105 - Monitoring](ct105-monitoring.md)
- [Red LAN](../03-networking/lan-network.md)
- [Red Privada](../03-networking/private-network.md)

---

## 📚 Referencias

- [Portainer Documentation](https://docs.portainer.io/)
- [Portainer CE vs BE](https://www.portainer.io/pricing)
- [Docker Documentation](https://docs.docker.com/)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
