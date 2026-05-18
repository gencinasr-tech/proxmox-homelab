# ⚡ Quick Start

> 🚧 **Documentación en Progreso**
> 
> Este documento está siendo desarrollado. Por ahora, consulta la [Guia 3.0.md](../../Guia%203.0.md) en la raíz del repositorio para instrucciones detalladas paso a paso.

## 📋 Resumen Rápido

Esta guía te llevará desde cero hasta tener un homelab funcional en aproximadamente 30 minutos (sin contar descargas).

## ✅ Antes de Empezar

Asegúrate de haber revisado:
- [Overview](overview.md) - Entender qué es el proyecto
- [Requisitos Previos](prerequisites.md) - Verificar que cumples los requisitos
- [Arquitectura](architecture.md) - Comprender cómo funciona

## 🚀 Pasos Rápidos

### 1. Instalar Proxmox
Ver guía completa: [Instalación de Proxmox](../02-proxmox-base/installation.md)

### 2. Configurar Host
```bash
# Ejecutar scripts en orden
bash scripts/proxmox-host/01-prepare-repos.sh
bash scripts/proxmox-host/02-configure-lid.sh
bash scripts/proxmox-host/03-setup-hdd.sh
```

### 3. Crear Contenedores Base
- CT100: Tailscale Gateway
- CT101: Dashboards
- CT102: Portainer

### 4. Desplegar Servicios
Seguir las guías individuales en `/services`

## 📚 Documentación Completa

Para instrucciones detalladas paso a paso, consulta:
- **[Guia 3.0.md](../../Guia%203.0.md)** - Guía completa con todos los comandos

## 🆘 Ayuda

Si tienes problemas:
1. Revisa [Troubleshooting](../11-maintenance/troubleshooting.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)

---

[⬅️ Arquitectura](architecture.md) | [🏠 Índice](../README.md) | [➡️ Instalación Proxmox](../02-proxmox-base/installation.md)