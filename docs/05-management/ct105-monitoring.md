# CT105 - Monitoring (Grafana + Prometheus)

Sistema de monitoreo y visualización de métricas del homelab.

## 📋 Información del Contenedor

- **ID:** CT105
- **Hostname:** monitoring
- **IP Privada:** 10.10.10.50
- **OS:** Debian 12
- **Recursos:** 1 CPU, 1GB RAM, 16GB disco

## 🎯 Servicios

| Servicio | Puerto Interno Docker | Puerto Publicado | URL Acceso |
|----------|----------------------|------------------|------------|
| Grafana | 3000 | 3002 | http://10.10.10.50:3002 |
| Prometheus | 9090 | 9090 | http://10.10.10.50:9090 |
| Uptime Kuma | 3001 | 3001 | http://10.10.10.50:3001 |
| Beszel | 8090 | 8090 | http://10.10.10.50:8090 |
| Speedtest Tracker | 80 | 8085 | http://10.10.10.50:8085 |
| Scrutiny | 8080 | 8086 | http://10.10.10.50:8086 |

## 📚 Documentación Detallada

Para instrucciones completas, consulta:

- [Monitoreo y Alertas](../11-maintenance/monitoring-alerts.md) - Configuración completa
- [Diseño de Red](../03-networking/network-design.md) - Arquitectura de red

## 🔗 Acceso

- **Grafana:** http://10.10.10.50:3002 o https://grafana.home.arpa
- **Prometheus:** http://10.10.10.50:9090 o https://prometheus.home.arpa
- **Uptime Kuma:** http://10.10.10.50:3001 o https://kuma.home.arpa
- **Beszel:** http://10.10.10.50:8090 o https://beszel.home.arpa
- **Speedtest:** http://10.10.10.50:8085 o https://speedtest.home.arpa
- **Scrutiny:** http://10.10.10.50:8086 o https://scrutiny.home.arpa
- **Acceso remoto:** Vía Tailscale VPN

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
