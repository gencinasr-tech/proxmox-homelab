# 🐳 CT102 - Portainer

Plataforma de gestión visual para Docker con múltiples agentes distribuidos.

## 📋 Información del Contenedor

| Parámetro | Valor |
|-----------|-------|
| **ID** | 102 |
| **Hostname** | portainer |
| **Tipo** | LXC Container (Unprivileged) |
| **OS** | Debian 13 (Trixie) |
| **CPU** | 1 core |
| **RAM** | 1024 MB |
| **Swap** | 512 MB |
| **Disco** | 12 GB |
| **Red** | vmbr0 - 192.168.1.80/24 (LAN) |
| **Gateway** | 192.168.1.1 |
| **DNS** | 1.1.1.1 |
| **Autostart** | ✅ Recomendado |

## 🎯 Propósito

CT102 es el **centro de gestión Docker** del homelab:

1. **Gestión Centralizada**: Control de todos los contenedores Docker
2. **Múltiples Agentes**: Gestiona 14 environments distribuidos
3. **Interfaz Visual**: Deploy de stacks, gestión de imágenes, volúmenes
4. **Monitoreo**: Estado y logs de contenedores en tiempo real
5. **Seguridad**: Control de acceso y gestión de usuarios

## 🏗️ Arquitectura

```
Portainer CE (CT102 - 192.168.1.80:9443)
│
├── Local Environment
│   └── Gestiona contenedores en CT102
│
└── Remote Agents (14 environments)
    │
    ├── LAN Network (192.168.1.x)
    │   ├── CT101-dashboard (192.168.1.79:9001)
    │   ├── VM104-casaos-nas (192.168.1.81:9001)
    │   └── CT112-proxy (192.168.1.82:9001)
    │
    └── Private Network (10.10.10.x)
        ├── CT105-monitoring (10.10.10.50:9001)
        ├── CT106-vaultwarden (10.10.10.60:9001)
        ├── CT107-paperless (10.10.10.40:9001)
        ├── CT108-nextcloud (10.10.10.65:9001)
        ├── VM109-immich (10.10.10.30:9001)
        ├── CT110-tools (10.10.10.70:9001)
        ├── CT111-databases (10.10.10.73:9001)
        ├── CT113-identity (10.10.10.74:9001)
        ├── CT114-music (10.10.10.82:9001)
        └── CT115-downloads (10.10.10.83:9001)
```

## 📦 Instalación

### Paso 1: Crear el Contenedor

En Proxmox Web UI: `Crear CT`

**Configuración General:**
```
CT ID: 102
Hostname: portainer
Unprivileged container: ✅
Nesting: ✅
Start at boot: ✅
```

**Template:**
```
Storage: local
Template: debian-13-standard
```

**Discos:**
```
Storage: local-lvm
Disk size: 12 GB
```

**CPU:**
```
Cores: 1
```

**Memoria:**
```
Memory: 1024 MB
Swap: 512 MB
```

**Red:**
```
Bridge: vmbr0
IPv4: 192.168.1.80/24
Gateway: 192.168.1.1
```

**DNS:**
```
DNS servers: 1.1.1.1
```

### Paso 2: Configuración Inicial

**Acceder al contenedor:**

```bash
# Desde Proxmox Shell
pct enter 102

# O desde SSH
ssh root@192.168.1.80
```

**Verificar red:**

```bash
ip addr show
ip route
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### Paso 3: Instalar Docker

```bash
# Actualizar sistema
apt update
apt upgrade -y

# Instalar dependencias
apt install -y ca-certificates curl gnupg lsb-release nano htop git

# Añadir repositorio Docker
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

# Instalar Docker
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Habilitar Docker
systemctl enable --now docker

# Verificar instalación
docker version
docker compose version
```

### Paso 4: Configurar Ruta a Red Privada

Para gestionar agentes en la red privada:

```bash
# Añadir ruta temporal
ip route add 10.10.10.0/24 via 192.168.1.87

# Hacer permanente
cat >> /etc/network/interfaces <<'EOF'

post-up ip route add 10.10.10.0/24 via 192.168.1.87 || true
pre-down ip route del 10.10.10.0/24 via 192.168.1.87 || true
EOF

# Verificar conectividad
ping -c 2 10.10.10.50   # CT105 Monitoring
ping -c 2 10.10.10.60   # CT106 Vaultwarden
```

### Paso 5: Instalar Portainer CE

```bash
# Crear estructura de directorios
mkdir -p /opt/stacks/portainer
cd /opt/stacks/portainer

# Crear docker-compose.yml
cat > docker-compose.yml <<'EOF'
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9443:9443"   # HTTPS UI
      - "9000:9000"   # HTTP UI (opcional)
      - "8000:8000"   # Edge Agent (opcional)
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /opt/stacks/portainer/data:/data
    environment:
      - TZ=Europe/Madrid
