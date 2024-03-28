# Use an official Ubuntu image as base
FROM debian:latest

# Install git and any other dependencies needed for your build script
RUN apt update && \
 apt upgrade -y && \
 apt install -y autotools-dev binutils binutils-x86-64-linux-gnu cmake-data cpp cpp-12 fakeroot \
 fontconfig-config fonts-dejavu-core g++-12 gcc-12 libalgorithm-diff-perl libalgorithm-diff-xs-perl \ 
 libalgorithm-merge-perl libaom3 libarchive13 libasan8 libatomic1 libbinutils libbrotli1 libc-dev-bin \
 libc-devtools libc6-dev libcc1-0 libcrypt-dev libctf-nobfd0 libctf0 libcurl4 libde265-0 libdeflate0 \
 libdpkg-perl libexpat1 libfakeroot libfile-fcntllock-perl libfl2 libfontconfig1 libfreetype6 \
 libgcc-12-dev libgd3 libgmpxx4ldbl libgomp1 libheif1  libitm1 libjbig0  libjsoncpp25  liblsan0 \
 libnghttp2-14 libnsl-dev libnsl2 libnuma1 libpng16-16 libpsl5 libquadmath0  librhash0 librtmp1 \
 libssh2-1 libstdc++-12-dev libtirpc-dev libtsan2 libubsan1 libuv1 libwebp7 libx11-6 libx11-data \
 libx265-199 libxau6 libxcb1 libxdmcp6 libxml2 libxpm4 libyuv0 linux-libc-dev manpages-dev patch \
 publicsuffix rpcsvc-proto unzip autoconf automake bison build-essential cmake curl dpkg-dev flex \
 g++ gcc libfl-dev libgmp-dev libmpc-dev libmpfr-dev m4 make wget zip texinfo pkg-config python3 \
 python3-pip python3-venv file
