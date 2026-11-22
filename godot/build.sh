#!/bin/bash
# Build the Godot FFmpeg package for one target (linux64 or win64) on top of
# upstream's published lgpl-shared 9.0 image, using the unmodified build.sh.
set -euo pipefail
cd "$(dirname "$0")/.."

TARGET="${1:-}"
if [[ "$TARGET" != linux64 && "$TARGET" != win64 ]]; then
    echo "Usage: $0 linux64|win64" >&2
    exit 1
fi

# Images always come from upstream, also when running in a fork's CI.
UPSTREAM_REPO="ffmpeg-builds/ffmpeg-builds"
UPSTREAM_IMAGE="ghcr.io/${UPSTREAM_REPO}/${TARGET}-lgpl-shared-9.0:latest"
# The name build.sh derives for "TARGET lgpl-shared 9.0 godot". It only ever
# exists locally and is never pushed.
LOCAL_IMAGE="ghcr.io/${UPSTREAM_REPO}/${TARGET}-lgpl-shared-9.0-godot:latest"

source addins/godot.sh

docker pull "$UPSTREAM_IMAGE"
docker build --pull=false -t "$LOCAL_IMAGE" \
    --build-arg BASE="$UPSTREAM_IMAGE" --build-arg GODOT_FF_CONFIGURE="$GODOT_FF_CONFIGURE" godot

GITHUB_REPOSITORY="$UPSTREAM_REPO" ./build.sh "$TARGET" lgpl-shared 9.0 godot

if [[ "$TARGET" == win* ]]; then
    PACKAGE="$(ls -t artifacts/ffmpeg-*-"$TARGET"-lgpl-shared-9.0-godot.zip | head -n1)"
else
    PACKAGE="$(ls -t artifacts/ffmpeg-*-"$TARGET"-lgpl-shared-9.0-godot.tar.xz | head -n1)"
fi

{
    echo "upstream package: $(basename "$PACKAGE")"
    echo "package: ffmpeg-master-latest-${TARGET}-lgpl-godot.tar.xz"
    echo "ffmpeg-builds commit: $(git rev-parse HEAD)"
    echo "upstream image: $(docker image inspect --format '{{index .RepoDigests 0}}' "$UPSTREAM_IMAGE")"
    echo "extra configure: $GODOT_FF_CONFIGURE"
} > "artifacts/${TARGET}-build-info.txt"
cat "artifacts/${TARGET}-build-info.txt"

# Keep the engine's existing prefix names and a common archive format, even
# though upstream packages Windows as zip.
STAGING="$(mktemp -d)"
trap 'rm -rf "$STAGING"' EXIT
PREFIX="ffmpeg-master-latest-${TARGET}-lgpl-godot"
mkdir -p "$STAGING/$PREFIX"
if [[ "$TARGET" == win64 ]]; then
    unzip -q "$PACKAGE" -d "$STAGING/unpacked"
    mv "$STAGING"/unpacked/*/* "$STAGING/$PREFIX/"
    LIBAVCODEC="$STAGING/$PREFIX/bin/avcodec-63.dll"
else
    tar -xJf "$PACKAGE" --strip-components=1 -C "$STAGING/$PREFIX"
    LIBAVCODEC="$STAGING/$PREFIX/lib/libavcodec.so"
fi
# Read the extracted library, following SONAME symlinks on Linux.
for hwaccel in h264_vulkan hevc_vulkan; do
    if ! grep -qa "$hwaccel" "$LIBAVCODEC"; then
        echo "$hwaccel hwaccel missing from $LIBAVCODEC" >&2
        exit 1
    fi
done
tar -C "$STAGING" -cJf "artifacts/${PREFIX}.tar.xz" "$PREFIX"
rm "$PACKAGE"