EOF

# Iniciar Portainer
docker compose up -d

# Verificar que está corriendo
docker ps
docker logs portainer
```

### Paso 6: Configuración Inicial de Portainer

1. **Acceder a la interfaz web:**
   ```
   https://192.168.1.80:9443
   ```

2. **Crear usuario administrador:**
   - Username: `admin` (o tu preferencia)
   - Password: Contraseña fuerte (mínimo 12 caracteres)
   - Guardar en Vaultwarden

3. **Seleccionar entorno:**
   - Marcar `Get Started` para gestionar el Docker local

4. **Configurar:**
   - Nombre del environment: `CT102-portainer`
   - Guardar

## 🔗 Conectar Agentes

### Añadir Environment con Agent

Para cada contenedor/VM con Docker:

1. **En Portainer, ir a `Environments > Add environment`**

2. **Seleccionar `Docker Standalone`**

3. **Seleccionar `Agent`**

4. **Configurar:**
   ```
   Name: CT101-dashboard
   Environment URL: tcp://192.168.1.79:9001
   ```

5. **Click en `Add environment`**

### Lista Completa de Agents

Añadir estos environments uno por uno:

| Name | URL | Red | Notas |
|------|-----|-----|-------|
| CT101-dashboard | tcp://192.168.1.79:9001 | LAN | Dashboards |
| VM104-casaos-nas | tcp://192.168.1.81:9001 | LAN | NAS |
| CT105-monitoring | tcp://10.10.10.50:9001 | Privada | Monitoring |
| CT106-vaultwarden | tcp://10.10.10.60:9001 | Privada | Passwords |
| CT107-paperless | tcp://10.10.10.40:9001 | Privada | Documentos |
| CT108-nextcloud | tcp://10.10.10.65:9001 | Privada | Cloud |
| VM109-immich | tcp://10.10.10.30:9001 | Privada | Fotos |
| CT110-tools | tcp://10.10.10.70:9001 | Privada | Herramientas |
| CT111-databases | tcp://10.10.10.73:9001 | Privada | Bases de datos |
| CT112-proxy | tcp://192.168.1.82:9001 | LAN | Reverse proxy |
| CT113-identity | tcp://10.10.10.74:9001 | Privada | Keycloak SSO |
| CT114-music | tcp://10.10.10.82:9001 | Privada | Navidrome |
| CT115-downloads | tcp://10.10.10.83:9001 | Privada | Descargas |

## 🎯 Uso de Portainer

### Gestionar Contenedores

**Ver contenedores:**
1. Seleccionar environment
2. Ir a `Containers`
3. Ver estado, recursos, logs

**Acciones disponibles:**
- ▶️ Start / ⏸️ Stop / 🔄 Restart
- 📋 Ver logs en tiempo real
- 📊 Ver estadísticas (CPU, RAM, red)
- 🔍 Inspeccionar configuración
- 💻 Abrir consola interactiva

### Desplegar Stacks

**Desde Git:**
1. Ir a `Stacks > Add stack`
2. Seleccionar `Git Repository`
3. Configurar:
   ```
   Repository URL: https://github.com/usuario/repo
   Repository reference: main
   Compose path: docker-compose.yml
   ```
4. Deploy

**Desde Web Editor:**
1. Ir a `Stacks > Add stack`
2. Seleccionar `Web editor`
3. Pegar docker-compose.yml
4. Deploy

**Desde Upload:**
1. Ir a `Stacks > Add stack`
2. Seleccionar `Upload`
3. Subir docker-compose.yml
4. Deploy

### Gestionar Imágenes

**Ver imágenes:**
1. Seleccionar environment
2. Ir a `Images`
3. Ver imágenes descargadas

**Acciones:**
- 🗑️ Eliminar imágenes no usadas
- 📥 Pull nueva versión
- 🏷️ Ver tags disponibles
- 📊 Ver tamaño y capas

### Gestionar Volúmenes

**Ver volúmenes:**
1. Seleccionar environment
2. Ir a `Volumes`
3. Ver volúmenes y su uso

**Acciones:**
- 📁 Browse (explorar archivos)
- 🗑️ Eliminar volúmenes no usados
- 📊 Ver tamaño

### Gestionar Redes

**Ver redes:**
1. Seleccionar environment
2. Ir a `Networks`
3. Ver redes Docker

**Acciones:**
- ➕ Crear nueva red
- 🔗 Ver contenedores conectados
- 🗑️ Eliminar redes no usadas

## ⚙️ Configuración Avanzada

### Configurar Notificaciones

**Webhooks:**
1. `Settings > Notifications`
2. Añadir webhook (Discord, Slack, etc.)
3. Configurar eventos a notificar

### Configurar Usuarios

**Añadir usuarios:**
1. `Users > Add user`
2. Configurar:
   ```
   Username: usuario
   Password: contraseña
   Role: User / Administrator
   ```
3. Asignar environments

### Configurar Registries

**Añadir Docker Hub:**
1. `Registries > Add registry`
2. Seleccionar `DockerHub`
3. Configurar credenciales (opcional)

**Añadir registry privado:**
1. `Registries > Add registry`
2. Seleccionar `Custom registry`
3. Configurar URL y credenciales

### Configurar Auto-update

**Para stacks:**
1. Ir al stack
2. Habilitar `Auto-update`
3. Configurar webhook o polling

## ✅ Verificación

### Verificar Portainer

```bash
# Estado del contenedor
docker ps | grep portainer

