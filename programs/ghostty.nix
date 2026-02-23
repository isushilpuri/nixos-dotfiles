{ config, pkgs, ... }:

{
    programs.ghostty = {
	enable = true;
	installVimSyntax = true;
	enableZshIntegration = true;
	settings = {
	    font-family = "IntoneMono Nerd Font";
	    background-opacity = "90";
	};
  };
}

