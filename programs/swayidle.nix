{ config, pkgs, ... }:

let
  lockCmd = "swaylock -f --screenshots --effect-blur 3x2 --indicator --clock --ring-color 458588 --inside-color 282828cc --line-color 00000000 --separator-color 00000000";
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

