{ config, pkgs, ... }:

{
  home.username = "filippo";
  home.homeDirectory = "/home/filippo";
  services.gnome-keyring = {
  enable = true;
  components = [ "pkcs11" "secrets" "ssh" ];
};

# Set environment variables for applications to find the keyring
home.sessionVariables = {
  # ... your existing variables
  GNOME_KEYRING_CONTROL = "${config.home.homeDirectory}/.cache/keyring-control";
  BRAVE_PASSWORD_STORE = "gnome-libsecret";
};
	
  imports = [
    ./WM
    ./shell
    ./programs
    #./custom_keybindings.nix 
  ];

  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
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
    grim           # Screenshot utility
    slurp          # Screen area selection
    mako           # Notification daemon
    hyprsunset     # Blue-light

    # Vs code nix extension
    nil
    nixpkgs-fmt
  ];
}
