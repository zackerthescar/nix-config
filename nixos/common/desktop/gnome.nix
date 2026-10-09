{ config, pkgs, ... }:

{
    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];
    programs.dconf.enable = true;
      # GNOME
    services.xserver.enable = true;
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;
}
