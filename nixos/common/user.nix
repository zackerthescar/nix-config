{ inputs, config, pkgs, ...}:

let
   inherit (inputs) ssh-keys;
in

{
  programs.zsh.enable = true;
  users.users.zackerthescar = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "gamemode" ];
      home = "/home/zackerthescar";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [ ssh-keys.outPath ];
   };
}