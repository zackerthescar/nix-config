{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./theme/gtk.nix
        ./mpv.nix
        ./vscode.nix
        ./discord.nix
	./virt-manager.nix
    ];
    home.packages = with pkgs; [
        papirus-icon-theme
        firefox
        yt-dlp
        #spotify
        reaper
        vlc
        caffeine-ng
	chromium
    ];
}
