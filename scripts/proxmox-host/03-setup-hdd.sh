#!/bin/bash
# Script para configurar HDD adicional para backups
# ADVERTENCIA: Este script BORRARÁ todos los datos del disco especificado

set -e

echo "=========================================="
echo "Configuración de HDD para Backups"
echo "=========================================="
echo ""

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo "Error: Este script debe ejecutarse como root"
    exit 1
fi

# Mostrar discos disponibles
echo "Discos disponibles en el sistema:"
echo ""
lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
echo ""

# Solicitar confirmación del disco
read -p "Ingresa el dispositivo a usar (ej: sda): " DISK_NAME
DISK="/dev/${DISK_NAME}"

if [ ! -b "$DISK" ]; then
    echo "Error: El dispositivo $DISK no existe"
    exit 1
fi

echo ""
echo "ADVERTENCIA: Se borrarán TODOS los datos de $DISK"
echo "Información del disco:"
lsblk -o NAME,SIZE,TYPE,MODEL "$DISK"
echo ""
read -p "¿Estás seguro? Escribe 'SI' para continuar: " CONFIRM

if [ "$CONFIRM" != "SI" ]; then
    echo "Operación cancelada"
    exit 0
fi

echo ""
echo "1. Desmontando particiones existentes..."
umount ${DISK}* 2>/dev/null || true

echo "2. Limpiando disco..."
wipefs -a "$DISK"
sgdisk --zap-all "$DISK"

echo "3. Instalando parted si es necesario..."
apt install -y parted

echo "4. Actualizando tabla de particiones..."
partprobe "$DISK"

echo "5. Creando nueva partición GPT..."
sgdisk -n 1:0:0 -t 1:8300 -c 1:"hdd250-data" "$DISK"
partprobe "$DISK"

echo "6. Formateando en ext4..."
mkfs.ext4 -L hdd250-data -m 0 ${DISK}1

echo "7. Creando punto de montaje..."
mkdir -p /mnt/hdd250

echo "8. Montando disco..."
mount ${DISK}1 /mnt/hdd250

echo "9. Creando estructura de carpetas..."
mkdir -p /mnt/hdd250/{backups,data,media,downloads,shared}
mkdir -p /mnt/hdd250/backups/dump

echo "10. Configurando permisos..."
chmod -R 775 /mnt/hdd250

echo "11. Añadiendo a fstab para montaje automático..."
UUID=$(blkid -s UUID -o value ${DISK}1)
echo "UUID=$UUID /mnt/hdd250 ext4 defaults,noatime 0 2" >> /etc/fstab

echo "12. Verificando montaje automático..."
mount -a

echo ""
echo "=========================================="
echo "HDD configurado correctamente"
echo "=========================================="
echo ""
echo "Información del disco:"
df -h /mnt/hdd250
echo ""
echo "Estructura de carpetas:"
tree -L 2 /mnt/hdd250 2>/dev/null || ls -la /mnt/hdd250
echo ""
echo "Siguiente paso:"
echo "  Añadir como storage en Proxmox Web UI:"
echo "  Datacenter > Storage > Add > Directory"
echo "  - ID: hdd250-backups"
echo "  - Directory: /mnt/hdd250/backups"
echo "  - Content: VZDump backup file"
echo ""

# Made with Bob
