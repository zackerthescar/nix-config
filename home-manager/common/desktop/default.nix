{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./theme/gtk.nix
        ./mpv.nix
        ./vscode.nix
        ./discord.nix
    ];
    home.packages = with pkgs; [
        papirus-icon-theme
        firefox
        yt-dlp
        spotify
    ];
}