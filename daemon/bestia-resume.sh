#!/usr/bin/env bash
#
# Hook OPCIONAL de systemd: avisa "despierta" en cuanto el equipo vuelve de
# suspensión, sin esperar al siguiente latido.
#
# Instalación:
#   sudo cp daemon/bestia-resume.sh /usr/lib/systemd/system-sleep/bestia-resume
#   sudo chmod +x /usr/lib/systemd/system-sleep/bestia-resume
#
# systemd llama a este script con dos argumentos: $1 = pre|post, $2 = tipo.
#
NTFY="https://ntfy.sh"
HB_TOPIC="bestiavive-x7h3k9q2z4p"

case "$1" in
  post)   # justo después de despertar
    curl -s -m 10 -d "awake" "$NTFY/$HB_TOPIC" >/dev/null 2>&1
    ;;
esac
