#!/bin/bash

SCRIPT_REPO="https://git.code.sf.net/p/soxr/code"
SCRIPT_COMMIT="945b592b70470e29f917f4de89b4281fbbd540c0"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    cd "$FFBUILD_DLDIR/$SELF"

    mkdir build && cd build

    # Disable OpenMP on macOS
    unset FFBUILD_OPENMP
    if [[ $TARGET != macos* ]]; then
        FFBUILD_OPENMP="-DWITH_OPENMP=ON"
    fi
    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" "$FFBUILD_OPENMP" -DBUILD_TESTS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF ..
    make -j$(nproc)
    make install

    if [[ $TARGET != macos* ]]; then
        echo "Libs.private: -lgomp" >> "$FFBUILD_PREFIX"/lib/pkgconfig/soxr.pc
    fi
}

ffbuild_configure() {
    echo --enable-libsoxr
}

ffbuild_unconfigure() {
    echo --disable-libsoxr
}

ffbuild_ldflags() {
    echo -pthread
}

ffbuild_libs() {
    if [[ $TARGET != macos* ]]; then
        echo -lgomp
    fi
}
