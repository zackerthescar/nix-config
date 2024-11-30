{ config, pkgs, ...}:

{
    # boot.kernelPackages = pkgs.linuxPackages_latest;
    imports = [
        ./user.nix
        ./nix-settings.nix
        ./services.nix
    ];
    environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    nano
    tpm2-tss
    tpm2-tools
  ];
}
