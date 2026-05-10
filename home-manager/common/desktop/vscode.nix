{ inputs, config, pkgs, ... }:

let
  catppuccin-vsc-teal = inputs.catppuccin-vsc.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
    accent = "teal";
  };
in

{
    home.packages = with pkgs; [
        bison
        flex
        fontforge
        makeWrapper
        pkg-config
        gnumake
        gcc
        libiconv
        autoconf
        automake
        libtool # freetype calls glibtoolize
        python3
    ];
  # vscode config
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions = (with pkgs.vscode-extensions; [
          # C/C++ Extension Pack
          ms-vscode.cpptools
          twxs.cmake
          ms-vscode.cmake-tools
          # Python
          ms-python.python
          # Java
          redhat.java
          vscjava.vscode-java-debug
          # OCaml
          ocamllabs.ocaml-platform
          # Rust
          rust-lang.rust-analyzer
          # Svelte
          svelte.svelte-vscode
          # Nix
          bbenoist.nix
          arrterian.nix-env-selector
          # Remote
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-containers
          # LaTeX
          james-yu.latex-workshop
          # direnv
          mkhl.direnv
        ]) ++ [
          # Theme — flake input lets us bake teal accent in at build time.
          catppuccin-vsc-teal
        ];
        userSettings = {
            "window.titleBarStyle" = "native";
            "claudeCode.claudeProcessWrapper" = "${pkgs.claude-code}/bin/claude";
            "window.autoDetectColorScheme" = true;
            "workbench.preferredLightColorTheme" = "Catppuccin Latte";
            "workbench.preferredDarkColorTheme" = "Catppuccin Macchiato";
        };
      };
    };
  };
  xdg.configFile."containers/registries.conf".text = ''
    [registries.search]
    registries = ['docker.io']
  '';
}

