# 📊 CT101 - Dashboards

Centro de control visual con múltiples dashboards para gestionar el homelab.

## 📋 Información del Contenedor

| Parámetro | Valor |
|-----------|-------|
| **ID** | 101 |
| **Hostname** | dashboard |
| **Tipo** | LXC Container (Unprivileged) |
| **OS** | Debian 13 (Trixie) |
| **CPU** | 1 core |
| **RAM** | 1024 MB |
| **Swap** | 512 MB |
| **Disco** | 12 GB |
| **Red** | vmbr0 - 192.168.1.79/24 (LAN) |
| **Gateway** | 192.168.1.1 |
| **DNS** | 1.1.1.1 |
| **Autostart** | ✅ Recomendado |

## 🎯 Propósito

CT101 es el **centro de control visual** del homelab, proporcionando:

1. **Homepage**: Dashboard principal con widgets y servicios
2. **Homarr**: Dashboard moderno con integración Docker
3. **Homer**: Dashboard minimalista y rápido
4. **Heimdall**: Dashboard tipo app launcher
5. **Gestión Centralizada**: Acceso rápido a todos los servicios

## 🏗️ Arquitectura

```
CT101 Dashboard (192.168.1.79)
│
├── Homepage (puerto 3000)
│   ├── Widgets personalizables
│   ├── Integración Docker
│   └── Bookmarks organizados
│
├── Homarr v1 (puerto 7575)
│   ├── Widgets avanzados
│   ├── Integración Docker vía socket-proxy
│   ├── SSO con Keycloak
│   └── Temas personalizables
│
├── Homer (puerto 8080)
│   ├── Configuración YAML
│   ├── Búsqueda rápida
│   └── Temas predefinidos
│
├── Heimdall (puerto 8081)
│   ├── Apps organizadas
│   ├── Enlaces rápidos
│   └── Interfaz visual
│
├── Portainer Agent (puerto 9001)
│   └── Gestión remota desde Portainer
│
├── cAdvisor (puerto 8089)
│   └── Métricas para Prometheus
│
└── socket-proxy (puerto 2375)
    └── Acceso seguro a Docker para Homarr
```

## 📦 Instalación

### Paso 1: Crear el Contenedor

En Proxmox Web UI: `Crear CT`

**Configuración General:**
```
CT ID: 101
Hostname: dashboard
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
IPv4: 192.168.1.79/24
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
pct enter 101

# O desde SSH
ssh root@192.168.1.79
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

Para acceder a servicios en la red privada desde los dashboards:

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

### Paso 5: Crear Estructura de Directorios

```bash
mkdir -p /opt/stacks/{homepage,homarr-v1,homer,heimdall,portainer-agent,cadvisor,socket-proxy}
```

## 🎨 Instalación de Dashboards

### 1. Homepage

Dashboard principal con widgets personalizables.

```bash
cd /opt/stacks/homepage
mkdir -p config

cat > docker-compose.yml <<'EOF'
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

docker compose up -d
```

**Acceso**: `http://192.168.1.79:3000` o `https://homepage.home.arpa`

**Configuración**: Los archivos de configuración están en `/opt/stacks/homepage/config/`

### 2. Homarr v1

Dashboard moderno con integración Docker y SSO.

```bash
cd /opt/stacks/homarr-v1

cat > docker-compose.yml <<'EOF'
services:
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr-v1
    restart: unless-stopped
    ports:
      - "7575:7575"
    volumes:
      - /opt/stacks/homarr-v1/appdata:/app/data/configs
      - /opt/stacks/homarr-v1/appdata/db:/data
      - /opt/stacks/homarr-v1/icons:/app/public/icons
    environment:
      - TZ=Europe/Madrid
EOF

docker compose up -d
```

**Acceso**: `http://192.168.1.79:7575` o `https://homarr.home.arpa`

**Características**:
- Widgets para Docker, Uptime Kuma, etc.
- Integración con socket-proxy
- SSO con Keycloak (configurar después)
- Temas personalizables

### 3. Homer

Dashboard minimalista basado en YAML.

```bash
cd /opt/stacks/homer
mkdir -p assets

# Crear configuración básica
cat > assets/config.yml <<'EOF'
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
      - name: "Homepage"
        subtitle: "Dashboard principal"
        url: "http://192.168.1.79:3000"
        target: "_blank"
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

cat > docker-compose.yml <<'EOF'
services:
  homer:
    image: b4bz/homer:latest
    container_name: homer
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - /opt/stacks/homer/assets:/www/assets
    environment:
      - TZ=Europe/Madrid
EOF

docker compose up -d
```

**Acceso**: `http://192.168.1.79:8080` o `https://homer.home.arpa`

**Personalización**: Editar `/opt/stacks/homer/assets/config.yml`

### 4. Heimdall

Dashboard tipo app launcher.

```bash
cd /opt/stacks/heimdall

cat > docker-compose.yml <<'EOF'
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

# Crear directorio con permisos correctos
mkdir -p config
chown -R 1000:1000 config

docker compose up -d
```

**Acceso**: `http://192.168.1.79:8081` o `https://heimdall.home.arpa`

**Configuración**: Añadir aplicaciones desde la interfaz web

## 🔧 Servicios Auxiliares

### Portainer Agent

Para gestión remota desde Portainer (CT102):

```bash
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

### cAdvisor

Para métricas de contenedores (Prometheus):

```bash
cd /opt/stacks/cadvisor

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

docker compose up -d
```

### socket-proxy

Para acceso seguro a Docker desde Homarr:

```bash
cd /opt/stacks/socket-proxy

