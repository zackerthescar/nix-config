{ config, pkgs, ... }:

{
    imports = [
        ./fonts.nix
        ./gnome.nix
        ./steam.nix
        ./services.nix
    ];
}