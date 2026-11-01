# Laboratorio: ramas, merge, rebase y conflictos en git

Repositorio del laboratorio de [Lopand Academy](https://academy.lopandsolutions.com/tutoriales/git-ramas-merge-rebase-conflictos).
Un repositorio de práctica con tres ramas que cambian el mismo archivo, para provocar y resolver los dos conflictos
más comunes: uno con `merge` y otro con `rebase`.

## Empieza

**En el navegador, sin instalar nada:** [abrir en GitHub Codespaces](https://codespaces.new/Lopand-Solutions/laboratorio-git-ramas-conflictos).
El repositorio de práctica `mi-proyecto/` se crea solo al abrirlo. También funciona en VS Code con la extensión
Dev Containers.

**En tu computadora:**

```bash
git clone https://github.com/Lopand-Solutions/laboratorio-git-ramas-conflictos.git
cd laboratorio-git-ramas-conflictos
./tool/preparar.sh
cd mi-proyecto
```

`preparar.sh` crea `mi-proyecto/` con `main` y las ramas `cambia-puerto`, `cambia-mensaje` y `nueva-funcion`.
Sigue el tutorial desde el paso 3. Si quieres volver a empezar, borra `mi-proyecto/` y corre `preparar.sh` otra vez.

## Cómo saber si quedó

```bash
../tool/comprobar_laboratorio.sh
```

Revisa que no haya un merge o un rebase a medias, que `main` tenga el commit de merge con el acuerdo del equipo
(puerto 9090 y el mensaje nuevo), y que `nueva-funcion` esté encima de `main` sin commits de merge y con tu mensaje.
Si elegiste el lado de `HEAD` creyendo que era el tuyo, te lo dice.

## Reto: rómpelo y arréglalo

Alguien del equipo hizo commit sin resolver un conflicto y ya lo subió a `main`. Arréglalo sin reescribir la
historia que todos ya tienen:

```bash
./tool/reto.sh
cd reto/mi-copia
# ... arréglalo y haz push ...
cd ../..
./tool/comprobar_reto.sh
```

## Que cuente en tu avance de la Academy

Si tu empresa usa Lopand Academy, copia tu token de laboratorios desde tu cuenta y exporta la variable antes de
comprobar:

```bash
export ACADEMY_TOKEN=tu-token
```

Cuando el laboratorio o el reto quedan completos, el comprobador lo registra en tu avance. Sin la variable no se manda
nada. El comprobador corre en tu máquina: el registro confía en él, como en un examen sin vigilancia.

## Requisitos

git y una terminal con bash (Linux, macOS o Git Bash en Windows).

Código libre para usar y adaptar (licencia MIT).
