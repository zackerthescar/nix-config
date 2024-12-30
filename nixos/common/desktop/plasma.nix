{ config, pkgs, ... }:

{
    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];
    programs.dconf.enable = true;
    # SDDM
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    # KDE
    services.desktopManager.plasma6.enable = true;
}
