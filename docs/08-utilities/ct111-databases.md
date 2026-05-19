# CT111 - Bases de Datos

Servidor centralizado de bases de datos (PostgreSQL y MariaDB).

## 📋 Información del Contenedor

- **ID:** CT111
- **Hostname:** databases
- **IP Privada:** 10.10.10.73
- **OS:** Debian 12
- **Recursos:** 1 CPU, 2GB RAM, 24GB disco

## 🎯 Servicios

| Servicio | Puerto Interno Docker | Puerto Publicado | URL Acceso |
|----------|----------------------|------------------|------------|
| PostgreSQL | 5432 | 5432 | 10.10.10.73:5432 |
| MariaDB | 3306 | 3306 | 10.10.10.73:3306 |
| Adminer | 8080 | 8080 | http://10.10.10.73:8080 |
| pgAdmin | 80 | 8082 | http://10.10.10.73:8082 |
| ChartDB | 3000 | 8083 | http://10.10.10.73:8083 |

### Bases de Datos Alojadas
- **PostgreSQL:**
  - Nextcloud (CT108)
  - Immich (VM109)
  - Paperless-ngx (CT107)
  - Keycloak (CT113)
  
- **MariaDB:**
  - Servicios que requieran MySQL/MariaDB

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
