# ⚡ Performance Tuning

Guía completa para optimizar el rendimiento de tu homelab Proxmox.

## 📋 Tabla de Contenidos

- [Optimización del Host Proxmox](#optimización-del-host-proxmox)
- [Optimización de CPU](#optimización-de-cpu)
- [Optimización de Memoria](#optimización-de-memoria)
- [Optimización de Disco](#optimización-de-disco)
- [Optimización de Red](#optimización-de-red)
- [Optimización de Contenedores](#optimización-de-contenedores)
- [Optimización de Bases de Datos](#optimización-de-bases-de-datos)
- [Monitoreo de Performance](#monitoreo-de-performance)

---

## 🖥️ Optimización del Host Proxmox

### 1. Configuración del Kernel

```bash
# Editar parámetros del kernel
nano /etc/sysctl.conf
```

Añadir:
```bash
# Networking
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Memoria
vm.swappiness = 10
vm.vfs_cache_pressure = 50
vm.dirty_ratio = 10
vm.dirty_background_ratio = 5

# File descriptors
fs.file-max = 2097152
fs.inotify.max_user_watches = 524288

# Seguridad y performance
kernel.pid_max = 4194304
```

Aplicar:
```bash
sysctl -p
```

### 2. CPU Governor

```bash
# Ver governor actual
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Instalar herramientas
apt install cpufrequtils

# Configurar performance
echo "performance" | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Hacer permanente
nano /etc/default/cpufrequtils
```

Añadir:
```bash
GOVERNOR="performance"
```

### 3. Scripts de Modo Turbo/Noche

**Modo Turbo** (máximo rendimiento):
```bash
#!/bin/bash
# /usr/local/bin/turbo-mode.sh

echo "🚀 Activando Modo Turbo..."

# CPU a máximo
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Deshabilitar power saving
for i in /sys/bus/pci/devices/*/power/control; do
    echo on > $i
done

# Ajustar swappiness
sysctl -w vm.swappiness=10

# Deshabilitar CPU idle
for i in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do
    echo 1 > $i 2>/dev/null
done

echo "✅ Modo Turbo activado"
```

**Modo Noche** (ahorro de energía):
```bash
#!/bin/bash
# /usr/local/bin/night-mode.sh

echo "🌙 Activando Modo Noche..."

# CPU a powersave
echo powersave | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Habilitar power saving
for i in /sys/bus/pci/devices/*/power/control; do
    echo auto > $i
done

# Aumentar swappiness
sysctl -w vm.swappiness=60

# Habilitar CPU idle
for i in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do
    echo 0 > $i 2>/dev/null
done

echo "✅ Modo Noche activado"
```

Hacer ejecutables:
```bash
chmod +x /usr/local/bin/turbo-mode.sh
chmod +x /usr/local/bin/night-mode.sh
```

### 4. Automatización con Cron

```bash
# Editar crontab
crontab -e
```

Añadir:
```bash
# Modo turbo de 8 AM a 11 PM
0 8 * * * /usr/local/bin/turbo-mode.sh
0 23 * * * /usr/local/bin/night-mode.sh
```

---

## 🔥 Optimización de CPU

### 1. CPU Pinning

Para VMs críticas:
```bash
# Editar configuración de VM
nano /etc/pve/qemu-server/100.conf
```

Añadir:
```
cores: 4
cpu: host
affinity: 0,1,2,3
```

### 2. NUMA Awareness

```bash
# Ver topología NUMA
numactl --hardware

# Configurar VM con NUMA
qm set 100 -numa 1
```

### 3. CPU Limits en Contenedores

```yaml
# docker-compose.yml
services:
  app:
    cpus: 2.0
    cpu_shares: 1024
    cpuset: "0,1"
```

### 4. Balanceo de Carga

```bash
# Instalar irqbalance
apt install irqbalance

# Configurar
nano /etc/default/irqbalance
```

```bash
ENABLED="1"
ONESHOT="0"
```

---

## 💾 Optimización de Memoria

### 1. Huge Pages

```bash
# Calcular huge pages necesarias (para VM con 8GB)
# 8GB = 8192MB / 2MB = 4096 páginas

# Configurar
echo 4096 > /proc/sys/vm/nr_hugepages

# Hacer permanente
echo "vm.nr_hugepages = 4096" >> /etc/sysctl.conf
```

### 2. KSM (Kernel Same-page Merging)

```bash
# Habilitar KSM
echo 1 > /sys/kernel/mm/ksm/run

# Configurar agresividad
echo 100 > /sys/kernel/mm/ksm/pages_to_scan
echo 20 > /sys/kernel/mm/ksm/sleep_millisecs

# Hacer permanente
cat > /etc/systemd/system/ksm.service << 'EOF'
[Unit]
Description=Enable KSM

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'echo 1 > /sys/kernel/mm/ksm/run'
ExecStart=/bin/sh -c 'echo 100 > /sys/kernel/mm/ksm/pages_to_scan'

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ksm
systemctl start ksm
```

### 3. Ballooning

```bash
# Habilitar en VM
qm set 100 -balloon 2048

# Monitorear
qm monitor 100
info balloon
```

### 4. Swap Optimization

```bash
# Crear swap file si no existe
fallocate -l 8G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Añadir a fstab
echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Optimizar uso
sysctl -w vm.swappiness=10
sysctl -w vm.vfs_cache_pressure=50
```

---

## 💿 Optimización de Disco

### 1. Scheduler de I/O

```bash
# Ver scheduler actual
cat /sys/block/sda/queue/scheduler

# Cambiar a mq-deadline (mejor para SSD)
echo mq-deadline > /sys/block/sda/queue/scheduler

# Para NVMe usar none
echo none > /sys/block/nvme0n1/queue/scheduler

# Hacer permanente
cat > /etc/udev/rules.d/60-scheduler.rules << 'EOF'
# SSD
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
# HDD
ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
# NVMe
ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
EOF
```

### 2. Optimización de SSD

```bash
# Habilitar TRIM
systemctl enable fstrim.timer
systemctl start fstrim.timer

# Verificar
fstrim -v /
```

### 3. Cache de Disco en VMs

```bash
# Configurar cache para VM
qm set 100 -scsi0 local-lvm:vm-100-disk-0,cache=writeback,discard=on

# Para mejor performance (sin seguridad)
qm set 100 -scsi0 local-lvm:vm-100-disk-0,cache=unsafe

# Para mejor seguridad
qm set 100 -scsi0 local-lvm:vm-100-disk-0,cache=writethrough
```

### 4. I/O Threads

```bash
# Habilitar iothread
qm set 100 -scsi0 local-lvm:vm-100-disk-0,iothread=1
```

### 5. Optimización de ZFS (si usas ZFS)

```bash
# Configurar ARC
echo "options zfs zfs_arc_max=8589934592" > /etc/modprobe.d/zfs.conf

# Optimizar para SSD
zfs set compression=lz4 rpool
zfs set atime=off rpool
zfs set recordsize=128k rpool
```

---

## 🌐 Optimización de Red

### 1. Virtio Network

```bash
# Usar virtio para VMs
qm set 100 -net0 virtio,bridge=vmbr0
```

### 2. Multiqueue

```bash
# Habilitar multiqueue
qm set 100 -net0 virtio,bridge=vmbr0,queues=4
```

### 3. Offloading

```bash
# Habilitar offloading en host
ethtool -K eth0 tso on gso on gro on

# Verificar
ethtool -k eth0
```

### 4. MTU Optimization

```bash
# Aumentar MTU (si tu red lo soporta)
ip link set eth0 mtu 9000

# Hacer permanente
nano /etc/network/interfaces
```

```
auto eth0
iface eth0 inet static
    address 192.168.1.100
    netmask 255.255.255.0
    gateway 192.168.1.1
    mtu 9000
```

### 5. TCP Tuning

```bash
# Ya incluido en sysctl.conf anterior
# BBR congestion control
sysctl -w net.ipv4.tcp_congestion_control=bbr
sysctl -w net.core.default_qdisc=fq
```

---

## 🐳 Optimización de Contenedores

### 1. Límites de Recursos

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

### 2. Shared Memory

```yaml
services:
  app:
    shm_size: '2gb'
```

### 3. Tmpfs para Archivos Temporales

```yaml
services:
  app:
    tmpfs:
      - /tmp
      - /var/tmp
```

### 4. Optimización de Logs

```yaml
services:
  app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 5. Health Checks Eficientes

```yaml
healthcheck:
  test: ["CMD-SHELL", "nc -z localhost 8080 || exit 1"]
  interval: 30s
  timeout: 3s
  retries: 3
  start_period: 40s
```

---

## 🗄️ Optimización de Bases de Datos

### PostgreSQL

```bash
# Editar configuración
nano /var/lib/postgresql/data/postgresql.conf
```

```ini
# Memoria
shared_buffers = 2GB
effective_cache_size = 6GB
maintenance_work_mem = 512MB
work_mem = 32MB

# Checkpoints
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100

# Planner
random_page_cost = 1.1  # Para SSD
effective_io_concurrency = 200

# Workers
max_worker_processes = 4
max_parallel_workers_per_gather = 2
max_parallel_workers = 4
```

### MariaDB/MySQL

```bash
# Editar configuración
nano /etc/mysql/mariadb.conf.d/50-server.cnf
```

```ini
[mysqld]
# Memoria
innodb_buffer_pool_size = 2G
innodb_log_file_size = 512M
innodb_log_buffer_size = 16M

# I/O
innodb_flush_method = O_DIRECT
innodb_flush_log_at_trx_commit = 2
innodb_file_per_table = 1

# Threads
innodb_read_io_threads = 4
innodb_write_io_threads = 4
thread_cache_size = 50

# Query cache (solo MySQL <8.0)
query_cache_type = 1
query_cache_size = 128M
```

### Redis

```bash
# Editar configuración
nano /etc/redis/redis.conf
```

```ini
# Memoria
maxmemory 1gb
maxmemory-policy allkeys-lru

# Persistencia
save 900 1
save 300 10
save 60 10000

# Performance
tcp-backlog 511
timeout 0
tcp-keepalive 300
```

---

## 📊 Monitoreo de Performance

### 1. Herramientas de Monitoreo

```bash
# Instalar herramientas
apt install htop iotop nethogs sysstat

# CPU
htop

# Disco I/O
iotop

# Red
nethogs

# Estadísticas del sistema
sar -u 1 10  # CPU
sar -r 1 10  # Memoria
sar -d 1 10  # Disco
```

### 2. Prometheus Queries Útiles

```promql
# CPU usage por contenedor
rate(container_cpu_usage_seconds_total[5m]) * 100

# Memoria usage
container_memory_usage_bytes / container_spec_memory_limit_bytes * 100

# Disco I/O
rate(container_fs_reads_bytes_total[5m])
rate(container_fs_writes_bytes_total[5m])

# Red
rate(container_network_receive_bytes_total[5m])
rate(container_network_transmit_bytes_total[5m])
```

### 3. Script de Benchmark

```bash
#!/bin/bash
# /usr/local/bin/benchmark.sh

echo "=== System Benchmark ==="
echo ""

# CPU
echo "1. CPU Benchmark:"
sysbench cpu --cpu-max-prime=20000 run | grep "events per second"

# Memoria
echo "2. Memory Benchmark:"
sysbench memory --memory-total-size=10G run | grep "transferred"

# Disco
echo "3. Disk Benchmark:"
fio --name=random-write --ioengine=libaio --iodepth=32 --rw=randwrite \
    --bs=4k --direct=1 --size=1G --numjobs=4 --runtime=60 \
    --group_reporting | grep "IOPS"

# Red
echo "4. Network Benchmark:"
iperf3 -c 192.168.1.1 -t 10 | grep "sender"
```

### 4. Dashboard de Grafana

Importar dashboard ID: 1860 (Node Exporter Full)

Queries personalizadas:
```promql
# CPU Temperature
node_hwmon_temp_celsius

# Disk latency
rate(node_disk_io_time_seconds_total[5m])

# Network errors
rate(node_network_receive_errs_total[5m])
```

---

## 🎯 Optimizaciones Específicas

### Para Servidor Web (Nginx)

```nginx
# /etc/nginx/nginx.conf
worker_processes auto;
worker_rlimit_nofile 65535;

events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
}

http {
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    keepalive_requests 100;
    
    # Gzip
    gzip on;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_types text/plain text/css application/json;
    
    # Cache
    open_file_cache max=10000 inactive=30s;
    open_file_cache_valid 60s;
    open_file_cache_min_uses 2;
}
```

### Para Nextcloud

```php
// config.php
'memcache.local' => '\OC\Memcache\APCu',
'memcache.distributed' => '\OC\Memcache\Redis',
'memcache.locking' => '\OC\Memcache\Redis',
'redis' => [
    'host' => 'redis',
    'port' => 6379,
],
'filelocking.enabled' => true,
'maintenance_window_start' => 1,
```

### Para Immich

```yaml
services:
  immich-server:
    environment:
      - DB_HOSTNAME=postgres
      - REDIS_HOSTNAME=redis
      - UPLOAD_LOCATION=/mnt/photos
    volumes:
      - /mnt/fast-ssd/immich:/usr/src/app/upload
```

---

## 📋 Performance Checklist

### Host Proxmox
- [ ] Kernel parameters optimizados
- [ ] CPU governor en performance
- [ ] Huge pages configuradas
- [ ] KSM habilitado
- [ ] TRIM habilitado para SSDs
- [ ] I/O scheduler optimizado
- [ ] Network offloading habilitado

### VMs y Contenedores
- [ ] Virtio drivers instalados
- [ ] CPU pinning para VMs críticas
- [ ] Ballooning configurado
- [ ] Cache de disco optimizado
- [ ] Límites de recursos definidos
- [ ] Health checks eficientes

### Bases de Datos
- [ ] Buffer pools dimensionados
- [ ] Logs optimizados
- [ ] Índices creados
- [ ] Queries optimizadas
- [ ] Backups programados fuera de horas pico

### Aplicaciones
- [ ] Caching habilitado
- [ ] Compresión activada
- [ ] Assets estáticos optimizados
- [ ] CDN configurado (si aplica)
- [ ] Logs rotados

---

## 🔧 Troubleshooting de Performance

### CPU Alto

```bash
# Ver procesos
top -o %CPU

# Ver threads
ps -eLf | sort -k4 -r | head

# Profiling
perf top
```

### Memoria Alta

```bash
# Ver uso
free -h
vmstat 1

# Ver por proceso
ps aux --sort=-%mem | head

# Cache vs usado
cat /proc/meminfo
```

### Disco Lento

```bash
# Ver I/O
iotop -o

# Ver latencia
iostat -x 1

# Test de velocidad
dd if=/dev/zero of=/tmp/test bs=1M count=1024 oflag=direct
```

### Red Lenta

```bash
# Ver conexiones
ss -s

# Ver ancho de banda
iftop

# Test de velocidad
iperf3 -c servidor
```

---

## 📚 Recursos Adicionales

- [Proxmox Performance Tweaks](https://pve.proxmox.com/wiki/Performance_Tweaks)
- [Linux Performance](http://www.brendangregg.com/linuxperf.html)
- [PostgreSQL Tuning](https://wiki.postgresql.org/wiki/Tuning_Your_PostgreSQL_Server)
- [Nginx Optimization](https://www.nginx.com/blog/tuning-nginx/)

---

## 🔗 Navegación

- [⬅️ Volver a Security Hardening](security-hardening.md)
- [➡️ Siguiente: Scaling](scaling.md)
- [🏠 Volver al índice](../README.md)
