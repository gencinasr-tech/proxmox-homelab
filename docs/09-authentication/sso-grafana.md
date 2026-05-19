# SSO en Grafana con Keycloak

Configuración de autenticación OAuth 2.0 / OpenID Connect en Grafana usando Keycloak como Identity Provider.

## 📋 Información

- **Servicio:** Grafana
- **Contenedor:** CT105 (monitoring)
- **URL:** https://grafana.home.arpa
- **Cliente OIDC:** `grafana`
- **Keycloak Realm:** `homelab`

## 🎯 Objetivo

Permitir que los usuarios se autentiquen en Grafana usando sus cuentas de Keycloak (incluyendo Google OAuth), con mapeo automático de roles basado en grupos.

---

## ✅ Prerequisitos

1. ✅ Keycloak configurado y funcionando ([CT113](ct113-keycloak.md))
2. ✅ Cliente OIDC `grafana` creado en Keycloak
3. ✅ Grupos configurados en Keycloak (`homelab-admins`, `homelab-users`)
4. ✅ Archivo `/root/secrets/keycloak-oidc-client-secrets.env` con los secrets

---

## 🔧 Configuración Paso a Paso

### 1. Obtener Credenciales del Cliente

Desde CT113:

```bash
cat /root/secrets/keycloak-oidc-client-secrets.env | grep GRAFANA
```

Deberías ver:

```bash
GRAFANA_CLIENT_ID=grafana
GRAFANA_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Guardar estos valores** para el siguiente paso.

### 2. Configurar Variables de Entorno en Grafana

Acceder a CT105:

```bash
pct enter 105
cd /opt/stacks/monitoring
```

Editar el archivo `docker-compose.yml` y añadir las siguientes variables de entorno en el servicio `grafana`:

```yaml
services:
  grafana:
    image: grafana/grafana:11.4.0
    container_name: grafana
    restart: unless-stopped
    ports:
      - "10.10.10.71:3000:3000"
    environment:
      # Configuración básica
      GF_SERVER_ROOT_URL: "https://grafana.home.arpa"
      GF_SERVER_DOMAIN: "grafana.home.arpa"
      
      # OAuth / OIDC
      GF_AUTH_GENERIC_OAUTH_ENABLED: "true"
      GF_AUTH_GENERIC_OAUTH_NAME: "Keycloak"
      GF_AUTH_GENERIC_OAUTH_ALLOW_SIGN_UP: "true"
      GF_AUTH_GENERIC_OAUTH_CLIENT_ID: "grafana"
      GF_AUTH_GENERIC_OAUTH_CLIENT_SECRET: "TU_CLIENT_SECRET_AQUI"
      GF_AUTH_GENERIC_OAUTH_SCOPES: "openid email profile"
      GF_AUTH_GENERIC_OAUTH_AUTH_URL: "https://auth.home.arpa/realms/homelab/protocol/openid-connect/auth"
      GF_AUTH_GENERIC_OAUTH_TOKEN_URL: "https://auth.home.arpa/realms/homelab/protocol/openid-connect/token"
      GF_AUTH_GENERIC_OAUTH_API_URL: "https://auth.home.arpa/realms/homelab/protocol/openid-connect/userinfo"
      GF_AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_PATH: "contains(groups[*], 'homelab-admins') && 'Admin' || contains(groups[*], 'homelab-users') && 'Editor' || 'Viewer'"
      GF_AUTH_GENERIC_OAUTH_ROLE_ATTRIBUTE_STRICT: "false"
      GF_AUTH_GENERIC_OAUTH_AUTO_LOGIN: "false"
      GF_AUTH_GENERIC_OAUTH_USE_PKCE: "true"
      
      # Permitir asignación automática de organizaciones
      GF_USERS_AUTO_ASSIGN_ORG: "true"
      GF_USERS_AUTO_ASSIGN_ORG_ROLE: "Viewer"
      
      # Seguridad
      GF_SECURITY_ADMIN_USER: "admin"
      GF_SECURITY_ADMIN_PASSWORD: "TU_PASSWORD_ADMIN_LOCAL"
      GF_SECURITY_ALLOW_EMBEDDING: "false"
      
    volumes:
      - /opt/stacks/monitoring/grafana:/var/lib/grafana
    networks:
      - monitoring
