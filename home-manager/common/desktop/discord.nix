{ config, pkgs, ...}:

{
    nixpkgs.overlays = [
        (self:
            super: {
                discord = super.discord.overrideAttrs (
                _: { src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz;
                }
                );
            }
        )
  ];
    home.packages = with pkgs; [
        discord
	xwaylandvideobridge
    ];
}
