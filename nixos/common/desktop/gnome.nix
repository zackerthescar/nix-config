{ config, pkgs, ... }:

{
    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];
    programs.dconf.enable = true;
      # GNOME
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
}
