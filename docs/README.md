# 📚 Documentación del Homelab

Bienvenido a la documentación completa del Proxmox Homelab. Esta guía te llevará desde cero hasta tener un homelab completamente funcional con 15+ servicios self-hosted.

## 📖 Índice de Documentación

### 🎯 1. Para Empezar

Comienza aquí si es tu primera vez:

- **[Overview del Proyecto](01-getting-started/overview.md)** - Qué es este homelab y qué incluye
- **[Requisitos Previos](01-getting-started/prerequisites.md)** - Hardware, software y conocimientos necesarios
- **[Arquitectura Completa](01-getting-started/architecture.md)** - Diseño del sistema y cómo funciona todo
- **[Quick Start](01-getting-started/quick-start.md)** - Instalación rápida en 30 minutos

**Tiempo estimado**: 1-2 horas de lectura, 2-4 horas de implementación

---

### 💿 2. Instalación Base de Proxmox

Configuración del host Proxmox:

- **[Instalación de Proxmox](02-proxmox-base/installation.md)** - Desde ISO hasta primer acceso
- **[Configuración Inicial](02-proxmox-base/initial-config.md)** - Repositorios, updates, configuración de portátil
- **[Configurar HDD de Backups](02-proxmox-base/storage-setup.md)** - Disco adicional para almacenamiento
- **[Scripts de Rendimiento](02-proxmox-base/performance-scripts.md)** - Modo turbo y modo noche

**Tiempo estimado**: 1-2 horas

---

### 🌐 3. Configuración de Redes

Arquitectura de red dual:

- **[Diseño de Red](03-networking/network-design.md)** - Arquitectura de 2 redes explicada
- **[Red LAN](03-networking/lan-network.md)** - Configuración de 192.168.1.0/24
- **[Red Privada](03-networking/private-network.md)** - Configuración de 10.10.10.0/24
- **[Rutas Estáticas](03-networking/static-routes.md)** - Permitir acceso LAN → red privada
- **[Firewall](03-networking/firewall.md)** - Reglas de seguridad

**Tiempo estimado**: 1 hora

---

### 🔧 4. Servicios Core

Servicios fundamentales del homelab:

- **[CT100: Tailscale Gateway](04-core-services/ct100-tailscale.md)** - VPN, Subnet Router, Exit Node, NAT
- **[CT103: DNS (AdGuard Home)](04-core-services/ct103-dns.md)** - DNS local con bloqueo de ads
- **[CT112: Nginx Proxy Manager](04-core-services/ct112-proxy.md)** - Reverse proxy y certificados SSL

**Tiempo estimado**: 2-3 horas

---

### 📊 5. Gestión y Monitoring

Herramientas de administración:

- **[CT101: Dashboards](05-management/ct101-dashboards.md)** - Homepage, Homarr, Homer, Heimdall
- **[CT102: Portainer](05-management/ct102-portainer.md)** - Gestión visual de contenedores Docker
- **[CT105: Monitoring](05-management/ct105-monitoring.md)** - Grafana, Prometheus, Uptime Kuma, Beszel, Scrutiny

**Tiempo estimado**: 2-3 horas

---

### 💾 6. Storage y Backups

Sistema de almacenamiento y respaldo:

- **[VM104: CasaOS/NAS](06-storage-backup/vm104-casaos.md)** - NAS con Samba, Syncthing, estructura de datos
- **[Backups Locales](06-storage-backup/local-backups.md)** - Backups diarios automáticos en Proxmox
- **[Backups Remotos](06-storage-backup/remote-backups.md)** - rclone a Google Drive cifrado
- **[Duplicati](06-storage-backup/duplicati.md)** - Backups selectivos de carpetas específicas

**Tiempo estimado**: 2-3 horas

---

### 📝 7. Servicios de Productividad

Aplicaciones para el día a día:

- **[CT106: Vaultwarden](07-productivity/ct106-vaultwarden.md)** - Password manager con acceso HTTPS público
- **[CT107: Paperless-ngx](07-productivity/ct107-paperless.md)** - Sistema de gestión documental
- **[CT108: Nextcloud](07-productivity/ct108-nextcloud.md)** - Suite de productividad cloud personal
- **[VM109: Immich](07-productivity/vm109-immich.md)** - Galería de fotos con reconocimiento IA

**Tiempo estimado**: 3-4 horas

---

### 🛠️ 8. Utilidades

Herramientas adicionales útiles:

- **[CT110: Tools](08-utilities/ct110-tools.md)** - IT-Tools y Stirling PDF
- **[CT111: Databases](08-utilities/ct111-databases.md)** - PostgreSQL, MariaDB, Redis + herramientas admin
- **[CT114: Navidrome](08-utilities/ct114-music.md)** - Servidor de música personal
- **[CT115: Downloads](08-utilities/ct115-downloads.md)** - Descargador de música

**Tiempo estimado**: 2-3 horas

---

### 🔐 9. Autenticación y SSO

Sistema de autenticación centralizada:

- **[CT113: Keycloak](09-authentication/ct113-keycloak.md)** - Identity Provider con OAuth/OIDC
- **[SSO en Grafana](09-authentication/sso-grafana.md)** - Integración de Grafana con Keycloak
- **[SSO en Homarr](09-authentication/sso-homarr.md)** - Integración de Homarr con Keycloak
- **[SSO en Immich](09-authentication/sso-immich.md)** - Integración de Immich con Keycloak
- **[SSO en Nextcloud](09-authentication/sso-nextcloud.md)** - Integración de Nextcloud con Keycloak

**Tiempo estimado**: 2-3 horas

---

### 🔒 10. Temas Avanzados

Optimización y mejores prácticas:

