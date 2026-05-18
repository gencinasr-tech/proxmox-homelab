# CT105 - Monitoring (Grafana + Prometheus)

Sistema de monitoreo y visualización de métricas del homelab.

## 📋 Información del Contenedor

- **ID:** CT105
- **Hostname:** monitoring
- **IP Privada:** 10.0.0.105
- **OS:** Debian 12
- **Recursos:** 2 CPU, 4GB RAM, 16GB disco

## 🎯 Servicios

- **Grafana:** Dashboard de visualización (Puerto 3000)
- **Prometheus:** Recopilación de métricas (Puerto 9090)
- **Node Exporter:** Métricas del sistema
- **cAdvisor:** Métricas de Docker

## 📚 Documentación Detallada

Para instrucciones completas, consulta:

- [Monitoreo y Alertas](../11-maintenance/monitoring-alerts.md) - Configuración completa
- [Diseño de Red](../03-networking/network-design.md) - Arquitectura de red

## 🔗 Acceso

- **Interno:** http://10.0.0.105:3000
- **Externo:** https://grafana.tu-dominio.com (vía Nginx Proxy Manager)

## 🔗 Recursos Relacionados

- [Monitoreo y Alertas](../11-maintenance/monitoring-alerts.md)
- [Red Privada](../03-networking/private-network.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
