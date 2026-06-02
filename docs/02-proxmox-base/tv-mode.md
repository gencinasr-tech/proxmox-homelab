# 📺 Modo TV Local en Proxmox

Esta guía documenta la configuración del **modo TV local** del servidor Proxmox.

La idea de este modo es aprovechar que el host físico está conectado por HDMI a una televisión para usarlo como centro multimedia ligero, con control desde el móvil, audio Bluetooth y duplicación de pantalla experimental.

> **Estado:** funcional, pero considerado una excepción controlada dentro del diseño del homelab.
>
> **Importante:** esta configuración se realiza en el host Proxmox porque necesita acceso directo a hardware físico: HDMI, GPU, Bluetooth y WiFi Direct. No sustituye a una Smart TV, Chromecast o Android TV certificado.

---

## 📋 Resumen

| Componente | Estado | Uso |
|-----------|--------|-----|
| XFCE + LightDM | ✅ | Escritorio ligero por HDMI |
| Usuario `tv` | ✅ | Usuario no root para la sesión gráfica |
| Firefox ESR | ✅ | Navegador para YouTube, Netflix, paneles y servicios web |
| KDE Connect | ✅ | Control del escritorio desde el móvil |
| Bluetooth + PipeWire | ✅ | Audio por AirPods/auriculares Bluetooth |
| x11vnc | ✅ | Ver y controlar la TV desde el móvil |
| Firewall VNC | ✅ | Puerto 5900 protegido en LAN/Tailscale e IPv6 bloqueado |
| MiracleCast | ✅ experimental | Duplicar pantalla del móvil por Miracast/WiFi Direct |
| Chromecast real | ❌ | No implementado por limitaciones de protocolo/DRM |
| Android TV real | ❌ | No recomendado dentro del host Proxmox |

---

## 🎯 Objetivo

El objetivo era convertir el servidor Proxmox, conectado por HDMI a la TV, en un modo de uso local parecido a un pequeño centro multimedia:

```text
Servidor Proxmox -> HDMI -> TV
Móvil -> KDE Connect / VNC / Miracast -> Proxmox -> TV
```

Se buscaba poder:

- Encender una sesión gráfica solo cuando hiciera falta.
- Controlar el escritorio desde el móvil.
- Usar Firefox directamente en la TV.
- Enviar audio a la TV por HDMI o a auriculares Bluetooth.
- Duplicar la pantalla del móvil de forma experimental.
- No dejar servicios gráficos o remotos abiertos permanentemente.

---

## ❌ Por qué no se usó Android TV

No se desplegó Android TV dentro de Proxmox por varias razones:

1. **Android TV real necesita certificación y servicios de Google**  
   Una imagen Android genérica no equivale a un Android TV/Google TV certificado. Muchas apps comerciales dependen de certificación, DRM, Widevine, Google Play Services y compatibilidad específica.

2. **Netflix, Prime Video, Disney+ y similares usan DRM**  
   Aunque una imagen Android arrancase en una VM, no garantiza reproducción en alta calidad. Puede haber pantalla negra, baja resolución, errores de DRM o apps directamente no compatibles.

3. **GPU/HDMI/passthrough complica mucho el diseño**  
   Para que Android TV en VM funcionase de forma decente habría que pasar GPU, audio, USB/Bluetooth y salida HDMI. En un homelab pequeño esto añade fragilidad.

4. **No encaja con la filosofía del host Proxmox limpio**  
   Proxmox debe ser el hipervisor. Meter Android TV directamente o forzar una VM multimedia con passthrough puede convertir el host en algo más difícil de mantener.

5. **La solución más estable para streaming protegido sigue siendo un dispositivo certificado**  
   Para Netflix/Prime/Disney en alta calidad, lo correcto es un Chromecast/Google TV, Android TV certificado o Smart TV compatible.

Por eso se eligió una solución más simple y controlada:

```text
Proxmox host + escritorio ligero XFCE + Firefox ESR + control remoto desde móvil
```

---

## ❌ Por qué no es un Chromecast real

Miracast y Chromecast no son lo mismo.

