#/bin/sh

ARCH=x86_64-w64-mingw32

WORKDIR="$(cd "$(dirname "$0")" && pwd)"
BOOTSTRAP="$WORKDIR/bootstrap"
MAKE_FOLDER="$WORKDIR/make"
SOURCE_CODE="$WORKDIR/src"
GNU_FOLDER="$WORKDIR/.."
PATH="$BOOTSTRAP/bin:${PATH}"

VERSION=1.1.0

cd $WORKDIR

# Build cross-compiler

cd $GNU_FOLDER/binutils
sed -ri 's/(static bool insert_timestamp = )/\1!/' ld/emultempl/pe*.em \
 && sed -ri 's/(int pe_enable_stdcall_fixup = )/\1!!/' ld/emultempl/pe*.em \
 && cat $SOURCE_CODE/binutils-*.patch | patch -p1
mkdir $MAKE_FOLDER/x-binutils && cd "$_"
chmod +x $GNU_FOLDER/binutils/configure
$GNU_FOLDER/binutils/configure \
        --prefix=$BOOTSTRAP \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --target=$ARCH \
        --disable-nls \
        --with-static-standard-libraries \
        --disable-multilib \
 && make MAKEINFO=true -j$(nproc) \
 && make MAKEINFO=true install


# Fixes i686 Windows XP regression
# https://sourceforge.net/p/mingw-w64/bugs/821/
sed -i /OpenThreadToken/d $GNU_FOLDER/mingw-w64/mingw-w64-crt/lib32/kernel32.def


mkdir $MAKE_FOLDER/x-mingw-headers && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-headers/configure
$GNU_FOLDER/mingw-w64/mingw-w64-headers/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --with-default-msvcrt=msvcrt-os \
 && make -j$(nproc) \
 && make install

cd $BOOTSTRAP && ln -s $ARCH mingw

mkdir $MAKE_FOLDER/x-gcc && cd "$_"
cat $SOURCE_CODE/gcc-*.patch | patch -d $GNU_FOLDER/gcc -p1
chmod +x $GNU_FOLDER/gcc/configure
$GNU_FOLDER/gcc/configure \
        --prefix=$BOOTSTRAP \
        --with-sysroot=$BOOTSTRAP \
        --target=$ARCH \
        --enable-static \
        --disable-shared \
        --with-pic \
        --with-gnu-ld \
        --enable-languages=c,c++,fortran \
        --enable-libgomp \
        --enable-threads=posix \
        --enable-version-specific-runtime-libs \
        --disable-dependency-tracking \
        --disable-nls \
        --disable-lto \
        --disable-multilib \
        CFLAGS_FOR_TARGET="-Os" \
        CXXFLAGS_FOR_TARGET="-Os" \
        LDFLAGS_FOR_TARGET="-s" \
        CFLAGS="-Os" \
        CXXFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) all-gcc \
 && make install-gcc

mkdir -p $BOOTSTRAP/$ARCH/lib \
 && CC=$ARCH-gcc DESTDIR=$BOOTSTRAP/$ARCH/lib/ sh $SOURCE_CODE/libmemory.c \
 && ln $BOOTSTRAP/$ARCH/lib/libmemory.a $BOOTSTRAP/$ARCH/lib/ \
 && CC=$ARCH-gcc DESTDIR=$BOOTSTRAP/$ARCH/lib/ sh $SOURCE_CODE/libchkstk.S \
 && ln $BOOTSTRAP/$ARCH/lib/libchkstk.a $BOOTSTRAP/$ARCH/lib/

mkdir $MAKE_FOLDER/x-mingw-crt && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-crt/configure
$GNU_FOLDER/mingw-w64/mingw-w64-crt/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --with-default-msvcrt=msvcrt-os \
        --disable-dependency-tracking \
        --disable-lib32 \
        --enable-lib64 \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/x-winpthreads && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-libraries/winpthreads/configure
$GNU_FOLDER/mingw-w64/mingw-w64-libraries/winpthreads/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --enable-static \
        --disable-shared \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

