# ./overlays/default.nix
{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    inputs.catppuccin-vsc.overlays.default
    (self: super: {
        ffmpeg-riley = super.ffmpeg.override {
            withUnfree = true;
            withDav1d = true;
            withSvtav1 = true;
            withX264 = true;
            withX265 = true;
            withXvid = true;
            withFdkAac = true;
            withMp3lame = true;
            withOpus = true;
            withCuda = true;
            withZimg = true;
        };
        prismlauncher-riley = super.prismlauncher.override {
          jdks = with pkgs; [
            graalvm-ce
            zulu8
            zulu17
            zulu
          ];
        };
    })
  ];
}
