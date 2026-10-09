{ config, pkgs, ...}:

{
    nix = {
        extraOptions = ''
        experimental-features = nix-command flakes
        '';
        settings = {
            auto-optimise-store = true;
            # Binary caches for the flake inputs that do not follow our nixpkgs.
            # cache.nixos.org is added by NixOS. Keep this list in sync with
            # nixConfig in flake.nix.
            substituters = [
                "https://nix-community.cachix.org" # lanzaboote
                "https://cache.numtide.com"        # llm-agents
            ];
            trusted-public-keys = [
                "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="            ];
        };
  };
  # Allow unfree
  nixpkgs.config.allowUnfree = true;
}