cd $MAKE_FOLDER/x-gcc \
 && make -j$(nproc) \
 && make install

# Cross-compile GCC

mkdir $MAKE_FOLDER/binutils && cd "$_"
$GNU_FOLDER/binutils/configure \
        --prefix=$BOOTSTRAP \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --target=$ARCH \
        --disable-nls \
        --with-static-standard-libraries \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make MAKEINFO=true -j$(nproc) \
 && make MAKEINFO=true install \
 && rm $BOOTSTRAP/bin/elfedit.exe $BOOTSTRAP/bin/readelf.exe

mkdir $MAKE_FOLDER/gmp && cd "$_"
chmod +x $GNU_FOLDER/gmp/configure
$GNU_FOLDER/gmp/configure \
        --prefix=$BOOTSTRAP \
        --host=$ARCH \
        --enable-static \
        --disable-shared \
        CFLAGS="-Os" \
        CXXFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/mpfr && cd "$_"
chmod +x $GNU_FOLDER/mpfr/configure
$GNU_FOLDER/mpfr/configure \
        --prefix=$BOOTSTRAP \
        --host=$ARCH \
        --with-gmp-include=$BOOTSTRAP/include \
        --with-gmp-lib=$BOOTSTRAP/lib \
        --enable-static \
        --disable-shared \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/mpc && cd "$_"
chmod +x $GNU_FOLDER/mpc/configure
$GNU_FOLDER/mpc/configure \
        --prefix=$BOOTSTRAP \
        --host=$ARCH \
        --with-gmp-include=$BOOTSTRAP/include \
        --with-gmp-lib=$BOOTSTRAP/lib \
        --with-mpfr-include=$BOOTSTRAP/include \
        --with-mpfr-lib=$BOOTSTRAP/lib \
        --enable-static \
		--disable-shared \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/mingw-headers && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-headers/configure
$GNU_FOLDER/mingw-w64/mingw-w64-headers/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --with-default-msvcrt=msvcrt-os \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/mingw-crt && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-crt/configure
$GNU_FOLDER/mingw-w64/mingw-w64-crt/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --with-default-msvcrt=msvcrt-os \
        --disable-dependency-tracking \
        --disable-lib32 \
        --enable-lib64 \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/winpthreads && cd "$_"
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-libraries/winpthreads/configure
$GNU_FOLDER/mingw-w64/mingw-w64-libraries/winpthreads/configure \
        --prefix=$BOOTSTRAP/$ARCH \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --host=$ARCH \
        --enable-static \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/gcc && cd "$_"
chmod +x $GNU_FOLDER/gcc-$GCC_VERSION/configure
$GNU_FOLDER/gcc-$GCC_VERSION/configure \
        --prefix=$BOOTSTRAP \
        --with-sysroot=$BOOTSTRAP/$ARCH \
        --with-native-system-header-dir=/include \
        --target=$ARCH \
        --host=$ARCH \
        --enable-static \
        --disable-shared \
        --with-pic \
        --with-gnu-ld \
        --with-gmp-include=$BOOTSTRAP/include \
        --with-gmp-lib=$BOOTSTRAP/lib \
        --with-mpc-include=$BOOTSTRAP/include \
        --with-mpc-lib=$BOOTSTRAP/lib \
        --with-mpfr-include=$BOOTSTRAP/include \
        --with-mpfr-lib=$BOOTSTRAP/lib \
        --enable-languages=c,c++,fortran \
        --enable-libgomp \
		--enable-lto \
        --enable-threads=posix \
        --enable-version-specific-runtime-libs \
        --disable-dependency-tracking \
        --disable-lto \
        --disable-multilib \
        --disable-nls \
        --disable-win32-registry \
        --enable-mingw-wildcard \
        CFLAGS_FOR_TARGET="-Os" \
        CXXFLAGS_FOR_TARGET="-Os" \
        LDFLAGS_FOR_TARGET="-s" \
        CFLAGS="-Os" \
        CXXFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=g++.exe -DCMD=c++ \
        -Os -fno-asynchronous-unwind-tables \
        -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/c++.exe \
        $SOURCE_CODE/alias.c -lkernel32

