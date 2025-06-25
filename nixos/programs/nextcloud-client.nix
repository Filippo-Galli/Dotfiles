{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nextcloud-client
  ];

  # Optional: Enable autostart with single instance protection
  xdg.configFile."autostart/nextcloud.desktop".text = ''
    [Desktop Entry]
    Name=Nextcloud
    GenericName=Nextcloud Desktop Client
    Comment=Nextcloud desktop synchronization client
    Exec=${pkgs.nextcloud-client}/bin/nextcloud --background
    Terminal=false
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Type=Application
    Categories=Network;FileTransfer;
    StartupNotify=false
    X-GNOME-Autostart-Delay=10
    SingleMainWindow=true 
  '';
}