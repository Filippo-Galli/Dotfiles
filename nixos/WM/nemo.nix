{ config, pkgs, ... }:

{
  # Install Nemo with plugins and image preview support
  home.packages = with pkgs; [
    nemo-with-extensions
    imagemagick
    ffmpegthumbnailer
  ];

  # Set as default file manager
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
  };
}
