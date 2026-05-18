# 📈 Escalabilidad del Homelab

Guía para hacer crecer tu homelab de forma ordenada y eficiente.

## 📋 Tabla de Contenidos

- [Estrategias de Escalado](#estrategias-de-escalado)
- [Escalado Vertical](#escalado-vertical)
- [Escalado Horizontal](#escalado-horizontal)
- [Alta Disponibilidad](#alta-disponibilidad)
- [Load Balancing](#load-balancing)
- [Almacenamiento Distribuido](#almacenamiento-distribuido)
- [Migración de Servicios](#migración-de-servicios)
- [Planificación de Capacidad](#planificación-de-capacidad)

---

## 🎯 Estrategias de Escalado

### Cuándo Escalar

Señales de que necesitas escalar:

- **CPU**: Uso constante >80%
- **Memoria**: Swap activo frecuentemente
- **Disco**: I/O wait >20%
- **Red**: Saturación de ancho de banda
- **Servicios**: Timeouts o respuestas lentas

### Tipos de Escalado

```
┌─────────────────────────────────────────┐
│         ESCALADO VERTICAL               │
│  (Scale Up - Más recursos al mismo)    │
│                                         │
│  ┌─────┐      ┌─────────┐             │
│  │ 4GB │  →   │  16GB   │             │
│  │ 2CPU│      │  8CPU   │             │
│  └─────┘      └─────────┘             │
└─────────────────────────────────────────┘

┌─────────────────────────────────────────┐
│        ESCALADO HORIZONTAL              │
│  (Scale Out - Más instancias)          │
│                                         │
│  ┌─────┐      ┌─────┐ ┌─────┐ ┌─────┐│
│  │ VM1 │  →   │ VM1 │ │ VM2 │ │ VM3 ││
│  └─────┘      └─────┘ └─────┘ └─────┘│
└─────────────────────────────────────────┘
```

---

## ⬆️ Escalado Vertical

### 1. Añadir CPU a VM

```bash
# Apagar VM
qm shutdown 100

# Aumentar CPUs
qm set 100 -cores 4

# Iniciar VM
qm start 100
```

### 2. Añadir Memoria a VM

```bash
# Apagar VM
qm shutdown 100

# Aumentar memoria
qm set 100 -memory 8192

# Iniciar VM
qm start 100
```

### 3. Hot-plug (Sin Apagar)

```bash
# CPU hotplug (requiere configuración previa)
qm set 100 -vcpus 8

# Memoria hotplug
qm set 100 -memory 8192
```

### 4. Expandir Disco

```bash
# Aumentar tamaño del disco
qm resize 100 scsi0 +50G

# Dentro de la VM, expandir partición
# Para LVM:
lvextend -l +100%FREE /dev/mapper/vg-root
resize2fs /dev/mapper/vg-root

# Para partición directa:
growpart /dev/sda 1
resize2fs /dev/sda1
```

### 5. Contenedores LXC

```bash
# Aumentar recursos de contenedor
pct set 100 -cores 4
pct set 100 -memory 4096

# Expandir disco
pct resize 100 rootfs +20G
```

---

## ➡️ Escalado Horizontal

### 1. Cluster de Proxmox

#### Crear Cluster

```bash
# En el primer nodo
pvecm create mi-cluster

# Ver estado
pvecm status

# En nodos adicionales
pvecm add IP_PRIMER_NODO
```

#### Configuración de Quorum

```bash
# Ver configuración
pvecm nodes

# Configurar expected votes (para 2 nodos)
pvecm expected 1
```

### 2. Replicación de VMs

```bash
# Habilitar replicación
pvesh create /cluster/replication \
  -id 100-0 \
  -target nodo2 \
  -guest 100 \
  -schedule "*/15"

# Ver estado
pvesh get /cluster/replication
```

### 3. Migración en Vivo

```bash
# Migrar VM a otro nodo
qm migrate 100 nodo2 --online

# Migrar contenedor
pct migrate 100 nodo2 --restart
```

### 4. Docker Swarm

```yaml
# Inicializar swarm
docker swarm init --advertise-addr 192.168.1.87

# Añadir workers
docker swarm join --token TOKEN 192.168.1.87:2377

# Desplegar stack
docker stack deploy -c docker-compose.yml myapp
```

Ejemplo de stack escalable:
```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    deploy:
      replicas: 3
      update_config:
        parallelism: 1
        delay: 10s
      restart_policy:
        condition: on-failure
    networks:
      - webnet

  app:
    image: myapp:latest
    deploy:
      replicas: 5
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
    networks:
      - webnet
      - backend

networks:
  webnet:
  backend:
```

### 5. Kubernetes (K3s)

```bash
# Instalar K3s en master
curl -sfL https://get.k3s.io | sh -

# Obtener token
cat /var/lib/rancher/k3s/server/node-token

# Añadir workers
curl -sfL https://get.k3s.io | K3S_URL=https://master:6443 \
  K3S_TOKEN=TOKEN sh -
```

Deployment escalable:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myapp:latest
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

---

## 🔄 Alta Disponibilidad

### 1. HA en Proxmox

```bash
# Configurar HA
ha-manager add vm:100 --state started --max_restart 3 --max_relocate 3

# Ver estado
ha-manager status

# Configurar grupos
pvesh create /cluster/ha/groups/production \
  -nodes "nodo1,nodo2" \
  -restricted 1
```

### 2. Base de Datos HA

#### PostgreSQL con Patroni

```yaml
version: '3.8'

services:
  etcd:
    image: quay.io/coreos/etcd:latest
    environment:
      - ETCD_LISTEN_CLIENT_URLS=http://0.0.0.0:2379
      - ETCD_ADVERTISE_CLIENT_URLS=http://etcd:2379

  patroni1:
    image: patroni:latest
    environment:
      - PATRONI_NAME=patroni1
      - PATRONI_ETCD_HOSTS=etcd:2379
      - PATRONI_POSTGRESQL_DATA_DIR=/data/patroni
    volumes:
      - pg1_data:/data

  patroni2:
    image: patroni:latest
    environment:
      - PATRONI_NAME=patroni2
      - PATRONI_ETCD_HOSTS=etcd:2379
      - PATRONI_POSTGRESQL_DATA_DIR=/data/patroni
    volumes:
      - pg2_data:/data

  haproxy:
    image: haproxy:alpine
    ports:
      - "5432:5432"
    volumes:
      - ./haproxy.cfg:/usr/local/etc/haproxy/haproxy.cfg:ro
```

#### MariaDB Galera Cluster

```yaml
version: '3.8'

services:
  mariadb1:
    image: mariadb:latest
    environment:
      - MYSQL_ROOT_PASSWORD=secret
      - MYSQL_INITDB_SKIP_TZINFO=1
    command: >
      --wsrep-new-cluster
      --wsrep_cluster_address=gcomm://mariadb1,mariadb2,mariadb3

  mariadb2:
    image: mariadb:latest
    environment:
      - MYSQL_ROOT_PASSWORD=secret
    command: >
      --wsrep_cluster_address=gcomm://mariadb1,mariadb2,mariadb3

  mariadb3:
    image: mariadb:latest
    environment:
      - MYSQL_ROOT_PASSWORD=secret
    command: >
      --wsrep_cluster_address=gcomm://mariadb1,mariadb2,mariadb3
```

### 3. Redis HA

```yaml
version: '3.8'

services:
  redis-master:
    image: redis:alpine
    command: redis-server --appendonly yes

  redis-replica1:
    image: redis:alpine
    command: redis-server --slaveof redis-master 6379

  redis-replica2:
    image: redis:alpine
    command: redis-server --slaveof redis-master 6379

  redis-sentinel1:
    image: redis:alpine
    command: >
      redis-sentinel /etc/redis/sentinel.conf
      --sentinel monitor mymaster redis-master 6379 2
```

---

## ⚖️ Load Balancing

### 1. HAProxy

```bash
# Instalar
apt install haproxy

# Configurar
nano /etc/haproxy/haproxy.cfg
```

```cfg
global
    log /dev/log local0
    maxconn 4096

defaults
    log global
    mode http
    option httplog
    timeout connect 5000ms
    timeout client 50000ms
    timeout server 50000ms

frontend http_front
    bind *:80
    default_backend http_back

backend http_back
    balance roundrobin
    option httpchk GET /health
    server web1 192.168.1.101:80 check
    server web2 192.168.1.102:80 check
    server web3 192.168.1.103:80 check

listen stats
    bind *:8404
    stats enable
    stats uri /stats
    stats refresh 30s
```

### 2. Nginx Load Balancer

```nginx
upstream backend {
    least_conn;
    server 192.168.1.101:80 weight=3;
    server 192.168.1.102:80 weight=2;
    server 192.168.1.103:80 weight=1;
    server 192.168.1.104:80 backup;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        
        # Health check
        proxy_next_upstream error timeout http_500;
    }
}
```

### 3. Traefik

```yaml
version: '3.8'

services:
  traefik:
    image: traefik:latest
    command:
      - --api.insecure=true
      - --providers.docker=true
      - --entrypoints.web.address=:80
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock

  app:
    image: myapp:latest
    deploy:
      replicas: 3
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.app.rule=Host(`app.local`)"
      - "traefik.http.services.app.loadbalancer.server.port=8080"
```

---

## 💾 Almacenamiento Distribuido

### 1. Ceph

```bash
# Instalar Ceph en Proxmox
pveceph install

# Crear monitor
pveceph mon create

# Crear OSD
pveceph osd create /dev/sdb

# Crear pool
pveceph pool create mypool --size 3
```

### 2. GlusterFS

```bash
# Instalar
apt install glusterfs-server

# Crear volumen
gluster volume create gv0 replica 3 \
  nodo1:/data/brick1/gv0 \
  nodo2:/data/brick1/gv0 \
  nodo3:/data/brick1/gv0

# Iniciar volumen
gluster volume start gv0

# Montar en cliente
mount -t glusterfs nodo1:/gv0 /mnt/gluster
```

### 3. MinIO (S3 Compatible)

```yaml
version: '3.8'

services:
  minio1:
    image: minio/minio
    command: server http://minio{1...4}/data
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password
    volumes:
      - data1:/data

  minio2:
    image: minio/minio
    command: server http://minio{1...4}/data
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password
    volumes:
      - data2:/data

  minio3:
    image: minio/minio
    command: server http://minio{1...4}/data
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password
    volumes:
      - data3:/data

  minio4:
    image: minio/minio
    command: server http://minio{1...4}/data
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password
    volumes:
      - data4:/data
```

---

## 🔄 Migración de Servicios

### 1. Migración de Contenedor Docker

```bash
# Exportar contenedor
docker export container_name > container.tar

# En nuevo host
docker import container.tar myimage:latest
docker run -d myimage:latest
```

### 2. Migración de Volúmenes

```bash
# Backup de volumen
docker run --rm -v volume_name:/data -v $(pwd):/backup \
  alpine tar czf /backup/volume-backup.tar.gz /data

# Restaurar en nuevo host
docker run --rm -v new_volume:/data -v $(pwd):/backup \
  alpine tar xzf /backup/volume-backup.tar.gz -C /
```

### 3. Migración de Base de Datos

```bash
# PostgreSQL
pg_dump -h localhost -U user dbname > backup.sql
psql -h newhost -U user dbname < backup.sql

# MySQL/MariaDB
mysqldump -u user -p dbname > backup.sql
mysql -h newhost -u user -p dbname < backup.sql
```

### 4. Migración de VM Completa

```bash
# Backup de VM
vzdump 100 --mode snapshot --storage local

# Restaurar en nuevo nodo
qmrestore /var/lib/vz/dump/vzdump-qemu-100-*.vma.zst 100
```

---

## 📊 Planificación de Capacidad

### 1. Monitoreo de Tendencias

```promql
# Predicción de uso de CPU (30 días)
predict_linear(node_cpu_seconds_total[30d], 86400 * 30)

# Predicción de uso de disco
predict_linear(node_filesystem_free_bytes[30d], 86400 * 30)

# Predicción de memoria
predict_linear(node_memory_MemAvailable_bytes[30d], 86400 * 30)
```

### 2. Cálculo de Capacidad

```python
#!/usr/bin/env python3
# capacity-planning.py

def calculate_capacity(current_usage, growth_rate, months):
    """
    Calcula capacidad necesaria
    
    current_usage: Uso actual en GB
    growth_rate: Tasa de crecimiento mensual (0.1 = 10%)
    months: Meses a proyectar
    """
    future_usage = current_usage * ((1 + growth_rate) ** months)
    recommended = future_usage * 1.3  # 30% buffer
    
    return {
        'current': current_usage,
        'projected': future_usage,
        'recommended': recommended,
        'additional_needed': recommended - current_usage
    }

# Ejemplo
storage = calculate_capacity(500, 0.15, 12)
print(f"Almacenamiento actual: {storage['current']}GB")
print(f"Proyectado en 12 meses: {storage['projected']:.2f}GB")
print(f"Recomendado: {storage['recommended']:.2f}GB")
print(f"Adicional necesario: {storage['additional_needed']:.2f}GB")
```

### 3. Matriz de Decisión

```
┌─────────────────────────────────────────────────────┐
│  Recurso  │ Uso Actual │ Límite │ Acción Requerida │
├───────────┼────────────┼────────┼──────────────────┤
│ CPU       │    65%     │  80%   │ Monitorear       │
│ Memoria   │    85%     │  80%   │ Escalar YA       │
│ Disco     │    70%     │  85%   │ Planificar       │
│ Red       │    40%     │  70%   │ OK               │
└─────────────────────────────────────────────────────┘
```

### 4. Roadmap de Escalado

```markdown
## Q1 2024
- [ ] Añadir 32GB RAM a nodo principal
- [ ] Migrar DB a cluster HA
- [ ] Implementar load balancer

## Q2 2024
- [ ] Añadir segundo nodo Proxmox
- [ ] Configurar replicación de VMs
- [ ] Implementar Ceph para storage

## Q3 2024
- [ ] Migrar a Kubernetes
- [ ] Implementar auto-scaling
- [ ] Añadir tercer nodo

## Q4 2024
- [ ] Implementar multi-site
- [ ] Disaster recovery completo
- [ ] Optimización final
```

---

## 📋 Checklist de Escalado

### Antes de Escalar
- [ ] Identificar bottleneck real
- [ ] Documentar estado actual
- [ ] Backup completo del sistema
- [ ] Plan de rollback definido
- [ ] Ventana de mantenimiento programada

### Durante el Escalado
- [ ] Monitorear métricas en tiempo real
- [ ] Verificar cada paso
- [ ] Documentar cambios
- [ ] Probar funcionalidad

### Después del Escalado
- [ ] Verificar todos los servicios
- [ ] Monitorear por 24-48h
- [ ] Actualizar documentación
- [ ] Revisar costos
- [ ] Planificar siguiente fase

---

## 🎯 Mejores Prácticas

1. **Escala gradualmente**: No hagas cambios masivos de una vez
2. **Monitorea constantemente**: Usa métricas para decisiones
3. **Automatiza**: Scripts para tareas repetitivas
4. **Documenta**: Cada cambio debe estar documentado
5. **Prueba**: Siempre en entorno de test primero
6. **Backup**: Antes de cualquier cambio mayor
7. **Planifica**: Roadmap de 6-12 meses
8. **Optimiza primero**: Antes de añadir hardware

---

## 📚 Recursos Adicionales

- [Proxmox Cluster](https://pve.proxmox.com/wiki/Cluster_Manager)
- [Docker Swarm](https://docs.docker.com/engine/swarm/)
- [Kubernetes Scaling](https://kubernetes.io/docs/concepts/cluster-administration/cluster-autoscaling/)
- [HAProxy Documentation](http://www.haproxy.org/)

---

## 🔗 Navegación

- [⬅️ Volver a Performance Tuning](performance-tuning.md)
- [➡️ Siguiente: Mantenimiento](../11-maintenance/updates.md)
- [🏠 Volver al índice](../README.md)
