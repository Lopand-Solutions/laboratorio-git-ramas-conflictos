#!/usr/bin/env bash
# Revisa que el laboratorio quedó como pide el tutorial. Uso: desde mi-proyecto, ../tool/comprobar_laboratorio.sh
# o ./tool/comprobar_laboratorio.sh mi-proyecto
set -uo pipefail
cd "${1:-.}" || exit 1
fallas=0
bien() { printf '  ✓ %s\n' "$1"; }
mal()  { printf '  ✗ %s\n' "$1"; fallas=$((fallas + 1)); }
esperado_main=$'Puerto: 9090\nMensaje: Bienvenido'
esperado_rama=$'Puerto: 9090\nMensaje: Saludos'

git rev-parse --git-dir >/dev/null 2>&1 || { echo "Aquí no hay un repositorio git. Entra a mi-proyecto."; exit 1; }
gd=$(git rev-parse --git-dir)

echo "Sin operaciones a medias"
if [ -e "$gd/MERGE_HEAD" ]; then mal "Hay un merge sin terminar: resuélvelo y haz commit, o usa git merge --abort"
elif [ -d "$gd/rebase-merge" ] || [ -d "$gd/rebase-apply" ]; then mal "Hay un rebase sin terminar: git rebase --continue o --abort"
else bien "No hay merge ni rebase en curso"; fi

echo "Paso 3 y 4: merge en main"
git merge-base --is-ancestor cambia-puerto main 2>/dev/null && bien "main incluye cambia-puerto" || mal "main todavía no incluye cambia-puerto"
git merge-base --is-ancestor cambia-mensaje main 2>/dev/null && bien "main incluye cambia-mensaje" || mal "main todavía no incluye cambia-mensaje"
padres=$(git rev-list --parents -n 1 main | wc -w)
[ "$padres" -eq 3 ] && bien "El último commit de main es un commit de merge (dos padres)" || mal "El último commit de main no es el commit de merge"
contenido=$(git show main:config.txt 2>/dev/null)
if printf '%s' "$contenido" | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then mal "config.txt en main todavía tiene marcas de conflicto"
elif [ "$contenido" = "$esperado_main" ]; then bien "config.txt en main: puerto 9090 y el mensaje nuevo"
else mal "config.txt en main no quedó como el acuerdo del equipo (Puerto: 9090 / Mensaje: Bienvenido)"; fi

echo "Paso 5: rebase de nueva-funcion"
git merge-base --is-ancestor main nueva-funcion 2>/dev/null && bien "nueva-funcion está encima de main" || mal "nueva-funcion no está encima de main: falta git rebase main"
merges=$(git rev-list --merges main..nueva-funcion 2>/dev/null | wc -l)
[ "$merges" -eq 0 ] && bien "Sin commits de merge en nueva-funcion (historia en línea recta)" || mal "nueva-funcion tiene commits de merge: se integró con merge, no con rebase"
contenido=$(git show nueva-funcion:config.txt 2>/dev/null)
if printf '%s' "$contenido" | grep -qE '^(<<<<<<<|=======|>>>>>>>)'; then mal "config.txt en nueva-funcion todavía tiene marcas de conflicto"
elif [ "$contenido" = "$esperado_rama" ]; then bien "config.txt en nueva-funcion: puerto de main y tu mensaje"
else mal "config.txt en nueva-funcion no quedó bien: ¿elegiste el lado de HEAD creyendo que era el tuyo?"; fi

echo
if [ "$fallas" -eq 0 ]; then echo "Laboratorio completo."; "$(dirname "$0")/reportar.sh" git-ramas-conflictos principal; exit 0; fi
echo "Faltan $fallas punto(s)."; exit 1
