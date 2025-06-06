{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    home.packages = with pkgs; [
        kdePackages.plasma-desktop
    ];
    gtk = {
        enable = true;
        iconTheme = {
            name = "Papirus-Light";
            package = pkgs.papirus-icon-theme;
        };
        theme = {
            name = "catppuccin-macchiato-teal-compact";
            package = pkgs.catppuccin-gtk.override {
                accents = [ "teal" ];
                size = "compact";
                variant = "macchiato";
            };
        };
    };
    qt = {
        enable = true;
        style = {
            name = "Catppuccin-Macchiato-Teal";
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
            GTK_THEME = "catppuccin-macchiato-teal-compact";
    }; 
    programs.plasma = {
        enable = true;
        workspace = {
            iconTheme = "Papirus-Dark";
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
