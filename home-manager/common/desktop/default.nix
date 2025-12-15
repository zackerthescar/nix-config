{ inputs, config, lib, pkgs, catppuccin, ...}:

with pkgs;

{
    imports = [
        # ./theme/gtk.nix
        ./theme/plasma.nix
        # ./theme/sway.nix
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
        alacritty
        obs-studio-riley
        inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
        alvr
    ];
    catppuccin = {
        enable = true;
        accent = "teal";
        flavor = "macchiato";
    };
}
