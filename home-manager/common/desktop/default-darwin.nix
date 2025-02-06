{ config, lib, pkgs, ...}:

with pkgs;

{
    imports = [
        ./mpv.nix
        ./vscode-darwin.nix
        # ./discord.nix
	./virt-manager.nix
    ];
    home.packages = with pkgs; [
        # firefox
        yt-dlp
        spotify
        # vlc
	musescore
	iterm2
	utm
    ];
}
