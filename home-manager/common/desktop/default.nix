{ config, lib, pkgs, ...}:

{
    # The Linux-only modules gate themselves with pkgs.stdenv.hostPlatform.isLinux.
    # The imports list cannot depend on pkgs.
    imports = [
        ./theme/gtk.nix
        # ./theme/plasma.nix
        # ./theme/sway.nix
        ./mpv.nix
        ./vscode.nix
        ./discord.nix
        ./virt-manager.nix
    ];
    home.packages = with pkgs; [
        yt-dlp
        signal-desktop
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
        firefox
        spotify
        reaper
        vlc
        caffeine-ng
        musescore
        telegram-desktop
        prismlauncher-riley
        ckan
        calibre
        alacritty
        obs-studio-riley
        ghostty
        alvr
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
        # Firefox, Discord and Calibre come from Homebrew casks.
        ghostty-bin
        google-chrome
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
