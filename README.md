> [Report issues here](https://github.com/tfslabs/gnu-windows/issues). Note please describe your issue in as much detail as possible.
>
> Please view [administration guide](./.admin/Administration%20Guide.md) if you ou have read-write access into the project.
>
> Copyright years on source files may be listed using range notation, 
e.g., 1987-2012, indicating that every year in the range, inclusive, 
is a copyrightable year that could otherwise be listed individually.

# GNU Windows

GNU Windows is a suite of development kits for Windows, including the tools mentioned above. It is used to build [@TheFlightSims](https://github.com/TheFlightSims) application binaries from sources.

For all exclusive documents, you can try to search for yourself over the Internet.

> :warning: Warning
>
> GNU Windows only supports the 64-bit Windows operating system. Run best on Windows 10 1903 and later.

## Getting started

### Building GNU Windows

> :warning: Warning
>
> Because an unknown error was detected in the Windows Subsystem for Linux while checking the suffix of binaries, we recommend you build the repo in Linux or use Docker Desktop within Hyper-V.

Since this repo is a submodule package distribution, it is recommended to update submodules before actual compiling.

```shell
git clone https://github.com/tfslabs/gnu-windows.git
cd gnu-windows
git submodule update --init --recursive
```

#### Building within Docker

You need to run the pre-defined Docker image, mount your cloned GitHub repo, and build from that. Since GNU Windows uses the Git Submodules distribution system, it is recommended that you have to update all submodules.

Replace `<your path>` with your real path to the local repo. Double-quote is needed if there are spaces in your path.

```shell
docker run -it -v <your path>:/root shiroinekotfs/gnu-windows:latest bash
```

Once you're in the `bash`, try this command:

```shell
/root/.gnu-windows/build.sh
```

Once it's done, you'll see your GNU application is building in folder `.gnu-windows\bootstrap`

> If you've got an error of being unable to execute `configure`, or the `build.sh` itself, try deleting that GNU Windows repo, and cloning using a Linux distro. 
>
> WSL or Docker is good for that cloning task, but you cannot use WSL to build the binaries for you.

#### Building within Linux

Make sure you've installed all of these packages before building GNU Windows (Debian distros are recommended)

```bash
autotools-dev binutils binutils-x86-64-linux-gnu cmake-data cpp cpp-12 fakeroot \
    fontconfig-config fonts-dejavu-core g++-12 gcc-12 libalgorithm-diff-perl \
    libalgorithm-diff-xs-perl libalgorithm-merge-perl libaom3 libarchive13 libasan8 \
    libatomic1 libbinutils libbrotli1 libc-dev-bin libc-devtools libc6-dev libcc1-0 \
    libcrypt-dev libctf-nobfd0 libctf0 libcurl4 libde265-0 libdeflate0 libdpkg-perl \
    libexpat1 libfakeroot libfile-fcntllock-perl libfl2 libfontconfig1 libfreetype6 \
    libgcc-12-dev libgd3 libgmpxx4ldbl libgomp1 libheif1  libitm1 libjbig0  libjsoncpp25 \
    liblsan0 libnghttp2-14 libnsl-dev libnsl2 libnuma1 libpng16-16 libpsl5 libquadmath0 \
    librhash0 librtmp1 libssh2-1 libstdc++-12-dev libtirpc-dev libtsan2 libubsan1 libuv1 \
    libwebp7 libx11-6 libx11-data libx265-199 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 \
    libyuv0 linux-libc-dev manpages-dev patch publicsuffix rpcsvc-proto unzip autoconf \
    automake bison build-essential cmake curl dpkg-dev flex g++ gcc libfl-dev libgmp-dev \
    libmpc-dev libmpfr-dev m4 make wget zip texinfo pkg-config python3 python3-pip \
    python3-venv file mingw-w64-x86-64-dev mingw-w64-i686-dev mingw-w64-tools
```

Just run the `<your path>/.gnu-windows/build.sh` directly, without changing the current console directory. Don't forget to use the `chmod` command.

In case you cannot configure any of the above packages, try to find alternative packages based on your distribution.

Once it's done, you'll see your GNU application is building in folder `.gnu-windows\bootstrap`

> If you've got an error of being unable to execute `configure`, or the `build.sh` itself, try deleting that GNU Windows repo, and cloning using a Linux distro.
>
> WSL or Docker is good for that cloning task, but you cannot use WSL to build the binaries for you.

### Extension

For installing additional GNU Windows extensions, you can go [search at TheFlightSims Internal Labs repos](https://github.com/orgs/tfslabs/repositories?q=gnu-windows)

### Contributing

Read the instructions [here](./CONTRIBUTING.md)

## License

This project is linked with GNU GPL 3.0 License. With no restriction on distribution and reuse.

GNU Windows is made by the team of TheFlightSims - Department of Research.
