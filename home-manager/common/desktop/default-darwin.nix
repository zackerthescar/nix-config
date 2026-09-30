{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./mpv.nix
        ./vscode-darwin.nix
        # ./discord.nix
        # ./virt-manager.nix
    ];
    home.packages = with pkgs; [
        # firefox
        yt-dlp
        # spotify
        # vlc
        #calibre
        # virt-manager
        ghostty-bin
        google-chrome
        signal-desktop
    ];
    catppuccin = {
        autoEnable = true;
        enable = true;
        accent = "teal";
        flavor = "macchiato";
    };
    programs.zen-browser = {
        enable = true;
    };
}
