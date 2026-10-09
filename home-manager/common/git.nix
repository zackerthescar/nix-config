{ pkgs, config, ...}:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Riley Loo";
      user.email = "dev@zackerthescar.com";
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