{ config, lib, pkgs, ...}:
# The darwin hosts get Discord from a Homebrew cask.
lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    home.packages = with pkgs; [
        discord
    ];
}
