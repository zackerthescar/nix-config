{ pkgs, ...}:

with pkgs;

{
    programs.git = {
        enable = true;
        userName = "Riley Loo";
        userEmail = "dev@zackerthescar.com";
        extraConfig = {
          core.editor = "vim";
          credential.helper = "cache";
          init.defaultBranch = "main";
        };
  };
}
