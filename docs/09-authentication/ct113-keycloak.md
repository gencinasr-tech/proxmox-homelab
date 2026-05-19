# CT113 - Keycloak (SSO)

Servidor de autenticación y Single Sign-On (SSO).

## 📋 Información del Contenedor

- **ID:** CT113
- **Hostname:** keycloak
- **IP Privada:** 10.10.10.74
- **OS:** Debian 12
- **Recursos:** 2 CPU, 2GB RAM, 24GB disco

## 🎯 Propósito

Keycloak proporciona:
- 🔐 Autenticación centralizada (SSO)
- 👥 Gestión de usuarios y roles
- 🔑 OAuth 2.0 / OpenID Connect
- 🛡️ 2FA y autenticación fuerte
- 📊 Auditoría de accesos
- 🌐 Federación de identidades

## 🔒 Seguridad

- **Criticidad:** CRÍTICA
- **Acceso:** Solo vía proxy con SSL
- **Backups:** Diarios automáticos

## 📚 Documentación Detallada

Para instrucciones completas de instalación y configuración, consulta la documentación principal del proyecto.

## 🔗 Acceso

- **Puerto interno Docker:** 8080
- **Puerto publicado en host:** 8080
- **URL interna:** http://10.10.10.74:8080
- **Dominio interno:** https://auth.home.arpa
- **Acceso remoto:** Vía Tailscale VPN

> **Nota**: Keycloak está en la red privada y solo es accesible desde la LAN o vía Tailscale

## 🔗 Recursos Relacionados

- [SSO Grafana](sso-grafana.md)
- [SSO Homarr](sso-homarr.md)
- [SSO Immich](sso-immich.md)
- [SSO Nextcloud](sso-nextcloud.md)
- [Red Privada](../03-networking/private-network.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
