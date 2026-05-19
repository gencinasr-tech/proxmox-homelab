# CT106 - Vaultwarden (Password Manager)

Gestor de contraseñas autoalojado compatible con Bitwarden, con acceso seguro vía Tailscale HTTPS.

## 📋 Información del Contenedor

- **ID:** CT106
- **Hostname:** vaultwarden
- **IP Privada:** 10.10.10.60
- **OS:** Debian 12
- **Recursos:** 1 CPU, 1GB RAM, 12GB disco
- **Red:** vmbr10 (Red Privada)
- **Gateway:** 10.10.10.87

## 🎯 Propósito

Vaultwarden proporciona:
- 🔐 Gestión centralizada de contraseñas
- 👥 Compartir contraseñas de forma segura
- 📱 Sincronización entre dispositivos
- 🔑 Generador de contraseñas seguras
- 🛡️ 2FA y autenticación fuerte
- 📊 Auditoría de contraseñas débiles
- 🌐 Acceso vía Tailscale con HTTPS nativo

## 🔒 Seguridad

- **Criticidad:** CRÍTICA (almacena todas las contraseñas)
- **Acceso:** Solo vía Tailscale VPN con HTTPS
- **Backups:** Diarios automáticos cifrados
- **Registros:** Deshabilitados (solo invitaciones)
- **Admin Panel:** Protegido con token

---

## 🧱 Instalación Paso a Paso

### 1. Crear el Contenedor en Proxmox

Desde la interfaz web de Proxmox:

```bash
# Valores de configuración:
CT ID: 106
Hostname: vaultwarden
Template: debian-12-standard
Disco: 12 GB
CPU: 1 core
RAM: 1024 MB
Swap: 512 MB
Red: vmbr10
IP: 10.10.10.60/24
Gateway: 10.10.10.87
DNS: 192.168.1.53
Opciones: Unprivileged + Nesting habilitado
```

### 2. Configurar Permisos TUN para Tailscale

**Desde el host Proxmox:**

```bash
# Añadir permisos TUN al CT 106
cat >> /etc/pve/lxc/106.conf <<'EOF'
lxc.cgroup2.devices.allow: c 10:200 rwm
lxc.mount.entry: /dev/net/tun dev/net/tun none bind,create=file
EOF

# Reiniciar el contenedor
pct stop 106
pct start 106
```

### 3. Verificar Conectividad

Acceder al contenedor:

```bash
pct enter 106

# Verificar red
ip a
ip route
ping -c 3 10.10.10.87
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### 4. Instalar Docker y Docker Compose

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

### 5. Instalar Tailscale

```bash
# Instalar Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Iniciar servicio
systemctl enable tailscaled
systemctl restart tailscaled

# Conectar a Tailscale
tailscale up --hostname=vaultwarden

# Verificar estado
tailscale status
```

**Importante:** Autorizar el dispositivo en la [consola web de Tailscale](https://login.tailscale.com/admin/machines).

### 6. Generar Token de Admin

```bash
# Generar token seguro
openssl rand -base64 48

# Guardar el token (IMPORTANTE: guardar en un lugar seguro temporalmente)
```

**Ejemplo de token:**
```
xK9mP2nQ5rT8wY1zA4bC6dE7fG0hJ3kL5mN8pR1sT4vW6xY9zA2bC5dE8fG1hJ4k
```

### 7. Crear Stack de Vaultwarden

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

# Reemplazar el token
nano docker-compose.yml
# Sustituir PEGA_AQUI_TU_TOKEN con el token generado

# Levantar el servicio
docker compose up -d

# Verificar
docker ps
docker logs vaultwarden
```

### 8. Configurar Tailscale Serve (HTTPS)

Tailscale Serve proporciona HTTPS automático con certificados válidos:

```bash
# Activar Tailscale Serve
tailscale serve --bg --https=443 127.0.0.1:8080

# Verificar configuración
tailscale serve status
```

**Salida esperada:**
```
https://vaultwarden.tailXXXX.ts.net (tailnet only)
|-- / proxy http://127.0.0.1:8080
```

**Anotar la URL completa** (ejemplo: `https://vaultwarden.tailfcb362.ts.net`)

### 9. Configurar Dominio en Vaultwarden

Vaultwarden necesita conocer su URL pública para funcionar correctamente:

```bash
cd /opt/stacks/vaultwarden

# Backup del archivo
cp docker-compose.yml docker-compose.yml.bak

# Añadir variable DOMAIN (sustituir con tu URL de Tailscale)
sed -i '/DOMAIN=/d' docker-compose.yml
sed -i '/TZ=Europe\/Madrid/a\      - DOMAIN=https://vaultwarden.tailfcb362.ts.net' docker-compose.yml

# Reiniciar servicio
docker compose down && docker compose up -d
```

### 10. Crear Primer Usuario

**Abrir registros temporalmente:**

```bash
cd /opt/stacks/vaultwarden

# Habilitar registros
sed -i 's/SIGNUPS_ALLOWED=false/SIGNUPS_ALLOWED=true/' docker-compose.yml
docker compose down && docker compose up -d
```

