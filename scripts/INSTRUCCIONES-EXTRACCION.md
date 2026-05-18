# 📋 Instrucciones para Extraer Información del Servidor Proxmox

## 🎯 Objetivo

Este script extrae **TODA** la información de tu servidor Proxmox y la guarda en tu carpeta Samba para que puedas acceder fácilmente desde Windows.

---

## 🚀 Cómo Ejecutar el Script

### Paso 1: Conectarte a tu Proxmox por SSH

Desde tu Windows, abre PowerShell o CMD y ejecuta:

```bash
ssh root@192.168.1.200
```

Introduce tu contraseña cuando te la pida.

### Paso 2: Copiar el Script al Servidor

Una vez conectado a Proxmox, ejecuta estos comandos:

```bash
# Crear directorio para scripts si no existe
mkdir -p /root/scripts

# Descargar el script desde tu repositorio GitHub
cd /root/scripts
wget https://raw.githubusercontent.com/gencinasr-tech/proxmox-homelab/main/scripts/extract-proxmox-info.sh

# O si prefieres, cópialo manualmente desde Windows al Samba y luego:
cp /mnt/casaos-data/documents/extract-proxmox-info.sh /root/scripts/

# Dar permisos de ejecución
chmod +x /root/scripts/extract-proxmox-info.sh
```

### Paso 3: Ejecutar el Script

```bash
# Ejecutar el script
/root/scripts/extract-proxmox-info.sh
```

El script tardará unos 2-3 minutos en completarse.

---

## 📂 Dónde Encontrar los Archivos Generados

### Desde Windows:

1. **Abre el Explorador de Archivos**

2. **Ve a una de estas ubicaciones**:
   ```
   \\192.168.1.200\Server\documents\proxmox-info-export
   ```
   O si tienes la unidad mapeada (como en tu captura):
   ```
   Z:\documents\proxmox-info-export
   ```

3. **Encontrarás 2 archivos**:
   - `proxmox-complete-info-YYYYMMDD-HHMMSS.json` → Formato JSON estructurado
   - `proxmox-complete-info-YYYYMMDD-HHMMSS.txt` → Formato texto legible

---

## 📊 Qué Información Extrae el Script

El script recopila **TODO** lo siguiente:

### ✅ 1. Información de Proxmox
- Versión exacta de Proxmox VE
- Información del cluster (si existe)
- Configuración del datacenter

### ✅ 2. Hardware del Servidor
- CPU: Modelo, cores, threads, arquitectura
- RAM: Total, usado, disponible
- Discos: Todos los discos con tamaños, modelos, particiones
- Información detallada de cada disco (fdisk, lsblk)

### ✅ 3. Configuración de Red
- Todas las interfaces de red
- Direcciones IP asignadas
- Rutas de red
- Bridges configurados
- Configuración completa de `/etc/network/interfaces`

### ✅ 4. Almacenamiento
- Storage pools de Proxmox
- Uso de disco en cada pool
- Configuración de LVM (si existe)
- ZFS pools (si existen)
- Montajes y puntos de montaje

### ✅ 5. Contenedores LXC (TODOS)
Para cada contenedor:
- ID y nombre
- Configuración completa (CPU, RAM, disco, red)
- Estado actual (running/stopped)
- Uso de recursos en tiempo real
- Sistema operativo y versión

### ✅ 6. Máquinas Virtuales (TODAS)
Para cada VM:
- ID y nombre
- Configuración completa (CPU, RAM, disco, red)
- Estado actual
- Discos virtuales asignados

### ✅ 7. Backups
- Tareas de backup programadas
- Configuración de vzdump
- Backups disponibles en storage

### ✅ 8. Usuarios y Permisos
- Lista de usuarios
- Grupos configurados
- Roles y permisos
- ACLs (Access Control Lists)

### ✅ 9. Recursos del Sistema
- Uso actual de CPU y memoria
- Procesos de Proxmox en ejecución
- Servicios activos
- Top de procesos

### ✅ 10. Configuraciones Adicionales
- Firewall de Proxmox
- Repositorios APT configurados
- Configuración del datacenter

### ✅ 11. Logs Recientes
- Últimas 50 líneas del syslog
- Últimas 50 líneas del daemon.log

### ✅ 12. Docker en Contenedores
Para cada contenedor que tenga Docker:
- Versión de Docker
- Contenedores Docker en ejecución
- Imágenes Docker descargadas
- Volúmenes Docker
- Redes Docker
- Ubicación de archivos docker-compose.yml

