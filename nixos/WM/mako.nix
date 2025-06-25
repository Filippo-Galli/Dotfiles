{ config, pkgs, ... }:

{
  services.mako = {
    enable = false;

    settings = {
      ignore-timeout = true;
      default-timeout = 0;
      icons = true;
      border-radius = 15;
      border-color = "#88c0d0";
      border-size = 2;
      height = 110;
      width = 300;
      background-color = "#2e3440AA";
      font = "monospace 10";
      layer = "top";
      anchor = "top-right";
      sort = "-time";
      max-icon-size = 64;


      "urgency=low" = {
        border-color = "#cccccc";
      };
      
      "urgency=normal" = {
        border-color = "#f55302";
      };
      
      "urgency=high" = {
        border-color = "#ff0000";
        default-timeout = 0;
      };
      
      "category=mpd" = {
        default-timeout = 2000;
        group-by = "category";
      };

      "app-name=Nextcloud" = {
        default-timeout = 10000;  # 10 seconds instead of 5
        group-by = "app-name";
      };
    };
  };
}