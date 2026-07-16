{
  pkgs,
  inputs,
  stateVersion,
  ...
}:

let
  # Replace with this node's real Tailscale IPv4 address after bringing it up.
  tailscaleIp = "100.94.214.26";

  # Replace with the first Proxmox node's Tailscale IPv4 address.
  clusterMasterIp = "100.116.74.30";

  clusterName = "pve";
in
{
  imports = [
    ./hardware-configuration.nix

    # Tailscale
    ../../programs/tailscale.nix

    # Pulls in services.proxmox-ve.* and the declarative-VM options
    inputs.proxmox-nixos.nixosModules.proxmox-ve
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    substituters = [
      "https://cache.nixos.org/"
      "https://cache.saumon.network/proxmox-nixos"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM="
    ];

    max-jobs = "auto";
    cores = 0;
    auto-optimise-store = true;

    trusted-users = [
      "root"
      "filippo"
    ];
  };

  # -------------------------------------------------------------------------
  # Boot
  # -------------------------------------------------------------------------
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 2;
    };

    kernelParams = [
      "transparent_hugepage=madvise"
      "elevator=mq-deadline"
      "acpi_osi=Linux"
    ];

    # -------------------------------------------------------------------------
    # ZFS
    # -------------------------------------------------------------------------
    supportedFilesystems = [ "zfs" ];
    zfs.forceImportRoot = false;
  };

  hardware.enableAllFirmware = true;

  # -------------------------------------------------------------------------
  # Networking
  # -------------------------------------------------------------------------
  networking = {
    hostName = "appa";
    useNetworkd = true;
    # Required by ZFS — must be unique per machine, any 8 hex chars.
    hostId = "609ca65e";

    networkmanager = {
      enable = false;
      plugins = with pkgs; [ networkmanager-openconnect ];
    };

    firewall = {
      enable = true;

      allowedTCPPorts = [
        2222
        8006
      ];

      # Corosync usually needs UDP 5405 for cluster traffic.
      allowedUDPPorts = [
        5405
      ];

      # Allow Proxmox clustering and SSH/web access on Tailscale specifically.
      interfaces."tailscale0" = {
        allowedTCPPorts = [
          22
          2222
          8006
        ];
        allowedUDPPorts = [
          5405
        ];
      };
    };
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.trim.enable = true;

  # Make the vmbr0 bridge visible/selectable inside the Proxmox web UI.
  # Use the Tailscale address for node-to-node cluster communication.
  services.proxmox-ve = {
    enable = true;
    ipAddress = "${tailscaleIp}/32";
    bridges = [ "vmbr0" ];
  };

  systemd.network.networks."10-lan" = {
    matchConfig.Name = [ "enp6s0" ];
    networkConfig.Bridge = "vmbr0";
  };

  systemd.network.netdevs."vmbr0".netdevConfig = {
    Name = "vmbr0";
    Kind = "bridge";
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "vmbr0";
    networkConfig = {
      IPv6AcceptRA = true;
      DHCP = "ipv4";
    };
    linkConfig.RequiredForOnline = "routable";
  };

  # Explicit Tailscale enablement so the node has a stable overlay address
  # for Proxmox cluster communication.
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "client";
    openFirewall = true;
  };

  # Ensure cluster name resolution works even before DNS is arranged.
  networking.extraHosts = ''
    ${clusterMasterIp} pve1
    ${tailscaleIp} appa
  '';

  # -------------------------------------------------------------------------
  # Locale / time
  # -------------------------------------------------------------------------
  time.timeZone = "Europe/Rome";

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

  console.keyMap = "it2";

  # -------------------------------------------------------------------------
  # SSH
  # -------------------------------------------------------------------------
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

  # -------------------------------------------------------------------------
  # nix-ld
  # -------------------------------------------------------------------------
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
    glib
    util-linux
    icu
    libxml2
    libxslt
    bzip2
  ];

  # -------------------------------------------------------------------------
  # Security
  # -------------------------------------------------------------------------
  security = {
    sudo = {
      enable = true;
      extraConfig = ''
        Defaults pwfeedback
        Defaults lecture = never
        Defaults timestamp_timeout=30
      '';
    };
    apparmor.enable = true;
    rtkit.enable = true;
  };

  services.fstrim.enable = true;
  services.fwupd.enable = true;

  # -------------------------------------------------------------------------
  # Users
  # -------------------------------------------------------------------------
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
      initialHashedPassword = "$6$xriIDJykhwJ9bPwB$lZYtWTvKYs/HDY0f1lRQfLJC8qr46RWN5CdrC0ntpcwhQaBeZz0KXan7s4/yemq4UOj9kTB/YnwAEAYGX9y3H";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5999CjpyZ340e8Lz8vV3e8kRtvJFHhoMKAn+vluPOv filippo@appa"
      ];
    };
    root = {
      shell = pkgs.zsh;
      initialHashedPassword = "$6$xriIDJykhwJ9bPwB$lZYtWTvKYs/HDY0f1lRQfLJC8qr46RWN5CdrC0ntpcwhQaBeZz0KXan7s4/yemq4UOj9kTB/YnwAEAYGX9y3H";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5999CjpyZ340e8Lz8vV3e8kRtvJFHhoMKAn+vluPOv filippo@appa"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.proxmox-nixos.overlays.x86_64-linux
  ];

  # -------------------------------------------------------------------------
  # Packages / shell
  # -------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    bashInteractive
    wget
    vim
    git
    devenv
    tmux
  ];
  programs.zsh.enable = true;

  # -------------------------------------------------------------------------
  # Containers/virtualisation
  # -------------------------------------------------------------------------
  virtualisation.containers.enable = true;
  virtualisation.podman.enable = true;

  environment.sessionVariables = {
    TERM = "xterm";
  };
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

