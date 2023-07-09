{ config, pkgs, ...}:

{
  programs.zsh.enable = true;
  users.users.zackerthescar = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" ];
      home = "/home/zackerthescar";
      shell = pkgs.zsh;
   };
}