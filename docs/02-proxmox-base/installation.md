# 📦 Proxmox VE Installation

Guía completa para instalar Proxmox VE desde cero en tu hardware.

## 📋 Antes de Empezar

### Hardware Verificado

Este proyecto fue construido en:
- **Modelo**: ASUS TUF Gaming FX505DY
- **CPU**: AMD Ryzen 5 3550H (4C/8T)
- **RAM**: 16 GB DDR4
- **Almacenamiento**:
  - SSD NVMe Micron 2200V 500GB (sistema)
  - SSD SATA Crucial MX500 250GB (backups)

### Requisitos Mínimos

- **CPU**: 64-bit con soporte de virtualización (Intel VT-x / AMD-V)
- **RAM**: 4 GB mínimo, 8 GB recomendado
- **Disco**: 32 GB mínimo, SSD recomendado
- **Red**: Tarjeta Ethernet (WiFi no recomendado para host)

### Descargar Proxmox VE

1. Visita: https://www.proxmox.com/en/downloads
2. Descarga la ISO más reciente (este proyecto usa **Proxmox VE 9.1.9**)
3. Verifica el checksum SHA256

```bash
# En Linux/Mac
sha256sum proxmox-ve_*.iso

# En Windows (PowerShell)
Get-FileHash proxmox-ve_*.iso -Algorithm SHA256
```

### Crear USB Booteable

