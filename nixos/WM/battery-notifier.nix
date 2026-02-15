{ config, pkgs, ... }:

let
  batteryScript = pkgs.writeShellScriptBin "battery_notify.sh" ''
    export PATH=${pkgs.libnotify}/bin:${pkgs.systemd}/bin:${pkgs.coreutils}/bin:$PATH
    ${builtins.readFile ./config/scripts/battery_notify.sh}
  '';
in
{
  systemd.user.services.battery-notifier = {
    Unit = {
      Description = "Battery level notification service";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${batteryScript}/bin/battery_notify.sh";
      Restart = "on-failure";
      RestartSec = "10s";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}