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
