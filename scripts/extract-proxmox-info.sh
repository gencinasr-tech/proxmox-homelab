#!/bin/bash

################################################################################
# Script de Extracción Completa de Información de Proxmox
# Autor: Bob (Asistente IA)
# Fecha: 2026-05-18
# Descripción: Extrae TODA la información del servidor Proxmox para documentación
################################################################################

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directorio de salida (en CasaOS Samba para acceso desde Windows)
OUTPUT_DIR="/mnt/casaos-data/documents/proxmox-info-export"
OUTPUT_FILE="$OUTPUT_DIR/proxmox-complete-info-$(date +%Y%m%d-%H%M%S).json"
OUTPUT_TXT="$OUTPUT_DIR/proxmox-complete-info-$(date +%Y%m%d-%H%M%S).txt"

echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Script de Extracción Completa de Información de Proxmox      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Crear directorio de salida
mkdir -p "$OUTPUT_DIR"

echo -e "${GREEN}[✓]${NC} Directorio de salida: $OUTPUT_DIR"
echo -e "${GREEN}[✓]${NC} Archivo JSON: $(basename $OUTPUT_FILE)"
echo -e "${GREEN}[✓]${NC} Archivo TXT: $(basename $OUTPUT_TXT)"
echo ""

# Iniciar JSON
cat > "$OUTPUT_FILE" << 'EOF'
{
  "extraction_date": "TIMESTAMP_PLACEHOLDER",
  "proxmox_info": {},
  "hardware_info": {},
  "network_info": {},
  "storage_info": {},
  "containers": [],
  "vms": [],
  "backups": {},
  "users_and_permissions": {},
  "system_resources": {}
}
EOF

# Reemplazar timestamp
sed -i "s/TIMESTAMP_PLACEHOLDER/$(date -Iseconds)/" "$OUTPUT_FILE"

# Función para añadir al JSON
add_to_json() {
    local key=$1
    local value=$2
    python3 -c "
import json
import sys
with open('$OUTPUT_FILE', 'r') as f:
    data = json.load(f)
data['$key'] = $value
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(data, f, indent=2)
"
}

# Iniciar archivo de texto
cat > "$OUTPUT_TXT" << EOF
═══════════════════════════════════════════════════════════════════════════════
INFORMACIÓN COMPLETA DEL SERVIDOR PROXMOX
═══════════════════════════════════════════════════════════════════════════════
Fecha de extracción: $(date '+%Y-%m-%d %H:%M:%S')
Hostname: $(hostname)
═══════════════════════════════════════════════════════════════════════════════

EOF

echo -e "${YELLOW}[→]${NC} Extrayendo información del sistema..."

# 1. INFORMACIÓN DE PROXMOX
echo -e "\n${BLUE}[1/12]${NC} Versión de Proxmox..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 1. INFORMACIÓN DE PROXMOX                                                 ║
╚═══════════════════════════════════════════════════════════════════════════╝

EOF

pvesh get /version --output-format json >> "$OUTPUT_TXT"
pvesh get /version --output-format json | python3 -c "
import json, sys
data = json.load(sys.stdin)
with open('$OUTPUT_FILE', 'r') as f:
    full = json.load(f)
full['proxmox_info'] = data
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(full, f, indent=2)
"

cat >> "$OUTPUT_TXT" << EOF

Versión detallada:
$(cat /etc/pve/.version)

Cluster info:
$(pvesh get /cluster/status --output-format json 2>/dev/null || echo "No cluster configurado")

EOF

# 2. HARDWARE
echo -e "${BLUE}[2/12]${NC} Hardware del servidor..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 2. HARDWARE DEL SERVIDOR                                                  ║
╚═══════════════════════════════════════════════════════════════════════════╝

CPU:
$(lscpu | grep -E "Model name|Architecture|CPU\(s\)|Thread|Core|Socket")

Memoria RAM:
$(free -h)

Discos:
$(lsblk -o NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE,MODEL)

Información detallada de discos:
$(fdisk -l 2>/dev/null | grep -E "Disk /dev|Sector size|Disk model")

EOF

# 3. RED
echo -e "${BLUE}[3/12]${NC} Configuración de red..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 3. CONFIGURACIÓN DE RED                                                   ║
╚═══════════════════════════════════════════════════════════════════════════╝

Interfaces de red:
$(ip addr show)

Rutas:
$(ip route show)

Configuración de red de Proxmox:
$(cat /etc/network/interfaces)

Bridges:
$(brctl show 2>/dev/null || echo "brctl no disponible")

EOF

pvesh get /nodes/$(hostname)/network --output-format json | python3 -c "
import json, sys
data = json.load(sys.stdin)
with open('$OUTPUT_FILE', 'r') as f:
    full = json.load(f)
