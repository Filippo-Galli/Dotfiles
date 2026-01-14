{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    extraConfig = builtins.readFile ./config/hypr/hyprland.conf;
  };
}
