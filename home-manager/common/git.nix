{ pkgs, ...}:

with pkgs;

{
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
}