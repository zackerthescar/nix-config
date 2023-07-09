{ config, pkgs, ...}:
{
    services.tailscale.enable = true;
    networking.firewall.enable = true;
    networking.firewall.checkReversePath = "loose";
    services.openssh.enable = true;
}