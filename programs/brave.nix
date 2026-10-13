{ pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = pkgs.brave-origin;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
    extensions = [ /* optional */ ];
  };
}
