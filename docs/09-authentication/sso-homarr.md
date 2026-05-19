# SSO en Homarr con Keycloak

Configuración de autenticación OIDC en Homarr usando Keycloak como Identity Provider, con sincronización automática de usuarios y grupos familiares.

## 📋 Información

- **Servicio:** Homarr
- **Contenedor:** CT101 (dashboard)
- **URL:** https://homarr.home.arpa
- **Cliente OIDC:** `homarr`
- **Keycloak Realm:** `homelab`

## 🎯 Objetivo

Permitir que los usuarios se autentiquen en Homarr usando Keycloak (incluyendo Google OAuth), con provisión automática de dashboards personalizados para cada miembro de la familia.

---

## ✅ Prerequisitos

1. ✅ Keycloak configurado y funcionando ([CT113](ct113-keycloak.md))
2. ✅ Cliente OIDC `homarr` creado en Keycloak
3. ✅ Grupos configurados en Keycloak (`homelab-admins`, `familia`)
4. ✅ Archivo `/root/secrets/keycloak-oidc-client-secrets.env` con los secrets

---

## 🔧 Configuración Paso a Paso

### 1. Obtener Credenciales del Cliente

Desde CT113:

```bash
cat /root/secrets/keycloak-oidc-client-secrets.env | grep HOMARR
```

Deberías ver:

```bash
HOMARR_CLIENT_ID=homarr
HOMARR_CLIENT_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Guardar estos valores** para el siguiente paso.

### 2. Configurar Variables de Entorno en Homarr

Acceder a CT101:

```bash
pct enter 101
cd /opt/stacks/dashboard
```

Editar el archivo `docker-compose.yml` y añadir las siguientes variables de entorno en el servicio `homarr`:

```yaml
services:
  homarr:
    image: ghcr.io/ajnart/homarr:latest
    container_name: homarr
    restart: unless-stopped
    ports:
      - "192.168.1.80:7575:7575"
    environment:
      # Configuración básica
      BASE_URL: "https://homarr.home.arpa"
      PORT: "7575"
      
      # OIDC / Keycloak
      AUTH_PROVIDER: "oidc"
      AUTH_OIDC_URI: "https://auth.home.arpa/realms/homelab"
      AUTH_OIDC_CLIENT_ID: "homarr"
      AUTH_OIDC_CLIENT_SECRET: "TU_CLIENT_SECRET_AQUI"
      AUTH_OIDC_CLIENT_NAME: "Keycloak"
      AUTH_OIDC_ADMIN_GROUP: "homelab-admins"
      AUTH_OIDC_OWNER_GROUP: "homelab-admins"
      AUTH_OIDC_AUTO_LOGIN: "false"
      AUTH_OIDC_SCOPE_OVERWRITE: "openid email profile groups"
      
      # Sesiones
      AUTH_SESSION_EXPIRY_TIME: "7d"
      AUTH_SECRET: "TU_SECRET_ALEATORIO_AQUI"
      
      # Timezone
      TZ: "Europe/Madrid"
      
    volumes:
      - /opt/stacks/dashboard/homarr/configs:/app/data/configs
      - /opt/stacks/dashboard/homarr/data:/data
      - /opt/stacks/dashboard/homarr/icons:/app/public/icons
    networks:
      - dashboard
```

**IMPORTANTE:** Reemplazar:
- `TU_CLIENT_SECRET_AQUI` con el valor de `HOMARR_CLIENT_SECRET`
- `TU_SECRET_ALEATORIO_AQUI` con un string aleatorio largo (mínimo 32 caracteres)

Generar el AUTH_SECRET:

```bash
openssl rand -hex 32
```

### 3. Reiniciar Homarr

```bash
docker compose up -d homarr
docker logs -f homarr
```

Esperar a que aparezca:

```
Server listening on port 7575
OIDC provider configured successfully
```

### 4. Verificar Configuración

Acceder a `https://homarr.home.arpa`

Deberías ver:
- Botón **"Sign in with Keycloak"**

---

## 👥 Gestión de Usuarios y Grupos

### Crear Usuarios en Keycloak

Para cada miembro de la familia:

1. Acceder a `https://auth.home.arpa/admin/`
2. Cambiar al realm **homelab**
3. Ir a **Users** → **Add user**
4. Configurar:
   - **Username:** nombre del usuario (ej: `papa`, `mama`, `hijo1`)
   - **Email:** correo del usuario
   - **Email verified:** ON
   - **First name:** Nombre real
   - **Last name:** Apellido
