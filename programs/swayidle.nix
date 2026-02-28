{ config, pkgs, ... }:

let
    lockCmd = "${pkgs.swaylock-effects}/bin/swaylock -f --image ${config.home.homeDirectory}/Pictures/wallpapers/wall.jpg --scaling fill --effect-blur 8x6 --indicator --clock --ring-color 458588 --inside-color 282828cc --line-color 00000000 --separator-color 00000000";
in
{
  home.sessionVariables.TEST_SWAYIDLE = "loaded";

  services.swayidle = {
    enable = true;

    timeouts = [
      {
        timeout = 300; # 5 min
        command = lockCmd;
      }
      {
        timeout = 600; # 10 min
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = {
      before-sleep = lockCmd;
      
      after-resume = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
    };
  };
}

