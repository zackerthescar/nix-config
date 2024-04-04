{ config, pkgs, ...}:
{
    services.tailscale.enable = false;
    networking.firewall.enable = false;
    services.openssh.enable = true;
    virtualisation.libvirtd.enable = true;
}
