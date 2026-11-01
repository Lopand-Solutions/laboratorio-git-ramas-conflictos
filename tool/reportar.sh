#!/usr/bin/env bash
# Avisa a Lopand Academy que aprobaste un ejercicio, para que cuente en tu avance (y en el panel de tu empresa).
# Solo corre si tienes ACADEMY_TOKEN (tu token de laboratorios, en tu cuenta de la Academy). Sin token, no hace nada
# y no manda ningún dato. Uso interno: lo llaman los comprobar_*.sh cuando todo sale bien.
set -uo pipefail
laboratorio="$1"; ejercicio="$2"
[ -n "${ACADEMY_TOKEN:-}" ] || exit 0
url="${ACADEMY_URL:-https://academy.lopandsolutions.com}/api/laboratorios/resultado"
if curl --fail-with-body -sS -X POST "$url" \
     -H "Authorization: Bearer $ACADEMY_TOKEN" -H "Content-Type: application/json" \
     -d "{\"laboratorio\":\"$laboratorio\",\"ejercicio\":\"$ejercicio\",\"aprobado\":true}" >/dev/null; then
  echo "Registrado en tu avance de Lopand Academy."
else
  echo "No se pudo registrar en la Academy (el laboratorio sí quedó). Revisa tu ACADEMY_TOKEN." >&2
fi
