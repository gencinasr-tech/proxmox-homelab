#!/bin/bash
# Script para configurar el portátil para ignorar el cierre de tapa
# Útil para usar un portátil como servidor 24/7

set -e

echo "=========================================="
echo "Configurando cierre de tapa del portátil"
echo "=========================================="
echo ""

# Verificar que se ejecuta como root
if [ "$EUID" -ne 0 ]; then 
    echo "Error: Este script debe ejecutarse como root"
    exit 1
fi

echo "1. Creando backup de configuración original..."
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak
echo "   Backup guardado en: /etc/systemd/logind.conf.bak"

echo ""
echo "2. Configurando para ignorar cierre de tapa..."
sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf

echo ""
echo "3. Verificando configuración..."
echo ""
grep -E "HandleLidSwitch" /etc/systemd/logind.conf

echo ""
echo "4. Aplicando cambios..."
systemctl restart systemd-logind

echo ""
echo "=========================================="
echo "Configuración completada"
echo "=========================================="
echo ""
echo "El portátil ahora ignorará el cierre de tapa."
echo "Puedes cerrar la tapa y el servidor seguirá funcionando."
echo ""
echo "Para verificar que funciona:"
echo "  1. Cierra la tapa del portátil"
echo "  2. Desde otro PC, haz ping: ping 192.168.1.200"
echo "  3. O accede a: https://192.168.1.200:8006"
echo ""
