# ⚙️ Initial Configuration

Configuración inicial del host Proxmox después de la instalación.

## 📋 Resumen

Esta guía cubre:
- Configuración de repositorios no-subscription
- Actualización del sistema
- Configuración para portátiles (ignorar cierre de tapa)
- Instalación de herramientas básicas
- Configuración de zona horaria y locales

## 🔧 Configuración de Repositorios

### Problema con Repositorios Enterprise

Por defecto, Proxmox viene configurado con repositorios enterprise que requieren suscripción. Sin suscripción, verás errores al hacer `apt update`.

### Desactivar Repositorios Enterprise

```bash
# Desactivar repo enterprise de Proxmox
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/pve-enterprise.sources 2>/dev/null

# Desactivar repo enterprise de Ceph (si existe)
sed -i 's/^Enabled: yes/Enabled: no/' /etc/apt/sources.list.d/ceph.sources 2>/dev/null

# Verificar
cat /etc/apt/sources.list.d/pve-enterprise.sources
# Debe mostrar: Enabled: no
```

### Añadir Repositorio No-Subscription

```bash
# Crear archivo de repositorio no-subscription
cat > /etc/apt/sources.list.d/proxmox-no-subscription.sources <<'EOF'
Types: deb
URIs: http://download.proxmox.com/debian/pve
Suites: trixie
Components: pve-no-subscription
Signed-By: /usr/share/keyrings/proxmox-archive-keyring.gpg
EOF

# Verificar contenido
cat /etc/apt/sources.list.d/proxmox-no-subscription.sources
```

### Actualizar Sistema

```bash
# Actualizar lista de paquetes
apt update

# Actualizar todos los paquetes
apt upgrade -y

# Limpiar paquetes antiguos
apt autoremove -y
apt autoclean

# Si hay actualizaciones de kernel, reiniciar
reboot
```

### Verificar Actualizaciones

Después del reinicio:

```bash
# Ver versión de Proxmox
pveversion -v

# Debe mostrar algo como:
# proxmox-ve: 9.1.9 (running kernel: 6.8.12-4-pve)
# pve-manager: 9.1.9 (running version: 9.1.9/...)
```

## 💻 Configuración para Portátiles

Si instalaste Proxmox en un portátil, necesitas evitar que se suspenda al cerrar la tapa.

### Backup de Configuración

```bash
# Crear backup del archivo original
cp /etc/systemd/logind.conf /etc/systemd/logind.conf.bak

# Verificar backup
ls -lh /etc/systemd/logind.conf*
```

### Configurar Comportamiento de Tapa

```bash
# Configurar para ignorar cierre de tapa
sed -i 's/^#HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchExternalPower=.*/HandleLidSwitchExternalPower=ignore/' /etc/systemd/logind.conf
sed -i 's/^#HandleLidSwitchDocked=.*/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
```

### Verificar Configuración

```bash
# Ver líneas modificadas
grep -E "HandleLidSwitch" /etc/systemd/logind.conf

# Debe mostrar:
# HandleLidSwitch=ignore
# HandleLidSwitchExternalPower=ignore
# HandleLidSwitchDocked=ignore
```

### Aplicar Cambios

```bash
# Reiniciar servicio de login
systemctl restart systemd-logind

# Verificar estado
systemctl status systemd-logind
```

### Probar Configuración

1. Desde otro PC, inicia un ping continuo:
   ```bash
   ping 192.168.1.200
   ```

2. Cierra la tapa del portátil

3. El ping debe continuar sin interrupciones

4. Abre la tapa y verifica que todo sigue funcionando

## 🛠️ Herramientas Básicas

### Instalar Utilidades Esenciales

```bash
# Herramientas de sistema
apt install -y \
  htop \
  iotop \
  iftop \
  ncdu \
  tree \
  vim \
  nano \
  curl \
  wget \
  git \
  screen \
  tmux \
  net-tools \
  dnsutils \
  iputils-ping \
  traceroute \
  mtr \
  tcpdump \
  ethtool \
  lsof \
  strace

# Herramientas de monitoreo
apt install -y \
  lm-sensors \
  smartmontools \
  hdparm

# Herramientas de red
apt install -y \
  bridge-utils \
  vlan \
  ifupdown2
```

### Configurar Sensores de Temperatura

```bash
# Detectar sensores
sensors-detect --auto

# Ver temperaturas
sensors

# Ejemplo de salida:
# k10temp-pci-00c3
# Adapter: PCI adapter
# Tctl:         +45.0°C
```

### Configurar SMART Monitoring

```bash
# Habilitar SMART en discos
smartctl -s on /dev/nvme0n1
smartctl -s on /dev/sda

# Ver información SMART
smartctl -a /dev/nvme0n1
smartctl -a /dev/sda

# Programar tests automáticos (opcional)
cat >> /etc/smartd.conf <<'EOF'
/dev/nvme0n1 -a -o on -S on -s (S/../.././02|L/../../6/03)
/dev/sda -a -o on -S on -s (S/../.././02|L/../../6/03)
EOF

systemctl enable --now smartd
```

## 🌍 Configuración Regional

### Zona Horaria

