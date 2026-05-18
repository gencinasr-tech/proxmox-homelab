# 📋 Overview del Proyecto

## ¿Qué es este Homelab?

Este es un **homelab completo y funcional** basado en Proxmox VE que te permite tener tu propia infraestructura de servicios self-hosted en casa. Es una alternativa privada, segura y gratuita a servicios cloud comerciales como Google Drive, Dropbox, LastPass, etc.

## 🎯 Objetivos del Proyecto

1. **Privacidad Total**: Tus datos permanecen en tu hardware, bajo tu control
2. **Aprendizaje**: Practicar con tecnologías enterprise en un entorno real
3. **Ahorro**: Evitar suscripciones mensuales a servicios cloud
4. **Flexibilidad**: Personalizar y expandir según tus necesidades
5. **Replicabilidad**: Cualquiera puede seguir esta guía y obtener el mismo resultado

## 🏗️ Arquitectura General

### Componentes Principales

```
┌─────────────────────────────────────────────────────────┐
│                    PROXMOX HOST                         │
│                   (Portátil/PC)                         │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Red LAN (192.168.1.0/24)                │   │
│  │  - Servicios accesibles desde casa              │   │
│  │  - Dashboards, NAS, DNS, Proxy                  │   │
│  └─────────────────────────────────────────────────┘   │
│                         ↕                               │
│  ┌─────────────────────────────────────────────────┐   │
│  │    Red Privada (10.10.10.0/24)                  │   │
│  │  - Servicios sensibles                          │   │
│  │  - Solo accesibles vía Tailscale o proxy       │   │
│  │  - Vaultwarden, Nextcloud, Immich, etc.        │   │
│  └─────────────────────────────────────────────────┘   │
│                                                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │         Tailscale VPN                           │   │
│  │  - Acceso remoto seguro                         │   │
│  │  - Gateway entre redes                          │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### Tecnologías Utilizadas

- **Proxmox VE 8.x**: Plataforma de virtualización open-source
- **LXC Containers**: Contenedores Linux ligeros para servicios
- **Docker**: Contenedores de aplicaciones
- **Tailscale**: VPN moderna basada en WireGuard
- **Nginx Proxy Manager**: Reverse proxy con interfaz web
- **Keycloak**: Sistema de autenticación centralizada (SSO)

## 📊 Servicios Incluidos

### 🔧 Infraestructura Core
- **Tailscale Gateway**: VPN, acceso remoto, gateway entre redes
- **AdGuard Home**: DNS local con bloqueo de publicidad
- **Nginx Proxy Manager**: Reverse proxy y certificados SSL
- **Portainer**: Gestión visual de contenedores Docker

### 📊 Monitoring y Gestión
- **Homepage**: Dashboard principal personalizable
- **Homarr**: Dashboard alternativo con widgets
- **Homer**: Dashboard minimalista
- **Heimdall**: Dashboard tipo app launcher
- **Grafana**: Visualización de métricas
- **Prometheus**: Recolección de métricas
- **Uptime Kuma**: Monitoring de disponibilidad
- **Beszel**: Monitoring ligero de recursos
- **Scrutiny**: Monitoring de salud de discos

### 💾 Storage y Backups
- **CasaOS**: Sistema operativo para NAS
- **Samba**: Compartir archivos en red local
- **Syncthing**: Sincronización P2P de archivos
- **Duplicati**: Backups incrementales
- **rclone**: Backups cifrados a Google Drive

### 📝 Productividad
- **Vaultwarden**: Gestor de contraseñas (compatible con Bitwarden)
- **Paperless-ngx**: Sistema de gestión documental
- **Nextcloud**: Suite de productividad cloud (archivos, calendario, contactos)
- **Immich**: Galería de fotos con reconocimiento facial y búsqueda IA

### 🛠️ Utilidades
- **IT-Tools**: Colección de herramientas para desarrolladores
- **Stirling PDF**: Manipulación de PDFs
- **Navidrome**: Servidor de música personal
- **PostgreSQL, MariaDB, Redis**: Bases de datos centralizadas
- **Adminer, pgAdmin, ChartDB**: Herramientas de administración de BD

### 🔐 Seguridad y Autenticación
- **Keycloak**: Identity Provider con SSO
- **OAuth 2.0 / OpenID Connect**: Autenticación moderna
- **Integración con Google**: Login con cuenta de Google

## 🎨 Características Destacadas

### 1. Arquitectura de Doble Red
- **Red LAN**: Servicios de uso diario accesibles desde casa
- **Red Privada**: Servicios sensibles aislados, solo accesibles vía VPN o proxy interno

### 2. Acceso Remoto Seguro
- **Tailscale VPN**: Acceso desde cualquier lugar sin abrir puertos
- **Subnet Router**: Acceso a toda la red local desde fuera
- **Exit Node**: Usar el homelab como VPN de salida

### 3. Single Sign-On (SSO)
- Login único con Keycloak
- Integración con Google OAuth
- Acceso unificado a múltiples servicios

### 4. Backups Multinivel
- **Nivel 1**: Backups diarios locales en HDD dedicado
- **Nivel 2**: Backups semanales cifrados a Google Drive
- **Nivel 3**: Backups selectivos con Duplicati

### 5. Monitoring Completo
- Métricas de sistema con Prometheus + Grafana
- Uptime monitoring con Uptime Kuma
- Monitoring ligero con Beszel
- Salud de discos con Scrutiny
- Dashboards visuales con Homepage/Homarr

### 6. Gestión Centralizada
- Portainer para gestionar todos los contenedores Docker
- Múltiples agentes conectados
- Despliegue de stacks desde la UI

## 📈 Estadísticas del Sistema

- **Contenedores LXC**: 13
- **Máquinas Virtuales**: 2
- **Servicios Docker**: 40+
- **Dominios internos**: 25+
- **Redes configuradas**: 2
- **Sistemas de backup**: 3
- **Servicios con SSO**: 4+

## 🎯 Casos de Uso

### Para el Hogar
- Reemplazar Google Drive con Nextcloud
- Reemplazar Google Photos con Immich
- Reemplazar LastPass con Vaultwarden
- NAS personal para compartir archivos en familia
- Servidor de música para toda la casa

### Para Aprendizaje
- Practicar con Proxmox y virtualización
- Aprender Docker y contenedores
- Configurar redes complejas
- Implementar SSO enterprise
- Gestionar backups y disaster recovery

### Para Desarrollo
- Entorno de pruebas local
- Bases de datos para proyectos
- Reverse proxy para desarrollo
- Monitoring de aplicaciones

### Para Privacidad
- Control total sobre tus datos
- Sin dependencia de servicios cloud
- Cifrado end-to-end
- Sin telemetría ni tracking

## 💰 Costos

### Hardware
- **Mínimo**: Portátil viejo con 8GB RAM (~0€ si ya lo tienes)
- **Recomendado**: PC con 16GB RAM y SSD (~300-500€)
- **Opcional**: HDD adicional para backups (~50€)

### Software
- **Todo es gratuito y open-source**: 0€
- **Proxmox VE**: Gratis (versión community)
- **Todos los servicios**: Open-source y gratuitos

### Servicios Cloud (Opcional)
- **Google Drive**: 100GB gratis (para backups cifrados)
- **Tailscale**: Gratis hasta 100 dispositivos
- **Dominio**: Opcional, ~10€/año si quieres acceso público

### Total
- **Mínimo**: 0€ (usando hardware existente)
- **Recomendado**: 300-500€ (hardware nuevo)
- **Operación mensual**: 0€ + electricidad (~5-10€/mes)

## 🔄 Comparación con Servicios Cloud

| Servicio | Cloud (anual) | Self-hosted | Ahorro |
|----------|---------------|-------------|--------|
| Google Drive 2TB | 100€ | 0€ | 100€ |
| LastPass Premium | 36€ | 0€ | 36€ |
| Nextcloud | 60€ | 0€ | 60€ |
| Plex Pass | 40€ | 0€ | 40€ |
| **Total** | **236€/año** | **0€/año** | **236€/año** |

**ROI**: El hardware se paga en ~2 años, después todo es ahorro.

## 🚀 Ventajas

✅ **Control Total**: Tus datos, tu hardware, tus reglas
✅ **Privacidad**: Sin telemetría, sin tracking, sin venta de datos
✅ **Aprendizaje**: Experiencia práctica con tecnologías enterprise
✅ **Flexibilidad**: Añade o quita servicios según necesites
✅ **Ahorro**: Sin suscripciones mensuales
✅ **Rendimiento**: Red local = velocidad máxima
✅ **Disponibilidad**: Funciona sin internet (excepto acceso remoto)
✅ **Personalización**: Configura todo a tu gusto

## ⚠️ Consideraciones

❌ **Responsabilidad**: Tú eres el administrador, tú haces el mantenimiento
❌ **Tiempo**: Requiere tiempo inicial de setup y aprendizaje
❌ **Electricidad**: Consumo 24/7 (aunque mínimo con portátil)
❌ **Hardware**: Necesitas un equipo dedicado
❌ **Backups**: Debes gestionar tus propios backups
❌ **Uptime**: Si se va la luz o internet, pierdes acceso remoto
❌ **Soporte**: No hay soporte oficial, dependes de comunidad

## 🎓 Nivel de Dificultad

### Conocimientos Necesarios
- 🟢 **Básico**: Usar terminal Linux, conceptos de red
- 🟡 **Intermedio**: Docker, contenedores, proxies
- 🔴 **Avanzado**: Redes complejas, SSO, troubleshooting

### Curva de Aprendizaje
- **Semana 1**: Setup básico, servicios core funcionando
- **Semana 2-3**: Añadir más servicios, personalizar
- **Mes 1**: Sistema completo funcionando
- **Mes 2+**: Optimización, automatización, expansión

## 📚 Próximos Pasos

Ahora que entiendes qué es este proyecto, continúa con:

1. **[Requisitos Previos](prerequisites.md)** - Verifica que tienes todo lo necesario
2. **[Arquitectura Completa](architecture.md)** - Entiende cómo funciona todo
3. **[Quick Start](quick-start.md)** - Empieza la instalación

---

[⬅️ Volver al índice](../README.md) | [➡️ Requisitos Previos](prerequisites.md)