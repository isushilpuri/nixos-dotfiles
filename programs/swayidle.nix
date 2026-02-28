{ config, pkgs, ... }:

let
  lockCmd = "${pkgs.swaylock-effects}/bin/swaylock -f --clock --indicator --effect-blur 8x6 --grace 2 --fade-in 0.3 --text \"Love, Play and Meditate…\" --font \"CaskaydiaMono Nerd Font\" --text-color d5c4a1 --ring-color 3c3836 --key-hl-color 458588 --inside-color 282828cc --separator-color 00000000 --line-color 00000000";
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

    events = [
      {
        event = "before-sleep";
        command = lockCmd;
      }
      {
        event = "after-resume";
        command = "${pkgs.sway}/bin/swaymsg \"output * dpms on\"";
      }
    ];
  };
}

