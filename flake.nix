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

outputs = { nixpkgs, home-manager, nixos-hardware, darwin, lanzaboote, plasma-manager, zen-browser, ... }@inputs:
  let
    nixosMachines = {
      pathfinder = {
        extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-t520 ];
      };
      agena = {
        # Agena is bog standard
      };
      atlantis = {
        extraModules = [
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };

    darwinMachines = {
      discovery = {
        system = "aarch64-darwin";
      };
    };

    mkNixOsSystem = name: config: 
      let
        configPath = config.configPath or (./nixos + "/${name}/configuration.nix");
        homePath = config.homePath or (./home-manager + "/${name}/home.nix");
        defaults = {
          system = "x86_64-linux";
          backupExtension = "backup";
          extraModules = [];
          homeExtraArgs = {};
        };
        cfg = defaults // config;  # You need to merge config with defaults
      in
      nixpkgs.lib.nixosSystem {
        system = cfg.system;
        specialArgs = { inherit inputs; };  # Missing semicolon here
        modules = [
          configPath
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; } // cfg.homeExtraArgs;
            home-manager.users.zackerthescar = import homePath;
            home-manager.backupFileExtension = cfg.backupExtension;  # Use cfg instead of defaults
          }
          (import ./overlays/default.nix)
        ] ++ cfg.extraModules;
      };

  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkNixOsSystem nixosMachines;
    # You'll need to add darwinConfigurations too if you want them
  };
}
