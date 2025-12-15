{ config, pkgs, ...}:
{
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    services.printing.enable = true;
    security.polkit.enable = true;
    services.pcscd.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-curses;
    };
    services.udev.packages = [ pkgs.android-udev-rules ];
}
