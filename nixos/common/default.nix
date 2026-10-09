{ config, pkgs, ...}:

{
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    imports = [
        ./user.nix
        ./nix-settings.nix
        ./services.nix
    ];
    programs.gamemode = {
      enable = true;
      settings.gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    networking.networkmanager.enable = true;
    services.xserver.xkb.layout = "us";
    environment.shells = [pkgs.bash pkgs.zsh];
    programs.ssh.forwardX11 = true;
    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    nano
    tpm2-tss
    tpm2-tools
    podman-compose
    docker-compose
    xauth
    gnupg
    exfat
    exfatprogs
    e2fsprogs
    i2c-tools
    ddcutil
    ];
}
