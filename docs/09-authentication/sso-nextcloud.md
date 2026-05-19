# SSO en Nextcloud con Keycloak

Configuración de autenticación OpenID Connect en Nextcloud usando Keycloak como Identity Provider, con sincronización automática de usuarios y grupos.

## 📋 Información

- **Servicio:** Nextcloud
- **Contenedor:** CT108
- **URL:** https://nextcloud.home.arpa
- **Cliente OIDC:** `nextcloud`
- **Keycloak Realm:** `homelab`

## 🎯 Objetivo

Permitir que los usuarios se autentiquen en Nextcloud usando Keycloak (incluyendo Google OAuth), con provisión automática de usuarios y sincronización de grupos.

---

## ✅ Prerequisitos

1. ✅ Keycloak configurado y funcionando ([CT113](ct113-keycloak.md))
2. ✅ Cliente OIDC `nextcloud` creado en Keycloak
3. ✅ Grupos configurados en Keycloak (`homelab-admins`, `familia`)
4. ✅ Archivo `/root/secrets/keycloak-oidc-client-secrets.env` con los secrets
5. ✅ Nextcloud instalado y funcionando

---

## 🔧 Configuración Paso a Paso

### 1. Obtener Credenciales del Cliente

Desde CT113:

```bash
cat /root/secrets/keycloak-oidc-client-secrets.env | grep NEXTCLOUD
```

Deberías ver:

```bash
NEXTCLOUD_CLIENT_ID=nextcloud
NEXTCLOUD_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Guardar estos valores** para el siguiente paso.

### 2. Instalar App user_oidc en Nextcloud

Acceder a la interfaz web de Nextcloud: `https://nextcloud.home.arpa`

1. Login como administrador
2. Click en el avatar (esquina superior derecha) → **Apps**
3. En el menú lateral, click en **Security**
4. Buscar **"OpenID Connect user backend"** (user_oidc)
5. Click en **Download and enable**

Alternativamente, desde línea de comandos:

```bash
pct enter 108
docker exec -u www-data nextcloud php occ app:install user_oidc
docker exec -u www-data nextcloud php occ app:enable user_oidc
```

### 3. Configurar Trusted Domains

Nextcloud necesita confiar en el dominio de Keycloak:

```bash
pct enter 108

# Añadir auth.home.arpa como dominio confiable
docker exec -u www-data nextcloud php occ config:system:set trusted_domains 2 --value="auth.home.arpa"

# Verificar
docker exec -u www-data nextcloud php occ config:system:get trusted_domains
```

### 4. Configurar Proxy Settings

Si Nextcloud está detrás de Nginx Proxy Manager:

```bash
# Configurar proxy
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value="https"
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value="nextcloud.home.arpa"
docker exec -u www-data nextcloud php occ config:system:set overwrite.cli.url --value="https://nextcloud.home.arpa"

# Confiar en el proxy
docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value="192.168.1.82"
```

### 5. Configurar OpenID Connect Provider

Desde la interfaz web:

1. Ir a **Settings** → **Administration** → **OpenID Connect**
2. Click en **Add provider**
3. Configurar:

**Identifier:**
```
keycloak
```

**Display name:**
```
Keycloak
```

**Client ID:**
```
nextcloud
```

**Client secret:**
```
[pegar el NEXTCLOUD_CLIENT_SECRET]
```

**Discovery endpoint:**
```
https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
```

**Scope:**
```
openid email profile groups
```

**Groups claim:**
```
groups
```

**Use unique user ID:** ✅ ON

**Check Bearer token on API and WebDAV requests:** ✅ ON

4. Click **Save**

### 6. Configurar Mapeo de Atributos

En la misma página de configuración:

**Attribute mappings:**

| Nextcloud Attribute | OIDC Claim |
|---------------------|------------|
| User ID | `preferred_username` |
| Display name | `name` |
| Email | `email` |
| Quota | (dejar vacío) |
| Groups | `groups` |

**Group provisioning:**
- **Provisioning mode:** ✅ Auto-provision groups
- **Group prefix:** (dejar vacío)

5. Click **Save**

### 7. Configurar Botón de Login

```bash
pct enter 108

# Establecer el proveedor como predeterminado
docker exec -u www-data nextcloud php occ config:app:set user_oidc provider-1-loginButtonName --value="Login with Keycloak"

# Permitir auto-provisión de usuarios
docker exec -u www-data nextcloud php occ config:app:set user_oidc auto_provision --value="1"

# Habilitar modo de login único
docker exec -u www-data nextcloud php occ config:app:set user_oidc single_logout --value="1"
```

### 8. Verificar Configuración

1. Hacer logout de Nextcloud
2. En la pantalla de login, debería aparecer el botón **"Login with Keycloak"**
3. Click en el botón
4. Redirige a Keycloak
5. Login con Google o usuario local
6. Redirige de vuelta a Nextcloud
7. Usuario creado automáticamente

---

## 👥 Gestión de Usuarios y Grupos

### Sincronización Automática