```

**IMPORTANTE:** Reemplazar:
- `TU_CLIENT_SECRET_AQUI` con el valor de `GRAFANA_CLIENT_SECRET`
- `TU_PASSWORD_ADMIN_LOCAL` con una contraseña segura para el admin local (backup)

### 3. Reiniciar Grafana

```bash
docker compose up -d grafana
docker logs -f grafana
```

Esperar a que aparezca:

```
logger=settings msg="Starting Grafana" version=11.4.0
logger=server msg="HTTP Server Listen" address=[::]:3000 protocol=http
```

### 4. Verificar Configuración

Acceder a `https://grafana.home.arpa`

Deberías ver:
- Botón de login normal (usuario/contraseña local)
- Botón **"Sign in with Keycloak"**

---

## 🔐 Mapeo de Roles

El mapeo de roles se realiza automáticamente basándose en los grupos de Keycloak:

| Grupo Keycloak | Rol en Grafana | Permisos |
|----------------|----------------|----------|
| `homelab-admins` | **Admin** | Control total, gestión de usuarios, datasources, dashboards |
| `homelab-users` | **Editor** | Crear/editar dashboards, no puede gestionar usuarios |
| Otros | **Viewer** | Solo lectura de dashboards |

La expresión de mapeo es:

```
contains(groups[*], 'homelab-admins') && 'Admin' || contains(groups[*], 'homelab-users') && 'Editor' || 'Viewer'
```

---

## 👥 Gestión de Usuarios

### Primer Login con SSO

1. Acceder a `https://grafana.home.arpa`
2. Click en **"Sign in with Keycloak"**
3. Redirige a Keycloak
4. Login con Google o usuario local de Keycloak
5. Redirige de vuelta a Grafana
6. Usuario creado automáticamente con el rol correspondiente

### Verificar Usuarios

Como administrador:

1. Login en Grafana
2. Ir a **Configuration** → **Users**
3. Ver lista de usuarios con sus roles

### Añadir Usuario a Grupo de Admins

En Keycloak:

1. Acceder a `https://auth.home.arpa/admin/`
2. Cambiar al realm **homelab**
3. Ir a **Users** → Buscar usuario
4. Click en el usuario → **Groups** tab
5. Click **Join Group**
6. Seleccionar `homelab-admins`
7. Click **Join**

**Importante:** El usuario debe hacer logout y login nuevamente en Grafana para que se actualice el rol.

---

## 🔒 Seguridad

### Mantener Admin Local

Siempre mantener el usuario `admin` local activo como backup:

```yaml
GF_SECURITY_ADMIN_USER: "admin"
GF_SECURITY_ADMIN_PASSWORD: "password_seguro"
```

Esto permite acceder si hay problemas con Keycloak.

### Deshabilitar Auto-Login (Recomendado)

```yaml
GF_AUTH_GENERIC_OAUTH_AUTO_LOGIN: "false"
```

Esto permite elegir entre login local o SSO.

### Forzar HTTPS

Grafana debe estar detrás de Nginx Proxy Manager con SSL:

```yaml
GF_SERVER_ROOT_URL: "https://grafana.home.arpa"
```

---

## ✅ Verificación

### Test de Login SSO

1. Abrir navegador en modo incógnito
2. Ir a `https://grafana.home.arpa`
3. Click en **"Sign in with Keycloak"**
4. Login con Google o Keycloak
5. Verificar que redirige correctamente
6. Verificar rol asignado en **Profile** → **Preferences**

### Test de Roles

**Como Admin:**
- Acceder a **Configuration** → **Users** (debe ser visible)
- Crear un dashboard de prueba
- Editar datasources

