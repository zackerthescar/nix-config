{ inputs, config, lib, pkgs, ... }:

let
  inherit (pkgs.stdenv.hostPlatform) isLinux;
  llm-agents = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
  # The extension runs `<wrapper> <bundled claude> <args...>`, so drop the
  # bundled binary and run the llm-agents claude-code instead.
  claude-vscode-wrapper = pkgs.writeShellScript "claude-vscode-wrapper" ''
    case "''${1-}" in */claude) shift ;; esac
    exec ${llm-agents.claude-code}/bin/claude "$@"
  '';
in

{
    home.packages = lib.optionals isLinux (with pkgs; [
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
        distrobox
    ] ++ [
        llm-agents.claude-code
        llm-agents.codex
    ]);
  # vscode config
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles = {
      default = {
        extensions = (with pkgs.vscode-extensions; lib.optionals isLinux [
          # C/C++ Extension Pack
          ms-vscode.cpptools
          twxs.cmake
          ms-vscode.cmake-tools
          # Claude Code (CLI comes from llm-agents, see claudeProcessWrapper)
          anthropic.claude-code
        ] ++ [
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
        ]);
        # The Catppuccin theme and icons come from catppuccin.vscode
        # (catppuccin/nix), with the global accent built in.
        userSettings = {
            "window.titleBarStyle" = "native";
        } // lib.optionalAttrs isLinux {
            "claudeCode.claudeProcessWrapper" = "${claude-vscode-wrapper}";
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
