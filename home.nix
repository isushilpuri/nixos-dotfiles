{ config, pkgs, self, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    mpv = "mpv";
    zed = "zed";
    niri = "niri";
    noctalia = "noctalia";
    alacritty = "alacritty";
  };
in

{
  imports = [
    ./programs/zsh.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/ghostty.nix
    ./programs/swayidle.nix
  ];

  home.username = "v0idshil";
  home.homeDirectory = "/home/v0idshil";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.


  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    yazi
    nodejs_24
    ripgrep
    gcc
    nil
    nixpkgs-fmt
    unzip
    foliate
    ffmpeg-full
    protonvpn-gui
    keepassxc
    gnumake
    mpv
    zed-editor-fhs
    claude-code
    antigravity
    python314
    uv
    rustup
    obsidian
    docker
    lazydocker
    gimp
    distrobox
    nautilus
    kdePackages.dolphin
    swaylock-effects
    sway
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create_symlink "${dotfiles}/${subpath}";
    recursive = true;
  }) configs;
  
  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/v0idshil/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos btw";
      nrs = "nixos-rebuild switch --flake ~/nix-dotfiles#nixos";
    };

    initExtra = ''
      export LANG=en_US.UTF-8
    '';
  };

  programs.git = {
      enable = true;
      settings.user.name = "isushilpuri";
      settings.user.email = "isushilpuri@gmail.com";
      settings.alias = {
          pu = "push";
          co = "checkout";
          cm = "commit";
      };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true; # if you're using zsh
  };

}
