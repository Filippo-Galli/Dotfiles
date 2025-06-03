{ config, pkgs, ... }:

{
  services.mako = {
    enable = true;
    
    # Basic settings
    sort = "-time";
    layer = "overlay";
    backgroundColor = "#2e3440AA";
    width = 300;
    height = 110;
    borderSize = 2;
    borderColor = "#88c0d0";
    borderRadius = 15;
    icons = true;
    maxIconSize = 64;
    defaultTimeout = 5000;
    ignoreTimeout = true;
    font = "monospace 10";
    
    # Extra configuration for urgency levels and categories
    extraConfig = ''
      [urgency=low]
      border-color=#cccccc
      
      [urgency=normal]
      border-color=#f55302
      
      [urgency=high]
      border-color=#ff0000
      default-timeout=0
      
      [category=mpd]
      default-timeout=2000
      group-by=category
    '';
  };
}
