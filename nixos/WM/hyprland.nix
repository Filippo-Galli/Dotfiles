{
  config,
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    extraConfig =
      builtins.replaceStrings
        [
          "/home/filippo/Documents/Dotfiles/nixos/WM/wallpaper/starship.jpg"
          "$MONITORS_scale = 1.5"
        ]
        [
          "${./wallpaper/starship.jpg}"
          "$MONITORS_scale = ${
            if osConfig.networking.hostName == "escanor" then
              "2.0"
            else if osConfig.networking.hostName == "gyomei" then
              "1.5"
            else
              "1.5"
          }"
        ]
        (builtins.readFile ./config/hypr/hyprland.conf);
  };
}