- **[Docker Best Practices](10-advanced/docker-best-practices.md)** - Patrones y buenas prácticas
- **[Seguridad](10-advanced/security-hardening.md)** - Hardening del sistema
- **[Optimización de Rendimiento](10-advanced/performance-tuning.md)** - Mejorar performance
- **[Escalabilidad](10-advanced/scaling.md)** - Cómo hacer crecer el homelab

**Tiempo estimado**: 2-3 horas

---

### 🔧 11. Mantenimiento

Operaciones del día a día:

- **[Actualizaciones](11-maintenance/updates.md)** - Cómo actualizar servicios
- **[Troubleshooting](11-maintenance/troubleshooting.md)** - Solución de problemas comunes
- **[Alertas y Notificaciones](11-maintenance/monitoring-alerts.md)** - Configurar alertas
- **[Disaster Recovery](11-maintenance/disaster-recovery.md)** - Restaurar desde backups

**Tiempo estimado**: 1-2 horas

---

## 🗺️ Rutas de Aprendizaje

### 🚀 Ruta Rápida (Mínimo Viable)
Para tener algo funcionando rápido:

1. [Instalación de Proxmox](02-proxmox-base/installation.md)
2. [Configuración Inicial](02-proxmox-base/initial-config.md)
3. [CT100: Tailscale](04-core-services/ct100-tailscale.md)
4. [CT101: Dashboards](05-management/ct101-dashboards.md)
5. [CT102: Portainer](05-management/ct102-portainer.md)

**Tiempo total**: ~4 horas

### 📚 Ruta Completa (Homelab Completo)
Para implementar todo:

1. Sección 1: Para Empezar
2. Sección 2: Instalación Base
3. Sección 3: Redes
4. Sección 4: Servicios Core
5. Sección 5: Gestión y Monitoring
6. Sección 6: Storage y Backups
7. Sección 7: Productividad
8. Sección 8: Utilidades
9. Sección 9: Autenticación SSO
10. Sección 10: Avanzado
11. Sección 11: Mantenimiento

**Tiempo total**: ~25-35 horas

### 🎯 Ruta por Objetivos

**Solo quiero VPN y acceso remoto:**
- CT100: Tailscale Gateway
- CT103: DNS (AdGuard)

**Quiero un NAS personal:**
- VM104: CasaOS/NAS
- Backups Locales
- Duplicati

**Quiero reemplazar servicios cloud:**
- CT106: Vaultwarden (passwords)
- CT108: Nextcloud (archivos)
- VM109: Immich (fotos)
- CT107: Paperless (documentos)

**Quiero monitoring profesional:**
- CT105: Monitoring Stack completo
- Configurar alertas

---

## 📋 Checklist de Implementación

Usa esta lista para seguir tu progreso:

### Fase 1: Base
- [ ] Proxmox instalado y accesible
- [ ] Repositorios configurados
- [ ] HDD de backups montado
- [ ] Plantilla Debian descargada

### Fase 2: Red
- [ ] Red LAN configurada (192.168.1.0/24)
- [ ] Red privada configurada (10.10.10.0/24)
- [ ] Tailscale funcionando
- [ ] Rutas estáticas configuradas

### Fase 3: Core
- [ ] DNS (AdGuard) funcionando
- [ ] Proxy (Nginx PM) configurado
- [ ] Certificados SSL generados

### Fase 4: Gestión
- [ ] Dashboard principal accesible
- [ ] Portainer gestionando contenedores
- [ ] Monitoring recolectando métricas

### Fase 5: Servicios
- [ ] NAS compartiendo archivos
- [ ] Vaultwarden guardando passwords
- [ ] Nextcloud sincronizando archivos
- [ ] Immich organizando fotos
- [ ] Paperless gestionando documentos

### Fase 6: Avanzado
- [ ] SSO con Keycloak configurado
- [ ] Backups automáticos funcionando
- [ ] Alertas configuradas

---

## 🆘 Ayuda y Soporte

### Problemas Comunes
Consulta la [guía de troubleshooting](11-maintenance/troubleshooting.md) para soluciones a problemas frecuentes.

### Comunidad
- 🐛 [Reportar un bug](https://github.com/tu-usuario/proxmox-homelab/issues)
- 💡 [Solicitar una feature](https://github.com/tu-usuario/proxmox-homelab/issues)
- ❓ [Hacer preguntas](https://github.com/tu-usuario/proxmox-homelab/discussions)

### Recursos Adicionales
- [Documentación oficial de Proxmox](https://pve.proxmox.com/pve-docs/)
- [r/selfhosted en Reddit](https://reddit.com/r/selfhosted)
- [r/homelab en Reddit](https://reddit.com/r/homelab)
- [Awesome Self-Hosted](https://github.com/awesome-selfhosted/awesome-selfhosted)

---

## 📝 Convenciones de la Documentación

### Formato de Comandos
```bash
# Comandos que se ejecutan en el host Proxmox
comando-en-proxmox

# Comandos que se ejecutan dentro de un contenedor
pct exec 100 -- comando-en-contenedor
```

### Placeholders
- `TU_PASSWORD_AQUI` - Reemplazar con tu contraseña
- `TU_EMAIL_AQUI` - Reemplazar con tu email
- `192.168.1.X` - Ajustar a tu red local
- `tu-usuario` - Tu nombre de usuario

### Niveles de Dificultad
- 🟢 **Fácil** - No requiere conocimientos previos
- 🟡 **Medio** - Requiere conocimientos básicos
- 🔴 **Avanzado** - Requiere experiencia previa

---

<div align="center">

**¿Listo para empezar?**

[👉 Comienza con el Overview](01-getting-started/overview.md)

</div>