# 🐳 Docker Best Practices

Guía de mejores prácticas para gestionar contenedores Docker en tu homelab.

## 📋 Tabla de Contenidos

- [Estructura de Proyectos](#estructura-de-proyectos)
- [Docker Compose](#docker-compose)
- [Gestión de Imágenes](#gestión-de-imágenes)
- [Redes](#redes)
- [Volúmenes y Persistencia](#volúmenes-y-persistencia)
- [Seguridad](#seguridad)
- [Recursos y Límites](#recursos-y-límites)
- [Logging](#logging)
- [Health Checks](#health-checks)
- [Actualizaciones](#actualizaciones)

---

## 📁 Estructura de Proyectos

### Organización Recomendada

```
/opt/
├── stacks/
│   ├── monitoring/
│   │   ├── docker-compose.yml
│   │   ├── .env
│   │   └── configs/
│   ├── media/
│   │   ├── docker-compose.yml
│   │   └── .env
│   └── productivity/
│       ├── docker-compose.yml
│       └── .env
└── appdata/
    ├── grafana/
    ├── prometheus/
    └── nextcloud/
```

### Ventajas de esta Estructura

- **Separación clara**: Cada stack tiene su propio directorio
- **Fácil backup**: `/opt/stacks` contiene toda la configuración
- **Datos persistentes**: `/opt/appdata` contiene los datos de las apps
- **Portabilidad**: Fácil de mover entre sistemas

---

## 🐋 Docker Compose

### Plantilla Base

```yaml
version: '3.8'

services:
  app:
    image: app:latest
    container_name: app
    restart: unless-stopped
    
    environment:
      - TZ=Europe/Madrid
      - PUID=1000
      - PGID=1000
    
    volumes:
      - /opt/appdata/app:/config
      - /mnt/data:/data:ro
    
    networks:
      - app_network
    
    ports:
      - "8080:8080"
    
    labels:
      - "com.centurylinklabs.watchtower.enable=true"
      - "backup.enable=true"
    
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

networks:
  app_network:
    driver: bridge

volumes:
  app_data:
    driver: local
```

### Mejores Prácticas

#### 1. **Usar Variables de Entorno**

```yaml
# docker-compose.yml
environment:
  - DB_HOST=${DB_HOST}
  - DB_PASSWORD=${DB_PASSWORD}

# .env
DB_HOST=postgres
DB_PASSWORD=tu_password_seguro
```

#### 2. **Nombres de Contenedor Explícitos**

```yaml
# ✅ BIEN
container_name: grafana

# ❌ MAL (nombre aleatorio)
# Sin especificar container_name
```

#### 3. **Restart Policies**

```yaml
# Para servicios críticos
restart: always

# Para servicios normales (recomendado)
restart: unless-stopped

# Para servicios de desarrollo
restart: "no"
```

#### 4. **Usar Redes Personalizadas**

```yaml
networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true  # Sin acceso a internet
```

---

## 🖼️ Gestión de Imágenes

### Estrategia de Tags

```yaml
# ❌ MAL - Siempre la última versión (puede romper)
image: grafana/grafana:latest

# ✅ BIEN - Versión específica
image: grafana/grafana:10.2.3

# ✅ MEJOR - Versión mayor fija
image: grafana/grafana:10
```

### Limpieza Regular

```bash
# Eliminar imágenes sin usar
docker image prune -a

# Eliminar todo lo no usado
docker system prune -a --volumes

# Ver espacio usado
docker system df
```

### Actualización Controlada

```bash
# 1. Backup antes de actualizar
cd /opt/stacks/monitoring
docker-compose down
tar -czf backup-$(date +%Y%m%d).tar.gz /opt/appdata/grafana

# 2. Actualizar imagen
docker-compose pull

# 3. Recrear contenedor
docker-compose up -d

# 4. Verificar logs
docker-compose logs -f
```

---

## 🌐 Redes

### Red Bridge (Por Defecto)

```yaml
networks:
  default:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### Red Macvlan (IP Propia)

```yaml
networks:
  macvlan_net:
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        - subnet: 192.168.1.0/24
          gateway: 192.168.1.1
          ip_range: 192.168.1.128/25
```

### Comunicación Entre Contenedores

```yaml
services:
  app:
    depends_on:
      - db
    environment:
      - DB_HOST=db  # Usar nombre del servicio
  
  db:
    image: postgres:15
```

---

## 💾 Volúmenes y Persistencia

### Tipos de Volúmenes

#### 1. **Named Volumes (Recomendado)**

```yaml
volumes:
  postgres_data:
    driver: local

services:
  db:
    volumes:
      - postgres_data:/var/lib/postgresql/data
```

#### 2. **Bind Mounts**

```yaml
services:
  app:
    volumes:
      - /opt/appdata/app:/config
      - /mnt/nas/media:/media:ro  # Read-only
```

#### 3. **tmpfs (Temporal)**

```yaml
services:
  app:
    tmpfs:
      - /tmp
      - /run
```

### Permisos

```yaml
services:
  app:
    user: "1000:1000"  # PUID:PGID
    environment:
      - PUID=1000
      - PGID=1000
```

---

## 🔒 Seguridad

### 1. **No Ejecutar como Root**

```yaml
services:
  app:
    user: "1000:1000"
    # O dentro del Dockerfile:
    # USER appuser
```

### 2. **Secrets para Datos Sensibles**

```yaml
services:
  db:
    secrets:
      - db_password
    environment:
      - POSTGRES_PASSWORD_FILE=/run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### 3. **Read-Only Root Filesystem**

```yaml
services:
  app:
    read_only: true
    tmpfs:
      - /tmp
      - /var/run
```

### 4. **Capabilities Mínimas**

```yaml
services:
  app:
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
```

### 5. **No Exponer Puertos Innecesarios**

```yaml
# ❌ MAL - Expuesto a internet
ports:
  - "5432:5432"

# ✅ BIEN - Solo en localhost
ports:
  - "127.0.0.1:5432:5432"

# ✅ MEJOR - Sin exponer (usar red interna)
# Sin ports, solo networks
```

---

## 📊 Recursos y Límites

### Limitar CPU y Memoria

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### Prioridad de CPU

```yaml
services:
  critical_app:
    cpu_shares: 1024  # Alta prioridad
  
  background_task:
    cpu_shares: 512   # Baja prioridad
```

---

## 📝 Logging

### Configuración de Logs

```yaml
services:
  app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
        labels: "app,environment"
```

### Drivers de Logging

```yaml
# Syslog
logging:
  driver: syslog
  options:
    syslog-address: "tcp://192.168.1.87:514"

# Loki (para Grafana)
logging:
  driver: loki
  options:
    loki-url: "http://loki:3100/loki/api/v1/push"
```

### Ver Logs

```bash
# Logs en tiempo real
docker-compose logs -f

# Últimas 100 líneas
docker-compose logs --tail=100

# Logs de un servicio específico
docker-compose logs -f app

# Logs con timestamps
docker-compose logs -f -t
```

---

## 🏥 Health Checks

### HTTP Health Check

```yaml
healthcheck:
  test: ["CMD", "curl", "-f", "http://localhost:8080/health"]
  interval: 30s
  timeout: 10s
  retries: 3
  start_period: 40s
```

### TCP Health Check

```yaml
healthcheck:
  test: ["CMD-SHELL", "nc -z localhost 5432 || exit 1"]
  interval: 10s
  timeout: 5s
  retries: 5
```

### Script Personalizado

```yaml
healthcheck:
  test: ["CMD", "/app/healthcheck.sh"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

## 🔄 Actualizaciones

### Watchtower (Automático)

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 4 * * *  # 4 AM diario
      - WATCHTOWER_NOTIFICATIONS=email
      - WATCHTOWER_NOTIFICATION_EMAIL_TO=tu@email.com
```

### Manual (Recomendado)

```bash
# Script de actualización
#!/bin/bash
cd /opt/stacks/monitoring

# Backup
docker-compose down
tar -czf backup-$(date +%Y%m%d).tar.gz /opt/appdata/

# Actualizar
docker-compose pull
docker-compose up -d

# Verificar
docker-compose ps
docker-compose logs -f --tail=50
```

---

## 📋 Checklist de Best Practices

### Antes de Desplegar

- [ ] Variables de entorno en `.env`
- [ ] Secrets para datos sensibles
- [ ] Health checks configurados
- [ ] Límites de recursos definidos
- [ ] Logging configurado
- [ ] Restart policy apropiada
- [ ] Redes personalizadas
- [ ] Volúmenes con permisos correctos

### Después de Desplegar

- [ ] Verificar logs: `docker-compose logs`
- [ ] Verificar health: `docker-compose ps`
- [ ] Probar conectividad
- [ ] Documentar configuración
- [ ] Configurar backups
- [ ] Configurar monitoreo

---

## 🛠️ Herramientas Útiles

### Portainer

Gestión visual de contenedores:
```yaml
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    ports:
      - "9000:9000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
```

### Dockge

Editor visual de docker-compose:
```yaml
services:
  dockge:
    image: louislam/dockge:1
    container_name: dockge
    restart: unless-stopped
    ports:
      - "5001:5001"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/app/data
      - /opt/stacks:/opt/stacks
```

---

## 📚 Recursos Adicionales

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Security](https://docs.docker.com/engine/security/)
- [Awesome Docker](https://github.com/veggiemonk/awesome-docker)

---

## 🔗 Navegación

- [⬅️ Volver a Autenticación](../09-authentication/ct113-keycloak.md)
- [➡️ Siguiente: Security Hardening](security-hardening.md)
- [🏠 Volver al índice](../README.md)
