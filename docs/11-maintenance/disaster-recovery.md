# 🚨 Disaster Recovery

Guía completa para recuperación ante desastres en tu homelab.

## 📋 Tabla de Contenidos

- [Estrategia de Backup](#estrategia-de-backup)
- [Tipos de Desastres](#tipos-de-desastres)
- [Plan de Recuperación](#plan-de-recuperación)
- [Restauración de Proxmox](#restauración-de-proxmox)
- [Restauración de VMs y Contenedores](#restauración-de-vms-y-contenedores)
- [Restauración de Datos](#restauración-de-datos)
- [Restauración de Servicios](#restauración-de-servicios)
- [Testing del DR Plan](#testing-del-dr-plan)

---

## 💾 Estrategia de Backup

### Regla 3-2-1

```
┌─────────────────────────────────────────┐
│         REGLA 3-2-1 DE BACKUPS         │
├─────────────────────────────────────────┤
│  3  Copias de tus datos                │
│     - Original                          │
│     - Backup local                      │
│     - Backup remoto                     │
│                                         │
│  2  Tipos de medios diferentes         │
│     - SSD/HDD local                     │
│     - Cloud storage                     │
│                                         │
│  1  Copia offsite                      │
│     - Google Drive cifrado              │
│     - Otro datacenter                   │
└─────────────────────────────────────────┘
```

### Niveles de Backup

```
┌──────────────────────────────────────────────────┐
│ Nivel │ Frecuencia │ Retención │ Prioridad      │
├───────┼────────────┼───────────┼────────────────┤
│ L0    │ Semanal    │ 4 semanas │ Crítico        │
│ L1    │ Diario     │ 7 días    │ Alto           │
│ L2    │ Horario    │ 24 horas  │ Medio          │
│ L3    │ Continuo   │ 1 hora    │ Bajo           │
└──────────────────────────────────────────────────┘
```

### Qué Hacer Backup

#### Crítico (Diario)
- Configuración de Proxmox (`/etc/pve`)
- Bases de datos
- Datos de usuarios
- Configuraciones de servicios

#### Importante (Semanal)
- VMs completas
- Contenedores LXC
- Logs importantes
- Certificados SSL

#### Opcional (Mensual)
- ISOs y templates
- Archivos de instalación
- Documentación

---

## 💥 Tipos de Desastres

### 1. Fallo de Hardware

**Síntomas:**
- Servidor no arranca
- Disco duro muerto
- RAM defectuosa
- Fuente de alimentación quemada

**Impacto:** Alto
**Tiempo de recuperación:** 2-24 horas

### 2. Corrupción de Datos

**Síntomas:**
- Archivos corruptos
- Base de datos inconsistente
- Sistema de archivos dañado

**Impacto:** Medio-Alto
**Tiempo de recuperación:** 1-8 horas

### 3. Ransomware/Malware

**Síntomas:**
- Archivos cifrados
- Sistema comprometido
- Acceso no autorizado

**Impacto:** Crítico
**Tiempo de recuperación:** 4-48 horas

### 4. Error Humano

**Síntomas:**
- Configuración borrada
- VM eliminada accidentalmente
- Datos sobrescritos

**Impacto:** Bajo-Medio
**Tiempo de recuperación:** 30min-4 horas

### 5. Desastre Natural

**Síntomas:**
- Inundación
- Incendio
- Corte de energía prolongado

**Impacto:** Crítico
**Tiempo de recuperación:** 24-72 horas

---

## 📋 Plan de Recuperación

### RTO y RPO

```
RTO (Recovery Time Objective)
└─ Tiempo máximo aceptable de inactividad

RPO (Recovery Point Objective)
└─ Cantidad máxima de datos que puedes perder
```

**Objetivos Recomendados:**

| Servicio | RTO | RPO |
|----------|-----|-----|
| Crítico (Vaultwarden) | 1 hora | 15 min |
| Importante (Nextcloud) | 4 horas | 1 hora |
| Normal (Immich) | 24 horas | 1 día |
| Bajo (Media) | 72 horas | 1 semana |

### Procedimiento General

```bash
#!/bin/bash
# disaster-recovery-procedure.sh

echo "=== DISASTER RECOVERY PROCEDURE ==="
echo ""

# 1. EVALUAR
echo "1. EVALUACIÓN DEL DESASTRE"
echo "   - Tipo de fallo identificado"
echo "   - Servicios afectados"
echo "   - Datos en riesgo"
echo ""

# 2. AISLAR
echo "2. AISLAMIENTO"
echo "   - Desconectar sistemas afectados"
echo "   - Prevenir propagación"
echo "   - Documentar estado"
echo ""

# 3. RECUPERAR
echo "3. RECUPERACIÓN"
echo "   - Restaurar desde backup"
echo "   - Verificar integridad"
echo "   - Probar funcionalidad"
echo ""

# 4. VALIDAR
echo "4. VALIDACIÓN"
echo "   - Verificar todos los servicios"
echo "   - Comprobar datos"
echo "   - Monitorear estabilidad"
echo ""

# 5. DOCUMENTAR
echo "5. DOCUMENTACIÓN"
echo "   - Causa raíz"
echo "   - Pasos tomados"
echo "   - Lecciones aprendidas"
```

---

## 🔧 Restauración de Proxmox

### 1. Reinstalación Completa

```bash
# 1. Instalar Proxmox desde ISO
# 2. Configurar red básica
# 3. Actualizar sistema
apt update && apt full-upgrade

# 4. Restaurar configuración
# Si tienes backup de /etc/pve
tar -xzf pve-config-backup.tar.gz -C /
systemctl restart pve-cluster
```

### 2. Restaurar Configuración de Red

```bash
# Backup de configuración de red
cp /etc/network/interfaces /backup/interfaces.backup

# Restaurar
cp /backup/interfaces.backup /etc/network/interfaces
systemctl restart networking
```

### 3. Restaurar Storage

```bash
# Listar storage
pvesm status

# Añadir storage manualmente
pvesm add dir backup-disk --path /mnt/backup

# O restaurar configuración
cp /backup/storage.cfg /etc/pve/storage.cfg
```

### 4. Restaurar Firewall

```bash
# Restaurar reglas de firewall
cp /backup/cluster.fw /etc/pve/firewall/cluster.fw
systemctl restart pve-firewall
```

---

## 💻 Restauración de VMs y Contenedores

### 1. Restaurar VM desde Backup

```bash
# Listar backups disponibles
vzdump list

# Restaurar VM
qmrestore /var/lib/vz/dump/vzdump-qemu-100-2024_01_15-12_00_00.vma.zst 100

# O a nuevo ID
qmrestore /var/lib/vz/dump/vzdump-qemu-100-*.vma.zst 200 --unique

# Iniciar VM
qm start 100
```

### 2. Restaurar Contenedor LXC

```bash
# Restaurar contenedor
pct restore 100 /var/lib/vz/dump/vzdump-lxc-100-*.tar.zst

# Iniciar contenedor
pct start 100
```

### 3. Restauración Selectiva de Archivos

```bash
# Montar backup de VM
mkdir /mnt/restore
vzdump extract /var/lib/vz/dump/vzdump-qemu-100-*.vma.zst /mnt/restore

# Copiar archivos específicos
cp /mnt/restore/path/to/file /destination/

# Desmontar
umount /mnt/restore
```

### 4. Clonar VM de Emergencia

```bash
# Clonar VM existente
qm clone 100 200 --name emergency-clone

# Iniciar clon
qm start 200
```

---

## 📁 Restauración de Datos

### 1. Restaurar desde Backup Local

```bash
# Restaurar directorio completo
tar -xzf /mnt/backup/appdata-backup.tar.gz -C /opt/

# Restaurar archivo específico
tar -xzf /mnt/backup/appdata-backup.tar.gz -C /opt/ opt/appdata/nextcloud/config.php

# Verificar integridad
sha256sum -c checksums.txt
```

### 2. Restaurar desde Google Drive

```bash
# Listar backups disponibles
rclone ls gdrive-encrypted:backups/

# Descargar backup
rclone copy gdrive-encrypted:backups/backup-2024-01-15.tar.gz /tmp/

# Descomprimir y restaurar
cd /opt
tar -xzf /tmp/backup-2024-01-15.tar.gz
```

### 3. Restaurar Base de Datos

#### PostgreSQL

```bash
# Restaurar base de datos completa
psql -U postgres dbname < backup.sql

# Restaurar tabla específica
pg_restore -U postgres -d dbname -t table_name backup.dump

# Restaurar con formato custom
pg_restore -U postgres -d dbname backup.dump
```

#### MySQL/MariaDB

```bash
# Restaurar base de datos
mysql -u root -p dbname < backup.sql

# Restaurar tabla específica
mysql -u root -p dbname < table_backup.sql

# Restaurar desde mysqldump
mysql -u root -p < full_backup.sql
```

#### Redis

```bash
# Detener Redis
systemctl stop redis

# Restaurar dump
cp backup/dump.rdb /var/lib/redis/dump.rdb
chown redis:redis /var/lib/redis/dump.rdb

# Iniciar Redis
systemctl start redis
```

### 4. Restaurar Volúmenes Docker

```bash
# Restaurar volumen
docker run --rm -v volume_name:/data -v $(pwd):/backup \
  alpine tar xzf /backup/volume-backup.tar.gz -C /

# Verificar
docker run --rm -v volume_name:/data alpine ls -la /data
```

---

## 🔄 Restauración de Servicios

### 1. Nextcloud

```bash
# 1. Restaurar archivos
tar -xzf nextcloud-backup.tar.gz -C /opt/appdata/

# 2. Restaurar base de datos
mysql -u nextcloud -p nextcloud < nextcloud-db.sql

# 3. Restaurar configuración
cp backup/config.php /opt/appdata/nextcloud/config/

# 4. Ajustar permisos
chown -R www-data:www-data /opt/appdata/nextcloud

# 5. Modo mantenimiento off
docker exec -u www-data nextcloud php occ maintenance:mode --off

# 6. Verificar
docker exec -u www-data nextcloud php occ status
```

### 2. Vaultwarden

```bash
# 1. Restaurar base de datos
cp backup/db.sqlite3 /opt/appdata/vaultwarden/

# 2. Restaurar attachments
tar -xzf attachments-backup.tar.gz -C /opt/appdata/vaultwarden/

# 3. Reiniciar servicio
docker-compose restart vaultwarden

# 4. Verificar
curl -I https://vault.home.arpa
```

### 3. Immich

```bash
# 1. Restaurar base de datos PostgreSQL
docker exec -i immich-postgres psql -U postgres immich < immich-db.sql

# 2. Restaurar fotos
rsync -av backup/photos/ /mnt/photos/

# 3. Restaurar configuración
cp backup/.env /opt/stacks/immich/

# 4. Reiniciar stack
docker-compose down && docker-compose up -d

# 5. Reindexar
docker exec immich-server npm run cli -- upload
```

### 4. Grafana

```bash
# 1. Restaurar base de datos
cp backup/grafana.db /opt/appdata/grafana/

# 2. Restaurar dashboards
cp -r backup/dashboards/ /opt/appdata/grafana/

# 3. Restaurar datasources
cp backup/datasources.yaml /opt/appdata/grafana/provisioning/datasources/

# 4. Reiniciar
docker-compose restart grafana
```

---

## 🧪 Testing del DR Plan

### 1. Simulacro Mensual

```bash
#!/bin/bash
# dr-drill.sh

echo "=== DISASTER RECOVERY DRILL ==="
date

# 1. Seleccionar servicio aleatorio
SERVICES=("nextcloud" "vaultwarden" "grafana")
SERVICE=${SERVICES[$RANDOM % ${#SERVICES[@]}]}

echo "Servicio seleccionado: $SERVICE"

# 2. Simular fallo
echo "Deteniendo servicio..."
docker-compose -f /opt/stacks/$SERVICE/docker-compose.yml down

# 3. Restaurar desde backup
echo "Restaurando desde backup..."
./restore-service.sh $SERVICE

# 4. Verificar
echo "Verificando servicio..."
./verify-service.sh $SERVICE

# 5. Documentar
echo "Tiempo de recuperación: $(date)" >> dr-drill-log.txt
```

### 2. Checklist de Verificación

```markdown
## DR Drill Checklist

### Pre-Drill
- [ ] Notificar a usuarios
- [ ] Backup reciente disponible
- [ ] Documentación actualizada
- [ ] Herramientas preparadas

### Durante Drill
- [ ] Cronometrar cada paso
- [ ] Documentar problemas
- [ ] Verificar procedimientos
- [ ] Probar comunicaciones

### Post-Drill
- [ ] Servicios restaurados
- [ ] Datos verificados
- [ ] Tiempo documentado
- [ ] Lecciones aprendidas
- [ ] Plan actualizado
```

### 3. Métricas de DR

```python
#!/usr/bin/env python3
# dr-metrics.py

import json
from datetime import datetime

class DRMetrics:
    def __init__(self):
        self.drills = []
    
    def add_drill(self, service, rto_target, rto_actual, success):
        drill = {
            'date': datetime.now().isoformat(),
            'service': service,
            'rto_target': rto_target,
            'rto_actual': rto_actual,
            'success': success,
            'met_target': rto_actual <= rto_target
        }
        self.drills.append(drill)
    
    def get_success_rate(self):
        if not self.drills:
            return 0
        successful = sum(1 for d in self.drills if d['success'])
        return (successful / len(self.drills)) * 100
    
    def get_avg_rto(self):
        if not self.drills:
            return 0
        return sum(d['rto_actual'] for d in self.drills) / len(self.drills)

# Ejemplo de uso
metrics = DRMetrics()
metrics.add_drill('nextcloud', 240, 180, True)  # 4h target, 3h actual
metrics.add_drill('vaultwarden', 60, 45, True)  # 1h target, 45min actual

print(f"Success Rate: {metrics.get_success_rate()}%")
print(f"Average RTO: {metrics.get_avg_rto()} minutes")
```

---

## 📚 Documentación de Incidentes

### Plantilla de Informe

```markdown
# Incident Report: [TÍTULO]

## Información General
- **Fecha**: 2024-01-15
- **Hora inicio**: 14:30 UTC
- **Hora resolución**: 16:45 UTC
- **Duración**: 2h 15min
- **Severidad**: Alta
- **Servicios afectados**: Nextcloud, Vaultwarden

## Descripción del Incidente
[Descripción detallada de qué ocurrió]

## Causa Raíz
[Análisis de la causa principal]

## Impacto
- Usuarios afectados: 5
- Datos perdidos: Ninguno
- Tiempo de inactividad: 2h 15min

## Cronología
- 14:30 - Detección del problema
- 14:35 - Inicio de investigación
- 14:50 - Causa identificada
- 15:00 - Inicio de recuperación
- 16:30 - Servicios restaurados
- 16:45 - Verificación completa

## Acciones Tomadas
1. [Acción 1]
2. [Acción 2]
3. [Acción 3]

## Lecciones Aprendidas
- [Lección 1]
- [Lección 2]

## Acciones Preventivas
- [ ] [Acción preventiva 1]
- [ ] [Acción preventiva 2]

## Mejoras al DR Plan
- [ ] [Mejora 1]
- [ ] [Mejora 2]
```

---

## 🔒 Backup de Emergencia

### Script de Backup Rápido

```bash
#!/bin/bash
# emergency-backup.sh

BACKUP_DIR="/mnt/emergency-backup"
DATE=$(date +%Y%m%d-%H%M%S)

echo "🚨 EMERGENCY BACKUP - $DATE"

# 1. Configuración crítica
echo "Backing up critical configs..."
tar -czf $BACKUP_DIR/configs-$DATE.tar.gz \
  /etc/pve \
  /etc/network/interfaces \
  /opt/stacks

# 2. Bases de datos
echo "Backing up databases..."
docker exec postgres pg_dumpall -U postgres > $BACKUP_DIR/postgres-$DATE.sql
docker exec mariadb mysqldump -u root -p$MYSQL_ROOT_PASSWORD --all-databases > $BACKUP_DIR/mysql-$DATE.sql

# 3. Datos críticos
echo "Backing up critical data..."
tar -czf $BACKUP_DIR/vaultwarden-$DATE.tar.gz /opt/appdata/vaultwarden
tar -czf $BACKUP_DIR/nextcloud-$DATE.tar.gz /opt/appdata/nextcloud/config

# 4. Subir a cloud
echo "Uploading to cloud..."
rclone copy $BACKUP_DIR gdrive-encrypted:emergency-backups/

echo "✅ Emergency backup complete!"
```

---

## 📋 DR Checklist Completo

### Preparación
- [ ] Backups automáticos configurados
- [ ] Backups offsite funcionando
- [ ] Documentación actualizada
- [ ] Contactos de emergencia definidos
- [ ] Hardware de repuesto identificado

### Durante el Desastre
- [ ] Evaluar situación
- [ ] Notificar stakeholders
- [ ] Aislar sistemas afectados
- [ ] Iniciar procedimiento de recuperación
- [ ] Documentar acciones

### Recuperación
- [ ] Restaurar desde backup más reciente
- [ ] Verificar integridad de datos
- [ ] Probar funcionalidad
- [ ] Monitorear estabilidad
- [ ] Comunicar resolución

### Post-Incidente
- [ ] Análisis de causa raíz
- [ ] Informe de incidente
- [ ] Actualizar DR plan
- [ ] Implementar mejoras
- [ ] Programar drill de seguimiento

---

## 📚 Recursos Adicionales

- [Proxmox Backup Server](https://pbs.proxmox.com/)
- [Disaster Recovery Best Practices](https://www.ready.gov/business/implementation/IT)
- [NIST Contingency Planning Guide](https://csrc.nist.gov/publications/detail/sp/800-34/rev-1/final)

---

## 🔗 Navegación

- [⬅️ Volver a Scaling](../10-advanced/scaling.md)
- [➡️ Siguiente: Monitoring Alerts](monitoring-alerts.md)
- [🏠 Volver al índice](../README.md)
