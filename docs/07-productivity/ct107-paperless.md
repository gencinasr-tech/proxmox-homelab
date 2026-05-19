# CT107 - Paperless-ngx

Sistema de gestión documental digital (DMS).

## 📋 Información del Contenedor

- **ID:** CT107
- **Hostname:** paperless
- **IP Privada:** 10.10.10.40
- **OS:** Debian 12
- **Recursos:** 1 CPU, 1GB RAM, 16GB disco

## 🔌 Puertos

| Servicio | Puerto Interno Docker | Puerto Publicado | URL Acceso |
|----------|----------------------|------------------|------------|
| Paperless-ngx | 8000 | 8000 | http://10.10.10.40:8000 |

## 🎯 Propósito

Paperless-ngx proporciona:
- 📄 Digitalización y OCR de documentos
- 🏷️ Etiquetado y categorización automática
- 🔍 Búsqueda de texto completo
- 📧 Importación por email
- 📱 Apps móviles

## 📚 Documentación Detallada

Para instrucciones completas de instalación y configuración, consulta la documentación principal del proyecto.

## 🔗 Acceso

- **Interno:** http://10.10.10.40:8000 o https://paperless.home.arpa
- **Acceso remoto:** Vía Tailscale VPN
- **Base de datos:** PostgreSQL en CT111 (10.10.10.73:5432)

## 🔗 Recursos Relacionados

- [Red Privada](../03-networking/private-network.md)
- [CT111 - Bases de Datos](../08-utilities/ct111-databases.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
