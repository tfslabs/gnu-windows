# GNU Windows

> THIS PROJECT IS NO LONGER MAINTAINED. WE ENCOURAGE PEOPLE TO MOVE TO [MinGW](https://sourceforge.net/projects/mingw/) - which has better support
>
> Copyright years on source files may be listed using range notation,
e.g., 1987-2012, indicating that every year in the range, inclusive,
is a copyrightable year that could otherwise be listed individually.

![GitHub Downloads (all assets, all releases)](https://img.shields.io/github/downloads/tfslabs/gnu-windows/total)
![GitHub language count](https://img.shields.io/github/languages/count/tfslabs/gnu-windows)
![GitHub repo size](https://img.shields.io/github/repo-size/tfslabs/gnu-windows)
![GitHub Repo stars](https://img.shields.io/github/stars/tfslabs/gnu-windows)

GNU Windows is a suite of development kits for Windows, including the tools mentioned above. It is used to build [@TheFlightSims](https://github.com/TheFlightSims) application binaries from sources.

For all exclusive documents, you can try to search for yourself over the Internet.

> :warning: Warning
>
> GNU Windows only supports the 64-bit Windows operating system. Run best on Windows 10 1809 and later.

## Getting started

### Building GNU Windows

Since this repo is a submodule package distribution, it is recommended to update submodules before actual compiling.

```shell
git clone https://github.com/tfslabs/gnu-windows.git
```

#### Building within Docker (recommended)

Since version 1.1.1, it is recommended to switch to build using [Ubunu Dev Containers](https://hub.docker.com/r/theflightsims/ubuntu-dev).

> Depends on your host machine architecture and workload limitation, please choose your image that fit with your task.

Replace `<your path>` with your real path to the local repo. Double-quote is needed if there are spaces in your path.

```shell
docker run -it -v <your path>:/root theflightsims/gnu-windows-build:latest bash
```

Once you're in the `bash`, try this command:

```shell
# Prepare environment
/root/.gnu-windows/prepare_env.sh

# Start building
/root/.gnu-windows/build.sh
```

> Note:
>
> If you have failed to build, it is recommended for you to start from the beginning. In that case, you can use this command
>
> ```bash
> /root/.gnu-windows/cleanup_all.sh
> ```

Once it's done, you'll see your GNU application is building in folder `.gnu-windows\bootstrap`

#### Building within bare metal environment (non-Docker environment)

Depending on your distro, it is required for your OS installation to have those packages:

- [Core utilities](https://github.com/tfslabs/ubuntu-dev/blob/master/PACKAGES.md#1-core-utilities)
- [Development tools & build dependencies](https://github.com/tfslabs/ubuntu-dev/blob/master/PACKAGES.md#1-core-utilities)
- [Libraries & development headers](https://github.com/tfslabs/ubuntu-dev/blob/master/PACKAGES.md#1-core-utilities)
- [Compilers & toolchains (GNU, LLVM, cross)](https://github.com/tfslabs/ubuntu-dev/blob/master/PACKAGES.md#12-compilers--toolchains-gnu-llvm-cross)

Replace `<your path>` with your real path to the local repo. Double-quote is needed if there are spaces in your path.

```shell
# Prepare environment
<your path>/.gnu-windows/prepare_env.sh

# Start building
<your path>/.gnu-windows/build.sh
```

> Note:
>
> If you have failed to build, it is recommended for you to start from the beginning. In that case, you can use this command
>
> ```bash
> <your path>/.gnu-windows/cleanup_all.sh
> ```

Once it's done, you'll see your GNU application is building in folder `.gnu-windows\bootstrap`

### Extension

Extensions are no longer supported for GNU Windows after version 1.1.1

### Contributing

Read the instructions [here](./CONTRIBUTING.md)

## License

This project is linked with GNU GPL 3.0 License. With no restriction on distribution and reuse.

All of the submodules have their own licenses.

GNU Windows is made by the team of TheFlightSims Labs.