Cuando un usuario hace login por primera vez:
- Se crea automáticamente en Nextcloud
- Se sincronizan sus grupos desde Keycloak
- Se asigna cuota por defecto

### Mapeo de Grupos

Los grupos de Keycloak se sincronizan automáticamente:

| Grupo Keycloak | Grupo Nextcloud | Permisos |
|----------------|-----------------|----------|
| `homelab-admins` | `homelab-admins` | Administradores de Nextcloud |
| `familia` | `familia` | Usuarios normales con cuota estándar |
| `invitados` | `invitados` | Usuarios con cuota limitada |

### Promover Usuario a Admin

**Opción 1: Desde la interfaz web**

1. Login como admin en Nextcloud
2. Ir a **Settings** → **Users**
3. Buscar el usuario
4. En la columna **Groups**, añadir al grupo `admin`

**Opción 2: Desde línea de comandos**

```bash
pct enter 108
docker exec -u www-data nextcloud php occ group:adduser admin username
```

### Establecer Cuotas por Grupo

```bash
pct enter 108

# Cuota para familia: 100GB
docker exec -u www-data nextcloud php occ user:setting --group familia files quota "100 GB"

# Cuota para invitados: 10GB
docker exec -u www-data nextcloud php occ user:setting --group invitados files quota "10 GB"

# Sin límite para admins
docker exec -u www-data nextcloud php occ user:setting --group homelab-admins files quota "none"
```

---

## 📱 Configuración de Clientes

### App Móvil (Android/iOS)

