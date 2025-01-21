{ config, pkgs, ...}:
{

    home.packages = with pkgs; [
		reaper
		lmms
		hydrogen
		chow-kick
		chow-tape-model
		supercollider
		neural-amp-modeler-lv2
		airwindows-lv2
    ];
}
