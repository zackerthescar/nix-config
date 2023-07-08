{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    gtk = {
        enable = true;
        iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
        };
        theme = {
        name = "Catppuccin-Macchiato-Compact-Teal-Dark";
        package = pkgs.catppuccin-gtk.override {
            accents = [ "teal" ];
            size = "compact";
            variant = "macchiato";
        };
        };
    };
    home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            GTK_THEME = "Catppuccin-Macchiato-Compact-Teal-Dark";
    }; 
    dconf.settings = {
        "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        };
        "org/gnome/desktop/wm/preferences" = {
        theme = "Catppuccin-Macchiato-Compact-Teal-Dark";
        button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" ];
        };
        "org/gnome/shell/extensions/user-theme" = {
        name = "Catppuccin-Macchiato-Compact-Teal-Dark";
        };
    };
}