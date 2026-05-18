# 💾 Storage Setup

Configuración del disco adicional para backups en Proxmox.

## 📋 Resumen

Este proyecto utiliza dos discos:
- **SSD NVMe 500GB**: Sistema Proxmox y VMs/CTs
- **SSD SATA 250GB**: Backups locales

Esta guía cubre la configuración del disco de backups.

## 🔍 Identificar Discos

```bash
# Ver todos los discos
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL

# Salida esperada:
# NAME        SIZE TYPE FSTYPE MOUNTPOINT           MODEL
# sda         250G disk                             Crucial_MX500_250GB
# nvme0n1     500G disk                             Micron_2200V_MTFDHBA512TCK
# ├─nvme0n1p1 1007K part
# ├─nvme0n1p2  512M part vfat   /boot/efi
# └─nvme0n1p3  499G part lvm
```

En este caso:
- `/dev/nvme0n1` = Disco principal (Proxmox)
- `/dev/sda` = Disco de backups (Crucial MX500 250GB)

## ⚠️ ADVERTENCIA

**Este proceso BORRARÁ todos los datos del disco seleccionado.**

Verifica dos veces que estás trabajando con el disco correcto:

```bash
# Ver información detallada del disco
lsblk -o NAME,SIZE,MODEL /dev/sda
smartctl -i /dev/sda
```

## 🧹 Limpiar Disco

### Desmontar Particiones Existentes

```bash
# Ver si hay algo montado
mount | grep sda

# Desmontar si es necesario
umount /dev/sda1 2>/dev/null || true
umount /dev/sda2 2>/dev/null || true
```

### Borrar Estructuras Existentes

```bash
# Limpiar firmas de filesystem
wipefs -a /dev/sda

# Limpiar tabla de particiones
sgdisk --zap-all /dev/sda

# Actualizar kernel sobre cambios
partprobe /dev/sda

# Si partprobe no existe:
apt install -y parted
partprobe /dev/sda
```

### Verificar Limpieza

```bash
# No debe mostrar particiones
lsblk /dev/sda

# Salida esperada:
# NAME SIZE TYPE
# sda  250G disk
```

## 📐 Crear Partición

### Crear Partición GPT

```bash
# Crear una sola partición usando todo el disco
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" /dev/sda

# Actualizar kernel
partprobe /dev/sda

# Verificar
lsblk /dev/sda

# Salida esperada:
# NAME   SIZE TYPE
# sda    250G disk
# └─sda1 250G part
```

**Explicación de parámetros:**
- `-n 1:0:0` = Partición 1, desde el inicio hasta el final
- `-t 1:8300` = Tipo Linux filesystem
- `-c 1:"hdd250-data"` = Etiqueta de partición

## 🗂️ Formatear Partición

### Formatear en ext4

```bash
# Formatear con optimizaciones
mkfs.ext4 -L hdd250-data -m 0 /dev/sda1

# Parámetros:
# -L hdd250-data = Etiqueta del filesystem
# -m 0 = Sin espacio reservado para root (más espacio disponible)
```

### Verificar Formato

```bash
# Ver información del filesystem
blkid /dev/sda1

# Salida esperada:
# /dev/sda1: LABEL="hdd250-data" UUID="..." TYPE="ext4"

# Ver detalles
tune2fs -l /dev/sda1 | grep -E "Filesystem|Block count|Block size|Reserved"
```

## 📁 Montar Disco

### Crear Punto de Montaje

```bash
# Crear directorio
mkdir -p /mnt/hdd250

# Verificar
ls -ld /mnt/hdd250
```

### Montaje Manual

```bash
# Montar
mount /dev/sda1 /mnt/hdd250

# Verificar
df -h /mnt/hdd250

# Salida esperada:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1       246G   28K  246G   1% /mnt/hdd250
```

### Montaje Automático (fstab)

```bash
# Obtener UUID
UUID=$(blkid -s UUID -o value /dev/sda1)
echo "UUID del disco: $UUID"

# Añadir a fstab
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab

# Verificar fstab
cat /etc/fstab | grep hdd250

# Probar montaje automático
umount /mnt/hdd250
mount -a
df -h /mnt/hdd250
```

**Opciones de montaje:**
- `defaults` = Opciones por defecto
- `noatime` = No actualizar tiempo de acceso (mejor rendimiento)
- `0` = No hacer dump
- `2` = Verificar filesystem en boot (después del root)

## 📂 Crear Estructura de Directorios

```bash
# Crear estructura
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
mkdir -p /mnt/hdd250/backups/dump

# Establecer permisos
chmod -R 775 /mnt/hdd250

# Verificar
tree -L 2 /mnt/hdd250

# Salida esperada:
# /mnt/hdd250
# ├── backups
# │   └── dump
# ├── data
# ├── downloads
# ├── media
# └── shared
```

## 🔧 Añadir a Proxmox

### Desde Web UI

1. Ir a `Datacenter > Storage > Add > Directory`