cat > docker-compose.yml <<'EOF'
services:
  socket-proxy:
    image: lscr.io/linuxserver/socket-proxy:latest
    container_name: socket-proxy
    restart: unless-stopped
    ports:
      - "2375:2375"
    environment:
      - CONTAINERS=1
      - POST=0
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
EOF

docker compose up -d
```

## ⚙️ Configuración

### Configurar Homarr con socket-proxy

1. **En Homarr, ir a Settings > Docker**
2. **Añadir Docker host:**
   ```
   Name: CT101-dashboard
   URL: tcp://192.168.1.79:2375
   ```
3. **Guardar y verificar conexión**

### Configurar SSO en Homarr (Opcional)

Después de configurar Keycloak (CT113):

1. **En Homarr, ir a Settings > Authentication**
2. **Habilitar OIDC:**
   ```
   Provider: Keycloak
   Client ID: homarr
   Client Secret: (desde Keycloak)
   Issuer URL: https://auth.home.arpa/realms/homelab
   ```
3. **Guardar y probar login**

## ✅ Verificación

### Verificar Servicios

```bash
# Ver todos los contenedores
docker ps

# Debe mostrar:
# - homepage
# - homarr-v1
# - homer
# - heimdall
# - portainer-agent
# - cadvisor
# - socket-proxy

# Verificar logs
docker logs homepage
docker logs homarr-v1
docker logs homer
docker logs heimdall
```

### Probar Acceso

**Desde navegador:**
```
http://192.168.1.79:3000  # Homepage
http://192.168.1.79:7575  # Homarr
http://192.168.1.79:8080  # Homer
http://192.168.1.79:8081  # Heimdall
```

**O con dominios (si configuraste DNS y proxy):**
```
https://homepage.home.arpa
https://homarr.home.arpa
https://homer.home.arpa
https://heimdall.home.arpa
```

## 🔧 Mantenimiento

### Actualizar Dashboards

```bash
# Actualizar todos
cd /opt/stacks/homepage && docker compose pull && docker compose up -d
cd /opt/stacks/homarr-v1 && docker compose pull && docker compose up -d
cd /opt/stacks/homer && docker compose pull && docker compose up -d
cd /opt/stacks/heimdall && docker compose pull && docker compose up -d
```

### Backup de Configuraciones

```bash
# Backup manual
tar -czf dashboards-backup-$(date +%Y%m%d).tar.gz /opt/stacks/{homepage,homarr-v1,homer,heimdall}

# Restaurar
tar -xzf dashboards-backup-YYYYMMDD.tar.gz -C /
```

### Logs

```bash
# Ver logs en tiempo real
docker logs -f homarr-v1

# Últimas 50 líneas
docker logs --tail 50 homepage
```

## 🐛 Troubleshooting

### Homarr no muestra contenedores Docker

**Solución:**
```bash
# Verificar socket-proxy
docker logs socket-proxy

# Verificar conectividad
curl http://192.168.1.79:2375/containers/json

# Reiniciar socket-proxy
cd /opt/stacks/socket-proxy
docker compose restart
```

### Homepage no carga

**Solución:**
```bash
# Verificar logs
docker logs homepage

# Verificar permisos
ls -la /opt/stacks/homepage/config

# Reiniciar
cd /opt/stacks/homepage
docker compose restart
```

### Homer no muestra servicios

**Solución:**
```bash
# Verificar configuración YAML
cat /opt/stacks/homer/assets/config.yml

# Validar sintaxis YAML online
# Reiniciar Homer
cd /opt/stacks/homer
docker compose restart
```

## 📊 Integración con Otros Servicios

### Portainer

En Portainer (CT102), añadir este environment:
- **Name**: `CT101-dashboard`
- **URL**: `tcp://192.168.1.79:9001`

### Prometheus

Añadir target en Prometheus (CT105):
```yaml
- job_name: "ct101-cadvisor"
  static_configs:
    - targets: ["192.168.1.79:8089"]
```

### Uptime Kuma

Añadir monitores en Uptime Kuma (CT105):
- Homepage: `http://192.168.1.79:3000`
- Homarr: `http://192.168.1.79:7575`
- Homer: `http://192.168.1.79:8080`
- Heimdall: `http://192.168.1.79:8081`

## 🎨 Personalización

### Temas en Homarr

1. **Settings > Appearance**
2. **Seleccionar tema**: Dark, Light, Custom
3. **Personalizar colores**

### Iconos en Homer

Añadir iconos personalizados en `/opt/stacks/homer/assets/tools/`:
```bash
cd /opt/stacks/homer/assets/tools
wget https://ejemplo.com/icono.png
```

Usar en config.yml:
```yaml
icon: "tools/icono.png"
```

## 🔗 Recursos

- [Homepage Documentation](https://gethomepage.dev/)
- [Homarr Documentation](https://homarr.dev/)
- [Homer Documentation](https://github.com/bastienwirtz/homer)
- [Heimdall Documentation](https://heimdall.site/)

## 📚 Próximos Pasos

Después de configurar CT101:

1. **Configurar Portainer** → [CT102 - Portainer](ct102-portainer.md)
2. **Configurar Monitoring** → [CT105 - Monitoring](ct105-monitoring.md)
3. **Personalizar Dashboards** → Añadir todos tus servicios

---

[⬅️ Core Services](../04-core-services/) | [🏠 Índice](../README.md) | [➡️ CT102 Portainer](ct102-portainer.md)
