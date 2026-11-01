#!/usr/bin/env bash
# Revisa el reto «rómpelo y arréglalo». Uso: ./tool/comprobar_reto.sh [carpeta del reto]   (por defecto: reto)
set -uo pipefail
remoto="${1:-reto}/remoto.git"
[ -d "$remoto" ] || { echo "No encuentro $remoto. Corre primero ./tool/reto.sh"; exit 1; }
fallas=0
bien() { printf '  ✓ %s\n' "$1"; }
mal()  { printf '  ✗ %s\n' "$1"; fallas=$((fallas + 1)); }
esperado=$'Puerto: 9090\nMensaje: Hola\nIdioma: es'
roto=$(git --git-dir="$remoto" rev-list --all --grep="^Merge branch 'cambia-puerto'" | head -1)
contenido=$(git --git-dir="$remoto" show main:config.txt 2>/dev/null)
if printf '%s' "$contenido" | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then mal "main en el remoto todavía tiene marcas de conflicto (¿hiciste push?)"
elif [ "$contenido" = "$esperado" ]; then bien "config.txt en main: Puerto 9090, sin marcas"
else mal "config.txt en main no quedó como se pide (Puerto: 9090, Mensaje: Hola, Idioma: es)"; fi
if [ -n "$roto" ] && git --git-dir="$remoto" merge-base --is-ancestor "$roto" main; then
  bien "La historia compartida sigue intacta: el arreglo es un commit nuevo encima"
else mal "El commit roto ya no está en main: reescribiste historia que el equipo ya tenía (no uses push --force en main)"; fi
echo
if [ "$fallas" -eq 0 ]; then echo "Reto completo."; "$(dirname "$0")/reportar.sh" git-ramas-conflictos reto; exit 0; fi
echo "Faltan $fallas punto(s)."; exit 1
