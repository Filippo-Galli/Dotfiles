{ config, pkgs, ... }:

{
  # Ensure we have the necessary tools
  home.packages = with pkgs; [
    zenity  # For dialog boxes if needed
  ];

  # GNOME keybindings through Home Manager
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
	"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/"     
	 ];
    };

    # Kitty terminal with Super+q
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>q";
      command = "kitty";
      name = "Launch Terminal";
    };
    
    # Brave browser with Super+b
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>b";
      command = "brave";
      name = "Launch Brave";
    };

    # Add direct mapping for window closing 
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>k"];  # This directly maps Super+k to the window close function
    };

    # Vs code with Super+c
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>c";
      command = "code";
      name = "Launch VS Code";
    };



  };
}
