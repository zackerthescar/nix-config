{ config, pkgs, lib, ...}:
{

    home.packages = with pkgs; [
        ffmpeg-riley
    ];
}
