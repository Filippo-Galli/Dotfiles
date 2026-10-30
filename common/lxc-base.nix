{
  config,
  stateVersion,
  lib,
  ...
}:

let
  cfg = config.homelab.lxc;
  useStaticAddress = cfg.ctId != null;
in
{
  imports = [
    ../programs/tailscale.nix
  ];

  options.homelab.lxc = {
    ctId = lib.mkOption {
      type = lib.types.nullOr (lib.types.ints.between 1 254);
      default = null;

      description = ''
        Container ID used as the final octet of the LAN IPv4 address.
        When null, retain DHCP networking.
        This does not create or set the Proxmox container ID.
      '';
    };

    gateway = lib.mkOption {
      type = lib.types.str;
      default = "192.168.1.254";
      description = "Default IPv4 gateway for statically addressed LXCs.";
    };
  };

  config = lib.mkMerge [
    {
      boot.isContainer = true;
      boot.loader.initScript.enable = true;
      system.stateVersion = stateVersion;

      services.openssh = {
        enable = lib.mkDefault true;
        settings.PermitRootLogin = lib.mkDefault "yes";
      };

      users.users.root.hashedPassword = "$6$/5LG06ycvzJqkjQa$rxy6rj4gIb3WUxuWTAlrGH1hRKkNLchoBEoJc9qN.mJmCMdUma/uiI.MKA/9G4pjCsf5H7azz1bfx/jeW.Ozg1";
      services.tailscale = {
        enable = lib.mkDefault true;
        extraUpFlags = lib.mkDefault [
          "--ssh"
          "--accept-dns=false"
        ];
      };

      boot.loader.systemd-boot.enable = lib.mkDefault false;
      boot.loader.grub.enable = lib.mkDefault false;
    }

    (lib.mkIf (!useStaticAddress) {
      networking.useDHCP = lib.mkDefault true;
    })

    (lib.mkIf useStaticAddress {
      networking = {
        useDHCP = false;

        interfaces.eth0 = {
          useDHCP = false;

          ipv4.addresses = [
            {
              address = "192.168.1.${toString cfg.ctId}";
              prefixLength = 24;
            }
          ];
        };

        defaultGateway = lib.mkDefault {
          address = cfg.gateway;
          interface = "eth0";
        };

        nameservers = lib.mkDefault [
          "1.1.1.1"
          "9.9.9.9"
        ];
      };
    })
  ];
}
