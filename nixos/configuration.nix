{ config, pkgs, inputs, stateVersion, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Tailscale 
      ./programs/tailscale.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    
    # Add these lines
    substituters = [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "it_IT.UTF-8";
    LC_IDENTIFICATION = "it_IT.UTF-8";
    LC_MEASUREMENT = "it_IT.UTF-8";
    LC_MONETARY = "it_IT.UTF-8";
    LC_NAME = "it_IT.UTF-8";
    LC_NUMERIC = "it_IT.UTF-8";
    LC_PAPER = "it_IT.UTF-8";
    LC_TELEPHONE = "it_IT.UTF-8";
    LC_TIME = "it_IT.UTF-8";
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  # Enable necessary services for Hyprland
  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  # Optional: Keep GNOME alongside Hyprland
  services.xserver = {
    enable = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;
  };

  services.upower = {
    enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "it";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.zsh.enable = true;
  
  # Docker 
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.filippo = {
    isNormalUser = true;
    description = "Filippo Galli";
    extraGroups = [ "networkmanager" "wheel" "bluetooth"];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
  	wget
    vim
    kitty
    git

    gnome-keyring
    seahorse
    libsecret  # Needed for apps to talk to gnome-keyring
  ];

  services.power-profiles-daemon.enable = true;

  security.pam.services.hyprland.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.passwd.enableGnomeKeyring = true;
  # To show * in password prompts
  security.sudo.extraConfig = ''
    Defaults pwfeedback
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Set the default editor to vim
  environment.variables = {
  	EDITOR = "nvim";
	  SECRET_TOOL_BACKEND = "gnome";
  };

  system.stateVersion = stateVersion;

  fonts = {
    packages = with pkgs; [
      # Individual Nerd Fonts (new format)
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.dejavu-sans-mono
      
      # Font Awesome (all versions for compatibility)
      font-awesome_6
      font-awesome_5
      
      # Additional icon fonts that many applications use
      material-design-icons
      material-icons
      
      # Emoji support
      noto-fonts-emoji
      
      # Symbols and icons
      symbola
    ];
    
    # Enable default fonts for better compatibility
    enableDefaultPackages = true;
    
    # Font configuration
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "DejaVu Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
      };
    };
  };


  # Enable Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;  # Don't auto-enable at boot
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

}