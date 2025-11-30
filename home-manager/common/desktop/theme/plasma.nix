{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    home.packages = with pkgs; [
        kdePackages.plasma-desktop
    ];
    home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
    }; 
    programs.plasma = {
        enable = true;
        panels = [
            {
                location = "bottom";
                height = 32;
                floating = true;
            }
        ];
    };
}
