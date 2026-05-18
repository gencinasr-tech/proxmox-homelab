# Monitoreo y Alertas

Configuración de monitoreo y sistema de alertas para el homelab.

## 📋 Índice

- [Grafana + Prometheus](#grafana--prometheus)
- [Configuración de Alertas](#configuración-de-alertas)
- [Métricas Importantes](#métricas-importantes)
- [Dashboards](#dashboards)

## Grafana + Prometheus

### Acceso

- **URL:** `https://grafana.tu-dominio.com`
- **Contenedor:** CT105 (Monitoring)
- **Puerto:** 3000

### Métricas Recopiladas

El sistema recopila métricas de:

- **Proxmox Host:** CPU, RAM, disco, red
- **Contenedores LXC:** Recursos por contenedor
- **Docker:** Estado de contenedores
- **Servicios:** Disponibilidad y rendimiento
- **Red:** Tráfico y latencia

## Configuración de Alertas

### Alertas de Recursos

#### Alta Utilización de CPU

```yaml
# Alert: CPU alta
- alert: HighCPUUsage
  expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "CPU alta en {{ $labels.instance }}"
    description: "CPU al {{ $value }}% durante 5 minutos"
```

#### Memoria Baja

```yaml
# Alert: Memoria baja
- alert: LowMemory
  expr: (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100 < 10
  for: 5m
  labels:
    severity: critical
  annotations:
    summary: "Memoria baja en {{ $labels.instance }}"
    description: "Solo {{ $value }}% de memoria disponible"
```

#### Disco Lleno

```yaml
# Alert: Disco lleno
- alert: DiskSpaceLow
  expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Disco lleno en {{ $labels.instance }}"
    description: "Solo {{ $value }}% de espacio disponible en {{ $labels.mountpoint }}"
```

### Alertas de Servicios

#### Servicio Caído

```yaml
# Alert: Servicio no disponible
- alert: ServiceDown
  expr: up == 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Servicio caído: {{ $labels.job }}"
    description: "{{ $labels.instance }} no responde"
```

#### Contenedor Docker Parado

```yaml
# Alert: Contenedor Docker parado
- alert: DockerContainerDown
  expr: docker_container_running == 0
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Contenedor Docker parado"
    description: "{{ $labels.name }} no está corriendo"
```

### Alertas de Red

#### Alta Latencia

```yaml
# Alert: Latencia alta
- alert: HighLatency
  expr: probe_duration_seconds > 1
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "Latencia alta a {{ $labels.instance }}"
    description: "Latencia de {{ $value }}s"
```

#### Servicio Web No Disponible

```yaml
# Alert: Web no disponible
- alert: WebsiteDown
  expr: probe_success == 0
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "Sitio web caído: {{ $labels.instance }}"
    description: "No se puede acceder a {{ $labels.instance }}"
```

## Métricas Importantes

### Métricas del Host

```promql
# CPU total
100 - (avg(irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memoria usada
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# Disco usado
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100

# Tráfico de red
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### Métricas de Contenedores

```promql
# CPU por contenedor
rate(container_cpu_usage_seconds_total[5m])

# Memoria por contenedor
container_memory_usage_bytes

# Red por contenedor
rate(container_network_receive_bytes_total[5m])
rate(container_network_transmit_bytes_total[5m])
```

### Métricas de Docker

```promql
# Contenedores corriendo
docker_container_running

# Uso de CPU de contenedor
rate(docker_container_cpu_usage_seconds_total[5m])

# Uso de memoria de contenedor
docker_container_memory_usage_bytes
```

## Dashboards

### Dashboard Principal

Incluye:
- Resumen de recursos del host
- Estado de todos los servicios
- Gráficos de uso histórico
- Alertas activas

### Dashboard por Servicio

Para cada servicio crítico:
- Disponibilidad (uptime)
- Tiempo de respuesta
- Tráfico de red
- Uso de recursos

### Dashboard de Red

- Tráfico total
- Latencia a servicios externos
- Conexiones activas
- Errores de red

## Configuración de Notificaciones

### Telegram

```yaml
# alertmanager.yml
receivers:
  - name: 'telegram'
    telegram_configs:
      - bot_token: 'TU_BOT_TOKEN'
        chat_id: TU_CHAT_ID
        parse_mode: 'HTML'
        message: |
          <b>{{ .GroupLabels.alertname }}</b>
          {{ range .Alerts }}
          {{ .Annotations.summary }}
          {{ .Annotations.description }}
          {{ end }}
```

### Email

```yaml
# alertmanager.yml
receivers:
  - name: 'email'
    email_configs:
      - to: 'tu-email@ejemplo.com'
        from: 'alertas@tu-dominio.com'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'tu-email@gmail.com'
        auth_password: 'tu-password'
        headers:
          Subject: 'Alerta: {{ .GroupLabels.alertname }}'
```

### Discord

```yaml
# alertmanager.yml
receivers:
  - name: 'discord'
    webhook_configs:
      - url: 'https://discord.com/api/webhooks/TU_WEBHOOK'
        send_resolved: true
```

## Umbrales Recomendados

### Recursos

| Métrica | Warning | Critical |
|---------|---------|----------|
| CPU | > 80% | > 95% |
| Memoria | < 20% libre | < 10% libre |
| Disco | < 20% libre | < 10% libre |
| Swap | > 50% usado | > 80% usado |

### Servicios

| Métrica | Warning | Critical |
|---------|---------|----------|
| Uptime | < 99% | < 95% |
| Latencia | > 500ms | > 1s |
| Errores | > 1% | > 5% |

### Red

| Métrica | Warning | Critical |
|---------|---------|----------|
| Latencia | > 100ms | > 500ms |
| Pérdida paquetes | > 1% | > 5% |
| Ancho de banda | > 80% | > 95% |

## Mantenimiento de Grafana

### Backup de Dashboards

```bash
# Exportar dashboards
curl -H "Authorization: Bearer API_KEY" \
  http://localhost:3000/api/search?type=dash-db | \
  jq -r '.[] | .uid' | \
  xargs -I {} curl -H "Authorization: Bearer API_KEY" \
  http://localhost:3000/api/dashboards/uid/{} > dashboard_{}.json
```

### Limpieza de Datos Antiguos

```bash
# En Prometheus, configurar retención
--storage.tsdb.retention.time=30d
--storage.tsdb.retention.size=50GB
```

### Actualización

```bash
# Actualizar Grafana
docker-compose pull grafana
docker-compose up -d grafana

# Actualizar Prometheus
docker-compose pull prometheus
docker-compose up -d prometheus
```

## Checklist de Monitoreo

### Configuración Inicial

- [ ] Grafana instalado y accesible
- [ ] Prometheus recopilando métricas
- [ ] Node Exporter en host
- [ ] cAdvisor para Docker
- [ ] Dashboards importados

### Alertas Configuradas

- [ ] Alertas de recursos (CPU, RAM, disco)
- [ ] Alertas de servicios críticos
- [ ] Alertas de red
- [ ] Notificaciones funcionando
- [ ] Pruebas de alertas realizadas

### Mantenimiento Regular

- [ ] Revisar dashboards semanalmente
- [ ] Ajustar umbrales según necesidad
- [ ] Limpiar datos antiguos mensualmente
- [ ] Backup de configuración
- [ ] Actualizar documentación

## 📚 Recursos Relacionados

- [Actualizaciones](updates.md)
- [Troubleshooting](troubleshooting.md)
- [CT105 - Monitoring](../05-management/ct105-monitoring.md)
- [Índice de Documentación](../README.md)

## 🆘 Ayuda

Si necesitas ayuda:
1. Revisa la [documentación completa](../README.md)
2. Consulta [Issues en GitHub](https://github.com/gencinasr-tech/proxmox-homelab/issues)
3. Abre una [nueva pregunta](https://github.com/gencinasr-tech/proxmox-homelab/issues/new?template=question.md)

---

[🏠 Volver al índice](../README.md)
