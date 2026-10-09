{ config, lib, pkgs, ...}:

{
    # home.username and home.homeDirectory come from users.users.<name>
    # through the home-manager NixOS and nix-darwin modules.
    home.stateVersion = lib.mkDefault "22.05";
    programs.home-manager.enable = true;

    imports = [
        ./git.nix
        ./zsh.nix
        ./tmux.nix
        ./zellij.nix
    ];
    home.packages = with pkgs; [
        fortune
        lolcat
        fastfetch
        hyfetch
        htop
        btop
        (lib.hiPrio ffmpreg)
    ] ++ lib.optionals stdenv.hostPlatform.isLinux [
        # The darwin hosts get MacTeX from Homebrew.
        texliveMedium
        texlivePackages.preprint
        texlivePackages.enumitem
        texlivePackages.hvfloat
        texlivePackages.titlesec
        texlivePackages.marvosym
        texlivePackages.fancyhdr
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
        ffmpeg
        atomicparsley
        flac
    ];
}
