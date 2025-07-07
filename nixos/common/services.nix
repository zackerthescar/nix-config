{ config, pkgs, ...}:
{
    services.tailscale.enable = false;
    networking.firewall.enable = false;
    services.openssh.enable = true;
    virtualisation.libvirtd.enable = true;
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };
}
