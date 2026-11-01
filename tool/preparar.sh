#!/usr/bin/env bash
# Crea el repositorio de práctica del tutorial «Ramas, merge, rebase y conflictos en git».
# Uso: ./tool/preparar.sh [carpeta]   (por defecto: mi-proyecto)
# Funciona igual en Linux y macOS: no usa sed -i, que cambia entre los dos.
set -euo pipefail
destino="${1:-mi-proyecto}"
if [ -e "$destino" ]; then
  echo "Ya existe '$destino'. Bórralo o elige otro nombre: ./tool/preparar.sh otra-carpeta" >&2
  exit 1
fi
git init -q -b main "$destino"
cd "$destino"
git config user.name "Ana"
git config user.email "ana@tu-dominio.com"

printf 'Puerto: 8080\nMensaje: Hola\n' > config.txt
git add config.txt
git commit -q -m "Configuración inicial"

git switch -q -c cambia-puerto
printf 'Puerto: 9090\nMensaje: Hola\n' > config.txt
git commit -q -am "Puerto 9090"

git switch -q main
git switch -q -c cambia-mensaje
printf 'Puerto: 3000\nMensaje: Bienvenido\n' > config.txt
git commit -q -am "Puerto 3000 y nuevo mensaje"

# nueva-funcion sale del commit inicial, como una rama que empezaste hace días.
git switch -q main
git switch -q -c nueva-funcion
printf 'Puerto: 8080\nMensaje: Saludos\n' > config.txt
git commit -q -am "Mensaje: Saludos"

git switch -q main
echo "Listo: $destino tiene main y tres ramas (cambia-puerto, cambia-mensaje, nueva-funcion)."
echo "Sigue el tutorial desde el paso 3: cd $destino && git merge cambia-puerto"