**Como Editor:**
- Crear/editar dashboards
- No debe ver **Configuration** → **Users**

**Como Viewer:**
- Solo lectura de dashboards
- No puede editar nada

### Logs de Autenticación

```bash
# Ver logs de Grafana
docker logs grafana | grep -i oauth

# Ver logs de Keycloak
pct enter 113
docker logs keycloak | grep grafana
```

---

## 🆘 Troubleshooting

### Error: "Login Failed"

**Causa:** Client Secret incorrecto o expirado.

**Solución:**

1. Verificar el secret en Keycloak:
   ```bash
   pct enter 113
   cat /root/secrets/keycloak-oidc-client-secrets.env | grep GRAFANA
   ```

2. Actualizar en docker-compose.yml
3. Reiniciar Grafana

### Error: "Invalid Redirect URI"

**Causa:** La URI de redirección no está configurada en Keycloak.

**Solución:**

1. Acceder a Keycloak Admin
2. Ir a **Clients** → `grafana`
3. Verificar **Valid redirect URIs**:
   ```
   https://grafana.home.arpa/login/generic_oauth
   ```
4. Guardar

### Usuario no tiene el rol correcto

**Causa:** El usuario no está en el grupo correcto en Keycloak.

**Solución:**

1. Verificar grupos del usuario en Keycloak
2. Añadir al grupo correspondiente
3. Usuario debe hacer logout/login en Grafana

### No aparece botón "Sign in with Keycloak"

**Causa:** OAuth no está habilitado o hay error en la configuración.

**Solución:**

1. Verificar logs:
   ```bash
   docker logs grafana | grep -i oauth
   ```

2. Verificar que `GF_AUTH_GENERIC_OAUTH_ENABLED: "true"`

3. Reiniciar Grafana:
   ```bash
   docker compose restart grafana
   ```

### Error de certificado SSL

**Causa:** Grafana no puede verificar el certificado de Keycloak.

**Solución:**

Si usas certificados autofirmados, añadir en docker-compose.yml:

```yaml
environment:
  GF_AUTH_GENERIC_OAUTH_TLS_SKIP_VERIFY_INSECURE: "true"
```

**Nota:** Solo para entornos de desarrollo/homelab.

---

## 📊 Configuración Avanzada

### Auto-Login Forzado

Para forzar que todos los usuarios usen SSO:

```yaml
GF_AUTH_GENERIC_OAUTH_AUTO_LOGIN: "true"
GF_AUTH_DISABLE_LOGIN_FORM: "true"
```

**Advertencia:** Asegúrate de que el admin local funciona antes de hacer esto.

### Sincronización de Equipos

Para mapear grupos de Keycloak a equipos de Grafana:

```yaml
GF_AUTH_GENERIC_OAUTH_TEAM_IDS: ""
GF_AUTH_GENERIC_OAUTH_ALLOWED_ORGANIZATIONS: ""
```

### Logout Completo

Para que el logout de Grafana también cierre sesión en Keycloak:

```yaml
GF_AUTH_GENERIC_OAUTH_SIGNOUT_REDIRECT_URL: "https://auth.home.arpa/realms/homelab/protocol/openid-connect/logout?redirect_uri=https://grafana.home.arpa"
```

---

## 🔗 Recursos Relacionados

- [CT113 - Keycloak](ct113-keycloak.md)
- [CT105 - Monitoring Stack](../05-management/ct105-monitoring.md)
- [SSO en Homarr](sso-homarr.md)
- [SSO en Immich](sso-immich.md)
- [SSO en Nextcloud](sso-nextcloud.md)

---

## 📚 Referencias

- [Grafana OAuth Documentation](https://grafana.com/docs/grafana/latest/setup-grafana/configure-security/configure-authentication/generic-oauth/)
- [Keycloak OIDC](https://www.keycloak.org/docs/latest/securing_apps/#_oidc)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [🔐 Autenticación](README.md)
