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
        cursorTheme = {
            package = pkgs.catppuccin-cursors.macchiatoTeal;
            name = "catppuccin-macchiato-teal-cursors";
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
