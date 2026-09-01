{ pkgs, config, ...}:

{
  programs.git = {
    enable = true;
    userName = "Riley Loo";
    userEmail = "dev@zackerthescar.com";

    settings = {
      core.editor = "vim";
      credential.helper = "cache";
      init.defaultBranch = "main";
    };

    signing = {
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
    };
  };
}