$BOOTSTRAP/bin/$ARCH-gcc -DEXE=gcc.exe -DCMD=cc \
        -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/cc.exe $SOURCE_CODE/alias.c -lkernel32 \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=gcc.exe -DCMD="cc -std=c99" \
        -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/c99.exe $SOURCE_CODE/alias.c -lkernel32 \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=gcc.exe -DCMD="cc -ansi" \
        -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/c89.exe $SOURCE_CODE/alias.c -lkernel32 \
 && printf '%s\n' addr2line ar as c++filt cpp dlltool dllwrap elfedit g++ \
      gcc gcc-ar gcc-nm gcc-ranlib gcov gcov-dump gcov-tool ld nm objcopy \
      objdump ranlib readelf size strings strip windmc windres \
    | xargs -I{} -P$(nproc) \
          $BOOTSTRAP/bin/$ARCH-gcc -DEXE={}.exe -DCMD=$ARCH-{} \
            -Os -fno-asynchronous-unwind-tables \
            -Wl,--gc-sections -s -nostdlib \
            -o $BOOTSTRAP/bin/$ARCH-{}.exe $SOURCE_CODE/alias.c -lkernel32

# Build some extra development tools, alongside with the primary development tools

mkdir $MAKE_FOLDER/mingw-tools-gendef && cd "$_"
patch -d $GNU_FOLDER/mingw-w64 -p1 < $SOURCE_CODE/gendef-silent.patch
chmod +x $GNU_FOLDER/mingw-w64/mingw-w64-tools/gendef/configure
$GNU_FOLDER/mingw-w64/mingw-w64-tools/gendef/configure \
        --host=$ARCH \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && cp gendef.exe $BOOTSTRAP/bin/

mkdir $MAKE_FOLDER/expat && cd "$_"
chmod +x $GNU_FOLDER/expat/configure
$GNU_FOLDER/expat/configure \
        --prefix=$BOOTSTRAP \
        --host=$ARCH \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

cd $GNU_FOLDER/pdcurses
make -j$(nproc) -C wincon CC=$BOOTSTRAP/bin/$ARCH-gcc AR=$ARCH-ar CFLAGS="-I.. -Os -DPDC_WIDE" pdcurses.a \
 && cp wincon/pdcurses.a $BOOTSTRAP/lib/libcurses.a \
 && cp curses.h $BOOTSTRAP/include

mkdir $MAKE_FOLDER/libiconv && cd "$_"
chmod +x $GNU_FOLDER/libiconv/configure
$GNU_FOLDER/libiconv/configure \
        --prefix=$BOOTSTRAP \
        --host=$ARCH \
        --disable-nls \
        --disable-shared \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && make install

mkdir $MAKE_FOLDER/gdb && cd "$_"
cat $SOURCE_CODE/gdb-*.patch | patch -d $GNU_FOLDER/gdb -p1 \
 && sed -i 's/quiet = 0/quiet = 1/' $GNU_FOLDER/gdb/gdb/main.c
chmod +x $GNU_FOLDER/gdb/configure
$GNU_FOLDER/gdb/configure \
        --host=$ARCH \
        --enable-tui \
        CFLAGS="-Os -DPDC_WIDE -I$BOOTSTRAP/include" \
        CXXFLAGS="-Os -DPDC_WIDE -I$BOOTSTRAP/include" \
        LDFLAGS="-s -L$BOOTSTRAP/lib" \
 && make MAKEINFO=true -j$(nproc) \
 && cp gdb/.libs/gdb.exe gdbserver/gdbserver.exe $BOOTSTRAP/bin/

mkdir $MAKE_FOLDER/make && cd "$_"
chmod +x $GNU_FOLDER/make/configure
$GNU_FOLDER/make/configure \
        --host=$ARCH \
        --disable-nls \
        CFLAGS="-Os" \
        LDFLAGS="-s" \
 && make -j$(nproc) \
 && cp make.exe $BOOTSTRAP/bin/ \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=make.exe -DCMD=make \
        -Os -fno-asynchronous-unwind-tables \
        -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/mingw32-make.exe $SOURCE_CODE/alias.c -lkernel32