5. Click **Create**

6. Ir a **Credentials** tab
7. Click **Set password**
8. Establecer contraseña
9. **Temporary:** OFF
10. Click **Save**

11. Ir a **Groups** tab
12. Click **Join Group**
13. Seleccionar `familia`
14. Click **Join**

### Primer Login

Cada usuario debe:

1. Acceder a `https://homarr.home.arpa`
2. Click en **"Sign in with Keycloak"**
3. Login con sus credenciales
4. Homarr crea automáticamente su dashboard personal

---

## 🏠 Provisión Automática de Dashboards

### Script de Provisión Familiar

Este script crea automáticamente dashboards personalizados para cada miembro de la familia con widgets adaptados a su edad y necesidades.

```bash
# Desde CT101
mkdir -p /root/scripts

cat > /root/scripts/homarr-family-provisioner.py <<'PYTHON'
#!/usr/bin/env python3
import json, sqlite3, hashlib, secrets
from pathlib import Path
from datetime import datetime

# ---- CONFIGURACIÓN ----
DB_PATH = Path("/opt/stacks/dashboard/homarr/data/db.sqlite")
FAMILY_MEMBERS = [
    {
        "username": "papa",
        "name": "Papá",
        "email": "papa@example.com",
        "role": "owner",
        "widgets": ["calendar", "weather", "media-server", "downloads", "system-monitor", "rss-feed"]
    },
    {
        "username": "mama",
        "name": "Mamá",
        "email": "mama@example.com",
        "role": "owner",
        "widgets": ["calendar", "weather", "media-server", "photos", "notes"]
    },
    {
        "username": "hijo1",
        "name": "Hijo Mayor",
        "email": "hijo1@example.com",
        "role": "user",
        "widgets": ["weather", "media-server", "games", "homework"]
    },
    {
        "username": "hijo2",
        "name": "Hijo Menor",
        "email": "hijo2@example.com",
        "role": "user",
        "widgets": ["weather", "games", "videos"]
    }
]

WIDGET_TEMPLATES = {
    "calendar": {
        "type": "calendar",
        "properties": {"view": "month", "integrations": ["nextcloud"]},
        "position": {"x": 0, "y": 0, "width": 6, "height": 4}
    },
    "weather": {
        "type": "weather",
        "properties": {"location": "Madrid, Spain", "units": "metric"},
        "position": {"x": 6, "y": 0, "width": 3, "height": 2}
    },
    "media-server": {
        "type": "media-server",
        "properties": {"service": "jellyfin", "url": "https://jellyfin.home.arpa"},
        "position": {"x": 0, "y": 4, "width": 4, "height": 3}
    },
    "downloads": {
        "type": "download-speed",
        "properties": {"services": ["qbittorrent", "sabnzbd"]},
        "position": {"x": 4, "y": 4, "width": 3, "height": 2}
    },
    "system-monitor": {
        "type": "system-monitor",
        "properties": {"targets": ["proxmox", "nas"]},
        "position": {"x": 7, "y": 4, "width": 5, "height": 3}
    },
    "photos": {
        "type": "iframe",
        "properties": {"url": "https://immich.home.arpa", "title": "Fotos"},
        "position": {"x": 4, "y": 4, "width": 4, "height": 3}
    },
    "notes": {
        "type": "iframe",
        "properties": {"url": "https://nextcloud.home.arpa/apps/notes", "title": "Notas"},
        "position": {"x": 8, "y": 4, "width": 4, "height": 3}
    },
    "games": {
        "type": "app-grid",
        "properties": {"category": "games"},
        "position": {"x": 0, "y": 4, "width": 6, "height": 3}
    },
    "videos": {
        "type": "iframe",
        "properties": {"url": "https://jellyfin.home.arpa", "title": "Videos"},
        "position": {"x": 0, "y": 4, "width": 8, "height": 4}
    },
    "homework": {
        "type": "iframe",
        "properties": {"url": "https://nextcloud.home.arpa/apps/files", "title": "Tareas"},
        "position": {"x": 6, "y": 4, "width": 6, "height": 3}
    },
    "rss-feed": {
        "type": "rss",
        "properties": {"feeds": ["https://news.ycombinator.com/rss"]},
        "position": {"x": 9, "y": 0, "width": 3, "height": 4}
    }
}

def get_db():
    if not DB_PATH.exists():
        raise FileNotFoundError(f"Database not found: {DB_PATH}")
    return sqlite3.connect(DB_PATH)

def user_exists(conn, username):
    cur = conn.execute("SELECT id FROM user WHERE name = ?", (username,))
    return cur.fetchone() is not None

def create_user(conn, member):
    if user_exists(conn, member["username"]):
        print(f"Usuario ya existe: {member['username']}")
        return
    
    user_id = secrets.token_urlsafe(16)
    password_hash = hashlib.sha256(secrets.token_bytes(32)).hexdigest()
    
    conn.execute("""
        INSERT INTO user (id, name, email, emailVerified, image, password, provider, salt, colorScheme)
        VALUES (?, ?, ?, 1, NULL, ?, 'oidc', NULL, 'dark')
    """, (user_id, member["username"], member["email"], password_hash))
    
    print(f"Usuario creado: {member['username']} ({member['name']})")
    return user_id

def create_board(conn, user_id, member):
    board_id = secrets.token_urlsafe(16)
    board_name = f"Dashboard de {member['name']}"
    
    widgets = []
    for widget_name in member["widgets"]:
        if widget_name in WIDGET_TEMPLATES:
            widget = WIDGET_TEMPLATES[widget_name].copy()
            widget["id"] = secrets.token_urlsafe(8)
            widgets.append(widget)
    
    config = {
        "widgets": widgets,
        "settings": {
            "background": {"type": "solid", "color": "#1a1a1a"},
            "customization": {"layout": "grid", "gridSize": 12}
        }
    }
    
    conn.execute("""
        INSERT INTO board (id, name, isPublic, creatorId, config, createdAt, updatedAt)
        VALUES (?, ?, 0, ?, ?, ?, ?)
    """, (
        board_id,
        board_name,
        user_id,
        json.dumps(config),
        datetime.utcnow().isoformat(),
        datetime.utcnow().isoformat()
    ))
    
    print(f"Dashboard creado para {member['name']}: {len(widgets)} widgets")

def main():
    print("===== HOMARR FAMILY PROVISIONER =====\n")
    
    conn = get_db()
    conn.row_factory = sqlite3.Row
    
    try:
        for member in FAMILY_MEMBERS:
            print(f"\nProcesando: {member['name']} ({member['username']})")
            user_id = create_user(conn, member)
            if user_id:
                create_board(conn, user_id, member)
        
        conn.commit()
        print("\n✅ Provisión completada exitosamente")
        
    except Exception as e:
        conn.rollback()
        print(f"\n❌ Error: {e}")
        raise
    finally:
        conn.close()

if __name__ == "__main__":
    main()
PYTHON

chmod +x /root/scripts/homarr-family-provisioner.py
```

