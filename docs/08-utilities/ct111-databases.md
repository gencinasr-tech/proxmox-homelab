# CT111 - Bases de Datos

Servidor centralizado de bases de datos (PostgreSQL y MariaDB).

## 📋 Información del Contenedor

- **ID:** CT111
- **Hostname:** databases
- **IP Privada:** 10.10.10.73
- **OS:** Debian 12
- **Recursos:** 4 CPU, 8GB RAM, 64GB disco

## 🎯 Servicios

- **PostgreSQL:** Puerto 5432
  - Nextcloud
  - Immich
  - Paperless-ngx
  
- **MariaDB:** Puerto 3306
  - Otros servicios que requieran MySQL

## 🔒 Seguridad

- **Criticidad:** CRÍTICA
- **Acceso:** Solo desde red privada
- **Backups:** Diarios automáticos
- **Replicación:** Configurada

## 📚 Documentación Detallada

Para instrucciones completas de instalación y configuración, consulta la documentación principal del proyecto.

## 🔗 Recursos Relacionados

- [Red Privada](../03-networking/private-network.md)
- [Backups Locales](../06-storage-backup/local-backups.md)
- [Recuperación de Desastres](../11-maintenance/disaster-recovery.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
