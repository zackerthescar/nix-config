# hosts/YourHostName/default.nix
{ lib, pkgs, ... }:

{

  users.users.zackerthescar.home = "/Users/zackerthescar";
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  programs.zsh.enable = true;
  system.stateVersion = 5;
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../common/brew.nix
  ];

}

