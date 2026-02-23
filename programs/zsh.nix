{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    initContent = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      # Custom configs go here
      export EDITOR=nvim
      bindkey '^R' history-incremental-search-backward

      # Add ~/.local/bin to PATH
      export PATH=$HOME/.local/bin:$PATH
    '';
  };
}

