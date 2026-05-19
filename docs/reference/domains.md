# Dominios y DNS

> **Configuración completa** de dominios internos, DNS y resolución de nombres

## Estructura de Dominios

### Dominio Base
- **TLD**: `.home.arpa` (RFC 8375 - dominio reservado para uso local)
- **Servidor DNS**: AdGuard Home en CT103 (192.168.1.53)
- **DNS Secundario**: Cloudflare 1.1.1.1 (fallback)

### Convención de Nomenclatura
```
<servicio>.home.arpa
```

## Tabla de Dominios

### 🌐 Servicios en Red LAN (192.168.1.0/24)

| Dominio                  | IP Destino     | Servicio           | Contenedor |
| ------------------------ | -------------- | ------------------ | ---------- |
| proxmox.home.arpa        | 192.168.1.200  | Proxmox Host       | Host       |
| homepage.home.arpa       | 192.168.1.79   | Dashboard          | CT101      |
| homarr.home.arpa         | 192.168.1.79   | Dashboard          | CT101      |
| homer.home.arpa          | 192.168.1.79   | Dashboard          | CT101      |
| heimdall.home.arpa       | 192.168.1.79   | Dashboard          | CT101      |
| portainer.home.arpa      | 192.168.1.80   | Gestión Docker     | CT102      |
| adguard.home.arpa        | 192.168.1.53   | DNS                | CT103      |
| casaos.home.arpa         | 192.168.1.81   | NAS                | VM104      |
| syncthing.home.arpa      | 192.168.1.81   | Sincronización     | VM104      |
| duplicati.home.arpa      | 192.168.1.81   | Backups            | VM104      |
| npm.home.arpa            | 192.168.1.82   | Nginx Proxy        | CT112      |

### 🔒 Servicios en Red Privada (10.10.10.0/24)

| Dominio                  | IP Destino     | Servicio           | Contenedor |
| ------------------------ | -------------- | ------------------ | ---------- |
| kuma.home.arpa           | 10.10.10.50    | Uptime Kuma        | CT105      |
| grafana.home.arpa        | 10.10.10.50    | Monitorización     | CT105      |
| prometheus.home.arpa     | 10.10.10.50    | Métricas           | CT105      |
| speedtest.home.arpa      | 10.10.10.50    | Speedtest          | CT105      |
| scrutiny.home.arpa       | 10.10.10.50    | SMART Discos       | CT105      |
| beszel.home.arpa         | 10.10.10.50    | Monitoring         | CT105      |
| vault.home.arpa          | 10.10.10.60    | Contraseñas        | CT106      |
| paperless.home.arpa      | 10.10.10.40    | Documentos         | CT107      |
| nextcloud.home.arpa      | 10.10.10.65    | Nube Privada       | CT108      |
| immich.home.arpa         | 10.10.10.30    | Fotos              | VM109      |
| tools.home.arpa          | 10.10.10.70    | IT-Tools           | CT110      |
| pdf.home.arpa            | 10.10.10.70    | Stirling PDF       | CT110      |
| adminer.home.arpa        | 10.10.10.73    | DB Admin           | CT111      |
| pgadmin.home.arpa        | 10.10.10.73    | PostgreSQL Admin   | CT111      |
| chartdb.home.arpa        | 10.10.10.73    | DB Diagrams        | CT111      |
| auth.home.arpa           | 192.168.1.82   | SSO/Keycloak (via NPM) | CT113  |
| music.home.arpa          | 10.10.10.82    | Navidrome          | CT114      |
| downloads.home.arpa      | 10.10.10.83    | Music Downloader   | CT115      |

## Dominios Tailscale

### Acceso Externo vía VPN
Los servicios críticos están disponibles vía Tailscale con dominios propios:

| Servicio    | Dominio Tailscale                    | IP Interna   |
| ----------- | ------------------------------------ | ------------ |
| Vaultwarden | vaultwarden.tailXXXXXX.ts.net        | 10.10.10.60  |
| Nextcloud   | nextcloud.tailXXXXXX.ts.net          | 10.10.10.65  |
| Grafana     | grafana.tailXXXXXX.ts.net            | 10.10.10.50  |

**Nota**: `tailXXXXXX` es un placeholder. Cada instalación de Tailscale tiene su propio dominio único.

### Configuración Tailscale Serve
```bash
# Ejemplo de configuración en CT100
tailscale serve https / http://10.10.10.60:8080
```

## Configuración DNS

### AdGuard Home (CT103)

#### DNS Rewrites
AdGuard Home usa "DNS Rewrites" en lugar de archivos de hosts.

**Ubicación**: AdGuard Home Web UI → Filters → DNS rewrites

#### Configuración vía Web UI

1. Acceder a http://192.168.1.53
2. Ir a **Filters** → **DNS rewrites**
3. Añadir cada dominio con su IP correspondiente

#### Configuración vía Archivo

Ubicación: `/opt/adguardhome/conf/AdGuardHome.yaml`

