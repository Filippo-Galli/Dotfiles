{pkgs, config, ...}:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./mako.nix
    ./rofi.nix
    ./nemo.nix
    ./hyprlock.nix
  ];
}