| Tecnología | Cómo funciona | Resultado |
|-----------|---------------|-----------|
| VNC | El móvil ve/controla la pantalla del servidor | Útil para administrar, malo para vídeo |
| Miracast | El móvil duplica su pantalla completa por WiFi Direct | Funciona, pero puede tener retraso |
| Chromecast / Google Cast | La app manda la orden y el receptor reproduce el contenido | Mejor calidad, pero requiere receptor compatible/certificado |

Con Chromecast, normalmente el móvil no envía el vídeo completo. El receptor reproduce el contenido directamente desde Internet. Por eso funciona tan bien con Netflix o YouTube en dispositivos certificados.

Con Miracast, en cambio, se duplica la pantalla completa del móvil. Esto implica más latencia y más carga.

Conclusión:

```text
Miracast sirve para duplicar pantalla.
Chromecast sirve para reproducir contenido desde apps compatibles.
No son equivalentes.
```

---

## ⚠️ Riesgo de hacerlo en el host Proxmox

Sí, hacer esto directamente en el host Proxmox tiene más riesgo que hacerlo en un CT o VM.

La regla general del homelab es:

```text
El host Proxmox debe estar lo más limpio posible.
Los servicios deben ir en CTs o VMs.
```

Por eso servicios como Tailscale, dashboards, DNS, monitoring, Vaultwarden, Paperless, Nextcloud, Immich o Navidrome están separados en CTs/VMs.

En este caso se hizo una excepción porque el modo TV necesita acceso directo a hardware físico:

- HDMI real del servidor.
- Sesión gráfica local.
- Audio del host.
- Bluetooth local.
- Adaptador WiFi USB con WiFi Direct/P2P.
- Pantalla `:0` del host.

Un CT normal no gestiona bien este caso sin hacerlo privilegiado y pasarle dispositivos del host, lo cual también aumenta el riesgo. Una VM con passthrough sería más limpia conceptualmente, pero bastante más compleja.

### Decisión tomada

Se acepta como **excepción controlada**, no como patrón general.

Medidas aplicadas:

- Usuario dedicado `tv`, sin usar Firefox como root.
- LightDM desactivado por defecto; se arranca solo con `tv-on`.
- VNC apagado por defecto; se arranca solo con `tv-vnc-on`.
- VNC con contraseña.
- VNC limitado por firewall a LAN/Tailscale.
- IPv6 bloqueado para VNC.
- Miracast apagado por defecto; se arranca solo con `tv-miracast-on`.
- MiracleCast se usa solo con el USB WiFi dedicado.
- No se abre ningún puerto en el router.

---

## 🖥️ Modo escritorio local

### Componentes instalados

- `xserver-xorg`
- `lightdm`
- `xfce4`
- `xfce4-terminal`
- `xfce4-panel`
- `xfdesktop4`
- `xfwm4`
- `thunar`
- `dbus-x11`
- `dbus-user-session`
- `firefox-esr`

### Usuario dedicado

Se creó un usuario dedicado para el modo TV:

```bash
useradd -m -s /bin/bash tv
usermod -aG audio,video,render,input,plugdev tv
```

Si existe el grupo Bluetooth:

```bash
getent group bluetooth >/dev/null && usermod -aG bluetooth tv
```

### Sesión gráfica

Archivo del usuario `tv`:

```bash
cat > /home/tv/.xsession <<'EOF'
#!/bin/sh
exec startxfce4
EOF

chmod +x /home/tv/.xsession
chown tv:tv /home/tv/.xsession
```

### LightDM con autologin

```bash
mkdir -p /etc/lightdm/lightdm.conf.d

cat > /etc/lightdm/lightdm.conf.d/50-tv-autologin.conf <<'EOF'
[Seat:*]
autologin-user=tv
autologin-user-timeout=0
user-session=xfce
EOF
```

LightDM queda desactivado al arranque:

```bash
systemctl disable lightdm
```

---

## 🧰 Comandos principales

### Encender modo TV

```bash
cat > /usr/local/bin/tv-on <<'EOF'
#!/usr/bin/env bash
systemctl start lightdm
EOF

chmod +x /usr/local/bin/tv-on
```

### Apagar modo TV

```bash
cat > /usr/local/bin/tv-off <<'EOF'
#!/usr/bin/env bash
systemctl stop lightdm
EOF

chmod +x /usr/local/bin/tv-off
```

