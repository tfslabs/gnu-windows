#/bin/bash

# Global Failure handler
set -euo pipefail
trap 'echo "Error occurred at line ${LINENO} of ${BASH_SOURCE[0]}. Exiting..."; exit 1' ERR

# Arch build for Windows
ARCH=x86_64-w64-mingw32
VERSION=1.1.1

# Versioning
BINUTILS_VERSION=2.42
BUSYBOX_VERSION=FRP-5467-g9376eebd8
CPPCHECK_VERSION=2.10
CTAGS_VERSION=6.0.0
EXPAT_VERSION=R_2_6_2
GCC_VERSION=14.2.0
GDB_VERSION=15.1
GMP_VERSION=6.3.0
LIBICONV_VERSION=1.17
MAKE_VERSION=4.4.1
MINGW_VERSION=12.0.0
MPC_VERSION=1.3.1
MPFR_VERSION=4.2.1
NASM_VERSION=2.15.05rc2
PDCURSES_VERSION=3.9
VIM_VERSION=9.0.0000

# Working directories
WORKDIR="$(cd "$(dirname "$0")" && pwd)"
GNU_FOLDER="$WORKDIR/.."
TEMP_FOLDER="$WORKDIR/tmp"

# Validation
if [[ "$WORKDIR" == *" "* ]]; then
    echo "Your directory contains spaces. This is not allowed"
    exit 1
fi

if [[ "$(which tar)" == "" || "$(which wget)" == "" ]]; then
    echo "Required packages are not installed (tar and wget)."
    exit 1
fi

# Preparing download resources
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

# Create folders
mkdir -p "$TEMP_FOLDER"
mkdir -p "$GNU_FOLDER/binutils"
mkdir -p "$GNU_FOLDER/busybox-w32"
mkdir -p "$GNU_FOLDER/cppcheck"
mkdir -p "$GNU_FOLDER/ctags"
mkdir -p "$GNU_FOLDER/expat"
mkdir -p "$GNU_FOLDER/gcc"
mkdir -p "$GNU_FOLDER/gdb"
mkdir -p "$GNU_FOLDER/gmp"
mkdir -p "$GNU_FOLDER/libiconv"
mkdir -p "$GNU_FOLDER/make"
mkdir -p "$GNU_FOLDER/mingw-w64"
mkdir -p "$GNU_FOLDER/mpc"
mkdir -p "$GNU_FOLDER/mpfr"
mkdir -p "$GNU_FOLDER/nasm"
mkdir -p "$GNU_FOLDER/pdcurses"
mkdir -p "$GNU_FOLDER/vim"

# Switch context
cd "$GNU_FOLDER"

# Download packages
wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz -O "$TEMP_FOLDER/binutils-$BINUTILS_VERSION.tar.xz"
wget https://frippery.org/files/busybox/busybox-w32-$BUSYBOX_VERSION.tgz -O "$TEMP_FOLDER/busybox-w32-$BUSYBOX_VERSION.tgz"
wget https://github.com/danmar/cppcheck/archive/refs/tags/$CPPCHECK_VERSION.tar.gz -O "$TEMP_FOLDER/cppcheck-$CPPCHECK_VERSION.tar.gz"
wget https://github.com/universal-ctags/ctags/archive/refs/tags/v$CTAGS_VERSION.tar.gz -O "$TEMP_FOLDER/ctags-v$CTAGS_VERSION.tar.gz"
wget https://github.com/libexpat/libexpat/archive/refs/tags/$EXPAT_VERSION.tar.gz -O "$TEMP_FOLDER/expat-$EXPAT_VERSION.tar.gz"
wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz -O "$TEMP_FOLDER/gcc-$GCC_VERSION.tar.xz"
wget https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VERSION.tar.xz -O "$TEMP_FOLDER/gdb-$GDB_VERSION.tar.xz"
wget https://ftp.gnu.org/gnu/gmp/gmp-$GMP_VERSION.tar.xz -O "$TEMP_FOLDER/gmp-$GMP_VERSION.tar.xz"
wget https://ftp.gnu.org/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz -O "$TEMP_FOLDER/libiconv-$LIBICONV_VERSION.tar.gz"
wget https://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz -O "$TEMP_FOLDER/make-$MAKE_VERSION.tar.gz"
wget https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v$MINGW_VERSION.tar.bz2 -O "$TEMP_FOLDER/mingw-w64-v$MINGW_VERSION.tar.bz2"
wget https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz -O "$TEMP_FOLDER/mpc-$MPC_VERSION.tar.gz"
wget https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VERSION.tar.xz -O "$TEMP_FOLDER/mpfr-$MPFR_VERSION.tar.xz"
wget https://github.com/netwide-assembler/nasm/archive/refs/tags/nasm-$NASM_VERSION.tar.gz -O "$TEMP_FOLDER/nasm-$NASM_VERSION.tar.gz"
wget https://downloads.sourceforge.net/project/pdcurses/pdcurses/$PDCURSES_VERSION/PDCurses-$PDCURSES_VERSION.tar.gz -O "$TEMP_FOLDER/PDCurses-$PDCURSES_VERSION.tar.gz"
wget https://github.com/vim/vim/archive/refs/tags/v$VIM_VERSION.tar.gz -O "$TEMP_FOLDER/vim-$VIM_VERSION.tar.bz2"

