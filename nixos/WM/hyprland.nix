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
          "bind = , XF86Calculator, exec, grim -g \"$(slurp)\""
        ]
        [
          "${./wallpaper/starship.jpg}"
          "$MONITORS_scale = ${
            if osConfig.networking.hostName == "escanor" then
              "2.0"
            else if osConfig.networking.hostName == "gyomei" then
              "1.6"
            else
              "1.6"
          }"
          "${
            if osConfig.networking.hostName == "gyomei" then
              "bind = $mainMod, S, exec, grim -g \"$(slurp)\""
            else
              "bind = , XF86Calculator, exec, grim -g \"$(slurp)\""
          }"
        ]
        (builtins.readFile ./config/hypr/hyprland.conf);
  };
}
