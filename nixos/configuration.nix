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
    
    substituters = [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];

    max-jobs = "auto"; # Automatically determine the number of jobs based on available CPU cores
    cores = 0; # Use all cores
    auto-optimise-store = true; # Automatically optimize the Nix store
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true; # Use systemd-boot as the bootloader
      };
      efi.canTouchEfiVariables = true; # Allow NixOS to modify EFI variables
      timeout = 2; # Set bootloader timeout to 5 seconds
    };

    kernelParams = [
      "transparent_hugepage=madvise"
      "elevator=mq-deadline"  # Good for NVMe SSDs
    ];

  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;  # Don't auto-enable at boot
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  networking = {
    hostName = "nixos";

    networkmanager = {
      enable = true; # Enable NetworkManager for managing network connections
    };
  };

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
    
    # Improve sudo security
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
        Defaults timestamp_timeout=30
      '';
    };
    
    # Enable AppArmor for additional security
    apparmor = {
      enable = true;
    };

    pam.services = {
      hyprland.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
      passwd.enableGnomeKeyring = true;
    };

    # Enable RTKit for real-time scheduling
    rtkit.enable = true;
  };

  services = {
    dbus = {
      enable = true; # Enable D-Bus for inter-process communication
    };

    xserver = {
      enable = false; 
      displayManager.gdm.enable = true;

      xkb = {
        layout = "it"; # Set keyboard layout to Italian
        variant = ""; # No specific variant
      };
    };

    upower = {
      enable = true; # Enable UPower for power management
    };
    power-profiles-daemon.enable = true;

    printing.enable = false;

    pulseaudio.enable = false; # Disable PulseAudio, use PipeWire instead
    pipewire = {
      enable = true; # Enable PipeWire for audio and video
      alsa.enable = true; # Enable ALSA support
      alsa.support32Bit = true; # Support 32-bit applications
      pulse.enable = true; # Enable PulseAudio compatibility layer
      wireplumber.enable = true; # Use WirePlumber as the session manager
    };

    # Enable fstrim for SSDs
    fstrim.enable = true;
    
    # Firmware updates
    fwupd.enable = true;
    
    # System monitoring
    smartd.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk];
  };

  # Configure console keymap
  console.keyMap = "it2";
  
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
  programs.zsh.enable = true;

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
}