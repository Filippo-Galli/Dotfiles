{ config, pkgs, ... }:

{
  home.file."battery_notify.sh" = {
    target = ".local/bin/battery_notify.sh";
    source = ./config/scripts/battery_notify.sh;
    executable = true;
  };

  systemd.user.services.battery-notifier = {
    Unit = {
      Description = "Battery level notification service";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.local/bin/battery_notify.sh";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = [
        "PATH=${pkgs.bash}/bin:${pkgs.libnotify}/bin:${pkgs.systemd}/bin"
      ];
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}