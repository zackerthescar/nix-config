# ./overlays/default.nix
{ inputs, config, pkgs, lib, ... }:

let
  # Only the hosts with an NVIDIA card get the CUDA builds.
  hasNvidia = lib.elem "nvidia" config.services.xserver.videoDrivers;
in
{
  nixpkgs.overlays = [
    (self: super: {
        ffmpreg = (super.ffmpeg.override {
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
        prismlauncher-riley = super.prismlauncher.override {
          jdks = with pkgs; [
            zulu8
            zulu17
            zulu
	    graalvmPackages.graalvm-ce
          ];
        };
        obs-studio-riley =
          if hasNvidia
          then super.obs-studio.override { cudaSupport = true; }
          else super.obs-studio;
    })
  ];
}