**Crear cuenta:**

1. Acceder a `https://vaultwarden.tailfcb362.ts.net/#/register` (sustituir con tu URL)
2. Crear cuenta con:
   - Email
   - Nombre
   - Contraseña maestra (MUY SEGURA)
   - Hint (opcional)
3. Click en **Submit**

**Cerrar registros:**

```bash
# Deshabilitar registros
sed -i 's/SIGNUPS_ALLOWED=true/SIGNUPS_ALLOWED=false/' docker-compose.yml
docker compose down && docker compose up -d
```

### 11. Instalar Portainer Agent

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
- Name: `CT106-vaultwarden`
- Environment URL: `tcp://10.10.10.60:9001`

---

## 🔐 Configuración Inicial

### Acceder al Panel de Admin

1. Acceder a `https://vaultwarden.tailfcb362.ts.net/admin`
2. Introducir el **Admin Token**
3. Configurar:

**General Settings:**
- **Domain URL:** `https://vaultwarden.tailfcb362.ts.net`
- **Allow new signups:** ❌ OFF
- **Allow invitations:** ✅ ON (para invitar usuarios)
- **Require email verification:** ✅ ON (recomendado)

**SMTP Settings (Opcional pero recomendado):**
- **SMTP Host:** smtp.gmail.com
- **SMTP Port:** 587
- **SMTP Security:** STARTTLS
- **SMTP Username:** tu-email@gmail.com
- **SMTP Password:** [App Password de Gmail]
- **SMTP From:** tu-email@gmail.com

**Advanced Settings:**
- **Websocket enabled:** ✅ ON
- **Enable password hints:** ❌ OFF (seguridad)
- **Show password hints:** ❌ OFF

4. Click **Save**

### Invitar Usuarios

1. Acceder al panel de admin
2. Ir a **Users** → **Invite User**
3. Introducir email del usuario
4. Click **Invite**
5. El usuario recibirá un email con el enlace de registro

---

## 📱 Configuración de Clientes

### Extensión de Navegador

