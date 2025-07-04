{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    home.packages = with pkgs; [
        waybar
        mako
        wl-clipboard
        shotman
        wofi
        xfce.thunar
    ];
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
            modifier = "Mod4";
            terminal = "alacritty";
            bars = [ ];
        };
        extraOptions = [
            "--unsupported-gpu"
        ];
        extraConfig = ''
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
}
