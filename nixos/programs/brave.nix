{pkgs, ...}:{

  programs.brave = {
    enable = true;

    commandLineArgs = [
      "--password-store=gnome-libsecret"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
      "--enable-features=VerticalTabs"
    ];
    
  };

}
