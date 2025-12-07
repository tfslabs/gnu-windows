#!/bin/bash

set -euo pipefail
trap 'echo "Error occurred at line ${LINENO} of ${BASH_SOURCE[0]}. Exiting..."; exit 1' ERR

WORKDIR="$(cd "$(dirname "$0")" && pwd)"

if [[ "$WORKDIR" == *" "* ]]; then
        echo "Your directory contains spaces. This is not allowed"
        exit 1
fi

BOOTSTRAP="$WORKDIR/bootstrap"
MAKE_FOLDER="$WORKDIR/make"
TEMP_FOLDER="$WORKDIR/tmp"
GNU_FOLDER="$WORKDIR/.."

cd "$WORKDIR"

# Remove all build resources
rm -rf "$TEMP_FOLDER/" || true
rm -rf "$GNU_FOLDER/binutils" || true
rm -rf "$GNU_FOLDER/busybox-w32" || true
rm -rf "$GNU_FOLDER/cppcheck" || true
rm -rf "$GNU_FOLDER/ctags" || true
rm -rf "$GNU_FOLDER/expat" || true
rm -rf "$GNU_FOLDER/gcc" || true
rm -rf "$GNU_FOLDER/gdb" || true
rm -rf "$GNU_FOLDER/gmp" || true
rm -rf "$GNU_FOLDER/libiconv" || true
rm -rf "$GNU_FOLDER/make" || true
rm -rf "$GNU_FOLDER/mingw-w64" || true
rm -rf "$GNU_FOLDER/mpc" || true
rm -rf "$GNU_FOLDER/mpfr" || true
rm -rf "$GNU_FOLDER/nasm" || true
rm -rf "$GNU_FOLDER/pdcurses" || true
rm -rf "$GNU_FOLDER/vim" || true
rm -rf "$BOOTSTRAP" || true
rm -rf "$MAKE_FOLDER" || true

# Creating bootstrap and make folders
mkdir -p "$BOOTSTRAP"
mkdir -p "$MAKE_FOLDER"

echo "" > "$BOOTSTRAP/.gitkeep"
echo "" > "$MAKE_FOLDER/.gitkeep"
