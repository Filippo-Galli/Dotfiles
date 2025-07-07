{ config, pkgs, ... }:

{
  # Enable hyprlock through home-manager
  programs.hyprlock = {
    enable = true;
    
    settings = {
      # General settings
      general = {
        disable_loading_bar = true;
        grace = 2;
        hide_cursor = true;
        no_fade_in = false;
        # Enable PAM authentication
        pam_module = "hyprlock";
        pam_enabled = true;
        forward_pass = true;
      };

      # Background configuration
      background = [
        {
          path = "/home/filippo/Documents/Dotfiles/nixos/WM/wallpaper/RWB.jpg";
          blur_passes = 0;
          blur_size = 1;
        }
      ];

      # Input field (password)
      input-field = [
        {
          size = "600, 100";
          position = "0, +200";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgba(100, 100, 100, 0.5)";
          inner_color = "rgba(255, 255, 255, 0.1)";  # Semi-transparent white for glass effect
          outer_color = "rgba(255, 255, 255, 0.3)";  # Slightly more opaque border
          outline_thickness = 2;
          placeholder_text = "Password...";
          shadow_passes = 4;  # More shadow passes for depth
          shadow_size = 8;    # Shadow size for glow effect
          shadow_color = "rgba(0, 0, 0, 0.3)";  # Subtle shadow
          # Glossy/glass effect settings
          rounding = 40;      # Rounded corners
          border_size = 1;
          border_color = "rgba(255, 255, 255, 0.5)";  # Bright border for highlight
          # Add authentication feedback
          check_color = "rgba(34, 204, 136, 0.8)";  # Semi-transparent green
          fail_color = "rgba(204, 34, 34, 0.8)";    # Semi-transparent red
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_transition = 300;
          # Additional glass effects
          capslock_color = "rgba(255, 193, 7, 0.8)";  # Caps lock indicator
          numlock_color = "rgba(108, 117, 125, 0.8)";  # Num lock indicator
        }
      ];

      # Clock/Time display
      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgb(24, 25, 38)";
          font_size = 55;
          font_family = "Fira Semibold";
          position = "0, -150";
          halign = "center";
          valign = "top";
        }
        {
          monitor = "";
          text = "cmd[update:43200000] echo \"$(date +\"%A, %d %B %Y\")\"";
          color = "rgb(24, 25, 38)";
          font_size = 25;
          font_family = "Fira Semibold";
          position = "0, -250";
          halign = "center";
          valign = "top";
        }
      ];
    };
  };
}