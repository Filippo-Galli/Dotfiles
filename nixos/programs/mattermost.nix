{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    mattermost-desktop
  ];
}