Uso normal:

```bash
tv-on
```

Para apagar la sesión gráfica:

```bash
tv-off
```

---

## 🎛️ Panel de XFCE

Se dejó un panel sencillo, parecido a un escritorio clásico:

```text
[Aplicaciones] [Ventanas abiertas] [Separador] [Systray] [Volumen] [Reloj]
```

También se dejó un único workspace para evitar confusión con el selector de escritorios.

Objetivo:

- Que sea fácil de usar desde la TV.
- Que se vean las ventanas abiertas.
- Que aparezcan iconos de KDE Connect, Bluetooth, Proton VPN, volumen, etc.
- Evitar paneles duplicados o elementos raros.

---

## 🌐 DNS local en el host

Para que Firefox en el modo TV resuelva dominios internos `.home.arpa`, el host usa el DNS local del homelab:

```text
search home.arpa
nameserver 192.168.1.53
nameserver 1.1.1.1
```

Archivo:

```bash
/etc/resolv.conf
```

> Nota: en Proxmox este archivo puede ser regenerado por la configuración de red. Si se pierde tras reinicio, conviene hacerlo persistente desde la configuración de red del host.

---

## 📱 Control desde el móvil con KDE Connect

Se instaló KDE Connect para usar el móvil como:

- Ratón táctil.
- Teclado remoto.
- Control multimedia básico.
- Mando rápido para Firefox y el escritorio.

Paquete principal:

```bash
apt install -y kdeconnect
```

Autostart recomendado en el usuario `tv`:

```bash
mkdir -p /home/tv/.config/autostart

cat > /home/tv/.config/autostart/kdeconnect-autostart.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=KDE Connect Autostart
Comment=Arranca KDE Connect al iniciar la sesión TV
Exec=sh -c 'sleep 5; kdeconnect-cli --refresh >/dev/null 2>&1; command -v kdeconnect-indicator >/dev/null 2>&1 && kdeconnect-indicator'
Terminal=false
X-GNOME-Autostart-enabled=true
EOF

chown -R tv:tv /home/tv/.config
```

---

## 🔊 Audio Bluetooth y HDMI

### Paquetes usados

```bash
apt install -y \
  bluetooth bluez blueman \
  pipewire pipewire-pulse wireplumber libspa-0.2-bluetooth \
  pavucontrol pulseaudio-utils rfkill
```

Servicio Bluetooth:

```bash
systemctl enable --now bluetooth
rfkill unblock bluetooth
```

### Audio por AirPods / Bluetooth

Se configuró un comando `tv-audio-airpods` para conectar los auriculares y seleccionar el perfil de música `a2dp-sink`.

> En la documentación pública se usa `<AIRPODS_MAC>` como placeholder. En el host real se sustituye por la MAC real del dispositivo.

```bash
cat > /usr/local/bin/tv-audio-airpods <<'EOF'
#!/usr/bin/env bash
MAC="<AIRPODS_MAC>"
UIDTV=$(id -u tv)

rfkill unblock bluetooth 2>/dev/null || true
bluetoothctl power on >/dev/null 2>&1 || true
bluetoothctl trust "$MAC" >/dev/null 2>&1 || true
bluetoothctl connect "$MAC" >/dev/null 2>&1 || true
sleep 3

runuser -u tv -- env XDG_RUNTIME_DIR=/run/user/$UIDTV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UIDTV/bus bash -lc '
pactl set-card-profile bluez_card."${MAC//:/_}" a2dp-sink 2>/dev/null || true
AIR=$(pactl list short sinks | awk "/bluez_output/ {print \$2; exit}")

if [ -z "$AIR" ]; then
  echo "No aparece salida Bluetooth en PipeWire."
  pactl list short sinks
  exit 1
fi

pactl set-default-sink "$AIR"
pactl set-sink-mute "$AIR" 0
pactl set-sink-volume "$AIR" 90%

for ID in $(pactl list short sink-inputs | awk "{print \$1}"); do
  pactl move-sink-input "$ID" "$AIR" || true
done

echo "Audio Bluetooth activo: $AIR"
'
EOF

chmod +x /usr/local/bin/tv-audio-airpods
```

### Audio por HDMI

