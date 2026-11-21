#!/bin/bash
# Trimmed FFmpeg for the Project Heartbeat engine (Godot ffmpeg module).
#
# Only usable as "lgpl-shared 9.0 godot" through godot/build.sh: build.sh
# takes FF_CONFIGURE from the variant image, so godot/build.sh appends these
# flags to upstream's published lgpl-shared-9.0 image in a thin layer instead
# of rebuilding every dependency. Later flags override earlier ones.
GODOT_FF_CONFIGURE="--disable-network --disable-avdevice --disable-indevs --disable-outdevs \
--disable-encoders --disable-muxers --disable-filters \
--disable-decoders --enable-decoder=h264,hevc,vp8,vp9,av1,mpeg4,aac,aac_latm,mp3,vorbis,libvorbis,opus,libopus \
--disable-parsers --enable-parser=h264,hevc,vp8,vp9,av1,mpeg4video,mpegaudio,mpegvideo,aac,aac_latm,opus,vorbis \
--disable-demuxers --enable-demuxer=matroska,mov,aac,flv,avi \
--disable-hwaccels --enable-hwaccel=h264_vulkan,hevc_vulkan \
--disable-libplacebo --disable-libvpl --disable-vaapi --disable-vdpau \
--disable-cuvid --disable-nvdec --disable-nvenc --disable-opencl \
--disable-libdrm --disable-xlib --disable-liblcevc-dec"
