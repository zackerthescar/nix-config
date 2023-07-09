{ config, pkgs, ... }:

{
    services.dbus.enable = true;
    services.dbus.packages = with pkgs; [ dconf ];
    programs.dconf.enable = true;
      # GNOME
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = (with pkgs; [ 
        gnome-photos gnome-tour
        ]) ++ (with pkgs.gnome; [
        gnome-music
        gedit
        epiphany
        geary
        evince
        gnome-characters
        totem
        tali
        iagno
        hitori
        atomix
    ]);
}