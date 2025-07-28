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
            name = "catppuccin-macchiato-teal-compact";
            package = pkgs.catppuccin-gtk.override {
                accents = [ "teal" ];
                size = "compact";
                variant = "macchiato";
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
    home.packages = with pkgs; [
        pkgs.gnome-tweaks
        catppuccin-cursors
        gnomeExtensions.user-themes
	    gnomeExtensions.arcmenu
        gnomeExtensions.blur-my-shell
        gnomeExtensions.dash-to-dock
    ];
    dconf.settings = {
        "org/gnome/desktop/interface" = {
        	color-scheme = "prefer-dark";
            font-name = "Atkinson Hyperlegible Next 10";
            monospace-font-name = "Cascadia Mono 10";
            font-antialiasing = "rgba";
        };
        "org/gnome/desktop/wm/preferences" = {
        	theme = "catppuccin-macchiato-teal-compact";
        	button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/shell" = {
        	disable-user-extensions = false;
        	enabled-extensions = [ 
                "user-theme@gnome-shell-extensions.gcampax.github.com" 
                "arcmenu@arcmenu.com"
                "blur-my-shell@aunetx"
                "dash-to-dock@micxgx.gmail.com"
		    ];
        };
        "org/gnome/shell/extensions/user-theme" = {
        	name = "catppuccin-macchiato-teal-compact";
        };
        "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = "true";
        };
    };
}
