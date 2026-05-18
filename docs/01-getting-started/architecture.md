# 🏗️ Arquitectura Completa del Homelab

Este documento explica en detalle cómo está diseñado y estructurado el homelab, cómo se comunican los componentes y por qué se tomaron ciertas decisiones de diseño.

## 📐 Visión General

```
                    ┌─────────────────────────────────────┐
                    │         INTERNET                    │
                    └──────────────┬──────────────────────┘
                                   │
                    ┌──────────────▼──────────────────────┐
                    │      ROUTER (192.168.1.1)           │
                    │      - DHCP Server                  │
                    │      - Gateway                      │
                    └──────────────┬──────────────────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
        │         LAN (192.168.1.0/24)                       │
        │                                                     │
        │  ┌─────────────────────────────────────────────┐   │
        │  │   PROXMOX HOST (192.168.1.200)              │   │
        │  │                                             │   │
        │  │   ┌─────────────────────────────────────┐   │   │
        │  │   │  vmbr0 (Bridge LAN)                 │   │   │
        │  │   │  192.168.1.0/24                     │   │   │
        │  │   └──────────┬──────────────────────────┘   │   │
        │  │              │                              │   │
        │  │   ┌──────────▼──────────────────────────┐   │   │
        │  │   │  CT100: Tailscale Gateway           │   │   │
        │  │   │  - eth0: 192.168.1.87               │   │   │
        │  │   │  - eth1: 10.10.10.87                │   │   │
        │  │   │  - VPN + NAT + Routing              │   │   │
        │  │   └──────────┬──────────────────────────┘   │   │
        │  │              │                              │   │
        │  │   ┌──────────▼──────────────────────────┐   │   │
        │  │   │  vmbr10 (Bridge Privado)            │   │   │
        │  │   │  10.10.10.0/24                      │   │   │
        │  │   └──────────┬──────────────────────────┘   │   │
        │  │              │                              │   │
        │  │   ┌──────────▼──────────────────────────┐   │   │
        │  │   │  Servicios Privados                 │   │   │
        │  │   │  - CT105: Monitoring                │   │   │
        │  │   │  - CT106: Vaultwarden               │   │   │
        │  │   │  - CT107: Paperless                 │   │   │
        │  │   │  - CT108: Nextcloud                 │   │   │
        │  │   │  - VM109: Immich                    │   │   │
        │  │   │  - CT110: Tools                     │   │   │
        │  │   │  - CT111: Databases                 │   │   │
        │  │   │  - CT113: Keycloak                  │   │   │
        │  │   │  - CT114: Navidrome                 │   │   │
        │  │   │  - CT115: Downloads                 │   │   │
        │  │   └─────────────────────────────────────┘   │   │
        │  │                                             │   │
        │  │   ┌─────────────────────────────────────┐   │   │
        │  │   │  Servicios LAN                      │   │   │
        │  │   │  - CT101: Dashboards                │   │   │
        │  │   │  - CT102: Portainer                 │   │   │
        │  │   │  - CT103: DNS                       │   │   │
        │  │   │  - VM104: CasaOS/NAS                │   │   │
        │  │   │  - CT112: Nginx Proxy Manager       │   │   │
        │  │   └─────────────────────────────────────┘   │   │
        │  │                                             │   │
        │  │   ┌─────────────────────────────────────┐   │   │
        │  │   │  Storage                            │   │   │
        │  │   │  - local-lvm: Sistema y CTs         │   │   │
        │  │   │  - /mnt/hdd250: Backups locales     │   │   │
        │  │   └─────────────────────────────────────┘   │   │
        │  └─────────────────────────────────────────────┘   │
        └─────────────────────────────────────────────────────┘
                                   │
                    ┌──────────────▼──────────────────────┐
                    │      TAILSCALE VPN                  │
                    │      - Acceso remoto                │
                    │      - Subnet routing               │
                    │      - Exit node                    │
                    └─────────────────────────────────────┘
```

## 🌐 Arquitectura de Red

### Diseño de Doble Red

El homelab utiliza **dos redes separadas** por seguridad y organización:

#### 1. Red LAN (192.168.1.0/24)
**Propósito**: Servicios de uso diario accesibles desde la red local

**Características**:
- Accesible desde cualquier dispositivo en casa
- Servicios no críticos o de gestión
- Conectada directamente al router
- Sin restricciones de acceso desde LAN

**Servicios en esta red**:
- Dashboards (Homepage, Homarr, etc.)
- Portainer (gestión)
- DNS (AdGuard Home)
- NAS (CasaOS)
- Proxy Manager

#### 2. Red Privada (10.10.10.0/24)
**Propósito**: Servicios sensibles aislados

