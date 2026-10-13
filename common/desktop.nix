{
  pkgs,
  inputs,
  stateVersion,
  ...
}:

{
  imports = [
    ../programs/tailscale.nix
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org/"
      "https://hyprland.cachix.org"
      "https://cache.ysun.co"
      "https://niri.cachix.org"
      "https://cache.numtide.com"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache.ysun.co-1:WxPYwT5g3kt9XhUhHPpNLZKI9HIOsVVAuqSHpok8Qt4="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];

    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = true;

    trusted-users = [
      "root"
      "filippo"
    ];
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "transparent_hugepage=madvise"
      "acpi_osi=Linux"
      "acpi_backlight=intel"
    ];
  };

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;

    bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openconnect
    ];
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
    enable = false;
    xwayland.enable = true;
    withUWSM = false;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };
  programs.dconf.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # 1. Basics (Compression, Security, C standard libs)
    stdenv.cc.cc.lib
    zlib
    openssl
    glib

    # 2. Graphic & GUI libraries (Common for matplotlib, opencv, etc.)
    libGL
    libGLU

    # 3. System Utilities (Sometimes required by specific python wheels)
    util-linux
    icu
    libxml2
    libxslt
    bzip2
  ];

  # Security & Authentication
  security = {
    polkit.enable = true;
    pam.services.hyprlock = { };

    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
        Defaults timestamp_timeout=30
      '';
    };

    apparmor = {
      enable = true;
    };

    pam.services = {
      hyprland.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
      passwd.enableGnomeKeyring = true;
      ly.enableGnomeKeyring = true;
    };

    rtkit.enable = true;
  };

  services = {
    gnome.gnome-keyring.enable = true;

    dbus = {
      enable = true;
    };

    # Use Ly display manager
    displayManager = {
      ly = {
        enable = true;
        settings = {
          animation = "none";
          hide_borders = true;
        };
      };
    };

    upower = {
      enable = true;
    };
    power-profiles-daemon.enable = true;

    printing.enable = false;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    # Enable fstrim for SSDs
    fstrim.enable = true;

    # Firmware updates
    fwupd.enable = true;

    # Ignore lid switch for docked / external power usage
    logind.settings.Login = {
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
      niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Access" = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Notification" = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
      hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [
          "gtk"
        ];
        "org.freedesktop.impl.portal.Secret" = [
          "gnome-keyring"
        ];
      };
    };
  };

  users.users.filippo = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "Filippo Galli";
    extraGroups = [
      "networkmanager"
      "wheel"
      "bluetooth"
    ];
    hashedPassword = "$y$j9T$dtn6s3fY5WpMwuZtwg/.l0$I3NUWXusHHTYk6w9e4Wq0I7ccRIt3KOygV2HhNoJ4m5";
  };

  users.users.root = {
    shell = pkgs.zsh;
    hashedPassword = "$y$j9T$jvHtHzQgvdYK5WrnvsEuU/$n7EF8zPZgUrD1.hJR7m862kiUXTndfyjWtF6di6MsC8";
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    bashInteractive
    wget
    vim
    kitty
    git

    gnome-keyring
    seahorse
    libsecret
  ];
  programs.zsh.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
  };

  environment.variables = {
    EDITOR = "nvim";
    SECRET_TOOL_BACKEND = "gnome";
    XDG_SESSION_TYPE = "wayland";
  };

  system = {
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
    stateVersion = stateVersion;
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.dejavu-sans-mono

      font-awesome_6
      font-awesome_5

      material-design-icons
      material-icons

      noto-fonts-color-emoji
      symbola
    ];

    enableDefaultPackages = true;

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
