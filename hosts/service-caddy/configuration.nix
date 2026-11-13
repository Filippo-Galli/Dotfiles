{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  domain = "thepippo.org";
  privateDomain = "private.${domain}";

  tailscaleIP = "100.72.91.47";
  acmeEmail = "thepippolab@gmail.com";
  tunnelId = "61e13ffe-efdf-4e97-90be-797b265600c2";

  proxmoxTLSName = "pve";

  # Services exposed publicly through Cloudflare Tunnel.
  publicUpstreams = {
    "nc.${domain}" = "{$UPSTREAM_NC}";
    "auth.${domain}" = "{$UPSTREAM_AUTH}";
    "vw.${domain}" = "{$UPSTREAM_VW}";
    "obsidian.${domain}" = "{$UPSTREAM_OBSIDIAN}";
    "ntfy.${domain}" = "{$UPSTREAM_NTFY}";
    "cache.${domain}" = "{$UPSTREAM_ATTIC}";
  };

  # Services accessible only through Tailscale.
  privateUpstreams = {
    grafana = "{$UPSTREAM_GRAFANA}";
    immich = "{$UPSTREAM_IMMICH}";
  };

  certName = privateDomain;
  certDir = "/var/lib/acme/${certName}";

  privateTLS = ''
    tls ${certDir}/fullchain.pem ${certDir}/key.pem
  '';

  accessLog = ''
    output stderr
    format json
  '';

  publicExtra = {
    "vw.${domain}" = ''
      @blocked path /admin /admin/*
      respond @blocked 404
    '';
  };

  mkPublic =
    hostname: upstream:
    lib.nameValuePair "http://${hostname}:8080" {
      listenAddresses = [ "127.0.0.1" ];
      logFormat = accessLog;

      extraConfig = ''
        ${publicExtra.${hostname} or ""}
        reverse_proxy ${upstream} {
          header_up X-Real-IP {client_ip}
        }
      '';
    };

  mkPrivate =
    name: upstream:
    lib.nameValuePair "https://${name}.${privateDomain}" {
      listenAddresses = [ tailscaleIP ];
      logFormat = accessLog;

      extraConfig = ''
        ${privateTLS}
        reverse_proxy ${upstream}
      '';
    };
in
{
  imports = [
    ../../common/lxc-base.nix
  ];

  sops = {
    defaultSopsFile = ./secrets.yaml;
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      cloudflare_dns_token = {
        owner = "acme";
        group = "caddy";
        mode = "0440";
      };

      cloudflared_creds = {
        owner = "cloudflared";
      };

      caddy_env = {
        owner = "caddy";
        restartUnits = [ "caddy.service" ];
      };
    };
  };

  networking.hostName = "caddy";

  homelab.lxc.ctId = 100;

  image.modules.proxmox-lxc = {
    imports = [
      (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ];

    image.baseName = "${config.networking.hostName}-${config.system.nixos.label}";
  };

  systemd.mounts = [
    {
      where = "/sys/kernel/debug";
      enable = false;
    }
  ];

  users.groups.cloudflared = { };

  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
  };

  networking.firewall = {
    enable = true;
    interfaces.tailscale0.allowedTCPPorts = [ 443 ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = acmeEmail;

    certs.${certName} = {
      domain = "*.${privateDomain}";
      dnsProvider = "cloudflare";

      credentialFiles = {
        CLOUDFLARE_DNS_API_TOKEN_FILE = config.sops.secrets.cloudflare_dns_token.path;
      };

      dnsResolver = "1.1.1.1:53";

      group = "caddy";
      reloadServices = [ "caddy.service" ];
    };
  };

  services.caddy = {
    enable = true;
    openFirewall = false;

    globalConfig = ''
      auto_https disable_redirects

      servers {
        trusted_proxies static 127.0.0.1/32
        client_ip_headers CF-Connecting-IP
      }
    '';

    virtualHosts =
      builtins.listToAttrs (lib.mapAttrsToList mkPublic publicUpstreams)
      // builtins.listToAttrs (lib.mapAttrsToList mkPrivate privateUpstreams)
      // {
        "http://:8080" = {
          listenAddresses = [ "127.0.0.1" ];
          logFormat = accessLog;

          extraConfig = ''
            respond "Not found" 404
          '';
        };

        "https://proxmox.${privateDomain}" = {
          listenAddresses = [ tailscaleIP ];
          logFormat = accessLog;

          extraConfig = ''
            ${privateTLS}

            reverse_proxy https://{$PROXMOX_IP}:8006 {
              transport http {
                tls_server_name ${proxmoxTLSName}
                tls_trust_pool file /var/lib/caddy-trust/proxmox-ca.pem
              }
            }
          '';
        };
      };
  };

  systemd.services.caddy = {
    requires = [
      "acme-${certName}.service"
    ];

    wants = [
      "tailscaled.service"
    ];

    after = [
      "acme-${certName}.service"
      "tailscaled.service"
    ];

    preStart = lib.mkBefore ''
      echo "Waiting for Tailscale address ${tailscaleIP}..."

      for attempt in $(${pkgs.coreutils}/bin/seq 1 60); do
        if ${pkgs.iproute2}/bin/ip -4 -o addr show dev tailscale0 \
          2>/dev/null \
          | ${pkgs.gnugrep}/bin/grep \
              -Fq " inet ${tailscaleIP}/"; then
          echo "Tailscale address ${tailscaleIP} is available."
          exit 0
        fi

        ${pkgs.coreutils}/bin/sleep 1
      done

      echo \
        "Tailscale address ${tailscaleIP} did not become available." \
        >&2

      exit 1
    '';

    serviceConfig = {
      EnvironmentFile = [ config.sops.secrets.caddy_env.path ];
      TimeoutStartSec = "120s";
      Restart = lib.mkForce "on-failure";
      RestartSec = "5s";
    };
  };

  services.cloudflared = {
    enable = true;

    tunnels.${tunnelId} = {
      credentialsFile = config.sops.secrets.cloudflared_creds.path;

      ingress = lib.mapAttrs (_: _: {
        service = "http://127.0.0.1:8080";
      }) publicUpstreams;

      default = "http_status:404";
    };
  };
}
