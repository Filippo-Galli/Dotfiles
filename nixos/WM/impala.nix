{ config, pkgs, ... }:

{
  # Install iwd and impala for wireless network management
  home.packages = with pkgs; [
    iwd      # Intel wireless daemon
    impala   # TUI for managing wireless networks
  ];

  # Create a desktop entry for impala if you want GUI access
  xdg.desktopEntries.impala = {
    name = "Impala WiFi Manager";
    comment = "TUI for managing wireless networks";
    exec = "${pkgs.impala}/bin/impala";
    icon = "network-wireless";
    terminal = true;
    categories = [ "Network" "System" ];
  };
}