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
        iterm2
        utm
        #calibre
        # virt-manager
        alacritty
    ];
    catppuccin = {
        autoEnable = true;
        enable = true;
        accent = "teal";
        flavor = "macchiato";
    };
}
