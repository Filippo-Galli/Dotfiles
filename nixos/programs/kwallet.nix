{ config, lib, ... }:

{
  # Mask kwalletd6 by overriding with disabled units
  systemd.user.services.kwalletd6 = lib.mkForce {
    Unit = {
      Description = "KWallet Daemon (Disabled)";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "/bin/true";
      RemainAfterExit = false;
    };
  };

  systemd.user.sockets.kwalletd6 = lib.mkForce {};

  # Also disable through environment variable
  home.sessionVariables = {
    KWALLETD_DISABLE = "1";
  };

  # Disable it through config
  home.file.".config/kwalletrc".text = ''
    [Wallet]
    Enabled=false
    First Use=false
  '';
}