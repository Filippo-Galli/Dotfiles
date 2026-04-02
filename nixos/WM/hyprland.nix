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
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
    extraConfig =
      builtins.replaceStrings
        [ "/home/filippo/Documents/Dotfiles/nixos/WM/wallpaper/starship.jpg" ]
        [ "${./wallpaper/starship.jpg}" ]
        (builtins.readFile ./config/hypr/hyprland.conf);
  };
}
