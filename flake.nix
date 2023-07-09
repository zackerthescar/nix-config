{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    ssh-keys = {
      url = "https://github.com/zackerthescar.keys";
      flake = false;
    };

  };

  outputs = { nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # Thinkpad T520
      pathfinder = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./nixos/pathfinder/configuration.nix
          # nixos-hardware.nixosModules.lenovo-thinkpad-t520
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import ./home-manager/pathfinder/home.nix;
          }
        ];
      };
    };
  };
}
