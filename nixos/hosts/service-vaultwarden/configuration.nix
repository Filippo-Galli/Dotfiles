{ config, pkgs, ... }:
{
  imports = [
    ../../common/lxc-base.nix
  ];

  networking.hostName = "vaultwarden";
  image.modules.proxmox-lxc = {
    image.baseName = "${config.networking.hostName}-${config.system.nixos.label}";
  };

  services.tailscale.extraUpFlags = [ "--ssh" ];

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "https://vw-nix.tail05d5c9.ts.net";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = true;
    };
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
  };

  # Enable Tailscale Serve on boot to expose Vaultwarden to the Tailscale network
  systemd.services.tailscale-serve-vaultwarden = {
    description = "Configure Tailscale Serve for Vaultwarden";
    after = [
      "tailscaled.service"
      "vaultwarden.service"
    ];
    wants = [ "tailscaled.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = "${pkgs.tailscale}/bin/tailscale serve --bg 8222";
  };
}
