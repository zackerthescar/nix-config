{ config, lib, pkgs, ...}:

with lib;
with pkgs;

{
    # zsh config
    programs.zsh = {
        enable = true;
        initExtra = "any-nix-shell zsh --info-right | source /dev/stdin";
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
            { name = "plugins/direnv";            tags = [from:oh-my-zsh]; }
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

    home.packages = with pkgs; [
	any-nix-shell
    ];

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
    };

}
