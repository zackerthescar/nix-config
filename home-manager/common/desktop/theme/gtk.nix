{ config, lib, pkgs, ...}:

with lib;
with pkgs;

let
    gtkLatte = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "teal" ];
        shade = "light";
        size = "compact";
        tweaks = [ "macos" ];
    };
    gtkMacchiato = pkgs.magnetic-catppuccin-gtk.override {
        accent = [ "teal" ];
        size = "compact";
        tweaks = [ "macchiato" "macos" ];
    };
    gtkThemeLatte = "Catppuccin-GTK-Teal-Light-Compact";
    gtkThemeMacchiato = "Catppuccin-GTK-Teal-Dark-Compact-Macchiato";
    cursorLatte = "catppuccin-latte-teal-cursors";
    cursorMacchiato = "catppuccin-macchiato-teal-cursors";
    iconLight = "Papirus-Light";
    iconDark = "Papirus-Dark";
in
{
    gtk = {
        enable = true;
        theme = {
            name = gtkThemeMacchiato;
            package = gtkMacchiato;
        };
        cursorTheme = {
            package = pkgs.catppuccin-cursors.macchiatoTeal;
            name = cursorMacchiato;
        };
        iconTheme = {
            name = iconDark;
            package = pkgs.papirus-icon-theme;
        };
        # Disable home-manager's static gtk-4.0/gtk.css so darkman can manage it.
        gtk4.theme = null;
    };
    home.sessionVariables = {
            NIXOS_OZONE_WL = "1";
    };
    home.packages = with pkgs; [
        gtkLatte
        catppuccin-cursors.latteTeal
        pkgs.gnome-tweaks
        catppuccin-cursors
        gnomeExtensions.user-themes
	    gnomeExtensions.arcmenu
        gnomeExtensions.dash-to-dock
        gnomeExtensions.brightness-control-using-ddcutil
    ];
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            font-name = "Atkinson Hyperlegible Next 12";
            document-font-name = "IBM Plex Serif 12";
            monospace-font-name = "Cascadia Mono 12";
            font-antialiasing = "rgba";
        };
        "org/gnome/desktop/wm/preferences" = {
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
        "org/gnome/desktop/peripherals/touchpad" = {
            tap-to-click = "true";
        };
    };

    services.darkman = {
        enable = true;
        settings = {
            lat = 37.7749;
            lng = -122.4194;
            usegeoclue = false;
        };
        darkModeScripts.gnome-theme = ''
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"
            ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/user-theme/name "'${gtkThemeMacchiato}'"
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme '${gtkThemeMacchiato}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme '${cursorMacchiato}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme '${iconDark}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.wm.preferences theme '${gtkThemeMacchiato}'
            mkdir -p "$HOME/.config/gtk-4.0"
            cat > "$HOME/.config/gtk-4.0/gtk.css" <<EOF
            @import url("file://${gtkMacchiato}/share/themes/${gtkThemeMacchiato}/gtk-4.0/gtk.css");
            EOF
        '';
        lightModeScripts.gnome-theme = ''
            ${pkgs.dconf}/bin/dconf write /org/gnome/desktop/interface/color-scheme "'prefer-light'"
            ${pkgs.dconf}/bin/dconf write /org/gnome/shell/extensions/user-theme/name "'${gtkThemeLatte}'"
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface gtk-theme '${gtkThemeLatte}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface cursor-theme '${cursorLatte}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface icon-theme '${iconLight}'
            ${pkgs.glib}/bin/gsettings set org.gnome.desktop.wm.preferences theme '${gtkThemeLatte}'
            mkdir -p "$HOME/.config/gtk-4.0"
            cat > "$HOME/.config/gtk-4.0/gtk.css" <<EOF
            @import url("file://${gtkLatte}/share/themes/${gtkThemeLatte}/gtk-4.0/gtk.css");
            EOF
        '';
    };

    # On every home-manager switch, replay the appropriate darkman script so
    # gsettings + gtk-4.0/gtk.css match the current dark/light state.
    home.activation.refreshDarkmanState = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if ${pkgs.systemd}/bin/systemctl --user is-active darkman.service >/dev/null 2>&1; then
            mode=$(${pkgs.darkman}/bin/darkman get 2>/dev/null || echo dark)
            script="$HOME/.local/share/$mode-mode.d/gnome-theme"
            [ -x "$script" ] && $DRY_RUN_CMD "$script" || true
        fi
    '';
}
