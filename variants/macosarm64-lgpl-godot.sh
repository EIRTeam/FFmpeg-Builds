#!/bin/bash
source "$(dirname "$BASH_SOURCE")"/macos-install-shared-godot.sh
source "$(dirname "$BASH_SOURCE")"/defaults-lgpl-shared.sh
source "$(dirname "$BASH_SOURCE")"/lgpl-godot.sh

FFBUILD_TOOLCHAIN=arm64-apple-darwin21.4

FF_CONFIGURE+=" --cc=${FFBUILD_TOOLCHAIN}-clang --cxx=${FFBUILD_TOOLCHAIN}-clang++ --install-name-dir=@loader_path"

TOOLBOX="--enable-videotoolbox"
NEON="--enable-neon"

FF_CONFIGURE+=" $TOOLBOX $NEON"