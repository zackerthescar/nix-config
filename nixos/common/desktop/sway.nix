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
    security.pam.services.login.enableGnomeKeyring = true;
}
