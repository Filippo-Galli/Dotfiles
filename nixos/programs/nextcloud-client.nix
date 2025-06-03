{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    nextcloud-client
  ];

  # Optional: Enable autostart
  xdg.configFile."autostart/nextcloud.desktop".text = ''
    [Desktop Entry]
    Name=Nextcloud
    GenericName=Nextcloud Desktop Client
    Exec=${pkgs.nextcloud-client}/bin/nextcloud --background
    Terminal=false
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
    Type=Application
    Categories=Network;FileTransfer;
  '';
}
