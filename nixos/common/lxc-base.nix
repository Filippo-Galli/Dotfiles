{
  modulesPath,
  stateVersion,
  lib,
  ...
}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ../programs/tailscale.nix
  ];

  # Minimal system for a container
  system.stateVersion = stateVersion;

  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "yes";

  users.users.root.hashedPassword = "$6$/5LG06ycvzJqkjQa$rxy6rj4gIb3WUxuWTAlrGH1hRKkNLchoBEoJc9qN.mJmCMdUma/uiI.MKA/9G4pjCsf5H7azz1bfx/jeW.Ozg1";
  services.tailscale.enable = lib.mkDefault true;

  networking.useDHCP = lib.mkDefault true;

  boot.loader.systemd-boot.enable = lib.mkDefault false;
  boot.loader.grub.enable = lib.mkDefault false;
}
