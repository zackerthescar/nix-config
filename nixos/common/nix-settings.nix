{ config, pkgs, ...}:

{
    nix = {
        package = pkgs.nixFlakes;
        extraOptions = ''
        experimental-features = nix-command flakes
        '';
        settings = {
            auto-optimise-store = true;
        };
  };
  # Allow unfree
  nixpkgs.config.allowUnfree = true;
}