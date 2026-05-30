{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}:
let
  niriEnabled = (osConfig ? programs) && (osConfig.programs ? niri) && osConfig.programs.niri.enable;
  hostName = osConfig.networking.hostName or "";
  keyboardLayout = if hostName == "gyomei" then "us" else "it";
  screenshotBind = if hostName == "gyomei" then "Mod+S" else "XF86Calculator";
  monitorScale =
    if hostName == "escanor" then
      2.0
    else if hostName == "gyomei" then
      1.6
    else
      1.6;
  wallpaper = ./wallpaper/starship.jpg;
in
lib.mkIf niriEnabled {
  home.packages = [
    inputs.sunsetr.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.nirimon.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.file.".config/sunsetr/sunsetr.toml".text = ''
    transition_mode = "static"
    static_temp = 4000
    static_gamma = 90
  '';

  programs.niri.settings = {
    environment = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
    };

    input = {
      mod-key = "Super";
      focus-follows-mouse.enable = true;
      keyboard.xkb.layout = keyboardLayout;
      touchpad.natural-scroll = true;
      mouse.accel-speed = 0;
    };

    outputs = {
      "eDP-1".scale = monitorScale;
      "DP-3".scale = 1.0;
    };

    layout = {
      gaps = 2;
      focus-ring.enable = false;
      border = {
        enable = true;
        width = 1;
        active.color = "#777777aa";
        inactive.color = "#000000aa";
      };
    };

    animations = {
      horizontal-view-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1400;
        epsilon = 0.0001;
      };
      window-movement.kind.spring = {
        damping-ratio = 1.0;
        stiffness = 1400;
        epsilon = 0.0001;
      };
    };

    window-rules = [
      {
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-left = 10.0;
          bottom-right = 10.0;
        };
        clip-to-geometry = true;
      }
    ];

    spawn-at-startup = [
      {
        argv = [
          "dbus-update-activation-environment"
          "--all"
        ];
      }
      {
        argv = [
          "wl-paste"
          "--type"
          "text"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        argv = [
          "wl-paste"
          "--type"
          "image"
          "--watch"
          "cliphist"
          "store"
        ];
      }
      {
        argv = [
          "cliphist"
          "wipe"
        ];
      }
      { argv = [ "sunsetr" ]; }
      { argv = [ "awww-daemon" ]; }
      {
        argv = [
          "udiskie"
          "-an"
          "--no-tray"
          "-f"
          "nemo"
        ];
      }
      { argv = [ "swayosd-server" ]; }
      {
        argv = [
          "awww"
          "img"
          "${wallpaper}"
        ];
      }
    ];

    binds = {
      # Important Hotkeys dialog
      "Mod+Space".action."show-hotkey-overlay" = [ ];

      # Overview toggle
      "Mod+Tab".action."toggle-overview" = [ ];

      # Basic application bindings
      "Mod+Q".action.spawn = "kitty";
      "Mod+K".action."close-window" = [ ];
      "Mod+L".action.spawn = "hyprlock";

      # Rofi bindings (use spawn-sh for ~ expansion)
      "Mod+E".action."spawn-sh" = "rofi -show drun -theme ~/.config/rofi/custom-theme.rasi";
      "Mod+P".action."spawn-sh" = "rofi -show window -theme ~/.config/rofi/custom-theme.rasi";

      # System controls
      "Mod+Shift+S".action.spawn = [
        "shutdown"
        "now"
      ];
      "Mod+Shift+R".action.spawn = "reboot";

      # Hyprland togglesplit has no direct niri equivalent; closest layout toggle
      "Mod+J".action."toggle-column-tabbed-display" = [ ];

      # Focus movement
      "Mod+Left".action."focus-column-left" = [ ];
      "Mod+Right".action."focus-column-right" = [ ];
      "Mod+Up".action."focus-window-up" = [ ];
      "Mod+Down".action."focus-window-down" = [ ];

      # Workspace switching
      "Mod+1".action."focus-workspace" = 1;
      "Mod+2".action."focus-workspace" = 2;
      "Mod+3".action."focus-workspace" = 3;
      "Mod+4".action."focus-workspace" = 4;
      "Mod+5".action."focus-workspace" = 5;
      "Mod+6".action."focus-workspace" = 6;
      "Mod+7".action."focus-workspace" = 7;
      "Mod+8".action."focus-workspace" = 8;
      "Mod+9".action."focus-workspace" = 9;
      "Mod+0".action."focus-workspace" = 10;

      # Move windows to workspaces
      "Mod+Shift+1".action."move-window-to-workspace" = 1;
      "Mod+Shift+2".action."move-window-to-workspace" = 2;
      "Mod+Shift+3".action."move-window-to-workspace" = 3;
      "Mod+Shift+4".action."move-window-to-workspace" = 4;
      "Mod+Shift+5".action."move-window-to-workspace" = 5;
      "Mod+Shift+6".action."move-window-to-workspace" = 6;
      "Mod+Shift+7".action."move-window-to-workspace" = 7;
      "Mod+Shift+8".action."move-window-to-workspace" = 8;
      "Mod+Shift+9".action."move-window-to-workspace" = 9;
      "Mod+Shift+0".action."move-window-to-workspace" = 10;

      # Workspace scrolling
      "Mod+WheelScrollDown".action."focus-workspace-down" = [ ];
      "Mod+WheelScrollUp".action."focus-workspace-up" = [ ];

      # Brightness controls with SwayOSD
      "XF86MonBrightnessUp" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--brightness"
          "raise"
        ];
      };
      "XF86MonBrightnessDown" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--brightness"
          "lower"
        ];
      };

      # Audio controls with SwayOSD
      "XF86AudioRaiseVolume" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--output-volume"
          "raise"
        ];
      };
      "XF86AudioLowerVolume" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--output-volume"
          "lower"
        ];
      };
      "XF86AudioMute" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--output-volume"
          "mute-toggle"
        ];
      };
      "Super+XF86AudioRaiseVolume" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--input-volume"
          "raise"
        ];
      };
      "Super+XF86AudioLowerVolume" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--input-volume"
          "lower"
        ];
      };
      "XF86AudioMicMute" = {
        "allow-when-locked" = true;
        action.spawn = [
          "swayosd-client"
          "--input-volume"
          "mute-toggle"
        ];
      };

      # Caps Lock toggle with SwayOSD
      "Caps_Lock".action.spawn = [
        "swayosd-client"
        "--caps-lock"
        "toogle"
      ];

      # Screenshot
      "${screenshotBind}".action."spawn-sh" = "grim -g \"$(slurp)\"";

      # Waybar toggle
      "Mod+W".action."spawn-sh" =
        "if systemctl --user is-active --quiet waybar; then systemctl --user stop waybar; else systemctl --user start waybar; fi";

      # Custom application bindings
      "Mod+B".action.spawn = "brave";
      "Mod+F".action."fullscreen-window" = [ ];
      "Mod+C".action.spawn = [
        "code"
        "--password-store=gnome-libsecret"
      ];
      "Mod+N".action.spawn = "nemo";
      "Mod+Shift+B".action.spawn = "bitwarden";
      "Mod+V".action."spawn-sh" =
        "cliphist list | rofi -dmenu -display-columns 2- -theme ~/.config/rofi/custom-theme-dmenu.rasi | cliphist decode | wl-copy";
      "Mod+O".action.spawn = "obsidian";
      "Mod+G".action.spawn = [
        "kitty"
        "--class"
        "gazelle"
        "-e"
        "gazelle"
      ];

      # Multi-monitor workspace movement
      "Mod+Alt+L".action."move-workspace-to-monitor-left" = [ ];
      "Mod+Alt+R".action."move-workspace-to-monitor-right" = [ ];

      # Window management
      "Mod+Shift+Left".action."move-column-left" = [ ];
      "Mod+Shift+Right".action."move-column-right" = [ ];
      "Mod+Shift+Up".action."move-window-up" = [ ];
      "Mod+Shift+Down".action."move-window-down" = [ ];
    };
  };
}
