{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Thinkpad T520
      pathfinder = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs nix-colors; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ ./nixos/pathfinder/configuration.nix ];
      };
    };

    homeConfigurations = {
      # FIXME replace with your username@hostname
      "zackerthescar@pathfinder" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main home-manager configuration file <
        modules = [ ./home-manager/pathfinder/home.nix ];
      };
    };
  };
}
