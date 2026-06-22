# ⚙️ Paso 3 — Daemon de LA BESTIA en Linux

> **OBJETIVO:** dejar el Mac (ya con Linux) escuchando ntfy para que la **consola
> web** pueda **dormirlo** en remoto y ver su **estado** (latido). Y dejar
> preparado el **despertar** (Wake-on-LAN).

---

## 1) Instalar dependencias

```bash
sudo apt update
sudo apt install -y curl jq
```

## 2) Copiar el daemon al sistema

Desde la carpeta del repo (clónalo o descárgalo en el Mac con Linux):

```bash
# clona el repo (o cópialo desde un USB)
git clone https://github.com/kabalah314-ux/bestia-consola.git
cd bestia-consola

# instala el script del daemon
sudo cp daemon/bestia-daemon.sh /usr/local/bin/bestia-daemon.sh
sudo chmod +x /usr/local/bin/bestia-daemon.sh

# instala el servicio systemd
sudo cp daemon/bestia.service /etc/systemd/system/bestia.service
```

## 3) Arrancar el servicio

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now bestia.service
```

Comprobar que va bien:

```bash
systemctl status bestia.service     # debe decir 'active (running)'
journalctl -u bestia.service -f     # ver los logs en vivo (Ctrl+C para salir)
```

## 4) Probar desde la consola web

1. Abre `index.html` (la consola) en el móvil o el navegador.
2. Pulsa **🔍 COMPROBAR ESTADO** → debería detectar **DESPIERTA**.
3. Pulsa **[ OFF ]** → el Mac debería **suspenderse** en unos segundos y la consola
   marcar **DORMIDA**.

✅ Con esto, **dormir** y **ver estado** ya funcionan.

---

## 5) Despertar en remoto (Wake-on-LAN) — opcional pero recomendado

Estando suspendido, el Mac **no puede escuchar ntfy**, así que para despertarlo hace
falta **Wake-on-LAN (WoL)**: otro aparato de la misma red (un móvil, el router, una
Raspberry…) le envía un "paquete mágico".

> WoL funciona **mucho mejor por cable Ethernet**. Por WiFi (WoWLAN) muchas tarjetas
> no lo soportan bien. Si el Mac no tiene Ethernet, lo valoramos aparte.

### a) Activar WoL en la tarjeta de red

Averigua el nombre de tu interfaz de red:

```bash
ip link            # busca algo como 'enp0s1' (cable) o 'wlp...' (wifi)
```

Comprueba si soporta WoL (mira la línea `Supports Wake-on:` que incluya `g`):

```bash
sudo apt install -y ethtool
sudo ethtool <interfaz> | grep -i wake
```

Actívalo:

```bash
sudo ethtool -s <interfaz> wol g
```

Para que se mantenga tras reiniciar, déjalo como servicio:

```bash
sudo tee /etc/systemd/system/wol.service >/dev/null <<'EOF'
[Unit]
Description=Activar Wake-on-LAN
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/ethtool -s INTERFAZ wol g

[Install]
WantedBy=multi-user.target
EOF
# sustituye INTERFAZ por la tuya antes de habilitar:
sudo sed -i 's/INTERFAZ/<interfaz>/' /etc/systemd/system/wol.service
sudo systemctl enable wol.service
```

### b) Apunta la MAC del Mac

```bash
ip link show <interfaz>    # la MAC es el 'link/ether xx:xx:xx:xx:xx:xx'
```

Apúntala; la necesita quien envíe el paquete mágico.

### c) Enviar el paquete mágico desde otro aparato

- **Desde un móvil Android (el Pixel):** instala una app tipo *"Wake On Lan"* y
  configúrala con la **MAC** del Mac. Un botón = despertar.
- **Desde otro Linux en la misma red:** `wakeonlan xx:xx:xx:xx:xx:xx`
- **Avanzado (que la consola web también despierte):** se puede poner ese aparato
  (Pixel/router/Raspberry) a escuchar el topic `wakemac-...` y que, al recibirlo,
  lance el paquete mágico. Esto lo montamos cuando lleguemos aquí.

### d) Hook opcional: avisar "despierta" al instante al volver de suspensión

```bash
sudo cp daemon/bestia-resume.sh /usr/lib/systemd/system-sleep/bestia-resume
sudo chmod +x /usr/lib/systemd/system-sleep/bestia-resume
```

---

## 🛠️ Comandos útiles

```bash
sudo systemctl restart bestia.service    # reiniciar el daemon
sudo systemctl stop bestia.service       # pararlo
journalctl -u bestia.service -n 50       # últimos 50 logs
```

## ❓ Si algo no va

- La consola no detecta estado → revisa `journalctl -u bestia.service -f` y que haya
  internet. Recuerda que ntfy a veces da **429** (saturación): espera unos minutos.
- No suspende al pulsar OFF → prueba a mano `systemctl suspend`. Si falla, dímelo.

Cuando llegues a este punto, avísame y rematamos el despertar remoto según tu red. 🐉
