# ✅ Requisitos Previos

Antes de comenzar con la instalación del homelab, asegúrate de cumplir con los siguientes requisitos.

## 💻 Hardware

### Requisitos Mínimos

| Componente | Mínimo | Recomendado | Óptimo |
|------------|--------|-------------|--------|
| **CPU** | 2 cores (x64) | 4 cores | 6+ cores |
| **RAM** | 8 GB | 16 GB | 32 GB |
| **Almacenamiento** | 100 GB SSD | 250 GB SSD | 500 GB SSD + HDD |
| **Red** | 100 Mbps | 1 Gbps | 1 Gbps |
| **Tipo** | Portátil viejo | PC/Mini PC | Servidor dedicado |

### Hardware Utilizado en Esta Guía

Este homelab fue construido en un **portátil ASUS TUF Gaming FX505DY** con:
- **CPU**: AMD Ryzen 5 3550H (4 cores, 8 threads)
- **RAM**: 16 GB
- **SSD Principal**: Micron 2200V NVMe 500 GB (sistema y contenedores)
- **SSD Secundario**: Crucial MX500 250 GB (backups locales)
- **Red**: Ethernet 1 Gbps
- **Sistema**: ASUS TUF Gaming FX505DY

### Opciones de Hardware

#### Opción 1: Portátil Viejo (Más Económico)
✅ **Ventajas**:
- Gratis si ya lo tienes
- Batería integrada (UPS gratis)
- Bajo consumo (~20-30W)
- Silencioso
- Compacto

❌ **Desventajas**:
- RAM limitada (difícil expandir)
- Almacenamiento limitado
- Pantalla y teclado ocupan espacio
- Menos potencia

**Ideal para**: Empezar, aprender, homelab básico

#### Opción 2: Mini PC (Equilibrado)
✅ **Ventajas**:
- Compacto
- Bajo consumo (~30-50W)
- Silencioso
- Fácil de expandir RAM
- Mejor rendimiento

❌ **Desventajas**:
- Costo inicial (~300-500€)
- Sin batería integrada
- Almacenamiento limitado

**Ideal para**: Homelab serio, uso 24/7

**Modelos recomendados**:
- Intel NUC
- Lenovo ThinkCentre Tiny
- HP EliteDesk Mini
- Dell OptiPlex Micro

#### Opción 3: PC Torre (Máximo Rendimiento)
✅ **Ventajas**:
- Máxima potencia
- Fácil de expandir
- Múltiples discos
- Mejor refrigeración

❌ **Desventajas**:
- Mayor consumo (~100-200W)
- Más ruidoso
- Ocupa más espacio
- Mayor costo

**Ideal para**: Homelab avanzado, muchos servicios, VMs pesadas

#### Opción 4: Servidor Dedicado (Profesional)
✅ **Ventajas**:
- Hardware enterprise
- Máxima fiabilidad
- Redundancia
- Expansión ilimitada

❌ **Desventajas**:
- Muy caro
- Muy ruidoso
- Alto consumo
- Requiere rack

**Ideal para**: Entorno de producción, empresa

### Almacenamiento Adicional

Para backups locales, se recomienda un **disco adicional**:
- **Mínimo**: 250 GB
- **Recomendado**: 500 GB - 1 TB
- **Tipo**: SSD SATA o HDD SATA (SSD para mejor rendimiento, HDD más económico)
- **Conexión**: Interno (SATA) o externo (USB 3.0)
- **Nota**: En este proyecto se usa un SSD Crucial MX500 250GB

## 🌐 Red

### Requisitos de Red

- **Router con DHCP**: Para asignar IPs
- **Acceso al router**: Para configurar IPs estáticas o DHCP reservado
- **Ethernet recomendado**: WiFi funciona pero es menos estable
- **Puertos disponibles**: No necesitas abrir puertos en el router (gracias a Tailscale)

### Configuración de Red Necesaria

Necesitarás configurar en tu router:

1. **IP estática o DHCP reservado** para el servidor Proxmox
   - Ejemplo: `192.168.1.200`

