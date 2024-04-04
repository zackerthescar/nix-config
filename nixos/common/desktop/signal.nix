{ config, lib, pkgs, ...}: 
with lib;
with pkgs;

{
	environment.systemPackages = with pkgs; [
		signal-desktop
	];
}
