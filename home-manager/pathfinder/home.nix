{ config, lib, pkgs, ... }:

with lib;
with pkgs;
let
  browser = [ "firefox.desktop" ];
  associations = {
    "text/html" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/chrome" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/unknown" = browser;
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/xhtml+xml" = browser;
    "application/x-extension-xhtml" = browser;
    "application/x-extension-xht" = browser;

    "audio/*" = [ "vlc.desktop" ];
    "video/*" = [ "vlc.dekstop" ];
    #"image/*" = [ "ahoviewer.desktop" ];
    #"text/calendar" = [ "thunderbird.desktop" ]; # ".ics"  iCalendar format
    "application/json" = browser; # ".json"  JSON format
    "application/pdf" = browser; # ".pdf"  Adobe Portable Document Format (PDF)
  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "zackerthescar";
  home.homeDirectory = "/home/zackerthescar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (self:
      super: {
        discord = super.discord.overrideAttrs (
          _: { src = builtins.fetchTarball https://discord.com/api/download?platform=linux&format=tar.gz;
        }
        );
      }
    )
  ];

  # Git config
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Shaun Loo";
    userEmail = "shaunloo10@gmail.com";
    extraConfig = {
      core.editor = "vim";
      credential.helper = "cache";
      init.defaultBranch = "main";
    };
  };

  # tmux config
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
  };

  # zsh config
  programs.zsh = {
    enable = true;
    history = {
      size = 8192;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    zplug =  {
      enable = true;
      plugins = [
        { name = "plugins/colored-man-pages"; tags = [from:oh-my-zsh]; }
        { name = "plugins/colorize";          tags = [from:oh-my-zsh]; }
        { name = "plugins/command-not-found"; tags = [from:oh-my-zsh]; }
        { name = "plugins/fd";                tags = [from:oh-my-zsh]; }
        { name = "plugins/fzf";               tags = [from:oh-my-zsh]; }
        { name = "plugins/git";               tags = [from:oh-my-zsh]; }
        { name = "plugins/ripgrep";           tags = [from:oh-my-zsh]; }
        { name = "plugins/tmux";              tags = [from:oh-my-zsh]; }
        { name = "zsh-users/zsh-autosuggestions";}
        { name = "zsh-users/zsh-syntax-highlighting";}
        { name = "zsh-users/zsh-history-substring-search";}
        { name = "themes/theunraveler";      tags = [from:oh-my-zsh]; }
      # { name = "plugins/vi-mode";           tags = [from:oh-my-zsh]; }
      # { name = "plugins/cargo";             tags = [from:oh-my-zsh]; }
      # { name = "plugins/direnv";            tags = [from:oh-my-zsh]; }
      # { name = "plugins/pass";              tags = [from:oh-my-zsh]; }
      # { name = "plugins/rsync";             tags = [from:oh-my-zsh]; }
      # { name = "plugins/"; tags = [from:oh-my-zsh]; }
      { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
      # { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      ];
    };
  };

  #fzf
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # vscode config
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      arcticicestudio.nord-visual-studio-code
      ms-vscode-remote.remote-ssh
      yzhang.markdown-all-in-one
      ms-python.python
      ms-python.vscode-pylance
      redhat.java
      ms-vscode.cpptools
    ];
  };

  # mako config
  programs.mako = {
    enable = true;
    defaultTimeout = 2500;
  };

  # waybar config
  programs.waybar = {
    enable = true;
    package = (pkgs.waybar.override (oldAttrs: { pulseSupport = true;} ));
    settings = [{
      layer = "top";
      position = "top";
      height = 12;
      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [ "network" "pulseaudio" "battery" "clock" "tray" ];
    }];
  };

  # sway config
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      terminal = "alacritty";
      menu = "wofi --show drun -I";
      bars = [{
        fonts.size = 12.0;
        position = "top";
        command = "waybar";
      }]; 
      modifier = "Mod4";
      input = lib.mkOptionDefault {
        "type:touchpad" = {
          tap = "enabled";
        };
      };
      keybindings = lib.mkOptionDefault {
        "XF86MonBrightnessDown" = "exec light -U 10";
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86AudioMute" = "exec 'pamixer -t'";
        "XF86AudioRaiseVolume" = "exec 'pamixer -i 5'";
        "XF86AudioLowerVolume" = "exec 'pamixer -d 5'";
        "XF86AudioMicMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";
      };
      startup = [
        { command = "dbus-sway-environment";}
        { command = "configure-gtk";}
      ];
    };
  };


  home.packages = with pkgs; [
    # commands
    fortune
    lolcat
    neofetch
    htop
    # Sway stuff
    swaylock
    swayidle
    wl-clipboard
    mako
    alacritty
    wofi
    waybar
    grim
    slurp
    pamixer
    # Theme
    nordic
    papirus-icon-theme
    firefox-wayland
    discord
    vlc
    spotify
  ];

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway";
    NIXOS_OZONE_WL = 1;
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
  };

  gtk = {
    enable = true;
    font.name = "Noto Sans";
    theme = {
      name = "Nordic-darker";
      package = pkgs.nordic;
    };
    iconTheme = {
      name = "Papirus-dark";
      package = pkgs.papirus-icon-theme;
    };
  };
}