**En Windows:**
- Usa [Rufus](https://rufus.ie/) o [Ventoy](https://www.ventoy.net/)
- Selecciona la ISO de Proxmox
- Modo: DD Image o ISO
- Esquema de partición: GPT
- Sistema destino: UEFI

**En Linux:**
```bash
# Identifica tu USB (¡CUIDADO! Borrará todo)
lsblk

# Escribe la ISO (reemplaza sdX con tu dispositivo)
sudo dd if=proxmox-ve_*.iso of=/dev/sdX bs=4M status=progress
sudo sync
```

**En macOS:**
```bash
# Identifica tu USB
diskutil list

# Desmonta (reemplaza diskN)
diskutil unmountDisk /dev/diskN

# Escribe la ISO
sudo dd if=proxmox-ve_*.iso of=/dev/rdiskN bs=4m
```

## 🚀 Proceso de Instalación

### Paso 1: Boot desde USB

1. **Inserta el USB** en tu servidor/portátil
2. **Reinicia** y accede al menú de boot:
   - ASUS: F8 o ESC
   - HP: F9
   - Dell: F12
   - Lenovo: F12
   - Genérico: F2, F10, F12, ESC o DEL

3. **Selecciona el USB** de la lista de dispositivos

### Paso 2: Pantalla de Bienvenida

Verás el menú de Proxmox:

```
Proxmox VE (Terminal UI)
Install Proxmox VE (Graphical)  ← Selecciona esta
Install Proxmox VE (Terminal UI)
Advanced Options
Rescue Boot
Test Memory
```

Selecciona **"Install Proxmox VE (Graphical)"** y presiona Enter.

### Paso 3: Aceptar EULA

- Lee el acuerdo de licencia
- Marca "I agree" 
- Click en "Next"

### Paso 4: Selección de Disco

**⚠️ ADVERTENCIA**: Este paso BORRARÁ todos los datos del disco seleccionado.

1. **Selecciona tu disco principal**
   - En este proyecto: `/dev/nvme0n1` (Micron 2200V 500GB)
   - Verifica el modelo y tamaño antes de continuar

2. **Opciones avanzadas** (opcional):
   ```
   Filesystem: ext4 (recomendado para homelabs)
   hdsize: Deja el valor por defecto (usa todo el disco)
   swapsize: 4-8 GB (depende de tu RAM)
   maxroot: 96 GB (suficiente para Proxmox)
   minfree: 16 GB (espacio libre para snapshots)
   maxvz: Resto del disco (para VMs/CTs)
   ```

3. Click en "Next"

### Paso 5: Configuración Regional

```
Country: Spain
Time zone: Europe/Madrid
Keyboard Layout: Spanish (es)
```

Click en "Next"

### Paso 6: Contraseña y Email

1. **Root Password**: 
   - Usa una contraseña FUERTE
   - Mínimo 12 caracteres
   - Combina mayúsculas, minúsculas, números y símbolos
   - **GUÁRDALA EN TU GESTOR DE CONTRASEÑAS**

2. **Confirm Password**: Repite la contraseña

3. **Email**: Tu email (para notificaciones del sistema)
   ```
   ejemplo: admin@tudominio.com
   ```

Click en "Next"

### Paso 7: Configuración de Red

**Configuración Estática (Recomendado):**

```
Management Interface: enp2s0 (o tu interfaz principal)
Hostname (FQDN): pve.local
IP Address (CIDR): 192.168.1.200/24
Gateway: 192.168.1.1
DNS Server: 1.1.1.1
```

**Notas importantes:**
- El hostname debe ser un FQDN válido (nombre.dominio)
- La IP debe estar en tu rango de red local
- Usa una IP fija que no esté en el rango DHCP de tu router
- El gateway es típicamente la IP de tu router

**Configuración DHCP (No recomendado):**
- Proxmox puede usar DHCP, pero es mejor usar IP fija
- Si usas DHCP, reserva la IP en tu router después

Click en "Next"

### Paso 8: Resumen y Confirmación

Revisa toda la configuración:

```
Disk: /dev/nvme0n1
Country: Spain
Timezone: Europe/Madrid
Keyboard: es
Email: admin@tudominio.com
Hostname: pve.local
IP: 192.168.1.200/24
Gateway: 192.168.1.1
DNS: 1.1.1.1
```

**⚠️ ÚLTIMA OPORTUNIDAD**: Verifica que el disco es correcto.

Click en "Install" para comenzar.

### Paso 9: Instalación

El proceso tarda **5-15 minutos** dependiendo de tu hardware:

```
[████████████████████████████] 100%
Extracting files...
Installing bootloader...
Configuring system...
```

### Paso 10: Finalización

Cuando veas "Installation successful!":

1. **Retira el USB**
2. Click en "Reboot"
3. El sistema reiniciará automáticamente

## 🌐 Primer Acceso

### Acceso Web (Recomendado)

1. **Desde otro PC en la misma red**, abre un navegador
2. Navega a: `https://192.168.1.200:8006`
3. **Advertencia de seguridad**: Es normal, el certificado es autofirmado
   - Chrome: Click en "Advanced" → "Proceed to 192.168.1.200"
   - Firefox: Click en "Advanced" → "Accept the Risk and Continue"
   - Edge: Click en "Advanced" → "Continue to 192.168.1.200"

4. **Login**:
   ```
   Username: root
   Realm: Linux PAM standard authentication
   Password: tu_contraseña_root
   Language: English (o Spanish)
   ```

5. Click en "Login"

### Acceso por Consola (Alternativo)

Si no puedes acceder por web:

1. En el servidor, verás la consola de login
2. Login como `root` con tu contraseña
3. Verifica la red:
   ```bash
   ip addr show
   ip route
   ping -c 3 1.1.1.1
   ```

## ✅ Verificación Post-Instalación

### Verificar Versión

```bash
pveversion
# Debe mostrar: pve-manager/9.1.9/...
```

### Verificar Red

```bash
# Ver interfaces
ip addr show

# Ver rutas
ip route

# Test de conectividad
ping -c 3 1.1.1.1
ping -c 3 google.com
```

### Verificar Servicios

```bash
# Estado de servicios principales
systemctl status pveproxy
systemctl status pvedaemon
systemctl status pvestatd
systemctl status pve-cluster
```

Todos deben mostrar `active (running)`.

### Verificar Almacenamiento

```bash
# Ver discos
lsblk

# Ver uso de disco
df -h

# Ver almacenamiento Proxmox
pvesm status
```

## 🔧 Configuración Post-Instalación

### Actualizar Sistema

```bash
# Actualizar lista de paquetes
apt update

# Actualizar sistema (puede tardar)
apt upgrade -y

# Reiniciar si hay actualizaciones de kernel
reboot
```

### Configurar Repositorios

Ver [Initial Configuration](initial-config.md) para configurar los repositorios no-subscription.

### Configurar Portátil (Si aplica)

Si instalaste en un portátil, ver [Initial Configuration](initial-config.md) para evitar suspensión al cerrar la tapa.

## 🐛 Solución de Problemas

### No arranca desde USB

- Verifica que el USB está correctamente creado
- Desactiva Secure Boot en BIOS/UEFI
- Cambia el modo de boot a UEFI (no Legacy)
- Prueba otro puerto USB (preferiblemente USB 2.0)

### Error de red durante instalación

- Verifica que el cable Ethernet está conectado
- Prueba con DHCP primero, luego cambia a estática
- Verifica que la IP no está en uso por otro dispositivo

### Pantalla negra después de instalación

- Espera 2-3 minutos (puede estar configurando)
- Presiona Enter para ver si aparece el login
- Si persiste, reinicia y accede a GRUB (ESC durante boot)

### No puedo acceder a la Web UI

```bash
# Verificar IP
ip addr show

# Verificar servicios
systemctl status pveproxy

# Reiniciar servicios
systemctl restart pveproxy pvedaemon

# Verificar firewall
iptables -L -n
```

### Error "No valid subscription"

- Es normal sin suscripción enterprise
- No afecta la funcionalidad
- Se puede ocultar configurando repositorios no-subscription

## 📚 Próximos Pasos

1. **Configuración Inicial** → [Initial Configuration](initial-config.md)
2. **Configurar Almacenamiento** → [Storage Setup](storage-setup.md)
3. **Scripts de Rendimiento** → [Performance Scripts](performance-scripts.md)
4. **Crear Primer Contenedor** → [Quick Start](../01-getting-started/quick-start.md)

## 🔗 Referencias

- [Proxmox VE Installation Guide](https://pve.proxmox.com/wiki/Installation)
- [Proxmox VE System Requirements](https://www.proxmox.com/en/proxmox-ve/requirements)
- [Proxmox VE Network Configuration](https://pve.proxmox.com/wiki/Network_Configuration)

---

**¿Instalación completada?** Continúa con [Initial Configuration](initial-config.md) para preparar tu sistema.
