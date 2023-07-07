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
  };

  home.packages = with pkgs; [
    # commands
    fortune
    lolcat
    neofetch
    htop
    papirus-icon-theme
    firefox
    discord
    mpv
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Macchiato-Compact-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "teal" ];
        size = "compact";
        variant = "macchiato";
      };
    };
  };
  home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GTK_THEME = "Catppuccin-Macchiato-Compact-Teal-Dark";
  }; 
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
    "org/gnome/desktop/wm/preferences" = {
      theme = "Catppuccin-Macchiato-Compact-Teal-Dark";
      button-layout = "appmenu:minimize,maximize,close";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" ];
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Catppuccin-Macchiato-Compact-Teal-Dark";
    };
  };

}

