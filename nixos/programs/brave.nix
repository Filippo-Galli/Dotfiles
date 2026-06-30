{ inputs, pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = inputs.brave-origin.packages.${pkgs.system}.default;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
    extensions = [ /* optional */ ];
  };
}
