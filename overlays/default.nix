# ./overlays/default.nix
# A NixOS and nix-darwin module, so the overlay can read the host config.
{ config, lib, ... }:

let
  # Only the hosts with an NVIDIA card get the CUDA builds.
  # nix-darwin has no services.xserver, so this is false there.
  hasNvidia = lib.elem "nvidia" (config.services.xserver.videoDrivers or [ ]);
in
{
  nixpkgs.overlays = [
    (final: prev: {
        ffmpreg = (prev.ffmpeg.override {
            withUnfree = true;
            withDav1d = true;
            withSvtav1 = true;
            withX264 = true;
            withX265 = true;
            withXvid = true;
            withFdkAac = true;
            withMp3lame = true;
            withOpus = true;
            withCuda = hasNvidia;
            withZimg = true;
        });
        prismlauncher-riley = prev.prismlauncher.override {
          jdks = with final; [
            zulu8
            zulu17
            zulu
            graalvmPackages.graalvm-ce
          ];
        };
        obs-studio-riley =
          if hasNvidia
          then prev.obs-studio.override { cudaSupport = true; }
          else prev.obs-studio;
    })
  ];
}
