{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        # ./theme/gtk.nix
        ./theme/plasma.nix
        ./mpv.nix
        ./vscode.nix
        ./discord.nix
	    ./virt-manager.nix
    ];
    home.packages = with pkgs; [
        papirus-icon-theme
        firefox
        yt-dlp
        spotify
        reaper
        vlc
        caffeine-ng
	    musescore
        telegram-desktop
        prismlauncher-riley
        ckan
        calibre
        signal-desktop
    ];
}
