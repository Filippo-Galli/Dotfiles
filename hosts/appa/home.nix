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
    # Set the shell to nushell
    SHELL = "${pkgs.nushell}/bin/nu";
  };

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Vs code nix extension
    nil
    nixfmt

    # Nix output monitor
    nix-output-monitor
  ];

  imports = [
    ../../programs/direnv.nix
    ../../programs/nvim.nix
    ../../shell/git.nix
    ../../shell/nushell.nix
    ../../shell/starship.nix
    ../../shell/terminal_program.nix
  ];
}
