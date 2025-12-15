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
            GTK_THEME = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
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
            document-font-name = "IBM Plex Serif 10";
            monospace-font-name = "Cascadia Mono 10";
            font-antialiasing = "rgba";
        };
        "org/gnome/desktop/wm/preferences" = {
        	theme = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
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
        	name = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
        };
        "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = "true";
        };
    };
}