full['network_info'] = data
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(full, f, indent=2)
" 2>/dev/null

# 4. STORAGE
echo -e "${BLUE}[4/12]${NC} Almacenamiento..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 4. ALMACENAMIENTO                                                         ║
╚═══════════════════════════════════════════════════════════════════════════╝

Storage pools de Proxmox:
$(pvesh get /storage --output-format json)

Uso de disco:
$(df -h)

ZFS pools (si existen):
$(zpool list 2>/dev/null || echo "No ZFS pools")
$(zfs list 2>/dev/null || echo "")

LVM:
$(pvs 2>/dev/null)
$(vgs 2>/dev/null)
$(lvs 2>/dev/null)

EOF

pvesh get /storage --output-format json | python3 -c "
import json, sys
data = json.load(sys.stdin)
with open('$OUTPUT_FILE', 'r') as f:
    full = json.load(f)
full['storage_info'] = data
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(full, f, indent=2)
"

# 5. CONTENEDORES LXC
echo -e "${BLUE}[5/12]${NC} Contenedores LXC..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 5. CONTENEDORES LXC                                                       ║
╚═══════════════════════════════════════════════════════════════════════════╝

Lista de contenedores:
$(pct list)

EOF

# Obtener lista de CTs
CT_LIST=$(pct list | tail -n +2 | awk '{print $1}')

for CTID in $CT_LIST; do
    echo -e "${YELLOW}  → CT $CTID${NC}"
    cat >> "$OUTPUT_TXT" << EOF

───────────────────────────────────────────────────────────────────────────────
Contenedor $CTID
───────────────────────────────────────────────────────────────────────────────

Configuración:
$(pct config $CTID)

Estado:
$(pct status $CTID)

Recursos actuales:
$(pct exec $CTID -- df -h 2>/dev/null || echo "Contenedor apagado")
$(pct exec $CTID -- free -h 2>/dev/null || echo "")

EOF
done

# Guardar en JSON
pvesh get /nodes/$(hostname)/lxc --output-format json | python3 -c "
import json, sys
data = json.load(sys.stdin)
with open('$OUTPUT_FILE', 'r') as f:
    full = json.load(f)
full['containers'] = data
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(full, f, indent=2)
"

# 6. MÁQUINAS VIRTUALES
echo -e "${BLUE}[6/12]${NC} Máquinas virtuales..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 6. MÁQUINAS VIRTUALES                                                     ║
╚═══════════════════════════════════════════════════════════════════════════╝

Lista de VMs:
$(qm list)

EOF

VM_LIST=$(qm list | tail -n +2 | awk '{print $1}')

for VMID in $VM_LIST; do
    echo -e "${YELLOW}  → VM $VMID${NC}"
    cat >> "$OUTPUT_TXT" << EOF

───────────────────────────────────────────────────────────────────────────────
Máquina Virtual $VMID
───────────────────────────────────────────────────────────────────────────────

Configuración:
$(qm config $VMID)

Estado:
$(qm status $VMID)

EOF
done

pvesh get /nodes/$(hostname)/qemu --output-format json | python3 -c "
import json, sys
data = json.load(sys.stdin)
with open('$OUTPUT_FILE', 'r') as f:
    full = json.load(f)
full['vms'] = data
with open('$OUTPUT_FILE', 'w') as f:
    json.dump(full, f, indent=2)
" 2>/dev/null

# 7. BACKUPS
echo -e "${BLUE}[7/12]${NC} Configuración de backups..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 7. BACKUPS                                                                ║
╚═══════════════════════════════════════════════════════════════════════════╝

Tareas de backup programadas:
$(cat /etc/pve/vzdump.cron 2>/dev/null || echo "No hay backups programados")

Backups disponibles:
$(pvesh get /nodes/$(hostname)/storage/local/content --output-format json 2>/dev/null | grep -i backup || echo "")

EOF

# 8. USUARIOS Y PERMISOS
echo -e "${BLUE}[8/12]${NC} Usuarios y permisos..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 8. USUARIOS Y PERMISOS                                                    ║
╚═══════════════════════════════════════════════════════════════════════════╝

Usuarios:
$(pveum user list)

Grupos:
$(pveum group list)

Roles:
$(pveum role list)

ACLs:
$(pveum acl list)

EOF

# 9. RECURSOS DEL SISTEMA
echo -e "${BLUE}[9/12]${NC} Recursos del sistema..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 9. RECURSOS DEL SISTEMA                                                   ║
╚═══════════════════════════════════════════════════════════════════════════╝

Uso de CPU y memoria:
$(top -bn1 | head -20)

Procesos de Proxmox:
$(ps aux | grep -E "pve|qemu|lxc" | grep -v grep)