**Características**:
- Solo accesible vía Tailscale VPN o proxy interno
- Servicios críticos y datos sensibles
- Aislada de la LAN por defecto
- Requiere autenticación adicional

**Servicios en esta red**:
- Vaultwarden (contraseñas)
- Nextcloud (archivos personales)
- Immich (fotos privadas)
- Paperless (documentos)
- Keycloak (autenticación)
- Monitoring (métricas del sistema)
- Bases de datos

### Comunicación Entre Redes

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│   Dispositivo   │────────▶│   CT100         │────────▶│   Servicios     │
│   en LAN        │         │   Tailscale GW  │         │   Privados      │
│ 192.168.1.x     │         │   NAT + Routing │         │ 10.10.10.x      │
└─────────────────┘         └─────────────────┘         └─────────────────┘
                                     │
                                     │
                            ┌────────▼────────┐
                            │   Tailscale     │
                            │   VPN Mesh      │
                            │   (Internet)    │
                            └─────────────────┘
                                     │
                            ┌────────▼────────┐
                            │   Dispositivo   │
                            │   Remoto        │
                            │   (Móvil, PC)   │
                            └─────────────────┘
```

**CT100 (Tailscale Gateway)** actúa como:
1. **VPN Server**: Punto de entrada Tailscale
2. **Subnet Router**: Expone ambas redes a Tailscale
3. **NAT Gateway**: Permite a LAN acceder a red privada
4. **Exit Node**: Permite usar el homelab como VPN de salida

### Rutas Estáticas

Para que dispositivos en LAN puedan acceder a servicios privados:

```bash
# En el router o en cada dispositivo
Destino: 10.10.10.0/24
Gateway: 192.168.1.87 (CT100)
```

Esto permite acceder a servicios privados desde LAN sin VPN, útil para:
- Nginx Proxy Manager (CT112) puede hacer proxy a servicios privados
- Dashboards pueden mostrar widgets de servicios privados
- Administración desde casa sin conectar VPN

## 🔐 Capas de Seguridad

### Capa 1: Aislamiento de Red
- Red privada separada físicamente (vmbr10)
- Solo accesible vía gateway controlado

### Capa 2: VPN (Tailscale)
- Acceso remoto cifrado
- Sin puertos abiertos en router
- Autenticación en Tailscale

### Capa 3: Reverse Proxy (Nginx PM)
- Certificados SSL/TLS
- Control de acceso por dominio
- Logs de acceso

### Capa 4: SSO (Keycloak)
- Autenticación centralizada
- OAuth 2.0 / OpenID Connect
- Integración con Google

### Capa 5: Autenticación de Aplicación
- Cada servicio tiene su propia autenticación
- Contraseñas únicas por servicio
- 2FA donde sea posible

## 📦 Contenedores vs Máquinas Virtuales

### Contenedores LXC (14 total)

**Ventajas**:
- Muy ligeros (arrancan en segundos)
- Bajo consumo de recursos
- Fáciles de clonar y respaldar
- Ideales para servicios Docker

**Usados para**:
- Servicios basados en Docker
- Aplicaciones web
- Servicios de red (DNS, proxy)
- Herramientas de gestión

**Lista de CTs** (datos reales del servidor):
- CT100: TailScale - 1 CPU, 1GB RAM, 8GB disco
- CT101: dashboard - 1 CPU, 1GB RAM, 12GB disco
- CT102: Portainer - 1 CPU, 1GB RAM, 12GB disco
- CT103: DNS - 1 CPU, 1GB RAM, 12GB disco
- CT105: monitoring - 1 CPU, 1GB RAM, 16GB disco
- CT106: vaultwarden - 1 CPU, 1GB RAM, 12GB disco
- CT107: paperless - 1 CPU, 1GB RAM, 16GB disco
- CT108: nextcloud - 2 CPU, 2GB RAM, 32GB disco
- CT110: tools - 1 CPU, 1GB RAM, 16GB disco
- CT111: databases - 1 CPU, 2GB RAM, 24GB disco
- CT112: proxy - 1 CPU, 1GB RAM, 12GB disco
- CT113: identity (Keycloak) - 2 CPU, 2GB RAM, 24GB disco
- CT114: music (Navidrome) - 1 CPU, 1GB RAM, 12GB disco
- CT115: downloads - 2 CPU, 2GB RAM, 12GB disco

### Máquinas Virtuales (2 total)

**Ventajas**:
- Kernel completo independiente
- Mejor aislamiento
- Pueden ejecutar cualquier OS
- Ideales para sistemas complejos

**Usadas para**:
- Sistemas operativos completos
- Aplicaciones que requieren kernel específico
- Servicios que no funcionan bien en LXC

**Lista de VMs** (datos reales del servidor):
- VM104: casaos-nas - 2 CPU, 4GB RAM, 32GB disco
- VM109: immich - 4 CPU, 6GB RAM, 64GB disco

## 🗄️ Almacenamiento

### Estructura de Storage

```
Proxmox Host
├── local (NVMe 500GB)
│   ├── Micron 2200V NVMe
│   ├── ISO images
│   ├── CT templates
│   └── Backups de configuración
│
├── local-lvm (NVMe 500GB)
│   ├── Partición LVM en NVMe principal
│   ├── Discos de VMs
│   └── Volúmenes de CTs
│
└── /mnt/hdd250 (SSD 250GB)
    ├── Crucial MX500 SATA SSD
    ├── Nota: nombre "hdd250" es legacy, es un SSD
    ├── backups/
    │   └── dump/          # Backups de Proxmox
    ├── data/              # Datos compartidos
    ├── media/             # Multimedia
    ├── downloads/         # Descargas
    └── shared/            # Archivos compartidos
