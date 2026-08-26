{ pkgs, ... }:
{
  imports = [
    ../../common/lxc-base.nix
    ../../programs/tailscale.nix
  ];

  networking.hostName = "vaultwarden";

  services.tailscale.extraUpFlags = [ "--ssh" ];

  services.vaultwarden = {
    enable = true;
    dbBackend = "sqlite";
    config = {
      DOMAIN = "https://vaultwarden.<your-tailnet-name>.ts.net";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = true;
    };
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
  };

  # Declaratively run `tailscale serve` on boot instead of doing it by hand each time
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