cd $GNU_FOLDER/busybox-w32
cat $SOURCE_CODE/busybox-*.patch | patch -p1
make mingw64_defconfig \
 && sed -ri 's/^(CONFIG_AR)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_ASCII)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_DPKG\w*)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_FTP\w*)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_LINK)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_MAN)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_MAKE)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_PDPMAKE)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_RPM\w*)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_STRINGS)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_TEST2)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_TSORT)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_UNLINK)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_VI)=y/\1=n/' .config \
 && sed -ri 's/^(CONFIG_XXD)=y/\1=n/' .config \
 && make -j$(nproc) CROSS_COMPILE=$ARCH- \
    CONFIG_EXTRA_CFLAGS="-D_WIN32_WINNT=0x502" \
 && cp busybox.exe $BOOTSTRAP/bin/

cd $BOOTSTRAP/bin
$BOOTSTRAP/bin/$ARCH-gcc -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s \
      -nostdlib -o alias.exe $SOURCE_CODE/busybox-alias.c -lkernel32 \
 && printf '%s\n' arch ash awk base32 base64 basename bash bc bunzip2 bzcat \
      bzip2 cal cat chattr chmod cksum clear cmp comm cp cpio crc32 cut date \
      dc dd df diff dirname dos2unix du echo ed egrep env expand expr factor \
      false fgrep find fold free fsync getopt grep groups gunzip gzip hd \
      head hexdump httpd iconv id inotifyd install ipcalc jn kill killall \
      lash less ln logname ls lsattr lzcat lzma lzop lzopcat md5sum mkdir \
      mktemp mv nc nl nproc od paste patch pgrep pidof pipe_progress pkill \
      printenv printf ps pwd readlink realpath reset rev rm rmdir sed seq sh \
      sha1sum sha256sum sha3sum sha512sum shred shuf sleep sort split \
      ssl_client stat su sum sync tac tail tar tee test time timeout touch \
      tr true truncate ts ttysize uname uncompress unexpand uniq unix2dos \
      unlzma unlzop unxz unzip uptime usleep uudecode uuencode watch \
      wc wget which whoami whois xargs xz xzcat yes zcat \
    | xargs -I{} cp alias.exe $BOOTSTRAP/bin/{}.exe

cd $GNU_FOLDER/vim90/src
ARCH= make -f Make_ming.mak \
        OPTIMIZE=SIZE STATIC_STDCPLUS=yes HAS_GCC_EH=no \
        UNDER_CYGWIN=yes CROSS=yes CROSS_COMPILE=$ARCH- \
        FEATURES=HUGE VIMDLL=yes NETBEANS=no WINVER=0x0501 \
 && $ARCH-strip vimrun.exe \
 && rm -rf ../runtime/tutor/tutor.* \
 && cp -r ../runtime $BOOTSTRAP/share/vim \
 && cp vimrun.exe gvim.exe vim.exe *.dll $BOOTSTRAP/share/vim/ \
 && cp xxd/xxd.exe $BOOTSTRAP/bin \
 && printf '@set SHELL=\r\n@start "" "%%~dp0/../share/vim/gvim.exe" %%*\r\n' \
        >$BOOTSTRAP/bin/gvim.bat \
 && printf '@set SHELL=\r\n@"%%~dp0/../share/vim/vim.exe" %%*\r\n' \
        >$BOOTSTRAP/bin/vim.bat \
 && printf '@set SHELL=\r\n@"%%~dp0/../share/vim/vim.exe" %%*\r\n' \
        >$BOOTSTRAP/bin/vi.bat \
 && printf '@vim -N -u NONE "+read %s" "+write" "%s"\r\n' \
        '$VIMRUNTIME/tutor/tutor' '%TMP%/tutor%RANDOM%' \
        >$BOOTSTRAP/bin/vimtutor.bat

