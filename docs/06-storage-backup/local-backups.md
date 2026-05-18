# Backups Locales

Estrategia de backups locales en el homelab.

## 📋 Información

- **Ubicación:** /var/lib/vz/dump (Proxmox)
- **Frecuencia:** Diaria/Semanal según criticidad
- **Retención:** 7-30 días
- **Tipo:** Snapshots, dumps completos

## 🎯 Qué se Respalda

### Crítico (Diario)
- Configuración de Proxmox
- Bases de datos
- Vaultwarden
- Configuraciones de servicios

### Importante (Semanal)
- Contenedores LXC completos
- VMs completas
- Datos de aplicaciones

## 📚 Documentación Detallada

Para instrucciones completas, consulta:
- [Recuperación de Desastres](../11-maintenance/disaster-recovery.md)
- Documentación principal sobre estrategia de backups

## 🔗 Recursos Relacionados

- [Backups Remotos](remote-backups.md)
- [Duplicati](duplicati.md)
- [Recuperación de Desastres](../11-maintenance/disaster-recovery.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
