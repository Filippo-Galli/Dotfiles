{ config, pkgs, ... }:

{
  # Enable and configure rofi
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    # Simple configuration
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Windows";
      drun-display-format = "{name}";
      font = "mono 12";
    };
    
    # Simple dark theme
    theme = "gruvbox-dark";
  };
}