```bash
cat > /usr/local/bin/tv-audio-hdmi <<'EOF'
#!/usr/bin/env bash
UIDTV=$(id -u tv)

runuser -u tv -- env XDG_RUNTIME_DIR=/run/user/$UIDTV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UIDTV/bus bash -lc '
HDMI=$(pactl list short sinks | awk "/hdmi|HDMI|Raven|05_00.1/ {print \$2; exit}")

if [ -z "$HDMI" ]; then
  echo "No encuentro salida HDMI. Sinks disponibles:"
  pactl list short sinks
  exit 1
fi

pactl set-default-sink "$HDMI"
pactl set-sink-mute "$HDMI" 0
pactl set-sink-volume "$HDMI" 90%

for ID in $(pactl list short sink-inputs | awk "{print \$1}"); do
  pactl move-sink-input "$ID" "$HDMI" || true
done

echo "Audio cambiado a HDMI/TV: $HDMI"
pactl info | grep "Default Sink"
'
EOF

chmod +x /usr/local/bin/tv-audio-hdmi
```

Uso:

```bash
tv-audio-airpods
# o
tv-audio-hdmi
```

---

## 🕹️ VNC para ver/controlar la TV desde el móvil

Se instaló `x11vnc` para ver y controlar desde el móvil la sesión real que se muestra por HDMI.

Esto no sirve para ver vídeo fluido. Sirve para:

- Administrar la sesión desde el móvil.
- Abrir/cerrar Firefox.
- Escribir URLs.
- Usar el móvil como control remoto avanzado.

### Contraseña VNC

La contraseña VNC tiene límite práctico de 8 caracteres.

```bash
install -d -o tv -g tv /home/tv/.vnc
runuser -u tv -- x11vnc -storepasswd /home/tv/.vnc/passwd
chmod 600 /home/tv/.vnc/passwd
chown tv:tv /home/tv/.vnc/passwd
```

### Seguridad aplicada

- VNC no arranca solo.
- Se activa manualmente con `tv-vnc-on`.
- Escucha en `192.168.1.200:5900`.
- Solo se permite LAN `192.168.1.0/24` y rango Tailscale `100.64.0.0/10`.
- Se bloquea IPv6 para el puerto VNC.
- No se debe abrir el puerto 5900 en el router.

### Comandos finales

```text
tv-vnc-on      -> activa VNC + firewall
tv-vnc-off     -> apaga VNC
tv-vnc-status  -> comprueba proceso, puerto, firewall y logs
```

Conexión desde el móvil:

```text
192.168.1.200:5900
```

---

## 📡 Miracast experimental

Se probó Miracast para duplicar la pantalla del móvil en la TV:

```text
Móvil -> WiFi Direct / Miracast -> Proxmox -> HDMI -> TV
```

### Adaptador usado

Se usó un adaptador USB WiFi Atheros AR9271.

La interfaz real puede variar. En este caso se detectó como:

```text
<WIFI_USB_IFACE>
```

En el host real se sustituyó por el nombre real de la interfaz.

### Comprobación P2P

```bash
IFACE="<WIFI_USB_IFACE>"
PHY="phy$(iw dev "$IFACE" info | awk '/wiphy/ {print $2}')"

echo "Interfaz: $IFACE"
echo "PHY: $PHY"

iw phy "$PHY" info | sed -n "/Supported interface modes:/,/Band /p" | grep -E "managed|AP|monitor|P2P-client|P2P-GO|P2P-device|IBSS"
```

Resultado esperado:

```text
* P2P-client
* P2P-GO
```

Sin P2P, Miracast no es viable.

### MiracleCast

Como no estaba disponible como paquete apt, se compiló MiracleCast desde código fuente.

Binarios instalados:

```text
/usr/local/bin/miracle-wifid
/usr/local/bin/miracle-sinkctl
/usr/local/bin/miracle-wifictl
```

### Prueba manual realizada

```bash
miracle-wifid --interface "<WIFI_USB_IFACE>" > /tmp/miracle-wifid.log 2>&1 &
DISPLAY=:0 XAUTHORITY=/home/tv/.Xauthority miracle-sinkctl
```

Dentro de `miracle-sinkctl`:

```text
run <LINK_ID>
```

Resultado obtenido:

