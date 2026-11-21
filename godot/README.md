# Godot FFmpeg packages

Build on a Linux Docker host:

```sh
./godot/build.sh linux64
./godot/build.sh win64
```

This thin layer uses the public upstream `lgpl-shared-9.0` images and
unmodified upstream build/packaging scripts. Only the configure flags in
`addins/godot.sh` are added. It does not rebuild the upstream dependency matrix.
The base image digest and checkout commit are recorded beside each package.
The release branch and image tags track upstream updates; the recorded digest
identifies the image used for an individual build.

Packages retain the engine's `ffmpeg-master-latest-{linux64,win64}-lgpl-godot`
prefix names and tar.xz format. Both software decoding and H.264/HEVC Vulkan
Video are included; networking, encoders and most unused components are disabled.
Windows packages include MinGW and MSVC import libraries. Linux uses upstream's
glibc baseline (2.28). Programs are retained for upstream packaging compatibility,
but the engine only installs the shared libraries.

Use the **Godot FFmpeg** manual workflow to build both targets. Enable `publish`
to upload packages and SHA256SUMS to the `godot-9.0` release. The full upstream
workflow is gated to the upstream repository, so pushing this fork does not
start its dependency/image matrix.

Point the engine at the extracted prefix with `ffmpeg_path`. GPU support is
compiled automatically with FFmpeg 9+ on supported Vulkan builds; experimental
GPU playback still requires the engine's opt-in project settings.
