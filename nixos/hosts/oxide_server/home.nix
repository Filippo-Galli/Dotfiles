{
  config,
  pkgs,
  username,
  stateVersion,
  inputs,
  ...
}:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  services.gnome-keyring = {
    enable = true;
    components = [
      "pkcs11"
      "secrets"
      "ssh"
    ];
  };

  # Set environment variables for applications to find the keyring
  home.sessionVariables = {
    GNOME_KEYRING_CONTROL = "${config.home.homeDirectory}/.cache/keyring-control";
    BRAVE_PASSWORD_STORE = "gnome-libsecret";

    # Enable Ozone Wayland support
    NIXOS_OZONE_WL = "1";

    # GTK settings
    # GTK_THEME = "Adwaita-dark";
    # GTK_APPLICATION_PREFER_DARK_THEME = "1";
    GDK_BACKEND = "wayland,x11";

    # QT settings
    QT_QPA_PLATFORM = "wayland";

    # Cursor theme
    # XCURSOR_THEME = "Adwaita";
    # XCURSOR_SIZE = "24";

    # Set the shell to zsh
    SHELL = "${pkgs.zsh}/bin/zsh";

    # MESA_LOADER_DRIVER_OVERRIDE = "iris"; # For Intel graphics
    # LIBVA_DRIVER_NAME = "iHD"; # Intel hardware acceleration

  };

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  xdg.mimeApps = {
    enable = true;
  };

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
    ../../shell/kitty.nix
    ../../shell/zsh.nix
    ../../shell/nushell.nix
    ../../shell/starship.nix
    ../../shell/terminal_program.nix
  ];
}
