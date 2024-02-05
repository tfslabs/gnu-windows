```text
This directory contains various GNU tools for Windows, including binutils , busybox, cppcheck, ctags, expat, gcc/g++, gdb, libiconv, make, mingw-64, mpc, mpfr, nasm, PDCurses, vim.

Each directory (except the one started with dot(.) - these folders are main and admin folder) contains tools, with its own COPYRIGHT, assigned with various developers. These folder must be reserved, except in maintaince, for building the binaries.

See https://github.com/tfsmetadata/gnu-windows/issues for reporting issues. Note please describe your issue as much detail as possible.

Copyright years on source files may be listed using range
notation, e.g., 1987-2012, indicating that every year in the range,
inclusive, is a copyrightable year that could otherwise be listed
individually.
```

# GNU Windows

GNU Windows is a suite of development kits for Windows, including the tools already metioned above. It is used to build [@TheFlightSims](https://github.com/TheFlightSims) application binaries from sources.

All exclusive documents, you can try search for yourself on over the Internet.

> :warning: Warning
>
> GNU Windows is only support 64-bit Windows operating system. Run best on Windows 10 1903 and later.

## Getting started

### Build from source (GitHub)

You must run the configuration within Linux configuration. Once it's done, the folder `.gnu-windows/bootstrap` is your binaries. You can use it.

```bash
chmod +x .gnu-windows/build.sh
.gnu-windows/build.sh
```

### (For admins) Update source layout

Run the configuration in `.admin`. Once it's done, move all extracted to the repo folder. Don't forget to delete the old layout before moving!

```bash
chmod +x .admin/download_and_extract.sh
.admin/download_and_extract.sh
```