# Extract to folders
tar --strip-components=1 -xf "$TEMP_FOLDER/binutils-$BINUTILS_VERSION.tar.xz" -C "$GNU_FOLDER/binutils/"
tar --strip-components=1 -xf "$TEMP_FOLDER/busybox-w32-$BUSYBOX_VERSION.tgz" -C "$GNU_FOLDER/busybox-w32/"
tar --strip-components=1 -xf "$TEMP_FOLDER/cppcheck-$CPPCHECK_VERSION.tar.gz" -C "$GNU_FOLDER/cppcheck/" 
tar --strip-components=1 -xf "$TEMP_FOLDER/ctags-v$CTAGS_VERSION.tar.gz" -C "$GNU_FOLDER/ctags/" 
tar --strip-components=1 -xf "$TEMP_FOLDER/expat-$EXPAT_VERSION.tar.gz" -C "$GNU_FOLDER/expat/"
tar --strip-components=1 -xf "$TEMP_FOLDER/gcc-$GCC_VERSION.tar.xz" -C "$GNU_FOLDER/gcc/"
tar --strip-components=1 -xf "$TEMP_FOLDER/gdb-$GDB_VERSION.tar.xz" -C "$GNU_FOLDER/gdb/"
tar --strip-components=1 -xf "$TEMP_FOLDER/gmp-$GMP_VERSION.tar.xz" -C "$GNU_FOLDER/gmp/"
tar --strip-components=1 -xf "$TEMP_FOLDER/libiconv-$LIBICONV_VERSION.tar.gz" -C "$GNU_FOLDER/libiconv/"
tar --strip-components=1 -xf "$TEMP_FOLDER/make-$MAKE_VERSION.tar.gz" -C "$GNU_FOLDER/make/"
tar --strip-components=1 -xf "$TEMP_FOLDER/mingw-w64-v$MINGW_VERSION.tar.bz2" -C "$GNU_FOLDER/mingw-w64/"
tar --strip-components=1 -xf "$TEMP_FOLDER/mpc-$MPC_VERSION.tar.gz" -C "$GNU_FOLDER/mpc/"
tar --strip-components=1 -xf "$TEMP_FOLDER/mpfr-$MPFR_VERSION.tar.xz" -C "$GNU_FOLDER/mpfr/"
tar --strip-components=1 -xf "$TEMP_FOLDER/nasm-$NASM_VERSION.tar.gz" -C "$GNU_FOLDER/nasm/"
tar --strip-components=1 -xf "$TEMP_FOLDER/PDCurses-$PDCURSES_VERSION.tar.gz" -C "$GNU_FOLDER/pdcurses/"
tar --strip-components=1 -xf "$TEMP_FOLDER/vim-$VIM_VERSION.tar.bz2" -C "$GNU_FOLDER/vim/"

# Clean-up resources
rm -rf "$TEMP_FOLDER/" || true