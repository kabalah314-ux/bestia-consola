# 🐧 Paso 2 — Instalar Linux Mint en el Mac (Intel)

> **OBJETIVO:** borrar macOS e instalar **Linux Mint** (escritorio Cinnamon),
> dejando el Mac usable de verdad y, de paso, **libre del freno del 24%**.
>
> ⚠️ **Haz primero el [Paso 1 — Respaldo](01-RESPALDO-DATOS.md).** La instalación
> **borra todo** el disco del Mac.

---

## ¿Por qué Linux Mint?

- Basada en **Ubuntu LTS** → mucho soporte y guías.
- Escritorio **Cinnamon**: cómodo y familiar (parecido a Windows/macOS), **usable
  a diario**, no un servidor pelado.
- Va **ligero** en Macs Intel y suele esquivar el `kernel_task` que te frenaba.

---

## 🧰 Lo que necesitas

- Un **pendrive USB de 8 GB o más** (se borrará: úsalo vacío).
- Otro ordenador (o el propio Mac antes de borrarlo) para **crear el USB de arranque**.
- El portátil enchufado a la corriente durante todo el proceso. 🔌

---

## A) Descargar Linux Mint

1. Ve a la web oficial: **https://linuxmint.com/download.php**
2. Descarga la edición **Cinnamon** (archivo `.iso`, ~2-3 GB).

## B) Crear el USB de arranque

La forma más sencilla y multiplataforma es con **balenaEtcher**:

1. Descarga **balenaEtcher**: https://etcher.balena.io
2. Ábrelo → **Flash from file** → elige la `.iso` de Mint.
3. **Select target** → elige tu **pendrive** (¡cuidado de no elegir otro disco!).
4. **Flash!** y espera a que termine.

## C) Arrancar el Mac desde el USB

1. Conecta el USB al Mac.
2. **Apaga** el Mac del todo.
3. Enciéndelo y **mantén pulsada la tecla `⌥ Option (Alt)`** nada más pulsar encendido.
4. Aparece el **selector de arranque**. Elige el USB (suele salir como **"EFI Boot"**,
   icono naranja/amarillo).
5. En el menú de Mint, elige **"Start Linux Mint"**. Cargará un escritorio de prueba
   (aún no instala nada).

> 🔐 **Si no aparece el USB** o no arranca, puede ser por la seguridad de macOS.
> Avísame: en algunos Mac hay que ajustar la **Utilidad de Seguridad de Arranque**
> (permitir arranque desde medios externos). Te guío según tu modelo.

## D) Probar antes de instalar (recomendado)

En el escritorio de prueba, comprueba que funcionan:

- [ ] **WiFi** (icono de red abajo a la derecha).
- [ ] **Teclado y trackpad**.
- [ ] **Sonido** y **pantalla** se ven bien.

> Si el WiFi no va en la prueba, no pasa nada grave: a veces necesita un driver que
> se instala después. Anótalo y me lo dices.

## E) Instalar (esto borra macOS)

1. Doble clic en **"Install Linux Mint"**.
2. Idioma: **Español**. Teclado: el tuyo (prueba la `ñ`).
3. Marca **"Instalar codecs multimedia"** (para vídeo/audio).
4. Tipo de instalación: **"Borrar disco e instalar Linux Mint"**
   ⚠️ esto elimina macOS por completo (ya tienes el respaldo).
5. Zona horaria, usuario y **contraseña** (apúntala bien).
6. Instalar y esperar. Al terminar: **reiniciar** y **quitar el USB** cuando lo pida.

## F) Primer arranque

1. Inicia sesión con tu usuario/contraseña.
2. Conéctate al **WiFi**.
3. Abre el **Gestor de Actualizaciones** y aplica todo lo que ofrezca.

---

## 🌡️ MUY IMPORTANTE tras instalar — vigilar temperatura

Como el origen es un fallo de placa, confirmamos que el calor era falso:

```bash
sudo apt update
sudo apt install -y lm-sensors tlp
sudo sensors-detect --auto      # pulsa Enter a todo
sensors                          # muestra las temperaturas reales
```

- Usa el Mac un rato (navega, abre cosas) y vuelve a mirar `sensors`.
- Temperaturas en reposo ~40-55 °C y bajo carga por debajo de ~85-90 °C = **normal**.
- Si se dispara muy alto enseguida → el calor podría ser real: tocaría limpieza +
  pasta térmica. **Mándame los números de `sensors` y lo valoramos.**

`tlp` (ya instalado) ayuda con el consumo y la temperatura. Para activarlo:

```bash
sudo systemctl enable --now tlp
```

---

✅ Cuando tengas Linux Mint funcionando y actualizado, pasa al
**[Paso 3 — Daemon de LA BESTIA](03-DAEMON-BESTIA.md)** para que la consola web
vuelva a controlarlo.

> 🎉 **Truco:** desde Linux ya puedes abrir esta misma conversación / este repo en
> GitHub y seguir guiándote con todo el contexto.
