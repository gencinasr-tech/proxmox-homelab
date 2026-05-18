#!/bin/bash
# Script para preparar repositorios de Proxmox
# Desactiva repos enterprise y añade no-subscription

set -e

echo "=========================================="
echo "Preparando repositorios de Proxmox"
echo "=========================================="
echo ""

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo "Error: Este script debe ejecutarse como root"
    exit 1
fi

echo "1. Desactivando repositorios enterprise..."
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pve-enterprise.sources 2>/dev/null || true
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/ceph.sources 2>/dev/null || true

echo "2. Creando repositorio no-subscription..."
cat > /etc/apt/sources.list.d/proxmox-no-subscription.sources <<'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

echo "3. Actualizando lista de paquetes..."
apt update

echo ""
echo "=========================================="
echo "Repositorios configurados correctamente"
echo "=========================================="
echo ""
echo "Puedes actualizar el sistema con:"
echo "  apt upgrade -y"
echo ""

# Made with Bob
