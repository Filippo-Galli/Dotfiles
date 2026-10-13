{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../common/desktop.nix
  ];

  networking.hostName = "escanor";

  # Italian console keymap
  console.keyMap = "it2";

  # Intel Thermal Daemon for Lenovo Yoga chassis & fan management
  services.thermald.enable = true;
}
