# 🔒 Security Hardening

Guía completa para endurecer la seguridad de tu homelab Proxmox.

## 📋 Tabla de Contenidos

- [Seguridad del Host Proxmox](#seguridad-del-host-proxmox)
- [Seguridad de Red](#seguridad-de-red)
- [Seguridad de Contenedores](#seguridad-de-contenedores)
- [Gestión de Accesos](#gestión-de-accesos)
- [Certificados SSL](#certificados-ssl)
- [Backups Seguros](#backups-seguros)
- [Monitoreo de Seguridad](#monitoreo-de-seguridad)
- [Auditoría y Compliance](#auditoría-y-compliance)

---

## 🖥️ Seguridad del Host Proxmox

### 1. Actualizaciones Automáticas

```bash
# Instalar unattended-upgrades
apt update
apt install unattended-upgrades apt-listchanges

# Configurar
dpkg-reconfigure -plow unattended-upgrades

# Editar configuración
nano /etc/apt/apt.conf.d/50unattended-upgrades
```

Configuración recomendada:
```bash
Unattended-Upgrade::Origins-Pattern {
    "origin=Debian,codename=${distro_codename},label=Debian-Security";
};

Unattended-Upgrade::AutoFixInterruptedDpkg "true";
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "false";
```

### 2. SSH Hardening

```bash
# Editar configuración SSH
nano /etc/ssh/sshd_config
```

Configuración segura:
```bash
# Deshabilitar root login
PermitRootLogin no

# Solo autenticación por clave
PasswordAuthentication no
PubkeyAuthentication yes

# Cambiar puerto (opcional)
Port 2222

# Limitar usuarios
AllowUsers tu_usuario

# Deshabilitar X11 forwarding
X11Forwarding no

# Configurar timeouts
ClientAliveInterval 300
ClientAliveCountMax 2

# Usar protocolo 2
Protocol 2

# Limitar intentos
MaxAuthTries 3
MaxSessions 2
```

Reiniciar SSH:
```bash
systemctl restart sshd
```

### 3. Firewall con UFW

```bash
# Instalar UFW
apt install ufw

# Configuración básica
ufw default deny incoming
ufw default allow outgoing

# Permitir SSH (ajustar puerto si cambiaste)
ufw allow 2222/tcp

# Permitir Proxmox Web UI
ufw allow 8006/tcp

# Permitir desde red local
ufw allow from 192.168.1.0/24

# Activar
ufw enable

# Ver estado
ufw status verbose
```

### 4. Fail2Ban

```bash
# Instalar
apt install fail2ban

# Crear configuración local
cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
nano /etc/fail2ban/jail.local
```

Configuración:
```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
destemail = tu@email.com
sendername = Fail2Ban
action = %(action_mwl)s

[sshd]
enabled = true
port = 2222
logpath = /var/log/auth.log

[proxmox]
enabled = true
port = 8006
logpath = /var/log/daemon.log
```

Iniciar:
```bash
systemctl enable fail2ban
systemctl start fail2ban
fail2ban-client status
```

### 5. Auditoría con Auditd

```bash
# Instalar
apt install auditd audispd-plugins

# Reglas básicas
cat > /etc/audit/rules.d/homelab.rules << 'EOF'
# Monitorear cambios en configuración
-w /etc/passwd -p wa -k identity
-w /etc/group -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/sudoers -p wa -k actions

# Monitorear accesos SSH
-w /var/log/auth.log -p wa -k auth

# Monitorear cambios en Proxmox
-w /etc/pve/ -p wa -k proxmox_config
EOF

# Recargar reglas
augenrules --load

# Ver eventos
ausearch -k identity
```

---

## 🌐 Seguridad de Red

### 1. Segmentación de Red

```
┌─────────────────────────────────────────┐
│         Internet                        │
└──────────────┬──────────────────────────┘
               │
        ┌──────▼──────┐
        │   Router    │
        │  Firewall   │
        └──────┬──────┘
               │
    ┌──────────┴──────────┐
    │                     │
┌───▼────┐          ┌─────▼─────┐
│  LAN   │          │  Private  │
│192.168 │          │  10.10.10 │
│.1.0/24 │          │   .0/24   │
└────────┘          └───────────┘
    │                     │
    │              ┌──────┴──────┐
    │              │             │
┌───▼────┐    ┌────▼───┐   ┌────▼────┐
│Clientes│    │Services│   │Databases│
└────────┘    └────────┘   └─────────┘
```

### 2. Firewall en Proxmox

```bash
# Habilitar firewall en datacenter
pvesh set /cluster/firewall/options --enable 1

# Crear reglas en /etc/pve/firewall/cluster.fw
cat > /etc/pve/firewall/cluster.fw << 'EOF'
[OPTIONS]
enable: 1

[RULES]
# Permitir SSH desde LAN
IN ACCEPT -source 192.168.1.0/24 -p tcp -dport 22

# Permitir Proxmox Web desde LAN
IN ACCEPT -source 192.168.1.0/24 -p tcp -dport 8006

# Permitir Tailscale
IN ACCEPT -p udp -dport 41641

# Bloquear todo lo demás
IN DROP
EOF
```

### 3. VLANs (Opcional)

```bash
# Crear VLAN en Proxmox
# En /etc/network/interfaces

auto vmbr0.10
iface vmbr0.10 inet static
    address 10.0.10.1
    netmask 255.255.255.0
    vlan-raw-device vmbr0

auto vmbr0.20
iface vmbr0.20 inet static
    address 10.0.20.1
    netmask 255.255.255.0
    vlan-raw-device vmbr0
```

---

## 🐳 Seguridad de Contenedores

### 1. Contenedores No Privilegiados

```bash
# Crear contenedor no privilegiado
pct create 100 local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst \
  --unprivileged 1 \
  --features nesting=1 \
  --hostname test \
  --memory 2048 \
  --net0 name=eth0,bridge=vmbr1,ip=dhcp
```

### 2. AppArmor

```bash
# Instalar AppArmor
apt install apparmor apparmor-utils

# Ver perfiles
aa-status

# Crear perfil personalizado
nano /etc/apparmor.d/docker-nginx

# Cargar perfil
apparmor_parser -r /etc/apparmor.d/docker-nginx
```

### 3. Seccomp Profiles

```json
{
  "defaultAction": "SCMP_ACT_ERRNO",
  "architectures": [
    "SCMP_ARCH_X86_64"
  ],
  "syscalls": [
    {
      "names": [
        "accept",
        "bind",
        "listen",
        "read",
        "write"
      ],
      "action": "SCMP_ACT_ALLOW"
    }
  ]
}
```

Usar en docker-compose:
```yaml
services:
  app:
    security_opt:
      - seccomp=/path/to/seccomp.json
```

### 4. Escaneo de Vulnerabilidades

```bash
# Instalar Trivy
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/trivy.list
apt update
apt install trivy

# Escanear imagen
trivy image nginx:latest

# Escanear filesystem
trivy fs /opt/stacks/

# Escanear con severidad alta/crítica
trivy image --severity HIGH,CRITICAL nginx:latest
```

---

## 🔑 Gestión de Accesos

### 1. Usuarios y Grupos

```bash
# Crear usuario sin shell
useradd -r -s /usr/sbin/nologin serviceuser

# Crear grupo para servicios
groupadd docker-users
usermod -aG docker-users tu_usuario

# Limitar sudo
visudo
# Añadir:
tu_usuario ALL=(ALL) NOPASSWD: /usr/bin/docker, /usr/bin/docker-compose
```

### 2. Autenticación de Dos Factores

```bash
# Instalar Google Authenticator
apt install libpam-google-authenticator

# Configurar para usuario
su - tu_usuario
google-authenticator

# Editar PAM
nano /etc/pam.d/sshd
# Añadir:
auth required pam_google_authenticator.so

# Editar SSH config
nano /etc/ssh/sshd_config
# Cambiar:
ChallengeResponseAuthentication yes

systemctl restart sshd
```

### 3. Gestión de Claves SSH

```bash
# Generar clave segura
ssh-keygen -t ed25519 -C "tu@email.com"

# Copiar a servidor
ssh-copy-id -i ~/.ssh/id_ed25519.pub usuario@servidor

# Configurar cliente
nano ~/.ssh/config
```

```
Host homelab
    HostName 192.168.1.100
    User tu_usuario
    Port 2222
    IdentityFile ~/.ssh/id_ed25519
    IdentitiesOnly yes
```

---

## 🔐 Certificados SSL

### 1. Let's Encrypt con Certbot

```bash
# Instalar Certbot
apt install certbot

# Obtener certificado (DNS challenge)
certbot certonly --manual --preferred-challenges dns \
  -d homelab.tudominio.com \
  -d '*.homelab.tudominio.com'

# Renovación automática
cat > /etc/cron.d/certbot << 'EOF'
0 3 * * * root certbot renew --quiet --deploy-hook "systemctl reload nginx"
EOF
```

### 2. Certificados Internos con mkcert

```bash
# Instalar mkcert
apt install libnss3-tools
wget https://github.com/FiloSottile/mkcert/releases/download/v1.4.4/mkcert-v1.4.4-linux-amd64
mv mkcert-v1.4.4-linux-amd64 /usr/local/bin/mkcert
chmod +x /usr/local/bin/mkcert

# Instalar CA local
mkcert -install

# Generar certificados
mkcert "*.local.tudominio.com" localhost 127.0.0.1 ::1
```

### 3. Renovación Automática

```bash
#!/bin/bash
# /usr/local/bin/renew-certs.sh

# Renovar Let's Encrypt
certbot renew --quiet

# Copiar a servicios
cp /etc/letsencrypt/live/tudominio.com/fullchain.pem /opt/certs/
cp /etc/letsencrypt/live/tudominio.com/privkey.pem /opt/certs/

# Recargar servicios
docker-compose -f /opt/stacks/proxy/docker-compose.yml restart

# Notificar
curl -X POST https://ntfy.sh/homelab-alerts \
  -d "Certificados SSL renovados exitosamente"
```

---

## 💾 Backups Seguros

### 1. Cifrado de Backups

```bash
# Backup cifrado con GPG
tar -czf - /opt/appdata | gpg --symmetric --cipher-algo AES256 -o backup.tar.gz.gpg

# Restaurar
gpg --decrypt backup.tar.gz.gpg | tar -xzf -
```

### 2. Backup a Cloud Cifrado

```bash
# Configurar rclone con cifrado
rclone config

# Backup automático
cat > /usr/local/bin/backup-to-cloud.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/mnt/backups"
REMOTE="gdrive-encrypted:backups"

# Crear backup
tar -czf $BACKUP_DIR/backup-$(date +%Y%m%d).tar.gz /opt/appdata

# Subir cifrado
rclone copy $BACKUP_DIR/ $REMOTE --progress

# Limpiar backups antiguos (>30 días)
find $BACKUP_DIR -name "backup-*.tar.gz" -mtime +30 -delete
rclone delete $REMOTE --min-age 30d
EOF

chmod +x /usr/local/bin/backup-to-cloud.sh
```

### 3. Verificación de Integridad

```bash
# Crear checksums
find /opt/appdata -type f -exec sha256sum {} \; > checksums.txt

# Verificar
sha256sum -c checksums.txt
```

---

## 📊 Monitoreo de Seguridad

### 1. Logs Centralizados

```yaml
# Loki + Promtail
version: '3.8'

services:
  loki:
    image: grafana/loki:latest
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yml:/etc/loki/local-config.yaml
      - loki_data:/loki

  promtail:
    image: grafana/promtail:latest
    volumes:
      - /var/log:/var/log:ro
      - ./promtail-config.yml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
```

### 2. Alertas de Seguridad

```yaml
# Prometheus rules
groups:
  - name: security
    interval: 30s
    rules:
      - alert: HighFailedLogins
        expr: rate(failed_login_attempts[5m]) > 5
        for: 5m
        annotations:
          summary: "Múltiples intentos de login fallidos"
          
      - alert: UnauthorizedAccess
        expr: unauthorized_access_attempts > 0
        annotations:
          summary: "Intento de acceso no autorizado detectado"
```

### 3. Monitoreo de Archivos

```bash
# Instalar AIDE
apt install aide

# Inicializar base de datos
aideinit

# Verificar cambios
aide --check

# Automatizar
cat > /etc/cron.daily/aide << 'EOF'
#!/bin/bash
aide --check | mail -s "AIDE Report" tu@email.com
EOF
chmod +x /etc/cron.daily/aide
```

---

## 📋 Auditoría y Compliance

### 1. Lynis Security Audit

```bash
# Instalar Lynis
apt install lynis

# Ejecutar auditoría
lynis audit system

# Ver reporte
cat /var/log/lynis.log
```

### 2. OpenSCAP

```bash
# Instalar
apt install libopenscap8 openscap-utils

# Descargar perfiles
wget https://security.debian.org/debian-security/pool/updates/main/s/scap-security-guide/ssg-debian_*.deb
dpkg -i ssg-debian_*.deb

# Escanear
oscap xccdf eval --profile standard \
  --results results.xml \
  --report report.html \
  /usr/share/xml/scap/ssg/content/ssg-debian12-ds.xml
```

### 3. Checklist de Seguridad

```bash
#!/bin/bash
# security-check.sh

echo "=== Security Audit ==="
echo ""

# 1. Actualizaciones pendientes
echo "1. Actualizaciones pendientes:"
apt list --upgradable

# 2. Usuarios con shell
echo "2. Usuarios con shell:"
grep -v '/nologin\|/false' /etc/passwd

# 3. Puertos abiertos
echo "3. Puertos abiertos:"
ss -tulpn

# 4. Servicios activos
echo "4. Servicios activos:"
systemctl list-units --type=service --state=running

# 5. Últimos logins
echo "5. Últimos logins:"
last -10

# 6. Intentos fallidos
echo "6. Intentos de login fallidos:"
grep "Failed password" /var/log/auth.log | tail -20

# 7. Permisos SUID
echo "7. Archivos con SUID:"
find / -perm -4000 -type f 2>/dev/null

# 8. Espacio en disco
echo "8. Espacio en disco:"
df -h

# 9. Procesos sospechosos
echo "9. Top procesos por CPU:"
ps aux --sort=-%cpu | head -10
```

---

## 🔒 Hardening Checklist

### Host Proxmox
- [ ] Actualizaciones automáticas configuradas
- [ ] SSH hardening aplicado
- [ ] Firewall UFW activo
- [ ] Fail2Ban configurado
- [ ] Auditd monitoreando cambios
- [ ] 2FA habilitado
- [ ] Backups cifrados

### Red
- [ ] Segmentación de red implementada
- [ ] Firewall de Proxmox activo
- [ ] VPN configurada (Tailscale)
- [ ] DNS seguro (AdGuard)
- [ ] Certificados SSL válidos

### Contenedores
- [ ] Contenedores no privilegiados
- [ ] AppArmor/Seccomp activos
- [ ] Escaneo de vulnerabilidades regular
- [ ] Límites de recursos configurados
- [ ] Logs centralizados

### Accesos
- [ ] Usuarios con permisos mínimos
- [ ] Claves SSH únicas por dispositivo
- [ ] Passwords seguros (>16 caracteres)
- [ ] SSO implementado donde sea posible
- [ ] Auditoría de accesos activa

### Monitoreo
- [ ] Alertas de seguridad configuradas
- [ ] Logs monitoreados
- [ ] Backups verificados regularmente
- [ ] Auditorías de seguridad mensuales

---

## 📚 Recursos Adicionales

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Proxmox Security](https://pve.proxmox.com/wiki/Security)

---

## 🔗 Navegación

- [⬅️ Volver a Docker Best Practices](docker-best-practices.md)
- [➡️ Siguiente: Performance Tuning](performance-tuning.md)
- [🏠 Volver al índice](../README.md)
