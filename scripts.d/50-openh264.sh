#!/bin/bash

SCRIPT_REPO="https://github.com/cisco/openh264.git"
SCRIPT_COMMIT="986606644aca8f795fc04f76dcc758d88378e4a0"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    local myconf=(
        PREFIX="$FFBUILD_PREFIX"
        INCLUDE_PREFIX="$FFBUILD_PREFIX"/include/wels
        BUILDTYPE=Release
        DEBUGSYMBOLS=False
        LIBDIR_NAME=lib
        AR="$FFBUILD_CROSS_PREFIX"ar
    )

    if [[ $TARGET == macos* ]]; then
        myconf+=(
            CC="$FFBUILD_CROSS_PREFIX"clang
            CXX="$FFBUILD_CROSS_PREFIX"clang++
        )
    else
        myconf+=(
            CC="$FFBUILD_CROSS_PREFIX"gcc
            CXX="$FFBUILD_CROSS_PREFIX"g++
        )
    fi

    if [[ $TARGET == win32 ]]; then
        myconf+=(
            OS=mingw_nt
            ARCH=i686
        )
    elif [[ $TARGET == win64 ]]; then
        myconf+=(
            OS=mingw_nt
            ARCH=x86_64
        )
    elif [[ $TARGET == linux64 ]]; then
        myconf+=(
            OS=linux
            ARCH=x86_64
        )
    elif [[ $TARGET == linuxarm64 ]]; then
        myconf+=(
            OS=linux
            ARCH=aarch64
        )
    elif [[ $TARGET == macos64 ]]; then
        myconf+=(
            OS=darwin
            ARCH=x86_64
            STATIC_LDFLAGS=-lc++
        )
    elif [[ $TARGET == macosarm64 ]]; then
        myconf+=(
            OS=darwin
            ARCH=arm64
            STATIC_LDFLAGS=-lc++
        )
    else
        echo "Unknown target"
        return -1
    fi

    make -j$(nproc) "${myconf[@]}" install-static
}

ffbuild_configure() {
    echo --enable-libopenh264
}

ffbuild_unconfigure() {
    echo --disable-libopenh264
}