2. **DNS personalizado** (opcional pero recomendado)
   - Apuntar a AdGuard Home: `192.168.1.53`

3. **Rutas estáticas** (para acceder a red privada desde LAN)
   - Ruta: `10.10.10.0/24` vía `192.168.1.87`

### Rangos de IP Utilizados

Este homelab usa dos redes:

- **Red LAN**: `192.168.1.0/24`
  - Gateway: `192.168.1.1` (tu router)
  - Proxmox: `192.168.1.200`
  - Servicios: `192.168.1.50-100`

- **Red Privada**: `10.10.10.0/24`
  - Gateway: `10.10.10.87` (Tailscale Gateway)
  - Servicios: `10.10.10.30-90`

> **Nota**: Si tu red local usa otro rango (ej: `192.168.0.x` o `10.10.10.x`), deberás ajustar las IPs en toda la configuración.

## 💿 Software

### Sistema Operativo del Host

- **Proxmox VE 9.1.9** (basado en Debian 13 "Trixie")
- Descarga: [https://www.proxmox.com/en/downloads](https://www.proxmox.com/en/downloads)
- Versión utilizada en este proyecto: Proxmox VE 9.1.9

### Herramientas Necesarias

#### En tu PC de Administración

- **Navegador web moderno**: Chrome, Firefox, Edge
- **Cliente SSH** (opcional): PuTTY (Windows), Terminal (Mac/Linux)
- **Editor de texto**: Para editar configuraciones

#### En el Servidor Proxmox

Todo se instalará durante el proceso, pero necesitarás:
- Acceso a internet para descargar paquetes
- Plantilla de Debian 13 para contenedores LXC

## 🧠 Conocimientos

### Conocimientos Básicos (Necesarios)

✅ **Linux básico**:
- Navegar por terminal (`cd`, `ls`, `pwd`)
- Editar archivos (`nano`, `vim`)
- Permisos básicos (`chmod`, `chown`)
- Gestión de paquetes (`apt update`, `apt install`)

✅ **Redes básicas**:
- Qué es una IP, máscara de red, gateway
- Diferencia entre LAN y WAN
- Concepto de puertos
- DNS básico

✅ **Conceptos de virtualización**:
- Qué es una máquina virtual
- Qué es un contenedor
- Diferencia entre VM y contenedor

### Conocimientos Intermedios (Recomendados)

🟡 **Docker**:
- Qué es Docker
- Contenedores vs imágenes
- Docker Compose básico
- Volúmenes y redes

🟡 **Proxmox**:
- Interfaz web básica
- Crear contenedores LXC
- Crear máquinas virtuales
- Gestión de almacenamiento

🟡 **Redes avanzadas**:
- VLANs (no necesario pero útil)
- Routing básico
- NAT y port forwarding
- Reverse proxy

### Conocimientos Avanzados (Opcionales)

🔴 **Seguridad**:
- Firewalls
- Certificados SSL/TLS
- OAuth 2.0 / OpenID Connect
- Hardening de sistemas

🔴 **Automatización**:
- Bash scripting
- Systemd services
- Cron jobs
- Ansible (futuro)

🔴 **Monitoring**:
- Prometheus
- Grafana
- Métricas y alertas

### Recursos de Aprendizaje

Si necesitas reforzar conocimientos:

- **Linux**: [Linux Journey](https://linuxjourney.com/)
- **Docker**: [Docker Docs](https://docs.docker.com/get-started/)
- **Proxmox**: [Proxmox Wiki](https://pve.proxmox.com/wiki/Main_Page)
- **Redes**: [Cisco Networking Basics](https://www.netacad.com/)

## 🔑 Cuentas y Servicios

### Cuentas Necesarias

1. **Cuenta de Google** (para SSO y backups)
   - Gmail existente o crear una nueva
   - Usada para: Keycloak OAuth, Google Drive backups

2. **Cuenta de Tailscale** (para VPN)
   - Gratis hasta 100 dispositivos
   - Registro: [https://tailscale.com/](https://tailscale.com/)
   - Puedes usar tu cuenta de Google para registrarte

### Cuentas Opcionales

- **GitHub**: Para clonar este repositorio y contribuir
- **Docker Hub**: Para descargar imágenes (no requiere cuenta)

## 📝 Preparación Previa

### Antes de Empezar

1. **Backup de datos importantes**: Si vas a usar un equipo existente
2. **Descargar Proxmox ISO**: ~1 GB, descarga mientras lees
3. **Crear USB booteable**: Con Rufus (Windows) o Etcher (Mac/Linux)
4. **Documentar tu red actual**: Anota tu rango de IPs, gateway, DNS
5. **Acceso al router**: Asegúrate de tener las credenciales
6. **Tiempo disponible**: Reserva 4-6 horas para el setup inicial

### Checklist Pre-Instalación

- [ ] Hardware cumple requisitos mínimos
- [ ] Proxmox ISO descargada
- [ ] USB booteable creado
- [ ] Acceso al router confirmado
- [ ] Cuenta de Google lista
- [ ] Cuenta de Tailscale creada
- [ ] Backup de datos importantes hecho
- [ ] Tiempo reservado para instalación
- [ ] Documentación de red actual
- [ ] Cable Ethernet disponible

## ⚡ Consumo Eléctrico

### Estimación de Consumo

| Hardware | Consumo | Costo Mensual* |
|----------|---------|----------------|
| Portátil | 20-30W | 4-6€ |
| Mini PC | 30-50W | 6-10€ |
| PC Torre | 100-200W | 20-40€ |
| Servidor | 200-400W | 40-80€ |

*Basado en 0.25€/kWh, 24/7

### Optimización de Consumo

- **Modo noche**: Script incluido para reducir consumo nocturno
- **Modo turbo**: Script para máximo rendimiento cuando se necesita
- **Apagar servicios no usados**: Detener contenedores innecesarios
- **Usar SSD**: Menor consumo que HDD

## 🛡️ Consideraciones de Seguridad

### Antes de Empezar

⚠️ **Importante**:
- Este homelab está diseñado para uso doméstico/aprendizaje
- No expongas servicios directamente a internet sin protección
- Usa contraseñas fuertes y únicas
- Mantén el sistema actualizado
- Haz backups regulares

### Recomendaciones

✅ **Hacer**:
- Usar Tailscale para acceso remoto (no abrir puertos)
- Cambiar contraseñas por defecto
- Habilitar 2FA donde sea posible
- Revisar logs regularmente
- Mantener backups actualizados

❌ **No hacer**:
- Exponer Proxmox directamente a internet
- Usar contraseñas débiles
- Ignorar actualizaciones de seguridad
- Confiar en servicios sin autenticación
- Olvidar hacer backups

## 📚 Documentación Adicional

### Recursos Oficiales

- [Proxmox VE Documentation](https://pve.proxmox.com/pve-docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Tailscale Documentation](https://tailscale.com/kb/)
- [Keycloak Documentation](https://www.keycloak.org/documentation)

### Comunidades

- [r/Proxmox](https://reddit.com/r/Proxmox)
- [r/selfhosted](https://reddit.com/r/selfhosted)
- [r/homelab](https://reddit.com/r/homelab)
- [Proxmox Forum](https://forum.proxmox.com/)

## ✅ Verificación Final

Antes de continuar, confirma que:

- [ ] Tienes el hardware necesario
- [ ] Tu red cumple los requisitos
- [ ] Has descargado Proxmox VE
- [ ] Tienes conocimientos básicos de Linux
- [ ] Has creado las cuentas necesarias
- [ ] Tienes tiempo disponible para la instalación
- [ ] Has hecho backup de datos importantes

## 🚀 Siguiente Paso

Si cumples todos los requisitos, continúa con:

**[➡️ Arquitectura Completa](architecture.md)** - Entiende cómo funciona todo el sistema

---

[⬅️ Overview](overview.md) | [🏠 Índice](../README.md) | [➡️ Arquitectura](architecture.md)