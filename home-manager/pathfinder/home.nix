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

  imports = [
    ../programs/git.nix
    ../programs/zsh.nix
  ];

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


  # tmux config
  programs.tmux = {
    enable = true;
    clock24 = true;
    terminal = "screen-256color";
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
    spotify
  ];

}

