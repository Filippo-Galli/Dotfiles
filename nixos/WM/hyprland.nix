{ config, pkgs, ... }:
{

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      "$mainMod" = "SUPER";

      env = [
      	"XCURSOR_THEME,Adwaita"
      	"XCURSOR_SIZE,24"
       ];
      
      # Monitor configuration
      monitor = [
        ",preferred,auto,2"
        "DP-3, 1920x1080, 2880x0, 1"
      ];
      
      # Startup applications
      exec-once = [
        "wl-paste --type text --watch cliphist store"
        "wl-paste --type image --watch cliphist store"
        "cliphist wipe"
        
        "hyprsunset -t 4000"
        "bus-update-activation-environment --all"
        "swww-daemon"
        "swww img ./pxfuel.jpg"
        #"udiskie -an --no-tray -f nemo"
        "bash ./battery_notify.sh"
      ];
      
      # Input configuration
      input = {
        kb_layout = "it";
        kb_variant = "";
        kb_model = "";
        kb_options = "";
        kb_rules = "";
        
        follow_mouse = 1;
        
        touchpad = {
          natural_scroll = true;
        };
        
        sensitivity = 0;
      };
      
      # Miscellaneous settings
      misc = {
        disable_hyprland_logo = true;
        vfr = true;
      };
      
      # General settings
      general = {
        gaps_in = 5;
        gaps_out = 1;
        border_size = 2;
        "col.active_border" = "rgba(777777aa)";
        "col.inactive_border" = "rgba(000000aa)";
        layout = "dwindle";
      };
      
      # Decoration settings
      decoration = {
        rounding = 10;
      };
      
      # Animation settings
      animations = {
        enabled = false;
        
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };
      
      # Dwindle layout settings
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      
      # Master layout settings
      master = {};
      
      # Gesture settings
      gestures = {
        workspace_swipe = true;
      };
      
      # Device-specific settings
      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };
      
      # Key bindings
      bind = [
        # Basic application bindings
        "$mainMod, Q, exec, kitty"
        "$mainMod, k, killactive"
        "$mainMod, L, exec, swaylock --clock --color 000000"
        "$mainMod, E, exec, bash ~/.config/rofi/launchers/type-5/launcher.sh"
        "$mainMod SHIFT, S, exec, shutdown now"
        "$mainMod SHIFT, R, exec, reboot"
        "$mainMod, P, pseudo"
        "$mainMod, J, togglesplit"
        
        # Focus movement with arrow keys
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        
        # Workspace switching
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        
        # Move windows to workspaces
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        
        # Workspace scrolling
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        
        # Brightness controls
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%- --min-value=5"
        
        # Audio controls
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        "SUPER, XF86AudioRaiseVolume, exec, pamixer --default-source -i 5"
        "SUPER, XF86AudioLowerVolume, exec, pamixer --default-source -d 5"
        ", XF86AudioMicMute, exec, pamixer --default-source --toggle-mute"
        
        # Screenshot
        ", XF86Calculator, exec, grim -g \"$(slurp)\""
        
        # Waybar toggle
        #"$mainMod, W, exec, pkill waybar || waybar -c ~/Documents/Dotfiles/Hyprland/waybar/config -s ~/Documents/Dotfiles/Hyprland/waybar/style.css "
        "$mainMod, W, exec, if systemctl --user is-active --quiet waybar; then systemctl --user stop waybar; else systemctl --user start waybar; fi"
        
        # Custom application bindings
        "$mainMod, B, exec, brave"
        "$mainMod, F, fullscreen"
        "$mainMod, C, exec, code --password-store=\"gnome-libsecret\""
        "$mainMod, N, exec, nemo"
        "$mainMod, V, exec, cliphist list | rofi -dmenu -theme ~/.config/rofi/launchers/type-2/style-1.rasi | cliphist decode | wl-copy"
        "$mainMod, R, exec, ~/Documents/Dotfiles/Script/toogle_temperature.sh"
        "$mainMod, O, exec, obsidian"
        
        # Multi-monitor workspace movement
        "$mainMod ALT, L, movecurrentworkspacetomonitor, l"
        "$mainMod ALT, R, movecurrentworkspacetomonitor, r"
      ];
      
      # Mouse bindings
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