1. Instalar Nextcloud desde:
   - [Google Play Store](https://play.google.com/store/apps/details?id=com.nextcloud.client)
   - [Apple App Store](https://apps.apple.com/app/nextcloud/id1125420102)

2. Abrir la app
3. **Server address:** `https://nextcloud.home.arpa`
4. Click **Login**
5. Seleccionar **"Login with Keycloak"**
6. Login con Google o Keycloak
7. Autorizar la app

### Desktop Client (Windows/Mac/Linux)

1. Descargar desde [nextcloud.com/install](https://nextcloud.com/install/#install-clients)
2. Instalar y abrir
3. **Server address:** `https://nextcloud.home.arpa`
4. Click **Next**
5. Se abre el navegador
6. Login con Keycloak
7. Autorizar el cliente
8. Configurar carpetas a sincronizar

### WebDAV

Para acceder vía WebDAV con SSO:

**URL:**
```
https://nextcloud.home.arpa/remote.php/dav/files/USERNAME/
```

**Autenticación:**
- Usar un **App Password** generado en Nextcloud
- Ir a **Settings** → **Security** → **Devices & sessions**
- Click en **Create new app password**
- Usar ese password en lugar de la contraseña de Keycloak

---

## 🔒 Seguridad

### Mantener Admin Local

Siempre mantener el usuario admin local activo como backup:

```bash
# Verificar que el admin local existe
docker exec -u www-data nextcloud php occ user:list

# Si no existe, crear uno
docker exec -u www-data nextcloud php occ user:add admin --password-from-env
```

### Deshabilitar Registro Local

Para permitir solo login vía SSO:

1. Ir a **Settings** → **Administration** → **Basic settings**
2. **Allow users to register:** ❌ OFF

### Forzar 2FA para Admins

```bash
pct enter 108

# Forzar 2FA para el grupo admin
docker exec -u www-data nextcloud php occ config:app:set twofactor_totp enforced_groups --value='["admin"]'
```

### Auditoría de Accesos

Habilitar el log de auditoría:

```bash
# Instalar app de auditoría
docker exec -u www-data nextcloud php occ app:install admin_audit
docker exec -u www-data nextcloud php occ app:enable admin_audit

# Configurar log
docker exec -u www-data nextcloud php occ config:app:set admin_audit logfile --value="/var/www/html/data/audit.log"
```

---

## ✅ Verificación

### Test de Login SSO

1. Abrir navegador en modo incógnito
2. Ir a `https://nextcloud.home.arpa`
3. Click en **"Login with Keycloak"**
4. Login con Google o Keycloak
5. Verificar que redirige correctamente
6. Verificar que el usuario se creó automáticamente

### Test de Sincronización de Grupos

1. Login en Nextcloud con un usuario nuevo
2. Ir a **Settings** → **Personal info**
3. Verificar que los grupos de Keycloak aparecen en Nextcloud

### Test de Clientes

**Desktop:**
1. Configurar cliente de escritorio
2. Verificar que sincroniza archivos
3. Crear un archivo de prueba
4. Verificar que aparece en la web

**Móvil:**
1. Configurar app móvil
2. Subir una foto
3. Verificar que aparece en la web

### Logs de Autenticación

```bash
# Ver logs de Nextcloud
pct enter 108
docker logs nextcloud | grep -i oidc

# Ver logs de Keycloak
pct enter 113
docker logs keycloak | grep nextcloud

# Ver log de auditoría
docker exec nextcloud cat /var/www/html/data/audit.log
```

---

## 🆘 Troubleshooting

### Error: "OpenID Connect login failed"

**Causa:** Configuración incorrecta del proveedor OIDC.

**Solución:**

1. Verificar el discovery endpoint:
   ```bash
   curl -k https://auth.home.arpa/realms/homelab/.well-known/openid-configuration
   ```

2. Verificar que el client secret es correcto en Nextcloud

3. Verificar logs:
   ```bash
   docker logs nextcloud | grep -i oidc
   ```

### Error: "Invalid Redirect URI"

**Causa:** La URI de redirección no está configurada en Keycloak.

**Solución:**

1. Acceder a Keycloak Admin
2. Ir a **Clients** → `nextcloud`
3. Verificar **Valid redirect URIs**:
   ```
   https://nextcloud.home.arpa/*
   ```
4. Guardar

### Usuario no puede acceder a archivos compartidos

**Causa:** Permisos de grupo incorrectos.

**Solución:**

1. Verificar que el usuario está en el grupo correcto:
   ```bash
   docker exec -u www-data nextcloud php occ user:info username
   ```

2. Añadir al grupo si es necesario:
   ```bash
   docker exec -u www-data nextcloud php occ group:adduser familia username
   ```

### Error: "This site can't be reached"

**Causa:** Problema de DNS o proxy.

**Solución:**

1. Verificar DNS:
   ```bash
   nslookup nextcloud.home.arpa
   nslookup auth.home.arpa
   ```

2. Verificar trusted domains:
   ```bash
   docker exec -u www-data nextcloud php occ config:system:get trusted_domains
   ```

3. Añadir si falta:
   ```bash
   docker exec -u www-data nextcloud php occ config:system:set trusted_domains 3 --value="auth.home.arpa"
   ```

### Cliente de escritorio no sincroniza

**Causa:** Problema de autenticación o certificado.

**Solución:**

1. Generar App Password en Nextcloud:
   - **Settings** → **Security** → **Create new app password**

2. Usar ese password en el cliente en lugar de SSO

3. Si el problema persiste, verificar certificado SSL

### Error: "CSRF check failed"

**Causa:** Problema con trusted domains o proxy.

**Solución:**

```bash
pct enter 108

# Verificar y corregir configuración de proxy
docker exec -u www-data nextcloud php occ config:system:set overwriteprotocol --value="https"
docker exec -u www-data nextcloud php occ config:system:set overwritehost --value="nextcloud.home.arpa"
docker exec -u www-data nextcloud php occ config:system:set trusted_proxies 0 --value="192.168.1.82"

# Reiniciar Nextcloud
docker restart nextcloud
```

---

## 📊 Configuración Avanzada

### Auto-Login Forzado

Para forzar que todos los usuarios usen SSO:

```bash
pct enter 108

# Ocultar formulario de login local
docker exec -u www-data nextcloud php occ config:app:set user_oidc hide_login_form --value="1"

# Redirigir automáticamente a Keycloak
docker exec -u www-data nextcloud php occ config:app:set user_oidc auto_redirect --value="1"
```

**Advertencia:** Asegúrate de que el admin local funciona antes de hacer esto.

### Sincronización de Avatar

Para sincronizar el avatar desde Keycloak:

```bash
# Habilitar sincronización de avatar
docker exec -u www-data nextcloud php occ config:app:set user_oidc use_picture_claim --value="1"
```

### Logout Completo

Para que el logout de Nextcloud también cierre sesión en Keycloak:

```bash
docker exec -u www-data nextcloud php occ config:app:set user_oidc single_logout --value="1"
```

### Backup Automático

Configurar backup de Nextcloud:

```bash
# Crear script de backup
cat > /root/scripts/backup-nextcloud.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/nextcloud"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Activar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --on

# Backup de base de datos
docker exec nextcloud-db pg_dump -U nextcloud nextcloud > $BACKUP_DIR/nextcloud-db-$DATE.sql

# Backup de archivos (solo config y data)
tar -czf $BACKUP_DIR/nextcloud-data-$DATE.tar.gz -C /opt/stacks/nextcloud config data

# Desactivar modo mantenimiento
docker exec -u www-data nextcloud php occ maintenance:mode --off

# Mantener solo los últimos 7 backups
find $BACKUP_DIR -name "nextcloud-*" -mtime +7 -delete

echo "Backup completado: $DATE"
EOF

chmod +x /root/scripts/backup-nextcloud.sh

# Añadir a crontab (diario a las 2 AM)
(crontab -l 2>/dev/null; echo "0 2 * * * /root/scripts/backup-nextcloud.sh") | crontab -
```

---

## 🔗 Recursos Relacionados

- [CT113 - Keycloak](ct113-keycloak.md)
- [CT108 - Nextcloud](../07-productivity/ct108-nextcloud.md)
- [SSO en Grafana](sso-grafana.md)
- [SSO en Homarr](sso-homarr.md)
- [SSO en Immich](sso-immich.md)

---

## 📚 Referencias

- [Nextcloud Documentation](https://docs.nextcloud.com/)
- [Nextcloud OIDC App](https://github.com/nextcloud/user_oidc)
- [Nextcloud Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [🔐 Autenticación](README.md)
