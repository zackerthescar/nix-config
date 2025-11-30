{ config, pkgs, ... }:

{
  # vscode config
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
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

