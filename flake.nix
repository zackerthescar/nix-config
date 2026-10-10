{
  description = "zackerthescar's NixOS and nix-darwin configurations";

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

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    ssh-keys = {
      url = "https://github.com/zackerthescar.keys";
      flake = false;
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
            catppuccin,
            llm-agents,
            open-apollo,
            zen-browser,
            ... 
}@inputs:
  let
    # The one user account on every host.
    username = "zackerthescar";

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
        extraModules = [
          lanzaboote.nixosModules.lanzaboote
          nixos-hardware.nixosModules.lenovo-thinkpad-x1-nano-gen1
        ];
        homeExtraArgs = { system = "x86_64-linux"; };
      };
    };

    darwinMachines = {
      discovery = {
        system = "aarch64-darwin";
        backupExtension = "backup-2";
      };
    };

    # Home-manager settings that NixOS and nix-darwin hosts share.
    # extraSharedModules adds the platform-specific home modules.
    # homePath is optional. Add home-manager/<host>/home.nix only for settings
    # that one host needs.
    mkHomeManager = cfg: homePath: extraSharedModules: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs username; };
      home-manager.users.${username}.imports = [
        ./home-manager/common/default.nix
        ./home-manager/common/desktop/default.nix
      ] ++ nixpkgs.lib.optional (builtins.pathExists homePath) homePath;
      home-manager.backupFileExtension = cfg.backupExtension;
      home-manager.sharedModules = [
        catppuccin.homeModules.catppuccin
        zen-browser.homeModules.beta
      ] ++ extraSharedModules;
    };

    mkNixOsSystem = name: config: 
      let
        configPath = config.configPath or (./nixos + "/${name}/configuration.nix");
        homePath = config.homePath or (./home-manager + "/${name}/home.nix");
        defaults = {
          backupExtension = "backup";
          extraModules = [];
          homeExtraArgs = {};
        };
        cfg = defaults // config;
      in
      # Each host's hardware-configuration.nix sets nixpkgs.hostPlatform.
      nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs username; };
        modules = [
          configPath
          ./overlays/default.nix
          home-manager.nixosModules.home-manager
          (mkHomeManager cfg homePath [ plasma-manager.homeModules.plasma-manager ])
        ] ++ cfg.extraModules;
      };

    mkDarwinSystem = name: config:
      let
        configPath = config.configPath or (./nix-darwin + "/${name}/default.nix");
        homePath = config.homePath or (./home-manager + "/${name}/home.nix");
        defaults = {
          backupExtension = "backup";
          extraModules = [];
        };
        cfg = defaults // config;
      in
      darwin.lib.darwinSystem {
        system = cfg.system;
        specialArgs = { inherit inputs username; };
        modules = [
          configPath
          ./overlays/default.nix
          home-manager.darwinModules.home-manager
          (mkHomeManager cfg homePath [ ])
        ] ++ cfg.extraModules;
      };

  in {
    nixosConfigurations = nixpkgs.lib.mapAttrs mkNixOsSystem nixosMachines;
    darwinConfigurations = nixpkgs.lib.mapAttrs mkDarwinSystem darwinMachines;
  };
}
