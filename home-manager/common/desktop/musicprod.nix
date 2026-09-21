{ config, pkgs, ...}:
{

    home.packages = with pkgs; [
		(pkgs.reaper.override { jackLibrary = pkgs.pipewire.jack; })
		lmms
		hydrogen
		chow-kick
		chow-tape-model
		supercollider
		neural-amp-modeler-lv2
		airwindows-lv2
    ];
}