**Chrome/Edge/Brave:**
1. Ir a [Chrome Web Store](https://chrome.google.com/webstore/detail/bitwarden/nngceckbapebfimnlniiiahkandclblb)
2. Instalar extensión "Bitwarden"
3. Click en el icono de Bitwarden
4. Click en ⚙️ (Settings)
5. **Server URL:** `https://vaultwarden.tailfcb362.ts.net`
6. Click **Save**
7. Login con tu cuenta

**Firefox:**
1. Ir a [Firefox Add-ons](https://addons.mozilla.org/firefox/addon/bitwarden-password-manager/)
2. Seguir los mismos pasos

### App Móvil

**Android:**
1. Instalar desde [Google Play Store](https://play.google.com/store/apps/details?id=com.x8bit.bitwarden)
2. Abrir la app
3. Click en ⚙️ (arriba a la izquierda)
4. **Server URL:** `https://vaultwarden.tailfcb362.ts.net`
5. Click en ← (volver)
6. Login con tu cuenta

**iOS:**
1. Instalar desde [App Store](https://apps.apple.com/app/bitwarden-password-manager/id1137397744)
2. Seguir los mismos pasos

**Importante:** El dispositivo debe estar conectado a Tailscale para acceder.

### App de Escritorio

**Windows/Mac/Linux:**
1. Descargar desde [bitwarden.com/download](https://bitwarden.com/download/)
2. Instalar y abrir
3. Click en **Settings** (icono de engranaje)
4. **Server URL:** `https://vaultwarden.tailfcb362.ts.net`
5. Click **Save**
6. Login con tu cuenta

### CLI (Línea de Comandos)

```bash
# Instalar Bitwarden CLI
npm install -g @bitwarden/cli

# Configurar servidor
bw config server https://vaultwarden.tailfcb362.ts.net

# Login
bw login

# Desbloquear vault
bw unlock

# Listar items
bw list items

# Obtener contraseña
bw get password "nombre-del-item"
```

---

## 🔒 Seguridad Avanzada

### Habilitar 2FA

1. Login en Vaultwarden web
2. Ir a **Settings** → **Two-step Login**
3. Seleccionar método:
   - **Authenticator App** (recomendado): Google Authenticator, Authy
   - **Email:** Código por email
   - **YubiKey:** Llave de seguridad física

4. Seguir las instrucciones
5. Guardar códigos de recuperación en lugar seguro

### Auditoría de Contraseñas

1. Login en Vaultwarden web
2. Ir a **Tools** → **Vault Health Reports**
3. Revisar:
   - **Exposed Passwords:** Contraseñas filtradas en brechas
   - **Reused Passwords:** Contraseñas reutilizadas
   - **Weak Passwords:** Contraseñas débiles
   - **Unsecured Websites:** Sitios sin HTTPS

4. Actualizar contraseñas problemáticas

### Organizaciones (Compartir)

Para compartir contraseñas con familia/equipo:

1. Ir a **Settings** → **Organizations**
2. Click **New Organization**
3. **Name:** Familia / Trabajo
4. **Billing Email:** tu-email@example.com
5. Click **Submit**

6. Ir a **Manage** → **People**
7. Click **Invite User**
8. Introducir email
9. Seleccionar permisos
10. Click **Save**

---

## 💾 Backups

### Backup Manual

```bash
# Backup de datos
cd /opt/stacks/vaultwarden
tar -czf /root/vaultwarden-backup-$(date +%F).tar.gz data/

# Backup de configuración
cp docker-compose.yml /root/vaultwarden-compose-$(date +%F).yml
```

### Backup Automático

```bash
# Crear script de backup
cat > /root/scripts/backup-vaultwarden.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/vaultwarden"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup de datos
tar -czf $BACKUP_DIR/vaultwarden-data-$DATE.tar.gz -C /opt/stacks/vaultwarden data/

# Backup de configuración
cp /opt/stacks/vaultwarden/docker-compose.yml $BACKUP_DIR/docker-compose-$DATE.yml

# Mantener solo los últimos 30 backups
find $BACKUP_DIR -name "vaultwarden-*" -mtime +30 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /root/scripts/backup-vaultwarden.sh

# Añadir a crontab (diario a las 3 AM)
(crontab -l 2>/dev/null; echo "0 3 * * * /root/scripts/backup-vaultwarden.sh") | crontab -
```

### Exportar Vault (Desde la Web)

1. Login en Vaultwarden
2. Ir a **Tools** → **Export Vault**
3. Seleccionar formato:
   - **.json:** Formato completo (recomendado)
   - **.csv:** Compatible con otros gestores
   - **.json (Encrypted):** Cifrado con contraseña
4. Click **Export Vault**
5. **Guardar en lugar seguro** (el archivo contiene todas tus contraseñas)

---

## 📊 Monitorización

### Añadir a Uptime Kuma

1. Acceder a Uptime Kuma
2. Añadir monitor:
   - **Type:** HTTP(s)
   - **Friendly Name:** Vaultwarden
   - **URL:** `https://vaultwarden.tailfcb362.ts.net`
   - **Heartbeat Interval:** 60 segundos

### Logs

```bash
# Ver logs en tiempo real
docker logs -f vaultwarden

# Ver últimas 100 líneas
docker logs --tail 100 vaultwarden

# Buscar errores
docker logs vaultwarden | grep -i error
```

---

## ✅ Verificación

### Test de Acceso

1. Desde un dispositivo conectado a Tailscale
2. Acceder a `https://vaultwarden.tailfcb362.ts.net`
3. Verificar que carga la página de login
4. Login con tu cuenta
5. Verificar que se sincronizan las contraseñas

### Test de Sincronización

1. Añadir una contraseña desde la web
2. Abrir la extensión del navegador
3. Verificar que aparece la nueva contraseña
4. Abrir la app móvil
5. Verificar que se sincronizó

### Test de 2FA

1. Cerrar sesión
2. Intentar login
3. Verificar que pide código 2FA
4. Introducir código
5. Verificar acceso

---

## 🆘 Troubleshooting

### No puedo acceder a Vaultwarden

**Causa:** No estás conectado a Tailscale.

**Solución:**

1. Verificar conexión a Tailscale:
   ```bash
   tailscale status
   ```

2. Si no está conectado:
   ```bash
   tailscale up
   ```

3. Verificar que el dispositivo está autorizado en la consola de Tailscale

### Error: "Invalid master password"

**Causa:** Contraseña maestra incorrecta.

**Solución:**

1. Verificar que estás usando la contraseña correcta
2. Si la olvidaste, NO hay forma de recuperarla (por diseño de seguridad)
3. Tendrás que crear una cuenta nueva

### Extensión no se conecta al servidor

**Causa:** URL del servidor incorrecta.

**Solución:**

1. Abrir configuración de la extensión
2. Verificar que la URL es exactamente: `https://vaultwarden.tailfcb362.ts.net`
3. No debe tener `/` al final
4. Guardar y reintentar

### No puedo invitar usuarios

**Causa:** SMTP no configurado.

**Solución:**

1. Acceder al panel de admin
2. Configurar SMTP (ver sección de configuración)
3. Probar envío de email de prueba
4. Guardar configuración

### Servicio no arranca después de reinicio

**Causa:** Tailscale no está activo.

**Solución:**

```bash
# Verificar estado de Tailscale
systemctl status tailscaled

# Si no está activo
systemctl start tailscaled
tailscale up

# Reiniciar Vaultwarden
cd /opt/stacks/vaultwarden
docker compose restart
```

---

## 🔗 Recursos Relacionados

- [CT100 - Tailscale](../04-core-services/ct100-tailscale.md)
- [Red Privada](../03-networking/private-network.md)
- [Backups](../06-storage-backup/local-backups.md)
- [Recuperación de Desastres](../11-maintenance/disaster-recovery.md)

---

## 📚 Referencias

- [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
- [Bitwarden Help Center](https://bitwarden.com/help/)
- [Tailscale Serve Documentation](https://tailscale.com/kb/1242/tailscale-serve/)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](../reference/inventory.md)
