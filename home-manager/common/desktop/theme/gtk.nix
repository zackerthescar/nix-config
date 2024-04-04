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
    home.packages = with pkgs; [
        gnome.gnome-tweaks
        gnomeExtensions.user-themes
	gnomeExtensions.dash-to-panel
	gnomeExtensions.arcmenu	
    ];
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
        	enabled-extensions = [ 
			"user-theme@gnome-shell-extensions.gcampax.github.com" 
			"arcmenu@arcmenu.com"
			"dash-to-panel@jderose9.github.com"
		];
        };
        "org/gnome/shell/extensions/user-theme" = {
        	name = "Catppuccin-Macchiato-Compact-Teal-Dark";
        };
	"org/gnome/desktop/peripherals/touchpad" = {
		tap-to-click = "true";
	};
	"org/gnome/shell/extensions/dash-to-panel" = {
		panel-sizes = "{\"0\":32}";
		appicon-margin = 0;
		panel-element-positions =   "{\"0\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"centerBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":true,\"position\":\"stackedBR\"}]}";
	};
    };
}
