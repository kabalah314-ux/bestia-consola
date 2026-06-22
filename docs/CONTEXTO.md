# 🧠 CONTEXTO DEL PROYECTO — léeme primero

> Este archivo es la **memoria** del proyecto. Cada vez que abramos una sesión
> nueva (desde el ordenador, el móvil o ya desde el MacBook con Linux), leyendo
> esto se recupera **todo el contexto** de lo que hemos hablado y decidido.
> Mantenlo actualizado.

---

## 👤 Quién y qué

- Usuario: Oscar.
- Objetivo general: tiene un **Mac** al que llama **"LA BESTIA"** y quiere poder
  **encenderlo/apagarlo (despertar/dormir) en remoto** desde una consola web.
- La consola ya existe y funciona: es `index.html` (terminal retro verde con un
  dragón animado). Se comunica por **ntfy.sh**.

## 🔥 EL PROBLEMA DEL MAC (el famoso "24%")

El Mac sufre el clásico problema de macOS de **throttling térmico por sensor
defectuoso**:

- Hay un **fallo en la placa base / un sensor de temperatura** que reporta un
  **sobrecalentamiento que NO es real** (un "placebo").
- Al "creer" que se quema, macOS lanza el proceso **`kernel_task`**, que **acapara
  la CPU a propósito** para frenar el procesador real.
- Resultado: el Mac se queda clavado usando solo ~**24% de su capacidad**. Va
  lentísimo aunque el hardware esté bien.
- **Clave:** ese freno lo hace el **software de macOS**, no el hardware.

## 💡 LA SOLUCIÓN ACORDADA: instalar Linux

- **Linux no tiene `kernel_task`** ni reacciona a ese sensor igual. Si el calor es
  falso (sensor roto), Linux **ignora** ese aviso y deja la CPU correr a tope.
- Es un caso típico de "revivir" Macs tullidos por este bug instalando Linux.
- ⚠️ **Precaución de seguridad:** como el fallo es de placa, hay que descartar que
  el calor sea *real*. Tras instalar Linux:
  - Instalar `lm-sensors` + `TLP` y **vigilar temperaturas reales** unos días.
  - Si se mantiene fresco → era sensor falso, resuelto. 🎉
  - Si sube de verdad → limpieza interna + pasta térmica nueva.

## 🧾 DECISIONES TOMADAS (22-jun-2026)

1. **Chip del Mac:** Intel ✅ (camino fácil para Linux).
2. **macOS:** se va a **borrar del todo** (solo Linux)… **PERO primero** hay que
   **respaldar los documentos** a un disco externo para no perder nada.
3. **Distro elegida:** **Linux Mint** (escritorio Cinnamon) — usable de verdad,
   con interfaz gráfica cómoda, no un servidor frío. Basada en Ubuntu LTS, muy
   amigable.
4. **Documentar TODO en GitHub** para poder reabrir esta conversación **desde el
   propio MacBook** una vez instalado Linux, y que Claude tenga el contexto.

## 🗺️ PLAN DE MIGRACIÓN

1. **Respaldo de datos** → `docs/01-RESPALDO-DATOS.md`
2. **Instalar Linux Mint** (borrando macOS) → `docs/02-INSTALAR-LINUX.md`
3. **Daemon de LA BESTIA** en Linux → `docs/03-DAEMON-BESTIA.md`
4. **Verificar** despertar/dormir desde la consola web.

## 📌 DATOS PENDIENTES DE CONFIRMAR

- [ ] **Modelo y año exacto** del Mac (ej. "MacBook Pro 2014"). Sirve para afinar
      compatibilidad de Linux y WiFi/cámara.
- [ ] ¿Tiene puerto **Ethernet** o solo WiFi? (importante para el despertar remoto
      / Wake-on-LAN — ver nota abajo).
- [ ] ¿Hay un **móvil Pixel** que se usaba como relé? (aparece mencionado en el
      código de la consola).

## ⚡ NOTA sobre "despertar" en remoto (importante)

- **Dormir** en remoto es fácil: el daemon recibe la orden por ntfy y suspende.
- **Despertar** un equipo suspendido es más difícil: estando dormido **no puede
  escuchar ntfy**. Se necesita **Wake-on-LAN (WoL)**: otro aparato de la misma red
  (el Pixel, un router, otra Raspberry…) envía un "paquete mágico" que lo despierta.
  - WoL funciona mejor por **cable Ethernet**. Por WiFi (WoWLAN) es más quisquilloso.
  - Esto lo afinaremos en el Paso 3. De momento, lo de dormir + el latido ya deja
    la consola plenamente útil.

---

### 🕓 Registro de sesiones

- **2026-06-22** — Diagnosticado el problema del 24% (kernel_task / sensor).
  Decidido migrar a Linux Mint. Creada toda la documentación y el daemon. Siguiente
  acción: **respaldar datos** (Paso 1).
