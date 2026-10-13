{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable hyprlock through home-manager
  programs.hyprlock = {
    enable = true;
    extraConfig = builtins.readFile ./config/hypr/hyprlock.conf;
  };
}
