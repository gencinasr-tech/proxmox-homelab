# ⚡ Performance Scripts

Scripts para optimizar el rendimiento del servidor Proxmox según el momento del día.

## 📋 Resumen

Este proyecto incluye dos modos de operación:
- **Modo Turbo**: Máximo rendimiento para uso diurno
- **Modo Noche Total**: Mínimo consumo para uso nocturno

## 🔧 Dependencias

### Instalar Herramientas

```bash
# Instalar utilidades necesarias
apt install -y linux-cpupower hdparm lm-sensors

# Detectar sensores de temperatura
sensors-detect --auto

# Verificar instalación
cpupower --version
hdparm -V
sensors
```

## 🚀 Modo Turbo

Script para máximo rendimiento durante el día.

### Crear Script

```bash
cat > /usr/local/sbin/modo-turbo <<'EOF'
#!/bin/bash
echo "=========================================="
echo "Activando MODO TURBO..."
echo "=========================================="
echo ""

# CPU: Governor performance (máxima frecuencia)
echo "1. Configurando CPU..."
cpupower frequency-set -g performance
cpupower frequency-set -u 2.10GHz 2>/dev/null || true

# Servicios Proxmox: Prioridad alta
echo "2. Ajustando prioridad de servicios..."
systemctl set-property pveproxy.service CPUWeight=100
systemctl set-property pvedaemon.service CPUWeight=100
systemctl set-property pvestatd.service CPUWeight=100

# Disco: Desactivar spin-down
echo "3. Configurando discos..."
hdparm -S 0 /dev/sda >/dev/null 2>&1 || true

echo ""
echo "=========================================="
echo "✓ Modo turbo activado"
echo "=========================================="
echo ""

# Mostrar estado
echo "Governor actual:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "N/A"

echo ""
echo "Frecuencia actual:"
cpupower frequency-info | grep "current CPU frequency" || true

echo ""
echo "Temperaturas:"
sensors | grep -E "Tctl|Core|temp" || true
EOF

chmod +x /usr/local/sbin/modo-turbo
```

### Características del Modo Turbo

**CPU:**
- Governor: `performance`
- Frecuencia máxima: 2.10 GHz (Ryzen 5 3550H)
- Sin throttling

**Servicios:**
- Proxmox con prioridad alta (CPUWeight=100)
- Respuesta rápida de la Web UI

**Discos:**
- Sin spin-down automático
- Acceso inmediato

### Ejecutar Modo Turbo

```bash
# Activar
modo-turbo

# Salida esperada:
# ==========================================
# Activando MODO TURBO...
# ==========================================
# 
# 1. Configurando CPU...
# 2. Ajustando prioridad de servicios...
# 3. Configurando discos...
# 
# ==========================================
# ✓ Modo turbo activado
# ==========================================
# 
# Governor actual:
# performance
```

## 🌙 Modo Noche Total

Script para mínimo consumo durante la noche, apagando servicios no críticos.

### Crear Script

