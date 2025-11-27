{ config, pkgs, ... }:

{
  # Install Nemo with plugins and image preview support
  home.packages = with pkgs; [
    nemo-with-extensions
    imagemagick
    ffmpegthumbnailer
  ];

  # Basic Nemo settings
  dconf.settings = {
    "org/nemo/preferences" = {
      show-image-thumbnails = "always";
      show-location-entry = true;
      show-sidebar = true;
      enable-interactive-search = true;  # Enable fuzzy search
    };
    
    "org/nemo/window-state" = {
      start-with-sidebar = true;
    };
  };

  # Set custom keybindings
  xdg.configFile."nemo/accels".text = ''
    (gtk_accel_path "<Actions>/DirViewActions/Trash" "Delete")
  '';

  # Set as default file manager
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
  };
}