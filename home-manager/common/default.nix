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
        neofetch
        hyfetch
        htop
    ];
}
