{ config, pkgs, lib, ...}:
{
    nixpkgs.overlays = with pkgs; [
        (self: super: {
            ffmpeg = ffmpeg.override {
                withFdkAac = true;
            };
        })
    ];

    home.packages = with pkgs; [
        ffmpeg
    ];
}
