{ pkgs, ... }:
{
  # Enable the tailscale service
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall = {
    # Allow established connections and the Tailscale network interface
    trustedInterfaces = [ "tailscale0" ];
  };
}