```text
[CONNECT] Peer: ...
NOTICE: SINK connected
SINK set resolution 1920x1080
```

Esto confirma que Miracast llegó a conectar.

### Limitaciones

- Puede ir con retraso.
- No es Chromecast.
- No garantiza Netflix/Prime/Disney en alta calidad.
- Algunas apps pueden bloquear captura por DRM.
- Es una función experimental y bajo demanda.

---

## 🧰 Comandos Miracast finales

Se crearon comandos limpios:

```text
tv-miracast-on      -> activa receptor Miracast
tv-miracast-off     -> apaga MiracleCast y limpia el USB
tv-miracast-status  -> ver estado, logs y conexión
```

Se usa `tmux` para dejar `miracle-sinkctl` corriendo en segundo plano.

El flujo normal es:

```bash
tv-on
tv-miracast-on
```

Después, desde Android:

```text
Smart View / Enviar pantalla / Wireless Display / Duplicar pantalla
```

Para apagar:

```bash
tv-miracast-off
```

---

## ✅ Comandos finales del modo TV

```text
tv-on                 -> enciende escritorio TV por HDMI
tv-off                -> apaga escritorio TV

tv-audio-airpods      -> audio a auriculares Bluetooth
tv-audio-hdmi         -> audio a la TV/HDMI
tv-hdmi-reload        -> recargar HDMI si se queda sin señal

tv-vnc-on             -> ver/controlar TV desde el móvil
tv-vnc-off            -> apagar VNC
tv-vnc-status         -> comprobar VNC + firewall

tv-miracast-on        -> activar receptor Miracast experimental
tv-miracast-off       -> apagar Miracast y limpiar USB
tv-miracast-status    -> ver estado/logs de Miracast
```

---

## 🧪 Uso recomendado

### Ver Netflix, YouTube o páginas web

Recomendado:

```bash
tv-on
tv-audio-hdmi
```

Después abrir Firefox directamente en la TV y controlar con KDE Connect.

### Usar AirPods o auriculares Bluetooth

```bash
tv-on
tv-audio-airpods
```

### Controlar la TV desde el móvil

```bash
tv-vnc-on
```

Al terminar:

```bash
tv-vnc-off
```

### Duplicar pantalla del móvil

```bash
tv-miracast-on
```

Al terminar:

```bash
tv-miracast-off
```

---

## 🔐 Reglas de seguridad

1. No abrir `5900/tcp` en el router.
2. No dejar VNC activo permanentemente.
3. No dejar Miracast activo permanentemente.
4. No navegar como root.
5. No instalar extensiones raras en Firefox.
6. No convertir el host Proxmox en un PC de uso diario.
7. Documentar todos los cambios hechos en `/usr/local/bin`.
8. Mantener backups de configuración del host.
9. Si algo falla, apagar primero VNC/Miracast y revisar logs.

---

## 🧯 Rollback rápido

Para apagar todo lo relacionado con modo TV:

```bash
tv-vnc-off 2>/dev/null || true
tv-miracast-off 2>/dev/null || true
tv-off 2>/dev/null || true
```

Para comprobar procesos:

```bash
pgrep -a x11vnc || true
pgrep -a miracle-wifid || true
pgrep -a miracle-sinkctl || true
pgrep -a lightdm || true
```

Para revisar scripts creados:

```bash
ls -lh /usr/local/bin/tv-*
```

---

## 🧠 Conclusión

Este modo TV funciona, pero debe entenderse como una **función local auxiliar** del homelab, no como un servicio principal.

La forma más estable de usarlo es:

```text
Firefox en la TV + KDE Connect como mando + audio HDMI/Bluetooth
```

VNC queda para control remoto desde el móvil.

Miracast queda como función experimental para duplicar pantalla.

Para streaming comercial en alta calidad con DRM, la opción correcta sigue siendo un dispositivo certificado tipo Chromecast/Google TV/Android TV real o Smart TV compatible.

La configuración en el host Proxmox es aceptable en este caso porque depende de hardware físico local, pero no debe convertirse en la norma para desplegar servicios. El patrón principal del proyecto sigue siendo:

```text
Servicios normales -> CTs/VMs
Hardware local directo -> excepción controlada en host
```