chmod +x $GNU_FOLDER/nasm/configure && chmod +x $GNU_FOLDER/nasm/autogen.sh
cd $GNU_FOLDER/nasm/
$GNU_FOLDER/nasm/autogen.sh
mkdir $MAKE_FOLDER/nasm && cd "$_"
$GNU_FOLDER/nasm-$NASM_VERSION/configure \
        --host=$ARCH \
		 CFLAGS="-Os" \
        LDFLAGS="-s" \
 && mkdir include \
 && make -j$(nproc) \
 && cp nasm.exe ndisasm.exe $BOOTSTRAP/bin

cd $GNU_FOLDER/ctags
sed -i /RT_MANIFEST/d win32/ctags.rc \
 && make -j$(nproc) -f mk_mingw.mak CC=gcc packcc.exe \
 && make -j$(nproc) -f mk_mingw.mak \
        CC=$BOOTSTRAP/bin/$ARCH-gcc WINDRES=$ARCH-windres \
        OPT= CFLAGS=-Os LDFLAGS=-s \
 && cp ctags.exe $BOOTSTRAP/bin/

cd $GNU_FOLDER/cppcheck
cat $SOURCE_CODE/cppcheck-*.patch | patch -p1 \
 && make -f $SOURCE_CODE/cppcheck.mak CXX=$ARCH-g++ \
 && mkdir $BOOTSTRAP/share/cppcheck/ \
 && cp -r cppcheck.exe cfg/ $BOOTSTRAP/share/cppcheck \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=../share/cppcheck/cppcheck.exe -DCMD=cppcheck \
        -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/cppcheck.exe $SOURCE_CODE/alias.c -lkernel32


#pack-up

cd $WORKDIR

printf "id ICON \"$SOURCE_CODE/gnu-windows.ico\"" > gnu-windows.rc \
 && $BOOTSTRAP/bin/$ARCH-windres -o gnu-windows.o gnu-windows.rc \
 && $BOOTSTRAP/bin/$ARCH-gcc \
        -Os -fno-asynchronous-unwind-tables \
        -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/debugbreak.exe $BOOTSTRAP/src/debugbreak.c \
        -lkernel32 \
 && $BOOTSTRAP/bin/$ARCH-gcc \
        -Os -fwhole-program -fno-asynchronous-unwind-tables \
        -Wl,--gc-sections -s -nostdlib -DPKG_CONFIG_PREFIX="\"/$ARCH\"" \
        -o $BOOTSTRAP/bin/pkg-config.exe $BOOTSTRAP/src/pkg-config.c \
        -lkernel32 \
 && $BOOTSTRAP/bin/$ARCH-gcc \
        -Os -fno-asynchronous-unwind-tables -fno-builtin -Wl,--gc-sections \
        -s -nostdlib -o $BOOTSTRAP/bin/vc++filt.exe $BOOTSTRAP/src/vc++filt.c \
        -lkernel32 -lshell32 -ldbghelp \
 && $BOOTSTRAP/bin/$ARCH-gcc -DEXE=pkg-config.exe -DCMD=pkg-config \
        -Os -fno-asynchronous-unwind-tables -Wl,--gc-sections -s -nostdlib \
        -o $BOOTSTRAP/bin/$ARCH-pkg-config.exe $BOOTSTRAP/src/alias.c -lkernel32 \
 && mkdir -p $BOOTSTRAP/$ARCH/lib/pkgconfig \
 && cp $GNU_FOLDER/mingw-w64-v$MINGW_VERSION/COPYING.MinGW-w64-runtime/COPYING.MinGW-w64-runtime.txt \
        $BOOTSTRAP/ \
 && printf "\n===========\nwinpthreads\n===========\n\n" \
        >>$BOOTSTRAP/COPYING.MinGW-w64-runtime.txt . \
 && echo $VERSION >$BOOTSTRAP/VERSION.txt

cd $WORKDIR

# Copy all executable from $ARCH into the primary folder
cp $BOOTSTRAP/$ARCH/bin/*.dll $BOOTSTRAP/bin
cp $BOOTSTRAP/$ARCH/bin/*.exe $BOOTSTRAP/bin

echo -e -n "Build sucessfully. Your GNU Windows is under path: $BOOTSTRAP"
