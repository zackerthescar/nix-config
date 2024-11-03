{ config, pkgs, ...}:

{
    nix = {
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