---

## 🔍 Formatos de Salida

### Archivo JSON (`*.json`)
- Formato estructurado para procesamiento automático
- Ideal para scripts y análisis programático
- Contiene toda la información en formato JSON válido

### Archivo TXT (`*.txt`)
- Formato legible para humanos
- Organizado en secciones con títulos
- Fácil de leer y buscar información específica
- Incluye tablas y formato visual

---

## 📤 Qué Hacer con los Archivos

### Opción 1: Enviar al Asistente IA

1. Copia uno de los archivos (preferiblemente el JSON)
2. Súbelo o pega su contenido en la conversación
3. El asistente generará documentación 100% precisa

### Opción 2: Revisar Manualmente

1. Abre el archivo TXT con cualquier editor de texto
2. Revisa la información extraída
3. Verifica que todo esté correcto

---

## ⚠️ Notas Importantes

### Seguridad
- ✅ El script **SOLO LEE** información, no modifica nada
- ✅ No se conecta a internet
- ✅ Los archivos se guardan localmente en tu Samba
- ⚠️ Los archivos contienen información sensible (IPs, configuraciones)
- ⚠️ No compartas los archivos públicamente

### Requisitos
- ✅ Proxmox VE 7.x o superior
- ✅ Acceso root al servidor
- ✅ Python 3 instalado (viene por defecto en Proxmox)
- ✅ Carpeta Samba CasaOS configurada en `/mnt/casaos-data/documents`

### Solución de Problemas

**Si el script falla:**

1. Verifica que tienes permisos de root:
   ```bash
   whoami  # Debe mostrar: root
   ```

2. Verifica que la carpeta Samba CasaOS existe:
   ```bash
   ls -la /mnt/casaos-data/documents
   ```

3. Verifica que Python 3 está instalado:
   ```bash
   python3 --version
   ```

4. Ejecuta el script con más detalle:
   ```bash
   bash -x /root/scripts/extract-proxmox-info.sh
   ```

---

## 🎯 Ejemplo de Ejecución

```bash
root@pve:~# /root/scripts/extract-proxmox-info.sh

╔════════════════════════════════════════════════════════════════╗
║  Script de Extracción Completa de Información de Proxmox      ║
╚════════════════════════════════════════════════════════════════╝

[✓] Directorio de salida: /mnt/casaos-data/documents/proxmox-info-export
[✓] Archivo JSON: proxmox-complete-info-20260518-142030.json
[✓] Archivo TXT: proxmox-complete-info-20260518-142030.txt

[→] Extrayendo información del sistema...

[1/12] Versión de Proxmox...
[2/12] Hardware del servidor...
[3/12] Configuración de red...
[4/12] Almacenamiento...
[5/12] Contenedores LXC...
  → CT 100
  → CT 101
  → CT 102
  ... (todos los contenedores)
[6/12] Máquinas virtuales...
  → VM 104
  → VM 109
[7/12] Configuración de backups...
[8/12] Usuarios y permisos...
[9/12] Recursos del sistema...
[10/12] Configuraciones adicionales...
[11/12] Logs recientes...
[12/12] Información de Docker en contenedores...
  → CT 101 tiene Docker
  → CT 102 tiene Docker
  ... (todos los que tengan Docker)

╔════════════════════════════════════════════════════════════════╗
║  ✓ EXTRACCIÓN COMPLETADA CON ÉXITO                             ║
╚════════════════════════════════════════════════════════════════╝

Archivos generados:
  📄 JSON: /mnt/casaos-data/documents/proxmox-info-export/proxmox-complete-info-20260518-142030.json
  📄 TXT:  /mnt/casaos-data/documents/proxmox-info-export/proxmox-complete-info-20260518-142030.txt

Acceso desde Windows:
  🗂️  Abre el explorador de archivos
  🗂️  Ve a: \\192.168.1.200\Server\documents\proxmox-info-export
  🗂️  O: Z:\documents\proxmox-info-export (si tienes la unidad mapeada)

[✓] Los archivos están listos para ser copiados a tu Windows
```

---

## 📞 Soporte

Si tienes problemas ejecutando el script:

1. Verifica que seguiste todos los pasos
2. Revisa los mensajes de error
3. Consulta la sección de "Solución de Problemas"
4. Contacta con el asistente IA con el error específico

---

**¡Listo!** Una vez ejecutado el script, tendrás toda la información de tu servidor lista para generar documentación profesional. 🚀