{
  config,
  pkgs,
  inputs,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

  };
  xdg.configFile."hypr/hyprland.conf".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "/home/filippo/Documents/Dotfiles/nixos/WM/config/hypr/hyprland.conf"
  );
}
