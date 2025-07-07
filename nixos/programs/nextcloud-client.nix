{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nextcloud-client
  ];
  systemd.user.services.nextcloud = {
    Unit = {
      Description = "Nextcloud Desktop Client";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud --background";
      Restart = "on-failure";
      RestartSec = "5";
      KillMode = "mixed";
      KillSignal = "SIGTERM";
      TimeoutStopSec = "10";
      RemainAfterExit = false;
      # Environment variables for GUI apps
      Environment = [
        "PATH=${config.home.profileDirectory}/bin"
        "XDG_DATA_DIRS=${config.home.profileDirectory}/share"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Enable the service
  systemd.user.startServices = true;
}