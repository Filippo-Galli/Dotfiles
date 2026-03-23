{ config, pkgs, ... }:

{
  # Install Nemo with plugins and image preview support
  home.packages = with pkgs; [
    nemo-with-extensions
    imagemagick
    ffmpegthumbnailer
  ];

  dconf.settings = {
    "org/nemo/preferences" = {
      enable-delete = true;
      swap-trash-delete = true;
      default-folder-viewer = "list-view";
      click-policy = "double";
      date-format = "iso";
      show-advanced-permissions = true;
      show-hidden-files = true;
      show-toggle-extra-pane-toolbar = true;
      size-prefixes = "base-10";
      tooltips-in-icon-view = false;
      tooltips-in-list-view = true;
      show-thumbnails = true;
    };
  };

  # Set as default file manager
  xdg.mimeApps.defaultApplications = {
    "inode/directory" = "nemo.desktop";
  };
}
