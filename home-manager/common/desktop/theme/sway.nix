{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    services.gnome-keyring.enable = true;
    home.packages = with pkgs; [
        mako
        wl-clipboard
        shotman
        wofi
        xfce.thunar
        pkgs.gcr
    ];
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
            modifier = "Mod4";
            terminal = "alacritty";
            bars = [ ];
            output = {
                "DP-1" = {
                    pos = "0 0";
                    res = "1920x1080@143.981Hz";
                    bg = "${../../../../assets/celeste.png} fill";
                };
                "DVI-D-1" = {
                    pos = "1920 15";
                    res = "1680x1050@59.954Hz";
                    bg = "${../../../../assets/bocchi.jpg} fill";
                };
            };
        };
        extraOptions = [
            "--unsupported-gpu"
        ];
        extraConfig = ''
            font pango:Atkinson Hyperlegible Next Regular 10
            bar {
                swaybar_command waybar
            }
            exec mako

            set $application_launcher       pgrep wofi >/dev/null 2>&1 && killall wofi || wofi --show drun
            set $file_explorer              thunar
            set $term                       alacritty
            set $mod                        Mod4

            gaps inner 8px
            gaps outer 4px
            default_border pixel 1px
            default_floating_border pixel 1px
            client.focused              #8bd5ca #1e2030 #cad3f5 #8bd5ca #8bd5ca
            client.focused_inactive     #6e738d #1e2030 #cad3f5 #6e738d #6e738d
            client.unfocused            #6e738d #1e2030 #cad3f5 #6e738d #6e738d
            client.urgent               #ed8796 #1e2030 #cad3f5 #ed8796 #ed8796
            client.placeholder          #6e738d #1e2030 #cad3f5 #6e738d #6e738d
            bindsym Print                   exec shotman -c output
            bindsym Print+Shift             exec shotman -c region
            bindsym Print+Shift+Control     exec shotman -c window
            bindsym $mod+Return             exec $term
            bindsym $mod+e                  exec $file_explorer
            bindsym $mod+d                  exec $application_launcher
            bindsym $mod+q                  kill
            bindsym $mod+Shift+c            reload
            bindsym $mod+Shift+space        floating toggle
        '';
    };
    programs.waybar = {
        enable = true;
        package = pkgs.waybar;
        style = builtins.readFile ./style.css;
        settings = {
            mainBar = {
                layer = "top";
                position = "top";
                height = 32;
                spacing = 4;
                modules-left = [ "sway/workspaces" "sway/mode" ];
                modules-center = [ "custom/applauncher" ];
                modules-right = [ "pulseaudio" "network" "tray" "clock"];
                pulseaudio = {
                    on-click = "pavucontrol";
                };
            };
        };
    };
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
}
