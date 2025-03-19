{ config, pkgs, ... }:

{
  # vscode config
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    mutableExtensionsDir = false;
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
        # Nix
        bbenoist.nix
        arrterian.nix-env-selector
	# Remote
	ms-vscode-remote.remote-ssh
        # Theme
        (pkgs.catppuccin-vsc.override {
                accent = "teal";
        })
        # LaTeX
        james-yu.latex-workshop
        # direnv
        mkhl.direnv
    ];
  };
}
