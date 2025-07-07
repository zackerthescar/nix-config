{ config, pkgs, ... }:

{
    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];
    programs.dconf.enable = true;
    xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        ];
    };
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = true;
    services.gvfs.enable = true;
    services.tumbler.enable = true;
}
