{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    home.packages = with pkgs; [
        kdePackages.plasma-desktop
    ];
    gtk = {
        enable = true;
        theme = {
            name = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
            package = pkgs.magnetic-catppuccin-gtk.override {
                accent = [ "teal" ] ;
                size = "compact";
                tweaks = [ "macchiato" "float" "macos" ];
            };
        };
    };
    qt = {
        enable = true;
        style = {
            name = "kvantum";
            package = pkgs.catppuccin-kde.override {
                accents = [ "teal" ];
                flavour = [ "macchiato" ];
                winDecStyles = [ "modern" "classic" ];
            };
        };
        platformTheme = {
            name = "Catppuccin-Macchiato-Teal";
        };
    };
    home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            GTK_THEME = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
    }; 
    programs.plasma = {
        enable = true;
        workspace = {
            # iconTheme = "Papirus-Dark";
            lookAndFeel = "Catppuccin-Macchiato-Teal";
        };
        panels = [
            {
                location = "bottom";
                height = 32;
                floating = true;
            }
        ];
    };
}