```bash
cat > /usr/local/sbin/modo-noche-total <<'EOF'
#!/bin/bash
echo "=========================================="
echo "Activando MODO NOCHE TOTAL..."
echo "=========================================="
echo ""

# Lista de CTs/VMs que NO se apagarán
KEEP_IDS="100 103"

# Función para verificar si un ID está en la lista
keep_vm() {
    local id="$1"
    for keep in $KEEP_IDS; do
        if [ "$id" = "$keep" ]; then
            return 0
        fi
    done
    return 1
}

# CPU: Governor powersave (mínima frecuencia)
echo "1. Configurando CPU para ahorro de energía..."
cpupower frequency-set -g powersave
cpupower frequency-set -u 1.40GHz

# Mostrar IDs protegidos
echo ""
echo "2. Contenedores/VMs protegidos (NO se apagarán):"
for id in $KEEP_IDS; do
    NAME=$(pct config $id 2>/dev/null | grep "^hostname:" | cut -d' ' -f2 || qm config $id 2>/dev/null | grep "^name:" | cut -d' ' -f2 || echo "Unknown")
    echo "   - CT/VM $id: $NAME"
done

# Apagar CTs no protegidos
echo ""
echo "3. Apagando contenedores no críticos..."
pct list | awk 'NR>1 {print $1}' | while read -r id; do
    if keep_vm "$id"; then
        echo "   ✓ CT $id protegido, mantener activo"
    else
        NAME=$(pct config $id 2>/dev/null | grep "^hostname:" | cut -d' ' -f2 || echo "CT$id")
        echo "   ⏸ Apagando CT $id ($NAME)..."
        pct shutdown "$id" --timeout 60 2>/dev/null || pct stop "$id" 2>/dev/null || true
    fi
done

# Apagar VMs no protegidas
echo ""
echo "4. Apagando máquinas virtuales no críticas..."
qm list | awk 'NR>1 {print $1}' | while read -r id; do
    if keep_vm "$id"; then
        echo "   ✓ VM $id protegida, mantener activa"
    else
        NAME=$(qm config $id 2>/dev/null | grep "^name:" | cut -d' ' -f2 || echo "VM$id")
        echo "   ⏸ Apagando VM $id ($NAME)..."
        qm shutdown "$id" --timeout 180 2>/dev/null || qm stop "$id" 2>/dev/null || true
    fi
done

# Disco: Spin-down agresivo
echo ""
echo "5. Configurando discos para ahorro..."
hdparm -S 241 /dev/sda >/dev/null 2>&1 || true  # 30 minutos
hdparm -y /dev/sda >/dev/null 2>&1 || true      # Standby inmediato

# Servicios Proxmox: Prioridad baja
echo "6. Reduciendo prioridad de servicios..."
systemctl set-property pveproxy.service CPUWeight=30
systemctl set-property pvedaemon.service CPUWeight=30
systemctl set-property pvestatd.service CPUWeight=30

echo ""
echo "=========================================="
echo "✓ Modo noche total activado"
echo "=========================================="
echo ""

# Mostrar estado final
echo "Governor actual:"
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "N/A"

echo ""
echo "Contenedores activos:"
pct list | grep running || echo "Ninguno"

echo ""
echo "VMs activas:"
qm list | grep running || echo "Ninguna"

echo ""
echo "Temperaturas:"
sensors | grep -E "Tctl|Core|temp" || true

echo ""
echo "=========================================="
EOF

chmod +x /usr/local/sbin/modo-noche-total
```

### Características del Modo Noche

**CPU:**
- Governor: `powersave`
- Frecuencia máxima: 1.40 GHz
- Mínimo consumo

**Servicios Críticos (Mantener):**
- CT 100: Tailscale Gateway (acceso VPN)
- CT 103: DNS / AdGuard (resolución DNS)

**Servicios Apagados:**
- Dashboards (CT 101)
- Portainer (CT 102)
- Monitoring (CT 105)
- Proxy (CT 112)
- Identity/SSO (CT 113)
- Todas las apps (CTs 106-111, 114-115)
- VMs (104, 109)

**Discos:**
- Spin-down después de 30 minutos
- Standby inmediato al activar modo

**Servicios Proxmox:**
- Prioridad baja (CPUWeight=30)

### Personalizar Lista de Protección

Si necesitas acceso a más servicios de noche:

```bash
# Editar script
nano /usr/local/sbin/modo-noche-total

# Cambiar línea:
KEEP_IDS="100 103"

# Por ejemplo, para mantener también proxy y SSO:
KEEP_IDS="100 103 112 113"

# Guardar y salir (Ctrl+X, Y, Enter)
```

### Ejecutar Modo Noche

```bash
# Activar
modo-noche-total

# Salida esperada:
# ==========================================
# Activando MODO NOCHE TOTAL...
# ==========================================
# 
# 1. Configurando CPU para ahorro de energía...
# 
# 2. Contenedores/VMs protegidos (NO se apagarán):
#    - CT/VM 100: tailscale-gw
#    - CT/VM 103: dns
# 
# 3. Apagando contenedores no críticos...
#    ⏸ Apagando CT 101 (dashboard)...
#    ⏸ Apagando CT 102 (portainer)...
#    ...
```

## 🔄 Automatización

### Programar con Cron

```bash
# Editar crontab
crontab -e

# Añadir líneas:
# Modo turbo a las 8:00 AM
0 8 * * * /usr/local/sbin/modo-turbo

# Modo noche a las 23:00 (11 PM)
0 23 * * * /usr/local/sbin/modo-noche-total
```

