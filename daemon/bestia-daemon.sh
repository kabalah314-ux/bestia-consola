#!/usr/bin/env bash
#
# 🐉 Daemon de LA BESTIA — para Linux
#
# Qué hace:
#   1) Publica un "latido" periódico en ntfy con el estado (awake) para que la
#      consola web sepa que el Mac está despierto.
#   2) Escucha la orden de DORMIR por ntfy y suspende el equipo.
#   3) Escucha la orden de DESPERTAR (sólo útil estando ya despierto; el despertar
#      desde suspensión real necesita Wake-on-LAN, ver docs/03-DAEMON-BESTIA.md).
#
# Requisitos: curl y jq   ->   sudo apt install -y curl jq
#
set -uo pipefail

# ── Configuración (deben coincidir con index.html) ───────────────────────────
NTFY="https://ntfy.sh"
WAKE_TOPIC="wakemac-x7h3k9q2z4p"     # orden de despertar
SLEEP_TOPIC="sleepmac-q4w8r2t6y9k3"  # orden de dormir
HB_TOPIC="bestiavive-x7h3k9q2z4p"    # latido (estado)

HEARTBEAT_SECS=60                    # cada cuánto se publica "awake"
                                     # (la consola considera "desconocido" a >180s)

# ── Utilidades ───────────────────────────────────────────────────────────────
log(){ echo "[$(date '+%F %T')] $*"; }
beat(){ curl -s -m 10 -d "$1" "$NTFY/$HB_TOPIC" >/dev/null 2>&1; }

# ── Latido en segundo plano ──────────────────────────────────────────────────
heartbeat_loop(){
  while true; do
    beat "awake"
    sleep "$HEARTBEAT_SECS"
  done
}

# Avisa "despierta" al arrancar (también cubre el arranque tras reiniciar).
beat "awake"
log "Daemon iniciado. Latido cada ${HEARTBEAT_SECS}s."

heartbeat_loop &
HB_PID=$!
trap 'kill "$HB_PID" 2>/dev/null' EXIT

# ── Bucle principal: escucha órdenes por ntfy ────────────────────────────────
# Se suscribe a los dos topics a la vez (separados por coma). Si el stream se
# corta (red, suspensión), el while exterior reconecta.
while true; do
  curl -s -N -m 0 "$NTFY/$WAKE_TOPIC,$SLEEP_TOPIC/json" \
  | while IFS= read -r line; do
      [ -z "$line" ] && continue
      event=$(printf '%s' "$line" | jq -r '.event // empty' 2>/dev/null)
      [ "$event" = "message" ] || continue
      topic=$(printf '%s' "$line" | jq -r '.topic // empty' 2>/dev/null)

      case "$topic" in
        "$SLEEP_TOPIC")
          log "Orden recibida: DORMIR."
          beat "asleep"          # avisa a la consola antes de suspender
          sleep 2
          systemctl suspend
          ;;
        "$WAKE_TOPIC")
          log "Orden recibida: DESPERTAR (ya estaba despierta)."
          beat "awake"
          ;;
      esac
    done

  log "Stream de ntfy cortado; reconectando en 3s..."
  sleep 3
done
