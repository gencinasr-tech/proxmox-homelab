# SSO en Immich con Keycloak

Configuración de autenticación OAuth 2.0 en Immich usando Keycloak como Identity Provider, con solución para certificados autofirmados.

## 📋 Información

- **Servicio:** Immich
- **Contenedor:** VM109
- **URL:** https://immich.home.arpa
- **Cliente OIDC:** `immich`
- **Keycloak Realm:** `homelab`

## 🎯 Objetivo

Permitir que los usuarios se autentiquen en Immich usando Keycloak (incluyendo Google OAuth), con gestión automática de álbumes y permisos basados en grupos.

---

## ✅ Prerequisitos

1. ✅ Keycloak configurado y funcionando ([CT113](ct113-keycloak.md))
2. ✅ Cliente OIDC `immich` creado en Keycloak
3. ✅ Grupos configurados en Keycloak (`homelab-admins`, `familia`)
4. ✅ Archivo `/root/secrets/keycloak-oidc-client-secrets.env` con los secrets
5. ✅ Immich instalado y funcionando

---

## 🔧 Configuración Paso a Paso

### 1. Obtener Credenciales del Cliente

Desde CT113:

```bash
cat /root/secrets/keycloak-oidc-client-secrets.env | grep IMMICH
```

Deberías ver:

```bash
IMMICH_CLIENT_ID=immich
IMMICH_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Guardar estos valores** para el siguiente paso.

### 2. Configurar DNS en la VM

**IMPORTANTE:** Immich necesita resolver `auth.home.arpa` correctamente.

Acceder a VM109:

```bash
# Desde Proxmox host
qm enter 109

# Verificar resolución DNS
nslookup auth.home.arpa
```

Si no resuelve, editar `/etc/resolv.conf`:

```bash
nano /etc/resolv.conf
```

Añadir:

```
nameserver 192.168.1.53
nameserver 1.1.1.1
```

Verificar:

```bash
ping -c 3 auth.home.arpa
```

### 3. Solución para Certificados Autofirmados

Immich usa Node.js que por defecto rechaza certificados autofirmados. Hay dos soluciones:

#### Opción A: Deshabilitar Verificación SSL (Solo Homelab)

Editar el docker-compose.yml de Immich:

```yaml
services:
  immich-server:
    image: ghcr.io/immich-app/immich-server:release
    container_name: immich-server
    environment:
      # ... otras variables ...
      
      # Deshabilitar verificación SSL para certificados autofirmados
      NODE_TLS_REJECT_UNAUTHORIZED: "0"
```

**Advertencia:** Solo usar en entornos de homelab con certificados locales.

#### Opción B: Instalar Certificado CA (Recomendado)

Si tienes un certificado CA local:

```bash
# Copiar certificado CA al contenedor
docker cp /path/to/ca.crt immich-server:/usr/local/share/ca-certificates/
docker exec immich-server update-ca-certificates
docker restart immich-server
```

### 4. Configurar OAuth en Immich

Acceder a la interfaz web de Immich: `https://immich.home.arpa`

1. Login como administrador
2. Ir a **Administration** (icono de engranaje)
3. Ir a **Settings** → **OAuth Authentication**
4. Configurar:

**Enabled:** ✅ ON

**Issuer URL:**
```
https://auth.home.arpa/realms/homelab
```

**Client ID:**
```
immich
```

**Client Secret:**
```
[pegar el IMMICH_CLIENT_SECRET]
```

**Scope:**
```
openid email profile
```

**Button Text:**
```
Login with Keycloak
```

**Auto Register:** ✅ ON (permite crear usuarios automáticamente)

**Auto Launch:** ❌ OFF (permite elegir entre login local o SSO)

**Mobile Redirect URI Override:**
```
app.immich:///oauth-callback
```

5. Click **Save**

### 5. Verificar Configuración

1. Hacer logout de Immich
2. En la pantalla de login, debería aparecer el botón **"Login with Keycloak"**
3. Click en el botón
4. Redirige a Keycloak
5. Login con Google o usuario local
6. Redirige de vuelta a Immich
7. Usuario creado automáticamente

---

