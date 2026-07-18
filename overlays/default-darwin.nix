# ./overlays/default.nix
{ config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
        ffmpreg = ((super.ffmpeg_8).override {
            withUnfree = true;
            withDav1d = true;
            withSvtav1 = true;
            withX264 = true;
            withX265 = true;
            withXvid = true;
            withFdkAac = true;
            withMp3lame = true;
            withOpus = true;
            withZimg = true;
        }).overrideAttrs (old: {
          version = "9.1-git";
            src = super.fetchgit {
              url = "https://code.ffmpeg.org/FFmpeg/FFmpeg.git";
              rev = "74f6cb9e20009dc98fa78de14f21aac9e368e5ee";
              hash = "sha256-RaJacO9mZpEDBw51kxiD5AOpXCs+Qf7c2AB2ZentXic=";
            };
          patches = [];
          doCheck = false;
          configureFlags = super.lib.subtractLists [
            "--disable-libcelt"
            "--disable-libshaderc"
          ] old.configureFlags;
        });
    })
  ];
}
