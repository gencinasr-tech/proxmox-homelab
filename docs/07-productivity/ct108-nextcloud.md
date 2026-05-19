# CT108 - Nextcloud

Plataforma de almacenamiento y colaboración en la nube auto-hospedada.

## 📋 Información del Contenedor

- **ID:** CT108
- **Hostname:** nextcloud
- **IP Privada:** 10.10.10.65
- **OS:** Debian 12
- **Recursos:** 2 CPU, 2GB RAM, 32GB disco + almacenamiento en /mnt/hdd250

## 🔌 Puertos

| Servicio | Puerto Interno Docker | Puerto Publicado | URL Acceso |
|----------|----------------------|------------------|------------|
| Nextcloud | 80 | 8088 | http://10.10.10.65:8088 |

## 🎯 Propósito

Nextcloud proporciona:
- ☁️ Almacenamiento en la nube privada
- 📁 Sincronización de archivos
- 📅 Calendario y contactos
- 📝 Edición colaborativa de documentos
- 📧 Cliente de correo
- 🎥 Videollamadas

## 📚 Documentación Detallada

Para instrucciones completas de instalación y configuración, consulta la documentación principal del proyecto.

## 🔗 Acceso

- **Interno:** http://10.10.10.65:8088 o https://nextcloud.home.arpa
- **Acceso remoto:** https://nextcloud.tailXXXXXX.ts.net (vía Tailscale)
- **Base de datos:** PostgreSQL en CT111 (10.10.10.73:5432)

## 🔗 Recursos Relacionados

- [Red Privada](../03-networking/private-network.md)
- [CT111 - Bases de Datos](../08-utilities/ct111-databases.md)
- [SSO Nextcloud](../09-authentication/sso-nextcloud.md)
- [Recuperación de Desastres](../11-maintenance/disaster-recovery.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
