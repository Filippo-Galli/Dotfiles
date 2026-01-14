{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable hyprlock through home-manager
  programs.hyprlock.enable = true;

  xdg.configFile."hypr/hyprlock.conf".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "/home/filippo/Documents/Dotfiles/nixos/WM/config/hypr/hyprlock.conf"
  );
}
