# Troubleshooting y Resolución de Problemas

Guía de solución de problemas comunes en el homelab.

## 📋 Índice

- [Problemas de Proxmox](#problemas-de-proxmox)
- [Problemas de Red](#problemas-de-red)
- [Problemas de Contenedores](#problemas-de-contenedores)
- [Problemas de Docker](#problemas-de-docker)
- [Problemas de Almacenamiento](#problemas-de-almacenamiento)

## Problemas de Proxmox

### Host No Responde

**Síntomas:** No se puede acceder a la interfaz web de Proxmox

**Soluciones:**

```bash
# Verificar estado del servicio
systemctl status pveproxy

# Reiniciar servicio web
systemctl restart pveproxy pvedaemon

# Verificar logs
journalctl -u pveproxy -f
```

### Alta Carga del Sistema

**Síntomas:** Sistema lento, alta carga de CPU

**Diagnóstico:**

```bash
# Ver procesos que consumen CPU
top
htop

# Ver carga del sistema
uptime

# Ver uso de memoria
free -h

# Ver I/O de disco
iotop
```

### Problemas de Almacenamiento

**Síntomas:** Disco lleno, errores de escritura

```bash
# Ver uso de disco
df -h

# Ver archivos grandes
du -sh /* | sort -h

# Limpiar logs antiguos
journalctl --vacuum-time=7d

# Limpiar cache de apt
apt clean
```

## Problemas de Red

### Contenedor Sin Conectividad

**Diagnóstico:**

```bash
# Dentro del contenedor
ping 8.8.8.8
ping google.com

# Verificar configuración de red
ip addr
ip route

# Verificar DNS
cat /etc/resolv.conf
```

**Soluciones:**

```bash
# Reiniciar red del contenedor
systemctl restart networking

# Desde Proxmox, reiniciar contenedor
pct stop <CTID>
pct start <CTID>
```

### Problemas de DNS

**Síntomas:** No resuelve nombres de dominio

```bash
# Probar resolución DNS
nslookup google.com
dig google.com

# Verificar servidor DNS
cat /etc/resolv.conf

# Cambiar DNS temporalmente
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

### Problemas de Firewall

**Síntomas:** Puertos bloqueados, servicios inaccesibles

```bash
# Ver reglas de firewall
iptables -L -n -v

# Ver puertos en escucha
netstat -tulpn
ss -tulpn

# Probar conectividad a puerto
telnet <IP> <PORT>
nc -zv <IP> <PORT>
```

## Problemas de Contenedores

### Contenedor No Inicia

**Diagnóstico:**

```bash
# Ver logs del contenedor
pct enter <CTID>
journalctl -xe

# Ver configuración
cat /etc/pve/lxc/<CTID>.conf

# Verificar recursos
pct status <CTID>
```

**Soluciones:**

```bash
# Iniciar en modo debug
pct start <CTID> --debug

# Verificar permisos
ls -la /var/lib/lxc/<CTID>

# Reparar sistema de archivos
pct fsck <CTID>
```

### Contenedor Corrupto

**Síntomas:** Errores al iniciar, archivos corruptos

```bash
# Restaurar desde backup
pct restore <CTID> /var/lib/vz/dump/vzdump-lxc-<CTID>-*.tar.zst

# O reparar sistema de archivos
pct mount <CTID>
fsck /dev/pve/vm-<CTID>-disk-0
pct unmount <CTID>
```

## Problemas de Docker

### Contenedor Docker No Inicia

**Diagnóstico:**

```bash
# Ver logs del contenedor
docker logs <container_name>

# Ver estado
docker ps -a

# Inspeccionar contenedor
docker inspect <container_name>
```

**Soluciones:**

```bash
# Recrear contenedor
docker-compose down
docker-compose up -d

# Limpiar y recrear
docker-compose down -v
docker-compose up -d
```

### Docker Sin Espacio

**Síntomas:** Error "no space left on device"

```bash
# Ver uso de disco de Docker
docker system df

# Limpiar contenedores parados
docker container prune

# Limpiar imágenes no usadas
docker image prune -a

# Limpiar volúmenes no usados
docker volume prune

# Limpieza completa
docker system prune -a --volumes
```

### Problemas de Red en Docker

**Síntomas:** Contenedores no se comunican

```bash
# Ver redes Docker
docker network ls

# Inspeccionar red
docker network inspect <network_name>

# Recrear red
docker network rm <network_name>
docker network create <network_name>

# Reconectar contenedor
docker network connect <network_name> <container_name>
```

## Problemas de Almacenamiento

### ZFS Pool Degradado

**Síntomas:** Alertas de ZFS, rendimiento degradado

```bash
# Ver estado del pool
zpool status

# Ver errores
zpool status -v

# Scrub del pool
zpool scrub <pool_name>

# Reemplazar disco fallido
zpool replace <pool_name> <old_disk> <new_disk>
```

### Disco Lleno

**Síntomas:** Errores de escritura, servicios fallan

```bash
# Identificar uso de disco
df -h
du -sh /* | sort -h

# Limpiar logs
journalctl --vacuum-time=7d
find /var/log -type f -name "*.log" -mtime +30 -delete

# Limpiar backups antiguos
find /var/lib/vz/dump -type f -mtime +30 -delete

# Limpiar Docker
docker system prune -a --volumes
```

## Comandos Útiles de Diagnóstico

### Información del Sistema

```bash
# Información general
pveversion -v
uname -a

# Uso de recursos
htop
iotop
nethogs

# Logs del sistema
journalctl -f
tail -f /var/log/syslog
```

### Verificación de Servicios

```bash
# Estado de servicios Proxmox
systemctl status pve*

# Estado de servicios en contenedor
pct exec <CTID> -- systemctl status

# Puertos en escucha
ss -tulpn | grep LISTEN
```

### Backup y Recuperación

```bash
# Listar backups
pvesm list local

# Restaurar contenedor
pct restore <CTID> <backup_file>

# Restaurar VM
qmrestore <backup_file> <VMID>
```

## Checklist de Troubleshooting

Cuando algo falla:

1. **Identificar el problema**
   - [ ] ¿Qué servicio está fallando?
   - [ ] ¿Cuándo empezó el problema?
   - [ ] ¿Qué cambios se hicieron recientemente?

2. **Recopilar información**
   - [ ] Revisar logs
   - [ ] Verificar recursos (CPU, RAM, disco)
   - [ ] Probar conectividad de red

3. **Intentar soluciones básicas**
   - [ ] Reiniciar el servicio
   - [ ] Reiniciar el contenedor/VM
   - [ ] Verificar configuración

4. **Soluciones avanzadas**
   - [ ] Restaurar desde backup
   - [ ] Revisar cambios recientes
   - [ ] Consultar documentación

5. **Documentar**
   - [ ] Anotar el problema
   - [ ] Documentar la solución
   - [ ] Actualizar procedimientos

## 📚 Recursos Relacionados

- [Actualizaciones](updates.md)
- [Monitoreo y Alertas](monitoring-alerts.md)
- [Recuperación de Desastres](disaster-recovery.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
