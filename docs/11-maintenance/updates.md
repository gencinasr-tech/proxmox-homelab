# Actualizaciones y Mantenimiento

Esta guía cubre las actualizaciones del sistema y el mantenimiento preventivo del homelab.

## 📋 Índice

- [Actualizaciones de Proxmox](#actualizaciones-de-proxmox)
- [Actualizaciones de Contenedores](#actualizaciones-de-contenedores)
- [Actualizaciones de Docker](#actualizaciones-de-docker)
- [Calendario de Mantenimiento](#calendario-de-mantenimiento)

## Actualizaciones de Proxmox

### Actualización del Host

```bash
# Actualizar repositorios
apt update

# Ver actualizaciones disponibles
apt list --upgradable

# Actualizar sistema
apt full-upgrade -y

# Limpiar paquetes antiguos
apt autoremove -y
apt autoclean

# Reiniciar si es necesario
reboot
```

### Actualización de Kernel

```bash
# Ver kernel actual
uname -r

# Ver kernels disponibles
apt search pve-kernel

# Instalar nuevo kernel
apt install pve-kernel-6.x.x-x-pve

# Reiniciar para aplicar
reboot
```

## Actualizaciones de Contenedores

### Contenedores LXC

```bash
# Dentro del contenedor
apt update && apt upgrade -y

# O desde Proxmox
pct exec <CTID> -- bash -c "apt update && apt upgrade -y"
```

### Actualización Masiva

Script para actualizar todos los contenedores:

```bash
#!/bin/bash
# update-all-containers.sh

for ctid in $(pct list | awk 'NR>1 {print $1}'); do
    echo "Actualizando CT $ctid..."
    pct exec $ctid -- bash -c "apt update && apt upgrade -y"
done
```

## Actualizaciones de Docker

### Actualizar Contenedores Docker

```bash
# Actualizar imágenes
docker-compose pull

# Recrear contenedores
docker-compose up -d

# Limpiar imágenes antiguas
docker image prune -a
```

### Actualización Automática con Watchtower

En cada contenedor con Docker, añadir Watchtower:

```yaml
services:
  watchtower:
    image: containrrr/watchtower
    container_name: watchtower
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
    environment:
      - WATCHTOWER_CLEANUP=true
      - WATCHTOWER_SCHEDULE=0 0 4 * * *  # 4 AM diario
```

## Calendario de Mantenimiento

### Tareas Diarias

- ✅ Revisar alertas de Grafana
- ✅ Verificar backups automáticos
- ✅ Revisar logs de errores

### Tareas Semanales

- 🔄 Actualizar contenedores Docker
- 🔄 Revisar uso de disco
- 🔄 Verificar certificados SSL

### Tareas Mensuales

- 📅 Actualizar Proxmox host
- 📅 Actualizar contenedores LXC
- 📅 Revisar y limpiar logs antiguos
- 📅 Verificar integridad de backups

### Tareas Trimestrales

- 📆 Actualizar documentación
- 📆 Revisar políticas de seguridad
- 📆 Auditoría de accesos
- 📆 Prueba de recuperación de desastres

## Checklist de Actualización

Antes de actualizar:

- [ ] Verificar backups recientes
- [ ] Revisar changelog de actualizaciones
- [ ] Planificar ventana de mantenimiento
- [ ] Notificar a usuarios si aplica

Durante la actualización:

- [ ] Tomar snapshot si es posible
- [ ] Aplicar actualizaciones
- [ ] Verificar logs de errores
- [ ] Probar servicios críticos

Después de actualizar:

- [ ] Verificar todos los servicios
- [ ] Revisar métricas de rendimiento
- [ ] Documentar cambios
- [ ] Eliminar snapshots antiguos

## 📚 Recursos Relacionados

- [Monitoreo y Alertas](monitoring-alerts.md)
- [Troubleshooting](troubleshooting.md)
- [Recuperación de Desastres](disaster-recovery.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)

