{ inputs, username, config, pkgs, lib, ...}:

let
   inherit (inputs) ssh-keys;
in

{
  programs.zsh.enable = true;
  hardware.i2c.enable = true;
  users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "gamemode" "podman" "i2c" ];
      home = "/home/${username}";
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
