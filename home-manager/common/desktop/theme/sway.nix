{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    wayland.windowManager.sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        config = rec {
            modifier = "Mod4";
            terminal = "alacritty";
        };
        extraOptions = [
            "--unsupported-gpu"
        ];
    };
}
