#/bin/bash

ARCH=x86_64-w64-mingw32

WORKDIR="$(cd "$(dirname "$0")" && pwd)"

BINUTILS_VERSION=2.41
BUSYBOX_VERSION=FRP-5236-g7dff7f376
CPPCHECK_VERSION=2.10
CTAGS_VERSION=6.0.0
EXPAT_VERSION=2.5.0
GCC_VERSION=13.2.0
GDB_VERSION=13.1
GMP_VERSION=6.3.0
LIBICONV_VERSION=1.17
MAKE_VERSION=4.4.1
MINGW_VERSION=11.0.1
MPC_VERSION=1.3.1
MPFR_VERSION=4.2.1
NASM_VERSION=2.15.05
PDCURSES_VERSION=3.9
VERSION=1.21.0
VIM_VERSION=9.0

cd $WORKDIR

apt update && \
 apt upgrade -y && \
 apt install -y build-essential curl libgmp-dev libmpc-dev libmpfr-dev m4 zip wget gcc g++ make cmake automake python3 python3-pip

wget --trust-server-names  \
    http://ftp.vim.org/pub/vim/unix/vim-$VIM_VERSION.tar.bz2 \
    http://ftp.vim.org/pub/vim/unix/vim-$VIM_VERSION.tar.bz2

wget --trust-server-names \
    https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v$MINGW_VERSION.tar.bz2 \
    https://downloads.sourceforge.net/project/pdcurses/pdcurses/$PDCURSES_VERSION/PDCurses-$PDCURSES_VERSION.tar.gz

wget --trust-server-names https://fossies.org/linux/www/expat-$EXPAT_VERSION.tar.xz

wget --trust-server-names https://frippery.org/files/busybox/busybox-w32-$BUSYBOX_VERSION.tgz

wget --trust-server-names \
    https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.xz \
    https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.xz \
    https://ftp.gnu.org/gnu/gdb/gdb-$GDB_VERSION.tar.xz \
    https://ftp.gnu.org/gnu/gmp/gmp-$GMP_VERSION.tar.xz \
    https://ftp.gnu.org/gnu/libiconv/libiconv-$LIBICONV_VERSION.tar.gz \
    https://ftp.gnu.org/gnu/make/make-$MAKE_VERSION.tar.gz \
    https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz \
    https://ftp.gnu.org/gnu/mpc/mpc-$MPC_VERSION.tar.gz \
    https://ftp.gnu.org/gnu/mpfr/mpfr-$MPFR_VERSION.tar.xz

wget -O cppcheck-$CPPCHECK_VERSION.tar.gz https://codeload.github.com/danmar/cppcheck/tar.gz/refs/tags/$CPPCHECK_VERSION

wget -O ctags-$CTAGS_VERSION.tar.gz https://codeload.github.com/universal-ctags/ctags/tar.gz/refs/tags/v$CTAGS_VERSION

wget --trust-server-names https://www.nasm.us/pub/nasm/releasebuilds/$NASM_VERSION/nasm-$NASM_VERSION.tar.xz

tar xJf binutils-$BINUTILS_VERSION.tar.xz \
 && tar xzf busybox-w32-$BUSYBOX_VERSION.tgz \
 && tar xzf ctags-$CTAGS_VERSION.tar.gz \
 && tar xJf gcc-$GCC_VERSION.tar.xz \
 && tar xJf gdb-$GDB_VERSION.tar.xz \
 && tar xJf expat-$EXPAT_VERSION.tar.xz \
 && tar xzf libiconv-$LIBICONV_VERSION.tar.gz \
 && tar xJf gmp-$GMP_VERSION.tar.xz \
 && tar xzf mpc-$MPC_VERSION.tar.gz \
 && tar xJf mpfr-$MPFR_VERSION.tar.xz \
 && tar xzf make-$MAKE_VERSION.tar.gz \
 && tar xjf mingw-w64-v$MINGW_VERSION.tar.bz2 \
 && tar xzf PDCurses-$PDCURSES_VERSION.tar.gz \
 && tar xJf nasm-$NASM_VERSION.tar.xz \
 && tar xjf vim-$VIM_VERSION.tar.bz2 \
 && tar xzf cppcheck-$CPPCHECK_VERSION.tar.gz
