{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./git.nix
        ./zsh.nix
        ./tmux.nix
    ];
    home.packages = with pkgs; [
        fortune
        lolcat
        neofetch
        htop
    ];
}