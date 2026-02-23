{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    escapeTime = 2000;
    mouse = true;
    sensibleOnTop = true;
    prefix = "C-Space";
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = ''
      set-environment -g LANG "en_US.UTF-8"
      set-environment -g LC_ALL "en_US.UTF-8"

      set-option -sa terminal-overrides ",xterm-256color:Tc"
      # Shift Alt vim keys to switch windows
      bind -n M-H previous-window
      bind -n M-L next-window

      # keybindings
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

      # Open panes in current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
    '';
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
        '';
      }
    ];
  };
}