### Programar con Systemd (Alternativo)

**Timer para Modo Turbo:**

```bash
cat > /etc/systemd/system/modo-turbo.service <<'EOF'
[Unit]
Description=Activate Turbo Mode
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/modo-turbo
EOF

cat > /etc/systemd/system/modo-turbo.timer <<'EOF'
[Unit]
Description=Activate Turbo Mode at 8 AM

[Timer]
OnCalendar=*-*-* 08:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now modo-turbo.timer
```

**Timer para Modo Noche:**

```bash
cat > /etc/systemd/system/modo-noche.service <<'EOF'
[Unit]
Description=Activate Night Mode
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/modo-noche-total
EOF

cat > /etc/systemd/system/modo-noche.timer <<'EOF'
[Unit]
Description=Activate Night Mode at 11 PM

[Timer]
OnCalendar=*-*-* 23:00:00
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable --now modo-noche.timer
```

### Verificar Timers

```bash
# Ver timers activos
systemctl list-timers

# Ver estado específico
systemctl status modo-turbo.timer
systemctl status modo-noche.timer
```

## 📊 Monitoreo

### Ver Estado Actual

```bash
# Governor actual
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# Frecuencia actual
cpupower frequency-info | grep "current CPU frequency"

# Temperaturas
sensors

# CTs/VMs activos
pct list | grep running
qm list | grep running
```

### Script de Estado

```bash
cat > /usr/local/bin/server-status <<'EOF'
#!/bin/bash
echo "=== SERVER STATUS ==="
echo ""

echo "Mode: $(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo 'Unknown')"
echo ""

echo "CPU Frequency:"
cpupower frequency-info | grep "current CPU frequency" || echo "N/A"
echo ""

echo "Temperature:"
sensors | grep -E "Tctl|Core" | head -3 || echo "N/A"
echo ""

echo "Active Containers:"
pct list | grep running | wc -l
echo ""

echo "Active VMs:"
qm list | grep running | wc -l
echo ""

echo "Memory Usage:"
free -h | grep Mem
echo ""

echo "Disk Usage:"
df -h / | tail -1
EOF

chmod +x /usr/local/bin/server-status
```

Uso:
```bash
server-status
```

## 🐛 Solución de Problemas

### Governor no cambia

```bash
# Verificar módulo cargado
lsmod | grep cpufreq

# Cargar módulo si es necesario
modprobe acpi-cpufreq

# Verificar governors disponibles
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors
```

### CTs no se apagan

```bash
# Apagar manualmente con timeout
pct shutdown 101 --timeout 60

# Forzar stop si no responde
pct stop 101

# Ver logs
journalctl -u pve-container@101
```

### Disco no entra en standby

```bash
# Verificar soporte
hdparm -I /dev/sda | grep "Standby"

# Forzar standby
hdparm -y /dev/sda

# Ver estado
hdparm -C /dev/sda
```

## 💡 Consejos

### Ahorro de Energía

- Modo noche puede reducir consumo en 40-60%
- Útil si el servidor corre 24/7
- Mantén solo servicios críticos activos

### Rendimiento

- Modo turbo mejora respuesta de Web UI
- Útil durante mantenimiento o configuración
- No necesario para operación normal

### Personalización

Ajusta `KEEP_IDS` según tus necesidades:

```bash
# Solo VPN y DNS (mínimo)
KEEP_IDS="100 103"

# + Proxy y SSO (acceso web)
KEEP_IDS="100 103 112 113"

# + Dashboard (monitoreo)
KEEP_IDS="100 103 112 113 101"
```

## 📚 Próximos Pasos

1. **Configurar Red** → [Network Design](../03-networking/network-design.md)
2. **Crear Servicios** → [Core Services](../04-core-services/)
3. **Configurar Backups** → [Local Backups](../06-storage-backup/local-backups.md)

## 🔗 Referencias

- [Linux CPUFreq](https://www.kernel.org/doc/html/latest/admin-guide/pm/cpufreq.html)
- [hdparm Manual](https://linux.die.net/man/8/hdparm)
- [systemd Timers](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)

---

**¿Scripts configurados?** Continúa con [Network Design](../03-networking/network-design.md) para configurar tu red.
