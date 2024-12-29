# ./overlays/default.nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
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
    })
  ];
}
