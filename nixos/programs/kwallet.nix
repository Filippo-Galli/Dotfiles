{ config, lib, ... }:

let
  disableService = {
    Unit = {
      Description = "Disabled KWallet Daemon";
    };
    Service = {
      ExecStart = "${config.programs.bash.package}/bin/false";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
in {
  # Mask kwalletd6 (prevents auto-starting)
  systemd.user.services.kwalletd6 = disableService;
  systemd.user.sockets.kwalletd6 = disableService;

  # Disable it through config
  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';
}


