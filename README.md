# 🐉 LA BESTIA · Consola remota

Proyecto para controlar un Mac ("LA BESTIA") de forma remota: **despertarlo** y
**dormirlo** desde una consola web retro (estilo terminal CRT verde), usando el
canal de mensajería **[ntfy.sh](https://ntfy.sh)**.

> **¿Vienes a retomar el contexto?** Empieza por **[`docs/CONTEXTO.md`](docs/CONTEXTO.md)**.
> Ahí está resumido TODO lo que hemos hablado y decidido, para no perder el hilo
> entre sesiones.

---

## 📂 Qué hay en este repo

| Archivo | Para qué sirve |
|---|---|
| [`index.html`](index.html) | La **consola web** (el dragón animado, botones ON/OFF, comprobar estado). |
| [`docs/CONTEXTO.md`](docs/CONTEXTO.md) | 🧠 **Memoria del proyecto**: el problema del Mac, las decisiones, el plan. **Léelo primero.** |
| [`docs/01-RESPALDO-DATOS.md`](docs/01-RESPALDO-DATOS.md) | 💾 Paso 1: copiar tus documentos a un disco externo antes de borrar nada. |
| [`docs/02-INSTALAR-LINUX.md`](docs/02-INSTALAR-LINUX.md) | 🐧 Paso 2: instalar Linux Mint en el Mac Intel (borrando macOS). |
| [`docs/03-DAEMON-BESTIA.md`](docs/03-DAEMON-BESTIA.md) | ⚙️ Paso 3: dejar el daemon corriendo para que la consola siga controlando el Mac. |
| [`daemon/bestia-daemon.sh`](daemon/bestia-daemon.sh) | El script que escucha ntfy (dormir) y manda el latido (estado). |
| [`daemon/bestia.service`](daemon/bestia.service) | Servicio `systemd` para que el daemon arranque solo. |
| [`daemon/bestia-resume.sh`](daemon/bestia-resume.sh) | Hook opcional: avisa "despierta" justo al volver de suspensión. |

---

## 🔌 Cómo funciona (resumen técnico)

```
 [ Consola web ]  ──POST "wake"/"sleep"──►  ntfy.sh  ──►  [ Daemon en el Mac ]
        ▲                                                        │
        └──────────  lee el "latido" (awake/asleep)  ◄──────────┘
```

**Topics de ntfy** (definidos en `index.html`):

- `wakemac-x7h3k9q2z4p` → orden de **despertar**
- `sleepmac-q4w8r2t6y9k3` → orden de **dormir**
- `bestiavive-x7h3k9q2z4p` → **latido** (el Mac publica `awake` / `asleep`)

---

## ✅ Plan de migración (estado actual)

- [ ] **Paso 1 — Respaldo** de documentos a disco externo · [guía](docs/01-RESPALDO-DATOS.md)
- [ ] **Paso 2 — Instalar Linux Mint** (borrando macOS) · [guía](docs/02-INSTALAR-LINUX.md)
- [ ] **Paso 3 — Daemon de LA BESTIA** corriendo en Linux · [guía](docs/03-DAEMON-BESTIA.md)
- [ ] **Paso 4 — Verificar** despertar/dormir desde la consola web

Vamos paso a paso, sin prisa. 🐢