Servicios activos:
$(systemctl list-units --type=service --state=running | grep -E "pve|proxmox")

EOF

# 10. CONFIGURACIONES ADICIONALES
echo -e "${BLUE}[10/12]${NC} Configuraciones adicionales..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 10. CONFIGURACIONES ADICIONALES                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

Firewall de Proxmox:
$(cat /etc/pve/firewall/cluster.fw 2>/dev/null || echo "No configurado")

Configuración de datacenter:
$(cat /etc/pve/datacenter.cfg 2>/dev/null || echo "Default")

Repositorios configurados:
$(cat /etc/apt/sources.list.d/pve-*.list 2>/dev/null)

EOF

# 11. LOGS RECIENTES
echo -e "${BLUE}[11/12]${NC} Logs recientes..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 11. LOGS RECIENTES (últimas 50 líneas)                                   ║
╚═══════════════════════════════════════════════════════════════════════════╝

Syslog:
$(tail -50 /var/log/syslog)

Daemon log:
$(tail -50 /var/log/daemon.log)

EOF

# 12. INFORMACIÓN DE DOCKER (en contenedores)
echo -e "${BLUE}[12/12]${NC} Información de Docker en contenedores..."
cat >> "$OUTPUT_TXT" << EOF

╔═══════════════════════════════════════════════════════════════════════════╗
║ 12. DOCKER EN CONTENEDORES                                                ║
╚═══════════════════════════════════════════════════════════════════════════╝

EOF

for CTID in $CT_LIST; do
    HAS_DOCKER=$(pct exec $CTID -- which docker 2>/dev/null)
    if [ -n "$HAS_DOCKER" ]; then
        echo -e "${YELLOW}  → CT $CTID tiene Docker${NC}"
        cat >> "$OUTPUT_TXT" << EOF

───────────────────────────────────────────────────────────────────────────────
Docker en CT $CTID
───────────────────────────────────────────────────────────────────────────────

Versión de Docker:
$(pct exec $CTID -- docker --version 2>/dev/null)

Contenedores Docker:
$(pct exec $CTID -- docker ps -a 2>/dev/null)

Imágenes Docker:
$(pct exec $CTID -- docker images 2>/dev/null)

Volúmenes Docker:
$(pct exec $CTID -- docker volume ls 2>/dev/null)

Redes Docker:
$(pct exec $CTID -- docker network ls 2>/dev/null)

Docker Compose (si existe):
$(pct exec $CTID -- find /root /opt /home -name "docker-compose.yml" -o -name "docker-compose.yaml" 2>/dev/null)

EOF
    fi
done

# FINALIZAR
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  ✓ EXTRACCIÓN COMPLETADA CON ÉXITO                             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}Archivos generados:${NC}"
echo -e "  📄 JSON: ${GREEN}$OUTPUT_FILE${NC}"
echo -e "  📄 TXT:  ${GREEN}$OUTPUT_TXT${NC}"
echo ""
echo -e "${YELLOW}Acceso desde Windows:${NC}"
echo -e "  🗂️  Abre el explorador de archivos"
echo -e "  🗂️  Ve a: ${BLUE}\\\\192.168.1.200\\Server\\documents\\proxmox-info-export${NC}"
echo -e "  🗂️  O: ${BLUE}Z:\\documents\\proxmox-info-export${NC} (si tienes la unidad mapeada)"
echo ""
echo -e "${GREEN}[✓]${NC} Los archivos están listos para ser copiados a tu Windows"
echo ""

# Hacer los archivos legibles
chmod 644 "$OUTPUT_FILE" "$OUTPUT_TXT"
chmod 755 "$OUTPUT_DIR"

echo -e "${BLUE}Resumen de la información extraída:${NC}"
echo -e "  • Versión de Proxmox y cluster"
echo -e "  • Hardware completo (CPU, RAM, discos)"
echo -e "  • Configuración de red"
echo -e "  • Storage pools y uso de disco"
echo -e "  • $(echo $CT_LIST | wc -w) contenedores LXC con configuración completa"
echo -e "  • $(echo $VM_LIST | wc -w) máquinas virtuales"
echo -e "  • Configuración de backups"
echo -e "  • Usuarios, grupos y permisos"
echo -e "  • Recursos del sistema en tiempo real"
echo -e "  • Información de Docker en cada contenedor"
echo -e "  • Logs recientes del sistema"
echo ""
echo -e "${YELLOW}Próximos pasos:${NC}"
echo -e "  1. Copia los archivos desde el Samba a tu Windows"
echo -e "  2. Envía el archivo JSON o TXT al asistente"
echo -e "  3. Se generará documentación 100% precisa"
echo ""

# Made with Bob
