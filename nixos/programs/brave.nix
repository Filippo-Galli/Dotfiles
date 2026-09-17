{ inputs, pkgs, ... }:
{
  programs.brave = {
    enable = true;
    package = inputs.brave-origin.packages.${pkgs.stdenv.hostPlatform.system}.default;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
    extensions = [ /* optional */ ];
  };
}
