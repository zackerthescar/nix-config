{ config, pkgs, ...}:

with pkgs;

{
    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs;  [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        font-awesome
        cascadia-code
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "Cascadia Code" ];
        };
      };
  };
}