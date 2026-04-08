{
  pkgs,
  username,
  stateVersion,
  inputs,
  ...
}:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Set environment variables for applications to find the keyring
  home.sessionVariables = {
    # Set the shell to zsh
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Vs code nix extension
    nil
    nixfmt-rfc-style

    # Nix output monitor
    nix-output-monitor

    # ghgrab
    inputs.ghgrab.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  imports = [
    ../../programs/direnv.nix
    ../../programs/nvim.nix
    ../../shell/git.nix
    ../../shell/zsh.nix
    ../../shell/nushell.nix
    ../../shell/starship.nix
    ../../shell/terminal_program.nix
  ];
}
