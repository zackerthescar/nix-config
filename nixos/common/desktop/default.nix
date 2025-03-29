{ config, pkgs, ... }:

{
    imports = [
        ./fonts.nix
        ./gnome.nix
        # ./plasma.nix
        ./steam.nix
        ./services.nix
    ];
}
