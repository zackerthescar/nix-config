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

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

  };

outputs = { nixpkgs, 
            home-manager, 
            nixos-hardware, 
            darwin, 
            lanzaboote, 
            plasma-manager, 
            zen-browser, 
            ghostty, 
            catppuccin,
            ... 
}@inputs:
  let
    nixosMachines = {
      pathfinder = {
        extraModules = [ nixos-hardware.nixosModules.lenovo-thinkpad-t520 ];
      };
      agena = {
        # Agena is bog standard
      };
      atlantis = {
        backupExtension = "backup-2";
        extraModules = [
          lanzaboote.nixosModules.lanzaboote
        ];
        homeExtraArgs = { system = "x86_64-linux"; };
      };
      endurance = {
        homeExtraArgs = { system = "x86_64-linux"; };
      };
    };

    darwinMachines = {
      columbia = {
        system = "x86_64-darwin";
      };
      discovery = {
        system = "aarch64-darwin";
        extraModules = [
          (import ./overlays/default-darwin.nix)
        ];
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
        cfg = defaults // config;
      in
      nixpkgs.lib.nixosSystem {
        system = cfg.system;
        specialArgs = { inherit inputs; };
        modules = [
          configPath
          catppuccin.nixosModules.catppuccin
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import homePath;
            home-manager.backupFileExtension = cfg.backupExtension;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager catppuccin.homeModules.catppuccin ];
          }
          (import ./overlays/default.nix)
        ] ++ cfg.extraModules;
      };

    mkDarwinSystem = name: config:
      let
        configPath = config.configPath or (./nix-darwin + "/${name}/default.nix");
        homePath = config.homePath or (./home-manager + "/${name}/home.nix");
        defaults = {
          extraModules = [];
        };
        cfg = defaults // config;
      in
      darwin.lib.darwinSystem {
        system = cfg.system;
        specialArgs = { inherit inputs; };
        modules = [
          configPath
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import homePath;
          }
        ] ++ cfg.extraModules;
      };

  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkNixOsSystem nixosMachines;
    darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinSystem darwinMachines;
  };
}
