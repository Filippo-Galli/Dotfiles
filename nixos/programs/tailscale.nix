{
  config,
  pkgs,
  ...
}:

{
  # Install the tailscale package
  environment.systemPackages = [ pkgs.tailscale ];

  # Enable the tailscale service
  services.tailscale = {
    enable = true;
  };

  # Open the tailscale port in the firewall
  networking.firewall = {
    # Allow the Tailscale UDP port through the firewall
    allowedUDPPorts = [ 41641 ];
    
    # Allow established connections and the Tailscale network interface
    trustedInterfaces = [ "tailscale0" ];
  };
}
