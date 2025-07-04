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
    services.gnome.gnome-keyring = {
      enable = true;
    };
}