### Ejecutar el Script

**IMPORTANTE:** Ejecutar DESPUÉS de que cada usuario haya hecho login al menos una vez en Homarr.

```bash
# Detener Homarr temporalmente
cd /opt/stacks/dashboard
docker compose stop homarr

# Ejecutar script
python3 /root/scripts/homarr-family-provisioner.py

# Reiniciar Homarr
docker compose start homarr
```

---

## 🔐 Roles y Permisos

### Mapeo de Grupos

| Grupo Keycloak | Rol en Homarr | Permisos |
|----------------|---------------|----------|
| `homelab-admins` | **Owner** | Control total, gestión de usuarios, configuración global |
| `familia` | **User** | Dashboard personal, no puede ver dashboards de otros |
| `invitados` | **Guest** | Solo lectura, dashboards compartidos |

### Configurar Permisos de Dashboard

Como administrador:

1. Login en Homarr
2. Ir a **Settings** → **Users**
3. Para cada usuario:
   - Verificar rol asignado
   - Configurar permisos de dashboard
   - Establecer dashboard por defecto

---

## 🎨 Personalización de Dashboards

### Widgets Disponibles

Homarr soporta múltiples tipos de widgets:

- **Calendar:** Integración con Nextcloud Calendar
- **Weather:** Pronóstico del tiempo
- **Media Server:** Jellyfin/Plex/Emby
- **Download Speed:** Monitoreo de descargas
- **System Monitor:** Estado de servidores
- **RSS Feed:** Noticias y feeds
- **iFrame:** Embeber cualquier servicio web
- **App Grid:** Accesos directos a aplicaciones

### Añadir Widget Manualmente

