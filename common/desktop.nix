{
  config,
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
        configurationLimit = 10;
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

    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
  };

  system.activationScripts.sopsUserKey = {
    text = ''
      USER_HOME="/home/filippo"
      KEY_PATH="$USER_HOME/.ssh/sops"

      if [ ! -f "$KEY_PATH" ]; then
        mkdir -p "$USER_HOME/.ssh"
        chmod 700 "$USER_HOME/.ssh"

        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -N "" -C "sops@${config.networking.hostName}" -f "$KEY_PATH"
        chown filippo:users "$KEY_PATH" "$KEY_PATH.pub"
        chmod 600 "$KEY_PATH"
        chmod 644 "$KEY_PATH.pub"

        echo "=========================================================="
        echo "Generated new SOPS SSH key at $KEY_PATH"
        echo "Public Age key for .sops.yaml:"
        ${pkgs.ssh-to-age}/bin/ssh-to-age -i "$KEY_PATH.pub"
        echo "=========================================================="
      fi
    '';
  };

  sops = {
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [
      "/home/filippo/.ssh/sops"
      "/etc/ssh/ssh_host_ed25519_key"
    ];
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
    shell = pkgs.nushell;
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
    shell = pkgs.bashInteractive;
    hashedPassword = "$y$j9T$jvHtHzQgvdYK5WrnvsEuU/$n7EF8zPZgUrD1.hJR7m862kiUXTndfyjWtF6di6MsC8";
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "firefox-esr-140-bin-unwrapped-140.17.0esr"
    ];
  };

  environment.systemPackages = with pkgs; [
    bashInteractive
    wget
    vim
    kitty
    git

    gnome-keyring
    seahorse
    libsecret

    sops
    age
    ssh-to-age
  ];
  programs.nushell.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SOPS_AGE_SSH_PRIVATE_KEY_FILE = "/home/filippo/.ssh/sops";
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
