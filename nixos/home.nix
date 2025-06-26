{ config, pkgs, username, stateVersion, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  
  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  # Set environment variables for applications to find the keyring
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "${config.home.homeDirectory}/.cache/keyring-control";
    BRAVE_PASSWORD_STORE = "gnome-libsecret";

    # Enable Ozone Wayland support
    NIXOS_OZONE_WL = "1";

    # GTK settings
    # GTK_THEME = "Adwaita-dark";
    # GTK_APPLICATION_PREFER_DARK_THEME = "1";
    GDK_BACKEND = "wayland,x11";
    
    # QT settings
    QT_QPA_PLATFORM = "wayland";
    
    # Cursor theme
    # XCURSOR_THEME = "Adwaita";
    # XCURSOR_SIZE = "24";  

    # Set the shell to zsh
    SHELL = "${pkgs.zsh}/bin/zsh";

    MESA_LOADER_DRIVER_OVERRIDE = "iris"; # For Intel graphics
    LIBVA_DRIVER_NAME = "iHD"; # Intel hardware acceleration
  
  };
	
  imports = [
    ./WM
    ./shell
    ./programs
  ];

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

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
