{
  description = "Your new nix config";

  # Binary caches for the inputs that have their own CI cache. The NixOS hosts
  # also get these from nixos/common/nix-settings.nix. This block is for the
  # first build and for the darwin hosts. Nix applies it only for a trusted
  # user, or with --accept-flake-config.
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.numtide.com"
      "https://catppuccin.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # nix-darwin
    darwin.url = "github:nix-darwin/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

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


    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
    };
    # Do not add nixpkgs.follows to llm-agents. Its cache only has the paths
    # built with its own locked nixpkgs.
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };

    open-apollo = {
      url = "github:rolotrealanis98/open-apollo";
    };

    zen-browser = {
    url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

outputs = { nixpkgs, 
            home-manager, 
            nixos-hardware, 
            darwin, 
            lanzaboote, 
            plasma-manager,
            nix-cachyos-kernel,
            catppuccin,
            llm-agents,
            open-apollo,
            zen-browser,
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
          open-apollo.nixosModules.default
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
        backupExtension = "backup-2";
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
          (import ./overlays/default.nix)
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.zackerthescar = import homePath;
            home-manager.backupFileExtension = cfg.backupExtension;
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager zen-browser.homeModules.beta ];
          }
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
            home-manager.backupFileExtension = cfg.backupExtension;
            home-manager.sharedModules = [ catppuccin.homeModules.catppuccin zen-browser.homeModules.beta ];
          }
        ] ++ cfg.extraModules;
      };

  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkNixOsSystem nixosMachines;
    darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinSystem darwinMachines;
  };
}
