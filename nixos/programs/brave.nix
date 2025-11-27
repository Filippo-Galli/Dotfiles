{pkgs, ...}:{

  programs.brave = {
    enable = true;

    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];
    
  };

}
