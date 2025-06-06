{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # Apple fonts
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    catppuccin-vsc = {
      url = "https://flakehub.com/f/catppuccin/vscode/*.tar.gz";
    };

    # TODO: Add any other flake you might need
    hardware.url = "github:nixos/nixos-hardware";

    ssh-keys = {
      url = "https://github.com/zackerthescar.keys";
      flake = false;
    };

  };

  outputs = { nixpkgs, home-manager, nixos-hardware, darwin, lanzaboote, plasma-manager, zen-browser, ... }@inputs: {
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
	          home-manager.backupFileExtension = "backup";
          }
        ];
      };
      # Thinkpad X230
      agena = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          ./nixos/agena/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import ./home-manager/agena/home.nix;
	          home-manager.backupFileExtension = "backup";
          }
        ];
      };
      # Custom Desktop
      atlantis = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        modules = [
          lanzaboote.nixosModules.lanzaboote
          ./nixos/atlantis/configuration.nix
          (import ./overlays/default.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; system = "x86_64-linux"; };
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            home-manager.users.zackerthescar = import ./home-manager/atlantis/home.nix;
	          home-manager.backupFileExtension = "backup-2";
          }
        ];
      };
    };
    darwinConfigurations = {
      columbia = darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./nix-darwin/columbia/default.nix
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import ./home-manager/columbia/home.nix;
          }
        ];
      };
      discovery = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [
          ./nix-darwin/discovery/default.nix
          (import ./overlays/default-darwin.nix)
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import ./home-manager/discovery/home.nix;
          }
        ];
      };
    };
  };
}