```yaml
dns:
  rewrites:
    # Servicios LAN
    - domain: proxmox.home.arpa
      answer: 192.168.1.200
    - domain: homepage.home.arpa
      answer: 192.168.1.79
    - domain: homarr.home.arpa
      answer: 192.168.1.79
    - domain: homer.home.arpa
      answer: 192.168.1.79
    - domain: heimdall.home.arpa
      answer: 192.168.1.79
    - domain: portainer.home.arpa
      answer: 192.168.1.80
    - domain: adguard.home.arpa
      answer: 192.168.1.53
    - domain: casaos.home.arpa
      answer: 192.168.1.81
    - domain: syncthing.home.arpa
      answer: 192.168.1.81
    - domain: duplicati.home.arpa
      answer: 192.168.1.81
    - domain: npm.home.arpa
      answer: 192.168.1.82
    
    # Servicios Privados
    - domain: kuma.home.arpa
      answer: 10.10.10.50
    - domain: grafana.home.arpa
      answer: 10.10.10.50
    - domain: prometheus.home.arpa
      answer: 10.10.10.50
    - domain: speedtest.home.arpa
      answer: 10.10.10.50
    - domain: scrutiny.home.arpa
      answer: 10.10.10.50
    - domain: beszel.home.arpa
      answer: 10.10.10.50
    - domain: vault.home.arpa
      answer: 10.10.10.60
    - domain: paperless.home.arpa
      answer: 10.10.10.40
    - domain: nextcloud.home.arpa
      answer: 10.10.10.65
    - domain: immich.home.arpa
      answer: 10.10.10.30
    - domain: tools.home.arpa
      answer: 10.10.10.70
    - domain: pdf.home.arpa
      answer: 10.10.10.70
    - domain: adminer.home.arpa
      answer: 10.10.10.73
    - domain: pgadmin.home.arpa
      answer: 10.10.10.73
    - domain: chartdb.home.arpa
      answer: 10.10.10.73
    - domain: auth.home.arpa
      answer: 192.168.1.82
    - domain: music.home.arpa
      answer: 10.10.10.82
    - domain: downloads.home.arpa
      answer: 10.10.10.83
```

#### Aplicar Cambios
```bash
# Reiniciar AdGuard Home
docker restart adguardhome

# O desde la UI: Settings → General → Restart
```

### Configuración de Clientes

#### Linux/macOS
Archivo: `/etc/resolv.conf`
```bash
nameserver 192.168.1.53
nameserver 1.1.1.1
```

#### Windows
```powershell
# PowerShell como administrador
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("192.168.1.53","1.1.1.1")
```

#### Router
Configurar DHCP para distribuir 192.168.1.53 como DNS primario a todos los clientes.

## Certificados SSL

### Certificados Locales (mkcert)

Para desarrollo local con HTTPS:

```bash
# Instalar mkcert
mkcert -install

# Generar certificados para dominios locales
mkcert "*.home.arpa" localhost 127.0.0.1 ::1

# Resultado:
# _wildcard.home.arpa+3.pem (certificado)
# _wildcard.home.arpa+3-key.pem (clave privada)
```

### Let's Encrypt (Tailscale)

Para dominios Tailscale públicos:

```bash
# Tailscale gestiona automáticamente certificados Let's Encrypt
tailscale cert vaultwarden.tailXXXXXX.ts.net
```

## Nginx Proxy Manager (CT112)

### Proxy Hosts
Configuración de reverse proxy para servicios:

```nginx
# Ejemplo: Vaultwarden
server_name vault.home.arpa;
location / {
    proxy_pass http://10.10.10.60:8080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

### SSL/TLS
- Certificados locales para dominios `.home.arpa`
- Let's Encrypt para dominios Tailscale
- Redirección automática HTTP → HTTPS

## Resolución de Problemas

### Verificar DNS
```bash
# Comprobar resolución
nslookup vault.home.arpa 192.168.1.53
dig @192.168.1.53 vault.home.arpa

# Verificar que AdGuard responde
ping 192.168.1.53
```

### Limpiar Caché DNS

#### Linux
```bash
sudo systemd-resolve --flush-caches
```

#### macOS
```bash
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

#### Windows
```powershell
ipconfig /flushdns
```

### Verificar Conectividad
```bash
# Ping al servicio
ping vault.home.arpa

# Verificar puerto abierto
nc -zv vault.home.arpa 8080
telnet vault.home.arpa 8080
```

## Mejores Prácticas

### Seguridad
1. **No exponer servicios internos a Internet**: Usar solo Tailscale para acceso remoto
2. **HTTPS siempre**: Incluso para servicios internos
3. **Certificados válidos**: Usar mkcert para desarrollo, Let's Encrypt para producción
4. **DNS seguro**: AdGuard Home con listas de bloqueo actualizadas

### Organización
1. **Nomenclatura consistente**: `<servicio>.home.arpa`
2. **Documentar cambios**: Actualizar esta tabla al añadir servicios
3. **Backup de configuración**: Exportar configuración de AdGuard regularmente
4. **Versionado**: Mantener historial de cambios en DNS

### Rendimiento
1. **Caché DNS**: AdGuard cachea consultas para mejor rendimiento
2. **DNS secundario**: Cloudflare 1.1.1.1 como fallback
3. **TTL apropiado**: 300 segundos (5 minutos) para registros locales

## Migración y Backup

### Exportar Configuración AdGuard Home
```bash
# Backup completo (incluye configuración y estadísticas)
docker exec adguardhome tar -czf /tmp/adguard-backup.tar.gz /opt/adguardhome/conf /opt/adguardhome/work
docker cp adguardhome:/tmp/adguard-backup.tar.gz ./adguard-backup.tar.gz

# Solo configuración
docker cp adguardhome:/opt/adguardhome/conf/AdGuardHome.yaml ./AdGuardHome-backup.yaml
```

### Restaurar Configuración
```bash
# Restaurar archivo de configuración
docker cp ./AdGuardHome-backup.yaml adguardhome:/opt/adguardhome/conf/AdGuardHome.yaml
docker restart adguardhome
```

## Referencias

- [RFC 8375 - .home.arpa](https://datatracker.ietf.org/doc/html/rfc8375)
- [AdGuard Home Documentation](https://github.com/AdguardTeam/AdGuardHome/wiki)
- [Tailscale DNS](https://tailscale.com/kb/1054/dns/)
- [mkcert](https://github.com/FiloSottile/mkcert)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [📋 Ver Inventario](inventory.md) | [🔌 Ver Puertos](ports.md)