2. Configurar:
   ```
   ID: hdd250-backups
   Directory: /mnt/hdd250/backups
   Content: VZDump backup file
   Shared: No
   Enable: Yes
   ```

3. Click en "Add"

### Desde CLI (Alternativo)

```bash
# Añadir storage
pvesm add dir hdd250-backups \
  --path /mnt/hdd250/backups \
  --content backup \
  --shared 0

# Verificar
pvesm status

# Debe aparecer:
# Name              Type     Status           Total       Used  Available        %
# hdd250-backups    dir      active      256901120      28672  256872448    0.01%
```

## ✅ Verificación

### Script de Verificación

```bash
cat > /root/verify-storage.sh <<'EOF'
#!/bin/bash
echo "=== STORAGE VERIFICATION ==="
echo ""

echo "1. Disk Information:"
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL | grep -E "NAME|sda"
echo ""

echo "2. Mount Status:"
mount | grep hdd250
echo ""

echo "3. Filesystem Info:"
df -h /mnt/hdd250
echo ""

echo "4. UUID:"
blkid /dev/sda1 | grep -o 'UUID="[^"]*"'
echo ""

echo "5. fstab Entry:"
grep hdd250 /etc/fstab
echo ""

echo "6. Directory Structure:"
tree -L 2 /mnt/hdd250
echo ""

echo "7. Proxmox Storage:"
pvesm status | grep -E "Name|hdd250"
echo ""

echo "8. Write Test:"
TEST_FILE="/mnt/hdd250/test-write-$(date +%s).txt"
echo "Test write at $(date)" > "$TEST_FILE"
if [ -f "$TEST_FILE" ]; then
  echo "✓ Write test successful"
  cat "$TEST_FILE"
  rm "$TEST_FILE"
else
  echo "✗ Write test failed"
fi
echo ""

echo "=== VERIFICATION COMPLETE ==="
EOF

chmod +x /root/verify-storage.sh
/root/verify-storage.sh
```

### Checklist

- [ ] Disco identificado correctamente
- [ ] Partición creada
- [ ] Filesystem formateado
- [ ] Montado en /mnt/hdd250
- [ ] Entrada en fstab
- [ ] Estructura de directorios creada
- [ ] Añadido a Proxmox como storage
- [ ] Test de escritura exitoso

## 🔄 Backup Manual de Prueba

```bash
# Hacer backup de un CT (ejemplo CT 100)
vzdump 100 --storage hdd250-backups --mode snapshot --compress zstd

# Ver backups
ls -lh /mnt/hdd250/backups/dump/

# Salida esperada:
# vzdump-lxc-100-2024_01_15-22_30_00.tar.zst
```

## 🐛 Solución de Problemas

### Disco no detectado

```bash
# Rescanear buses
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan

# Verificar
lsblk
```

### Error al montar

```bash
# Verificar filesystem
fsck.ext4 -f /dev/sda1

# Reparar si es necesario
fsck.ext4 -y /dev/sda1

# Intentar montar de nuevo
mount /dev/sda1 /mnt/hdd250
```

### Permisos incorrectos

```bash
# Corregir permisos
chown -R root:root /mnt/hdd250
chmod -R 775 /mnt/hdd250
```

### Storage no aparece en Proxmox

```bash
# Recargar configuración
pvesm set hdd250-backups --disable 0

# Verificar
pvesm status
```

## 📊 Monitoreo del Disco

### Ver Uso

```bash
# Uso general
df -h /mnt/hdd250

# Uso por directorio
du -sh /mnt/hdd250/*

# Uso detallado
ncdu /mnt/hdd250
```

### SMART Monitoring

```bash
# Ver estado SMART
smartctl -a /dev/sda

# Ver solo salud
smartctl -H /dev/sda

# Programar test
smartctl -t short /dev/sda
```

### Alertas de Espacio

```bash
# Script de alerta (opcional)
cat > /usr/local/bin/check-backup-space.sh <<'EOF'
#!/bin/bash
THRESHOLD=90
USAGE=$(df -h /mnt/hdd250 | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE" -gt "$THRESHOLD" ]; then
  echo "WARNING: Backup disk usage is ${USAGE}%"
  # Aquí podrías enviar email o notificación
fi
EOF

chmod +x /usr/local/bin/check-backup-space.sh

# Programar en cron (diario)
echo "0 8 * * * /usr/local/bin/check-backup-space.sh" | crontab -
```

## 📚 Próximos Pasos

1. **Scripts de Rendimiento** → [Performance Scripts](performance-scripts.md)
2. **Configurar Backups** → [Local Backups](../06-storage-backup/local-backups.md)
3. **Backups Remotos** → [Remote Backups](../06-storage-backup/remote-backups.md)

## 🔗 Referencias

- [Proxmox VE Storage](https://pve.proxmox.com/wiki/Storage)
- [Linux Filesystem Hierarchy](https://www.pathname.com/fhs/)
- [ext4 Filesystem](https://ext4.wiki.kernel.org/)

---

**¿Storage configurado?** Continúa con [Performance Scripts](performance-scripts.md) para optimizar tu servidor.