```bash
# Ver zona horaria actual
timedatectl

# Configurar zona horaria de Madrid
timedatectl set-timezone Europe/Madrid

# Verificar
timedatectl
# Debe mostrar: Time zone: Europe/Madrid (CET, +0100)
```

### Locales

```bash
# Generar locales español e inglés
cat >> /etc/locale.gen <<'EOF'
en_US.UTF-8 UTF-8
es_ES.UTF-8 UTF-8
EOF

# Generar locales
locale-gen

# Configurar locale por defecto
update-locale LANG=en_US.UTF-8

# Verificar
locale
```

### Configurar NTP

```bash
# Verificar sincronización de tiempo
timedatectl status

# Debe mostrar:
# System clock synchronized: yes
# NTP service: active

# Ver servidores NTP
cat /etc/systemd/timesyncd.conf

# Forzar sincronización
systemctl restart systemd-timesyncd
```

## 🔐 Seguridad Básica

### Configurar SSH (Opcional)

Si quieres acceder por SSH desde otros equipos:

```bash
# Verificar que SSH está activo
systemctl status ssh

# Configuración recomendada
cat >> /etc/ssh/sshd_config.d/custom.conf <<'EOF'
# Deshabilitar login root por contraseña (usar solo keys)
PermitRootLogin prohibit-password

# Deshabilitar autenticación por contraseña (solo keys)
# PasswordAuthentication no

# Permitir solo usuarios específicos
# AllowUsers tu_usuario

# Cambiar puerto (opcional, por seguridad)
# Port 2222
EOF

# Reiniciar SSH
systemctl restart ssh
```

### Configurar Firewall (Opcional)

Proxmox tiene su propio firewall integrado, pero puedes usar iptables:

```bash
# Ver reglas actuales
iptables -L -n -v

# Proxmox gestiona su firewall desde la Web UI
# Datacenter > Firewall
```

## 📊 Verificación Final

### Script de Verificación

```bash
cat > /root/verify-setup.sh <<'EOF'
#!/bin/bash
echo "=== PROXMOX SETUP VERIFICATION ==="
echo ""

echo "1. Proxmox Version:"
pveversion -v | head -3
echo ""

echo "2. Network Configuration:"
ip -4 addr show | grep inet
echo ""

echo "3. Storage:"
df -h | grep -E "Filesystem|/dev/"
echo ""

echo "4. Memory:"
free -h
echo ""

echo "5. CPU:"
lscpu | grep -E "Model name|CPU\(s\)|Thread"
echo ""

echo "6. Temperature:"
sensors 2>/dev/null | grep -E "Tctl|Core|temp" || echo "lm-sensors not configured"
echo ""

echo "7. Services:"
for service in pveproxy pvedaemon pvestatd; do
  systemctl is-active $service && echo "$service: OK" || echo "$service: FAILED"
done
echo ""

echo "8. Repositories:"
apt update 2>&1 | grep -E "Hit|Get|Err" | head -5
echo ""

echo "=== VERIFICATION COMPLETE ==="
EOF

chmod +x /root/verify-setup.sh
/root/verify-setup.sh
```

### Checklist de Configuración

- [ ] Repositorios no-subscription configurados
- [ ] Sistema actualizado
- [ ] Configuración de tapa (si es portátil)
- [ ] Herramientas básicas instaladas
- [ ] Zona horaria configurada
- [ ] Sensores de temperatura funcionando
- [ ] Servicios de Proxmox activos
- [ ] Red funcionando correctamente

## 🐛 Solución de Problemas

### Error al actualizar repositorios

```bash
# Limpiar cache
apt clean
rm -rf /var/lib/apt/lists/*
apt update

# Si persiste, verificar conectividad
ping -c 3 download.proxmox.com
```

### Servicios no inician

```bash
# Ver logs
journalctl -xe

# Reiniciar servicios
systemctl restart pveproxy pvedaemon pvestatd

# Verificar estado
systemctl status pveproxy pvedaemon pvestatd
```

### Problemas de red

```bash
# Verificar interfaces
ip link show

# Verificar configuración
cat /etc/network/interfaces

# Reiniciar red
systemctl restart networking

# O reiniciar el sistema
reboot
```

### Portátil se suspende al cerrar tapa

```bash
# Verificar configuración
grep HandleLidSwitch /etc/systemd/logind.conf

# Debe mostrar "ignore", no "suspend"
# Si no, repetir la configuración

# Reiniciar servicio
systemctl restart systemd-logind
```

## 📚 Próximos Pasos

1. **Configurar Almacenamiento** → [Storage Setup](storage-setup.md)
2. **Scripts de Rendimiento** → [Performance Scripts](performance-scripts.md)
3. **Crear Primer Contenedor** → [Quick Start](../01-getting-started/quick-start.md)

## 🔗 Referencias

- [Proxmox VE Package Repositories](https://pve.proxmox.com/wiki/Package_Repositories)
- [Proxmox VE System Administration](https://pve.proxmox.com/wiki/System_Administration)
- [Debian System Administration](https://www.debian.org/doc/manuals/debian-reference/)

---

**¿Configuración completada?** Continúa con [Storage Setup](storage-setup.md) para configurar tus discos.
