{ config, pkgs, stateVersion, ... }:

{
  home.username = "filippo";
  home.homeDirectory = "/home/filippo";
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # Set environment variables for applications to find the keyring
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "${config.home.homeDirectory}/.cache/keyring-control";
    BRAVE_PASSWORD_STORE = "gnome-libsecret";
    # GTK theme dark 
    GTK_THEME = "Adwaita:dark";
  };
	
  imports = [
    ./WM
    ./shell
    ./programs
  ];

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Wayland utilities
    waybar         # Status bar
    swww           # Wallpaper daemon
    wl-clipboard   # Clipboard utilities
    cliphist       # Clipboard history
    grim           # Screenshot utility
    slurp          # Screen area selection
    mako           # Notification daemon
    hyprsunset     # Blue-light
    brightnessctl  # Brightness control

    # Vs code nix extension
    nil
    nixfmt-rfc-style

    # Bluetooth
    bluetuith      # TUI Bluetooth manager

    # OSD
    swayosd 
  ];
}