1. Login en Homarr
2. Click en **Edit Mode** (icono de lápiz)
3. Click en **Add Widget**
4. Seleccionar tipo de widget
5. Configurar propiedades
6. Arrastrar y redimensionar
7. Click en **Save**

---

## ✅ Verificación

### Test de Login SSO

1. Abrir navegador en modo incógnito
2. Ir a `https://homarr.home.arpa`
3. Click en **"Sign in with Keycloak"**
4. Login con usuario de familia
5. Verificar que redirige correctamente
6. Verificar que aparece dashboard personal

### Test de Permisos

**Como Owner (homelab-admins):**
- Acceder a **Settings** → **Users** (debe ser visible)
- Ver todos los dashboards
- Editar configuración global

**Como User (familia):**
- Solo ver su propio dashboard
- No debe ver **Settings** → **Users**
- Puede editar su dashboard personal

### Logs de Autenticación

```bash
# Ver logs de Homarr
docker logs homarr | grep -i oidc

# Ver logs de Keycloak
pct enter 113
docker logs keycloak | grep homarr
```

---

## 🆘 Troubleshooting

### Error: "OIDC Configuration Failed"

**Causa:** Variables de entorno incorrectas o faltantes.

**Solución:**

1. Verificar todas las variables OIDC en docker-compose.yml
2. Verificar que el client secret es correcto:
   ```bash
   pct enter 113
   cat /root/secrets/keycloak-oidc-client-secrets.env | grep HOMARR
   ```
3. Reiniciar Homarr:
   ```bash
   docker compose restart homarr
   ```

### Error: "Invalid Redirect URI"

**Causa:** La URI de redirección no está configurada en Keycloak.

**Solución:**

1. Acceder a Keycloak Admin
2. Ir a **Clients** → `homarr`
3. Verificar **Valid redirect URIs**:
   ```
   https://homarr.home.arpa/api/auth/callback/oidc
   ```
4. Guardar

### Usuario no puede ver su dashboard

**Causa:** El usuario no está en el grupo `familia` en Keycloak.

**Solución:**

1. Acceder a Keycloak Admin
2. Ir a **Users** → Buscar usuario
3. Click en el usuario → **Groups** tab
4. Click **Join Group** → Seleccionar `familia`
5. Usuario debe hacer logout/login en Homarr

### Dashboard vacío después de login

**Causa:** El dashboard no se creó automáticamente.

**Solución:**

1. Ejecutar el script de provisión:
   ```bash
   cd /opt/stacks/dashboard
   docker compose stop homarr
   python3 /root/scripts/homarr-family-provisioner.py
   docker compose start homarr
   ```

2. O crear dashboard manualmente:
   - Login como admin
   - Ir a **Settings** → **Boards**
   - Click **Create Board**
   - Asignar al usuario

### Error: "Session Expired"

**Causa:** El AUTH_SECRET cambió o las sesiones expiraron.

**Solución:**

1. Verificar que `AUTH_SECRET` no ha cambiado
2. Si cambió, todos los usuarios deben hacer login nuevamente
3. Ajustar `AUTH_SESSION_EXPIRY_TIME` si es necesario

---

## 📊 Configuración Avanzada

### Auto-Login Forzado

Para forzar que todos los usuarios usen SSO:

```yaml
AUTH_OIDC_AUTO_LOGIN: "true"
```

### Sincronización de Grupos

Para sincronizar automáticamente grupos de Keycloak:

```yaml
AUTH_OIDC_SYNC_GROUPS: "true"
AUTH_OIDC_GROUP_CLAIM: "groups"
```

### Múltiples Proveedores OIDC

Homarr soporta múltiples proveedores simultáneamente:

```yaml
AUTH_PROVIDER: "oidc,credentials"
```

Esto permite login con Keycloak O con usuario/contraseña local.

---

## 🔗 Recursos Relacionados

- [CT113 - Keycloak](ct113-keycloak.md)
- [CT101 - Dashboard](../05-management/ct101-dashboards.md)
- [SSO en Grafana](sso-grafana.md)
- [SSO en Immich](sso-immich.md)
- [SSO en Nextcloud](sso-nextcloud.md)

---

## 📚 Referencias

- [Homarr Documentation](https://homarr.dev/docs)
- [Homarr OIDC Configuration](https://homarr.dev/docs/authentication/oidc)

**Última actualización**: 2026-05-19

---

[🏠 Volver al índice](../README.md) | [🔐 Autenticación](README.md)
