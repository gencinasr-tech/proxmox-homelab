# Dominios y DNS

> **Configuración completa** de dominios internos, DNS y resolución de nombres

## Estructura de Dominios

### Dominio Base
- **TLD**: `.home.arpa` (RFC 8375 - dominio reservado para uso local)
- **Servidor DNS**: Pi-hole en CT103 (192.168.1.53)
- **DNS Secundario**: Cloudflare 1.1.1.1 (fallback)

### Convención de Nomenclatura
```
<servicio>.home.arpa
```

## Tabla de Dominios

| Dominio                  | IP Destino   | Servicio           | Contenedor |
| ------------------------ | ------------ | ------------------ | ---------- |
| homarr.home.arpa         | 10.10.10.10  | Dashboard          | CT101      |
| portainer.home.arpa      | 10.10.10.20  | Gestión Docker     | CT102      |
| casaos.home.arpa         | 10.10.10.25  | File Manager       | VM104      |
| immich.home.arpa         | 10.10.10.30  | Fotos              | VM109      |
| paperless.home.arpa      | 10.10.10.40  | Documentos         | CT107      |
| grafana.home.arpa        | 10.10.10.50  | Monitorización     | CT105      |
| vault.home.arpa          | 10.10.10.60  | Contraseñas        | CT106      |
| nextcloud.home.arpa      | 10.10.10.65  | Nube Privada       | CT108      |
| jellyfin.home.arpa       | 10.10.10.70  | Media Server       | CT110      |
| auth.home.arpa           | 10.10.10.74  | SSO/Keycloak       | CT113      |
| proxy.home.arpa          | 10.10.10.80  | Nginx Proxy        | CT112      |
| music.home.arpa          | 10.10.10.82  | Navidrome          | CT114      |
| qbit.home.arpa           | 10.10.10.83  | Downloads          | CT115      |

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

### Pi-hole (CT103)

#### Archivo de Hosts Personalizados
Ubicación: `/etc/pihole/custom.list`

```bash
# Servicios Core
10.10.10.10  homarr.home.arpa
10.10.10.20  portainer.home.arpa
10.10.10.25  casaos.home.arpa

# Servicios de Productividad
10.10.10.30  immich.home.arpa
10.10.10.40  paperless.home.arpa
10.10.10.60  vault.home.arpa
10.10.10.65  nextcloud.home.arpa

# Servicios de Gestión
10.10.10.50  grafana.home.arpa
10.10.10.74  auth.home.arpa
10.10.10.80  proxy.home.arpa

# Servicios de Utilidades
10.10.10.70  jellyfin.home.arpa
10.10.10.82  music.home.arpa
10.10.10.83  qbit.home.arpa
```

#### Aplicar Cambios
```bash
pihole restartdns
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

# Verificar que Pi-hole responde
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
4. **DNS seguro**: Pi-hole con listas de bloqueo actualizadas

### Organización
1. **Nomenclatura consistente**: `<servicio>.home.arpa`
2. **Documentar cambios**: Actualizar esta tabla al añadir servicios
3. **Backup de configuración**: Exportar configuración de Pi-hole regularmente
4. **Versionado**: Mantener historial de cambios en DNS

### Rendimiento
1. **Caché DNS**: Pi-hole cachea consultas para mejor rendimiento
2. **DNS secundario**: Cloudflare 1.1.1.1 como fallback
3. **TTL apropiado**: 300 segundos (5 minutos) para registros locales

## Migración y Backup

### Exportar Configuración Pi-hole
```bash
# Backup completo
pihole -a -t

# Solo custom.list
sudo cp /etc/pihole/custom.list ~/pihole-custom-backup.list
```

### Restaurar Configuración
```bash
# Restaurar custom.list
sudo cp ~/pihole-custom-backup.list /etc/pihole/custom.list
pihole restartdns
```

## Referencias

- [RFC 8375 - .home.arpa](https://datatracker.ietf.org/doc/html/rfc8375)
- [Pi-hole Documentation](https://docs.pi-hole.net/)
- [Tailscale DNS](https://tailscale.com/kb/1054/dns/)
- [mkcert](https://github.com/FiloSottile/mkcert)

**Última actualización**: 2026-01-18