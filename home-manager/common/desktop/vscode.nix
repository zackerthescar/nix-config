{ config, pkgs, ... }:

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
        ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "claude-code";
            publisher = "anthropic";
            version = "2.1.116";
            sha256 = "1dh59kh8vlvdhpwg35w379qlw3nnw9h2igp5adifcs86hiww9cp3";
          }
        ];
        userSettings = {
            "window.titleBarStyle" = "native";
        };
      };
    };
  };
  xdg.configFile."containers/registries.conf".text = ''
    [registries.search]
    registries = ['docker.io']
  '';
}

