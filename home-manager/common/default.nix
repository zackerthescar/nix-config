{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./git.nix
        ./zsh.nix
        ./tmux.nix
        ./zellij.nix
        ./ffmpeg.nix
    ];
    home.packages = with pkgs; [
        fortune
        lolcat
        fastfetch
        hyfetch
        htop
        btop
        wimlib
        texliveMedium
        texlivePackages.preprint
        texlivePackages.enumitem
        texlivePackages.hvfloat
        texlivePackages.titlesec
        texlivePackages.marvosym
        texlivePackages.fancyhdr
    ];
}
