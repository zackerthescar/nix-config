{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./git.nix
        ./zsh.nix
        ./tmux.nix
        ./zellij.nix
    ];
    home.packages = with pkgs; [
        fortune
        lolcat
        fastfetch
        hyfetch
        htop
        btop
        ffmpeg
        ghostty-bin
        (pkgs.lib.hiPrio pkgs.ffmpreg)
        atomicparsley
        flac
    ];
}