# Logs
docker logs portainer -f

# Verificar puerto
ss -tulpn | grep 9443
```

### Verificar Agents

**Desde Portainer UI:**
1. Ir a `Environments`
2. Verificar que todos muestran estado `Up`
3. Click en cada uno para verificar conectividad

**Desde terminal:**
```bash
# Probar conectividad a cada agent
for ip in 192.168.1.79 192.168.1.81 10.10.10.50 10.10.10.60 10.10.10.40 10.10.10.65 10.10.10.30 10.10.10.70 10.10.10.73 192.168.1.82 10.10.10.74 10.10.10.82 10.10.10.83; do
  echo "Testing $ip:9001"
  nc -zv $ip 9001 2>&1 | grep -q succeeded && echo "✅ OK" || echo "❌ FAIL"
done
```

## 🔧 Mantenimiento

### Actualizar Portainer

```bash
cd /opt/stacks/portainer

# Descargar nueva imagen
docker compose pull

# Recrear contenedor
docker compose up -d

# Verificar versión
docker logs portainer | grep "Portainer"
```

### Backup de Configuración

```bash
# Backup manual
cd /opt/stacks/portainer
tar -czf portainer-backup-$(date +%Y%m%d).tar.gz data/

# Restaurar
tar -xzf portainer-backup-YYYYMMDD.tar.gz
docker compose restart
```

### Limpiar Recursos No Usados

**Desde Portainer UI:**
1. Seleccionar environment
2. Ir a `Host > Setup`
3. Click en `Remove unused volumes`
4. Click en `Remove unused images`

**Desde terminal:**
```bash
# En cada environment
docker system prune -a --volumes
```

## 🐛 Troubleshooting

### No puedo acceder a Portainer

**Solución:**
```bash
# Verificar que está corriendo
docker ps | grep portainer

# Ver logs
docker logs portainer --tail 50

# Reiniciar
cd /opt/stacks/portainer
docker compose restart

# Verificar puerto
ss -tulpn | grep 9443
```

### Agent no conecta

**Solución:**
```bash
# Verificar que el agent está corriendo en el host remoto
ssh root@IP_REMOTA
docker ps | grep portainer-agent

# Verificar conectividad desde Portainer
pct enter 102
ping IP_REMOTA
nc -zv IP_REMOTA 9001

# Verificar ruta estática (si es red privada)
ip route | grep 10.10.10.0
```

### Error "Cannot connect to Docker daemon"

**Solución:**
```bash
# Verificar que Docker está corriendo
systemctl status docker

# Verificar socket
ls -l /var/run/docker.sock

# Reiniciar Docker
systemctl restart docker

# Reiniciar Portainer
docker compose restart
```

### Stacks no se despliegan

**Solución:**
```bash
# Verificar sintaxis del docker-compose.yml
docker compose -f docker-compose.yml config

# Ver logs del stack en Portainer UI
# Verificar que las imágenes existen
# Verificar que los volúmenes/redes están disponibles
```

## 📊 Monitoreo

### Métricas en Portainer

**Dashboard principal:**
- Número de environments
- Contenedores corriendo/detenidos
- Uso de recursos por environment
- Stacks desplegados

**Por environment:**
- CPU usage
- Memory usage
- Network I/O
- Disk I/O

### Integración con Monitoring

Portainer puede ser monitoreado por:
- **Uptime Kuma**: Verificar que la UI está accesible
- **Prometheus**: Métricas de contenedores vía cAdvisor
- **Grafana**: Dashboards de estado de Docker

## 🔗 Recursos

- [Documentación Oficial Portainer](https://docs.portainer.io/)
- [Portainer CE vs Business](https://www.portainer.io/pricing)
- [Portainer Community](https://www.portainer.io/community)

## 📚 Próximos Pasos

Después de configurar CT102:

1. **Conectar todos los agents** → Añadir los 14 environments
2. **Configurar Monitoring** → [CT105 - Monitoring](ct105-monitoring.md)
3. **Desplegar servicios** → Usar Portainer para gestionar stacks

---

[⬅️ CT101 Dashboards](ct101-dashboards.md) | [🏠 Índice](../README.md) | [➡️ CT105 Monitoring](ct105-monitoring.md)
