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

    MESA_LOADER_DRIVER_OVERRIDE = "iris"; # For Intel graphics
    LIBVA_DRIVER_NAME = "iHD"; # Intel hardware acceleration

  };

  home.stateVersion = stateVersion;
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/mattermost" = [ "mattermost-desktop.desktop" ];
    };
  };

  home.packages = with pkgs; [
    # Wayland utilities
    waybar # Status bar
    swww # Wallpaper daemon
    wl-clipboard # Clipboard utilities
    cliphist # Clipboard history
    grim # Screenshot utility
    slurp # Screen area selection
    mako # Notification daemon
    hyprsunset # Blue-light
    brightnessctl # Brightness control

    # Vs code nix extension
    nil
    nixfmt-rfc-style

    # Bluetooth
    bluetuith # TUI Bluetooth manager

    # OSD
    swayosd

    # Nix output monitor
    nix-output-monitor

    # ghgrab
    inputs.ghgrab.packages.${pkgs.system}.default
  ];

  imports = [
    ../../programs/vscode.nix
    ../../programs/obsidian.nix
    ../../programs/brave.nix
    ../../programs/direnv.nix
    ../../programs/nvim.nix
    ../../programs/nextcloud-client.nix
    ../../programs/kwallet.nix
    ../../programs/onlyoffice.nix
    ../../programs/zotero.nix
    ../../programs/firefox.nix
    ../../programs/mattermost.nix
    ../../programs/zed.nix
    ../../shell/git.nix
    ../../shell/kitty.nix
    ../../shell/zsh.nix
    ../../shell/nushell.nix
    ../../shell/starship.nix
    ../../shell/terminal_program.nix
    ../../WM/hyprland.nix
    ../../WM/waybar.nix
    ../../WM/rofi.nix
    ../../WM/nemo.nix
    ../../WM/hyprlock.nix
    ../../WM/gtk.nix
    ../../WM/swaync.nix
    ../../WM/gazelle.nix
    ../../WM/hyprmon.nix
  ];
}
