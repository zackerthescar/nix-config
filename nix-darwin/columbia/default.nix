# hosts/YourHostName/default.nix
{ lib, pkgs, ... }:

{

  users.users.zackerthescar.home = "/Users/zackerthescar";
  services.nix-daemon.enable = true;
  # Installs a version of nix, that dosen't need "experimental-features = nix-command flakes" in /etc/nix/nix.conf
  # services.nix-daemon.package = pkgs.nixFlakes;
  programs.zsh.enable = true;
  imports = [
    ./brew.nix
  ];

}