```

### Estrategia de Almacenamiento

**SSD (Sistema)**:
- Sistema operativo Proxmox
- Contenedores y VMs
- Datos de aplicaciones activas
- Bases de datos

**HDD (Backups)**:
- Backups diarios de Proxmox
- Archivos multimedia
- Datos menos accedidos
- Descargas

## 💾 Estrategia de Backups

### Nivel 1: Backups Locales (Diarios)
```
Proxmox Backup
├── Horario: 22:30 diario
├── Destino: /mnt/hdd250/backups/dump
├── Retención: Últimos 2 backups
├── Modo: Snapshot
├── Compresión: ZSTD
└── Incluye: Todos los CTs y VMs
```

**Ventajas**:
- Restauración rápida
- Sin dependencia de internet
- Automático

**Desventajas**:
- Mismo hardware (riesgo de fallo)
- Capacidad limitada

### Nivel 2: Backups Remotos (Semanales)
```
rclone a Google Drive
├── Horario: Domingos 05:00
├── Destino: Google Drive (cifrado)
├── Cifrado: rclone crypt
├── Retención: Últimos 4 backups
└── Incluye: Backups de Proxmox
```

**Ventajas**:
- Offsite (protección contra desastres)
- Cifrado end-to-end
- Capacidad ilimitada (con plan)

**Desventajas**:
- Requiere internet
- Restauración más lenta
- Depende de servicio externo

### Nivel 3: Backups Selectivos (Continuos)
```
Duplicati
├── Origen: Carpetas específicas de CasaOS
│   ├── /data/documents
│   ├── /data/obsidian
│   ├── /data/sync
│   └── /data/shared
├── Destino: /data/backups/duplicati
├── Modo: Incremental
└── Retención: 30 días
```

**Ventajas**:
- Backups incrementales (eficiente)
- Restauración granular (archivos específicos)
- Versionado de archivos

**Desventajas**:
- Solo para datos, no sistema completo
- Requiere configuración por carpeta

### Nivel 4: Sincronización (Tiempo Real)
```
Syncthing
├── Windows PC ↔ CasaOS
├── Carpetas sincronizadas:
│   └── Obsidian vault
├── Modo: Bidireccional
└── Versionado: 30 días
```

**Ventajas**:
- Sincronización en tiempo real
- P2P (sin servidor central)
- Versionado automático

**Desventajas**:
- No es backup real (cambios se propagan)
- Requiere ambos dispositivos online

## 🔄 Flujo de Datos

### Acceso desde Casa (LAN)

```
Usuario en LAN
    │
    ├─▶ Directo a servicios LAN (192.168.1.x)
    │   └─▶ Homepage, Portainer, CasaOS, etc.
    │
    ├─▶ Vía Proxy a servicios privados (*.home.arpa)
    │   └─▶ Nginx PM (CT112) ──▶ Servicios 10.10.10.x
    │
    └─▶ Vía ruta estática a servicios privados (IP directa)
        └─▶ Router ──▶ CT100 (NAT) ──▶ Servicios 10.10.10.x
```

### Acceso Remoto (Fuera de Casa)

```
Usuario Remoto
    │
    └─▶ Tailscale VPN
        │
        ├─▶ Subnet Router (CT100)
        │   │
        │   ├─▶ Acceso a LAN (192.168.1.0/24)
        │   │   └─▶ Todos los servicios LAN
        │   │
        │   └─▶ Acceso a red privada (10.10.10.0/24)
        │       └─▶ Todos los servicios privados
        │
        └─▶ Vaultwarden directo (Tailscale Serve)
            └─▶ https://vaultwarden.tailXXXXXX.ts.net
