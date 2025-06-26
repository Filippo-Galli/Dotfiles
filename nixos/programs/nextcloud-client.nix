{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nextcloud-client
  ];

  # Updated autostart with single instance protection
  xdg.configFile."autostart/nextcloud.desktop".text = ''
    [Desktop Entry]
    Name=Nextcloud
    GenericName=Nextcloud Desktop Client
    Comment=Nextcloud desktop synchronization client
    Exec=sh -c 'if ! pgrep -x nextcloud > /dev/null; then ${pkgs.nextcloud-client}/bin/nextcloud --background; fi'
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