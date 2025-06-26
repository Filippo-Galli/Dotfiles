{pkgs, config, ...}:

{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    ./nemo.nix
    ./hyprlock.nix
    ./gtk.nix
    ./swaync.nix
    #./mako.nix
  ];
}