## 👥 Gestión de Usuarios

### Roles en Immich

Immich tiene dos roles principales:

| Rol | Permisos |
|-----|----------|
| **Admin** | Control total, gestión de usuarios, configuración del servidor |
| **User** | Subir fotos, crear álbumes, compartir con otros usuarios |

### Promover Usuario a Admin

1. Login como admin en Immich
2. Ir a **Administration** → **Users**
3. Click en el usuario
4. Toggle **Admin** → ON
5. Click **Save**

### Mapeo de Grupos (Manual)

Immich no soporta mapeo automático de grupos desde OIDC, por lo que los roles deben asignarse manualmente después del primer login.

**Recomendación:** Promover a admin solo a usuarios del grupo `homelab-admins` de Keycloak.

---

## 📱 Configuración de App Móvil

### Android / iOS

1. Instalar la app Immich desde:
   - [Google Play Store](https://play.google.com/store/apps/details?id=app.alextran.immich)
   - [Apple App Store](https://apps.apple.com/app/immich/id1613945652)

2. Abrir la app
3. **Server URL:** `https://immich.home.arpa`
4. Click **Login**
5. Seleccionar **"Login with Keycloak"**
6. Login con Google o Keycloak
7. Autorizar la app

**Nota:** La app móvil debe estar conectada a la red local o a Tailscale para acceder al servidor.

### Backup Automático

Configurar en la app:

1. Ir a **Settings** → **Backup**
2. **Enable Backup:** ON
3. **Select Albums:** Elegir álbumes a respaldar
4. **Backup over WiFi only:** ON (recomendado)
5. **Background Backup:** ON

---

## 🔒 Seguridad y Privacidad

### Álbumes Compartidos

Los usuarios pueden compartir álbumes entre sí:

1. Crear un álbum
2. Click en **Share**
3. Seleccionar usuarios con los que compartir
4. Establecer permisos (ver/editar)

### Álbumes Públicos

Los administradores pueden crear enlaces públicos:

1. Abrir un álbum
2. Click en **Share** → **Create Public Link**
3. Configurar:
   - **Allow Download:** ON/OFF
   - **Show Metadata:** ON/OFF
   - **Expiration Date:** Opcional
4. Copiar enlace

**Advertencia:** Los enlaces públicos son accesibles sin autenticación.

### Cuotas de Almacenamiento

Los administradores pueden establecer cuotas por usuario:

1. Ir a **Administration** → **Users**
2. Click en el usuario
3. **Storage Quota:** Establecer límite en GB
4. Click **Save**

---

## ✅ Verificación

### Test de Login SSO

1. Abrir navegador en modo incógnito
2. Ir a `https://immich.home.arpa`
3. Click en **"Login with Keycloak"**
4. Login con Google o Keycloak
5. Verificar que redirige correctamente
6. Verificar que el usuario se creó automáticamente

### Test de Subida de Fotos

1. Login en Immich
2. Click en **Upload**
3. Seleccionar fotos
4. Verificar que se suben correctamente
5. Verificar que aparecen en la galería

### Test de App Móvil

1. Abrir app Immich
2. Login con SSO
3. Verificar que se conecta al servidor
4. Subir una foto de prueba
5. Verificar que aparece en la web

### Logs de Autenticación

```bash
# Ver logs de Immich
docker logs immich-server | grep -i oauth

# Ver logs de Keycloak
pct enter 113
docker logs keycloak | grep immich
```

---

## 🆘 Troubleshooting

### Error: "Unable to connect to OAuth provider"

**Causa:** Immich no puede resolver o conectar con Keycloak.

**Solución:**

1. Verificar DNS en la VM:
   ```bash
   qm enter 109
   nslookup auth.home.arpa
   ping auth.home.arpa
   ```

2. Si no resuelve, añadir DNS en docker-compose.yml:
   ```yaml
   services:
     immich-server:
       dns:
         - 192.168.1.53
         - 1.1.1.1
   ```

3. Reiniciar Immich:
   ```bash
   docker compose restart immich-server
   ```

### Error: "certificate verify failed"

**Causa:** Node.js rechaza el certificado autofirmado.

**Solución:**

Añadir en docker-compose.yml:

```yaml
services:
  immich-server:
    environment:
      NODE_TLS_REJECT_UNAUTHORIZED: "0"
```

Reiniciar:

```bash
docker compose up -d immich-server
```

### Error: "Invalid Redirect URI"

**Causa:** La URI de redirección no está configurada en Keycloak.

**Solución:**

1. Acceder a Keycloak Admin
2. Ir a **Clients** → `immich`
3. Verificar **Valid redirect URIs**:
   ```
   https://immich.home.arpa/auth/login
   https://immich.home.arpa/user-settings
   app.immich:///oauth-callback
   ```
4. Guardar

### Usuario no puede subir fotos

**Causa:** Permisos de almacenamiento o cuota excedida.

**Solución:**

1. Verificar cuota del usuario:
   - **Administration** → **Users** → Click en usuario
   - Verificar **Storage Quota**

2. Verificar permisos de volumen:
   ```bash
   ls -la /opt/stacks/immich/upload
   chown -R 1000:1000 /opt/stacks/immich/upload
   ```

3. Verificar espacio en disco:
   ```bash
   df -h
   ```

### App móvil no se conecta

**Causa:** La app no puede acceder al servidor.

**Solución:**

1. Verificar que el dispositivo está en la red local o conectado a Tailscale

2. Verificar que el servidor es accesible:
   ```bash
   curl -k -I https://immich.home.arpa
   ```

3. Verificar que el puerto está abierto en el firewall

4. Probar con la IP directa en lugar del dominio

### Error: "OAuth state mismatch"

**Causa:** Problema con las cookies o sesiones.

**Solución:**

1. Limpiar cookies del navegador
2. Intentar en modo incógnito
3. Verificar que `BASE_URL` en docker-compose.yml es correcto:
   ```yaml
   IMMICH_SERVER_URL: "https://immich.home.arpa"
   ```

---

## 📊 Configuración Avanzada

### Auto-Launch OAuth

Para forzar que todos los usuarios usen SSO:

En la configuración de OAuth en Immich:
- **Auto Launch:** ✅ ON

Esto redirige automáticamente a Keycloak sin mostrar la pantalla de login.

### Deshabilitar Registro Local

Para permitir solo login vía SSO:

1. Ir a **Administration** → **Settings** → **User Settings**
2. **Allow New User Registration:** ❌ OFF

Esto evita que se creen usuarios locales.

### Sincronización de Metadatos

Immich puede extraer metadatos de las fotos:

1. Ir a **Administration** → **Settings** → **Machine Learning**
2. Configurar:
   - **Facial Recognition:** ON
   - **Object Detection:** ON
   - **CLIP Encoding:** ON

**Nota:** Requiere recursos adicionales (CPU/GPU).

### Backup de Base de Datos

Configurar backup automático de PostgreSQL:

```bash
# Crear script de backup
cat > /root/scripts/backup-immich-db.sh <<'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups/immich"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

docker exec immich-postgres pg_dumpall -U postgres > $BACKUP_DIR/immich-db-$DATE.sql

# Mantener solo los últimos 7 backups
find $BACKUP_DIR -name "immich-db-*.sql" -mtime +7 -delete

echo "Backup completado: immich-db-$DATE.sql"
EOF

chmod +x /root/scripts/backup-immich-db.sh

# Añadir a crontab (diario a las 3 AM)
(crontab -l 2>/dev/null; echo "0 3 * * * /root/scripts/backup-immich-db.sh") | crontab -
```

---

## 🔗 Recursos Relacionados

- [CT113 - Keycloak](ct113-keycloak.md)
- [VM109 - Immich](../07-productivity/vm109-immich.md)
- [SSO en Grafana](sso-grafana.md)
- [SSO en Homarr](sso-homarr.md)
- [SSO en Nextcloud](sso-nextcloud.md)

---

## 📚 Referencias

- [Immich Documentation](https://immich.app/docs)
- [Immich OAuth Configuration](https://immich.app/docs/administration/oauth)
- [Immich Mobile App](https://immich.app/docs/install/mobile)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [🔐 Autenticación](README.md)
