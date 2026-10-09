# hosts/YourHostName/default.nix
{ lib, pkgs, username, ... }:

{
  nix.enable = false;
  users.users.${username}.home = "/Users/${username}";
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  programs.zsh.enable = true;
  system.stateVersion = 5;
  system.primaryUser = username;
  nixpkgs.config.allowUnfree = true;
  imports = [
    ../common/brew.nix
  ];

}

