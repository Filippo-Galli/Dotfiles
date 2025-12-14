{pkgs, ...}: {

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    bat # A cat clone with syntax highlighting and Git integration

    lazygit
    lazydocker

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    tree 

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # Terminal file managers
    yazi

    # Automounting
    udiskie # automounting for Wayland

    # JSON processor
    jq
  ];

}
