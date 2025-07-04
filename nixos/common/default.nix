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
    programs.ssh.forwardX11 = true;
    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    nano
    tpm2-tss
    tpm2-tools
    (lib.hiPrio pkgs.uutils-coreutils-noprefix)
    podman-compose
    docker-compose
  ];
}