```

### Flujo de Autenticación (SSO)

```
Usuario
    │
    └─▶ Accede a servicio (ej: Grafana)
        │
        └─▶ Redirige a Keycloak (auth.home.arpa)
            │
            ├─▶ Login con Google OAuth
            │   └─▶ Google ──▶ Keycloak ──▶ Servicio
            │
            └─▶ Login con usuario/password local
                └─▶ Keycloak ──▶ Servicio
```

## 📊 Recursos por Servicio

### Asignación de Recursos (Datos Reales del Servidor)

| ID | Nombre | Tipo | CPU | RAM | Disco | Estado | Uso RAM Actual |
|----|--------|------|-----|-----|-------|--------|----------------|
| 100 | TailScale | LXC | 1 | 1GB | 8GB | ✅ Running | 44 MB |
| 101 | dashboard | LXC | 1 | 1GB | 12GB | ✅ Running | 616 MB |
| 102 | Portainer | LXC | 1 | 1GB | 12GB | ✅ Running | 118 MB |
| 103 | DNS | LXC | 1 | 1GB | 12GB | ✅ Running | 125 MB |
| 104 | casaos-nas | VM | 2 | 4GB | 32GB | ✅ Running | 2.5 GB |
| 105 | monitoring | LXC | 1 | 1GB | 16GB | ✅ Running | 205 MB |
| 106 | vaultwarden | LXC | 1 | 1GB | 12GB | ✅ Running | 121 MB |
| 107 | paperless | LXC | 1 | 1GB | 16GB | ✅ Running | 104 MB |
| 108 | nextcloud | LXC | 2 | 2GB | 32GB | ✅ Running | 250 MB |
| 109 | immich | VM | 4 | 6GB | 64GB | ✅ Running | 2.9 GB |
| 110 | tools | LXC | 1 | 1GB | 16GB | ✅ Running | 448 MB |
| 111 | databases | LXC | 1 | 2GB | 24GB | ✅ Running | 158 MB |
| 112 | proxy | LXC | 1 | 1GB | 12GB | ✅ Running | 238 MB |
| 113 | identity | LXC | 2 | 2GB | 24GB | ✅ Running | 449 MB |
| 114 | music | LXC | 1 | 1GB | 12GB | ✅ Running | 181 MB |
| 115 | downloads | LXC | 2 | 2GB | 12GB | ✅ Running | 128 MB |

**Total Asignado**: 20 CPU cores, 23GB RAM, ~280GB disco
**Total en Uso Real**: ~8.5GB RAM (37% del asignado)
**Host Disponible**: AMD Ryzen 5 3550H (4C/8T), 16GB RAM, 500GB NVMe + 250GB SSD

## 🎯 Decisiones de Diseño

### ¿Por qué dos redes?

**Seguridad por capas**: Servicios críticos aislados por defecto

**Flexibilidad**: Puedes exponer servicios LAN sin exponer privados

**Organización**: Clara separación entre servicios públicos y privados

### ¿Por qué Tailscale y no WireGuard directo?

**Facilidad**: Tailscale es WireGuard con gestión automática

**Sin configuración de router**: No necesitas abrir puertos

**Mesh network**: Todos los dispositivos se conectan entre sí

**Gratis**: Hasta 100 dispositivos

### ¿Por qué LXC y no solo Docker?

**Rendimiento**: LXC es más ligero que VMs

**Aislamiento**: Mejor que Docker, peor que VMs (equilibrio perfecto)

**Gestión**: Proxmox gestiona LXC nativamente

**Backups**: Fácil backup/restore de contenedores completos

### ¿Por qué Keycloak para SSO?

**Enterprise-grade**: Usado en producción por grandes empresas

**Flexible**: Soporta múltiples protocolos (OAuth, OIDC, SAML)

**Integración**: Fácil integración con Google y otros providers

**Open-source**: Gratis y con comunidad activa

## 🚀 Escalabilidad

### Cómo Crecer el Homelab

**Más servicios**:
- Crear nuevos CTs en red privada
- Añadir a Portainer para gestión
- Configurar en proxy y dashboards

**Más almacenamiento**:
- Añadir discos adicionales
- Configurar como storage en Proxmox
- Montar en CasaOS para NAS

**Más potencia**:
- Añadir RAM al host
- Asignar más recursos a CTs/VMs
- Considerar segundo servidor

**Alta disponibilidad**:
- Cluster de Proxmox (3+ nodos)
- Storage compartido (NFS, Ceph)
- Balanceo de carga

## 📚 Próximos Pasos

Ahora que entiendes la arquitectura, continúa con:

**[➡️ Quick Start](quick-start.md)** - Comienza la instalación paso a paso

---

[⬅️ Requisitos](prerequisites.md) | [🏠 Índice](../README.md) | [➡️ Quick Start](quick-start.md)