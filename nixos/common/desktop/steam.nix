{ config, lib, pkgs, ...}: 
with lib;
with pkgs;

{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
	};
}
