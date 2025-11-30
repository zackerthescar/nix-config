{ inputs, config, pkgs, lib, ...}:

let
   inherit (inputs) ssh-keys;
in

{
  programs.zsh.enable = true;
  users.users.zackerthescar = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "gamemode" "podman" ];
      home = "/home/zackerthescar";
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = 
	let 
		keys = builtins.readFile ssh-keys;
		keyList = builtins.filter (key: key != "")
			(lib.splitString "\n" keys);
		in
		keyList;
   };
}
