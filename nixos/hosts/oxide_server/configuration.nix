{
  pkgs,
  inputs,
  stateVersion,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Tailscale
    ../../programs/tailscale.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    max-jobs = "auto"; # Automatically determine the number of jobs based on available CPU cores
    cores = 0; # Use all cores
    auto-optimise-store = true; # Automatically optimize the Nix store

    trusted-users = [
      "root"
      "filippo"
    ]; # Allow these users to run Nix commands without restrictions
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
      "elevator=mq-deadline" # Good for NVMe SSDs
      "acpi_osi=Linux"
    ];

  };

  hardware = {
    enableAllFirmware = true;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 2222 ];
  };

  networking = {
    hostName = "oxide_server";
    networkmanager = {
      enable = false;
      # powersave = false;
      plugins = with pkgs; [
        networkmanager-openconnect
      ];
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

  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AllowUsers = [
        "filippo"
        "root"
      ];
    };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # 1. Basics (Compression, Security, C standard libs)
    stdenv.cc.cc.lib
    zlib
    openssl
    glib

    # 3. System Utilities (Sometimes required by specific python wheels)
    util-linux
    icu
    libxml2
    libxslt
    bzip2
  ];

  # Enable necessary services for Hyprland
  security = {
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

    # Enable RTKit for real-time scheduling
    rtkit.enable = true;
  };

  services = {
    # Enable fstrim for SSDs
    fstrim.enable = true;

    # Firmware updates
    fwupd.enable = true;

    # System monitoring
    # smartd.enable = true;
  };

  # Configure console keymap
  console.keyMap = "it2";

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users = {
    filippo = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "Filippo Galli";
      extraGroups = [
        "networkmanager"
        "wheel"
        "bluetooth"
        "docker"
      ];
      initialHashedPassword = "$6$dyDeUE6kLRTEGku7$hDenLW7t6R0Vbdcaht2.aWkCbVshyg4qcK/O5WCoHi/mmVOZBYZRrM5GVTZWcNzqfESLGEJHDDKRK2mm4uLCF/";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2kaIJVlVqnY/KzlMRBmICfcaxsKeVmXduJSyxCm0Nu filippo@gyomei"
      ];
    };
    root = {
      shell = pkgs.zsh;
      initialHashedPassword = "$6$Zw4CcLqRXcLcE9ua$Sc365jCUgWNb/j5V.2VWBn03jD2vNGjpEsOo6ryg5526zo4tPDJeklKSiaJ.d0jGq30pZG0fj31anlBsk1ccT1";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2kaIJVlVqnY/KzlMRBmICfcaxsKeVmXduJSyxCm0Nu filippo@gyomei"
      ];
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    bashInteractive
    wget
    vim
    git

    devenv # Nix development environment
    tmux
  ];
  programs.zsh.enable = true;

  # Enable podman
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;
    };
  };

  environment.sessionVariables = {
    TERM = "xterm";
  };

  # Set the default editor to vim
  environment.variables = {
    EDITOR = "nvim";
  };

  system = {
    stateVersion = stateVersion;
    configurationRevision =
      with inputs.self;
      if sourceInfo ? dirtyShortRev then sourceInfo.dirtyShortRev else sourceInfo.shortRev;
  };
}
