#!/usr/bin/env bash
# Reto «rómpelo y arréglalo»: crea un repositorio donde alguien ya subió a main un archivo con marcas de conflicto.
# Uso: ./tool/reto.sh [carpeta]   (por defecto: reto)
set -euo pipefail
destino="${1:-reto}"
if [ -e "$destino" ]; then echo "Ya existe '$destino'. Bórralo o elige otro nombre." >&2; exit 1; fi
mkdir -p "$destino"; cd "$destino"
git init -q --bare -b main remoto.git           # hace de GitHub o GitLab: lo que ya está compartido
git clone -q remoto.git equipo 2>/dev/null
cd equipo
git config user.name "Beto"; git config user.email "beto@tu-dominio.com"
printf 'Puerto: 8080\nMensaje: Hola\nIdioma: es\n' > config.txt
git add config.txt; git commit -q -m "Configuración inicial"
git switch -q -c cambia-puerto
printf 'Puerto: 9090\nMensaje: Hola\nIdioma: es\n' > config.txt; git commit -q -am "Puerto 9090"
git switch -q main
printf 'Puerto: 3000\nMensaje: Hola\nIdioma: es\n' > config.txt; git commit -q -am "Puerto 3000"
git merge -q cambia-puerto >/dev/null 2>&1 || true
# El error del reto: Beto hizo commit sin resolver el conflicto y lo subió.
git add config.txt; git commit -q --no-edit
git push -q origin main 2>/dev/null
cd ..
git clone -q remoto.git mi-copia 2>/dev/null
cd mi-copia; git config user.name "Ana"; git config user.email "ana@tu-dominio.com"
echo "Listo. Entra a $destino/mi-copia: main ya está en el remoto con marcas de conflicto en config.txt."
echo "Arréglalo para que quede Puerto: 9090, sin reescribir la historia que ya está compartida, y súbelo."
