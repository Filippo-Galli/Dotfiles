{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ../../common/desktop.nix
  ];

  networking.hostName = "gyomei";

  # US console keymap
  console.keyMap = "us";
}
