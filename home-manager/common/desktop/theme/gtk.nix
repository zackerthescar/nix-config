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
    };
    home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
            GTK_THEME = "catppuccin-macchiato-teal-compact";
    }; 
    home.packages = with pkgs; [
        gnome.gnome-tweaks
        gnomeExtensions.user-themes
	gnomeExtensions.arcmenu	
    ];
    dconf.settings = {
        "org/gnome/desktop/interface" = {
        	color-scheme = "prefer-dark";
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
			"dash-to-panel@jderose9.github.com"
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
