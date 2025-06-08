{ config, pkgs, ... }:

{
  # Install Nemo with plugins and image preview support
  home.packages = with pkgs; [
    cinnamon.nemo-with-extensions
    imagemagick
    ffmpegthumbnailer
  ];

  # Basic Nemo settings
  dconf.settings = {
    "org/nemo/preferences" = {
      show-image-thumbnails = "always";
      show-location-entry = true;
      show-sidebar = true;
    };
  };

  # Set as default file manager
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
  };
}