{ pkgs, ... }:
{
  programs.brave = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
    extensions = [ /* optional */ ];
  };

  home.file.".config/etc/brave/policies/managed/brave_prefs.json".text = ''
    {
      "BraveRewardsDisabled": true,
      "BraveWalletDisabled": true,
      "PaymentMethodsDisabled": true,
      "BraveVPNDisabled": true
    }
  '';
}
