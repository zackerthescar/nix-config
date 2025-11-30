{ config, pkgs, ... }:

{
    imports = [
        ./fonts.nix
        # ./gnome.nix
        ./plasma.nix
        # ./sway.nix
        ./steam.nix
        ./services.nix
    ];
}
