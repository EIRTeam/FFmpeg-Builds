ARG GH_REPO=ghcr.io/btbn/ffmpeg-builds
FROM $GH_REPO/base:latest

RUN --mount=src=MacOSX12.3.sdk.tar.xz,dst=/sdk.tar.xz \
    git clone https://github.com/tpoechtrager/osxcross.git /opt/osxcross && \
    cd /opt/osxcross && \
    git fetch --all && \
    git checkout ff8d100f3f026b4ffbe4ce96d8aac4ce06f1278b && \
    ln -s /sdk.tar.xz /opt/osxcross/tarballs/MacOSX12.3.sdk.tar.xz && \
    UNATTENDED=1 ./build.sh

RUN rustup target add x86_64-apple-darwin

ADD toolchain.cmake /toolchain.cmake
ADD cross.meson /cross.meson

ENV FFBUILD_TOOLCHAIN=x86_64-apple-darwin21.4
ENV PATH="/opt/osxcross/target/bin:${PATH}" \
    FFBUILD_TARGET_FLAGS="--pkg-config=pkg-config --cross-prefix=${FFBUILD_TOOLCHAIN}- --arch=x86_64 --target-os=darwin" \
    FFBUILD_CROSS_PREFIX="${FFBUILD_TOOLCHAIN}-" \
    FFBUILD_RUST_TARGET="x86_64-apple-darwin" \
    FFBUILD_PREFIX=/opt/ffbuild \
    FFBUILD_CMAKE_TOOLCHAIN=/toolchain.cmake \
    PKG_CONFIG=pkg-config \
    PKG_CONFIG_LIBDIR=/opt/ffbuild/lib/pkgconfig:/opt/ffbuild/share/pkgconfig \
    CC="${FFBUILD_TOOLCHAIN}-clang" \
    CXX="${FFBUILD_TOOLCHAIN}-clang++" \
    LD="${FFBUILD_TOOLCHAIN}-ld" \
    AR="${FFBUILD_TOOLCHAIN}-ar" \
    RANLIB="${FFBUILD_TOOLCHAIN}-ranlib" \
    NM="${FFBUILD_TOOLCHAIN}-nm" \
## zlib produces test files with off64_t variables. There is no support for _LARGE_FILE64_SOURCE / _FILE_OFFSET_BITS
## flags in Clang yet: https://github.com/llvm/llvm-project/issues/77376
## So, for now we redefine this type to int64_t
    CFLAGS="-mmacosx-version-min=12.3 -Doff64_t=int64_t -I/opt/ffbuild/include -O2 -pipe -fPIC -DPIC -pthread" \
    CXXFLAGS="-mmacosx-version-min=12.3 -I/opt/ffbuild/include -O2 -pipe -fPIC -DPIC -pthread" \
    LDFLAGS="-L/opt/ffbuild/lib -O2 -pipe -pthread -lm" \
    STAGE_CFLAGS="-fvisibility=hidden" \
    STAGE_CXXFLAGS="-fvisibility=hidden"
