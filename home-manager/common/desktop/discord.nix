{ config, pkgs, ...}: {
    home.packages = with pkgs; [
        kdePackages.xwaylandvideobridge
        legcord
    ];
}
