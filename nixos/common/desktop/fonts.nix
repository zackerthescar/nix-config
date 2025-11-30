{ inputs, config, pkgs, ...}:

with pkgs;

{
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs;  [
        inputs.apple-fonts.packages.${pkgs.system}.sf-pro
        inputs.apple-fonts.packages.${pkgs.system}.sf-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        fira-code
        fira-code-symbols
        mplus-outline-fonts.githubRelease
        dina-font
        proggyfonts
        font-awesome
        cascadia-code
        atkinson-hyperlegible-next
        ibm-plex
      ];
      fontconfig = {
        defaultFonts = {
          serif = [ "IBM Plex Serif" ];
          sansSerif = [ "Atkinson Hyperlegible Next" ];
          monospace = [ "Cascadia Code" ];
        };
      };
  };
}
