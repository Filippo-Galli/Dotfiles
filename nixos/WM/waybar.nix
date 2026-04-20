{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };

    style = builtins.readFile ./config/waybar/style.css;

    settings = {
      mainBar = {
        layer = "top";
        height = 30;
        spacing = 4;

        # Module layout
        modules-left = [
          "network"
          "pulseaudio"
          "bluetooth"
          #"custom/privacy-dots"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "temperature"
          "power-profiles-daemon"
          "battery"
          "custom/notification"
        ];

        # Module configurations
        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}%  ";
        };

        memory = {
          format = "{used} GB  ";
        };

        power-profiles-daemon = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            "default" = " ";
            "performance" = " ";
            "balanced" = "  ";
            "power-saver" = "  ";
          };
        };

        temperature = {
          thermal-zone = 9;
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [ "" ];
        };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };
          interval = 1;
          format = "{capacity}% {icon}";
          format-charging = "{capacity}%  ";
          format-alt = "{time} {icon}";
          format-icons = [
            " "
            " "
            " "
            " "
            " "
          ];
        };

        network = {
          format-ethernet = "[{bandwidthUpBits}]/[{bandwidthDownBits}]  ";
          format-wifi = "{essid} ({signalStrength}%)  ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-disabled = "Disabled ⚠";
          #on-click = "kitty impala";
        };

        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon}  {format_source} ";
          format-bluetooth-muted = "  {icon}  {format_source}";
          format-muted = "  {format_source}";
          format-source = "";
          format-source-muted = " ";
          format-icons = {
            headphone = " ";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              " "
              " "
            ];
          };
          on-click = "pavucontrol";
        };

        bluetooth = {
          format-on = " ";
          format-off = "! ";
          on-click = "kitty bluetuith";
        };

        "custom/privacy-dots" = {
          exec = "${./config/scripts/privacy_dots.sh}";
          return-type = "json";
          interval = 10;
          format = "{text}";
          tooltip = true;
          escape = false;
          markup = "pango";
        };

        "custom/hyprsunset" = {
          format = "{icon}";
          tooltip-format = "Blue light filter: {}";
          exec = "if pgrep -x hyprsunset > /dev/null; then echo 'ON'; else echo 'OFF'; fi";
          on-click = "pkill hyprsunset || hyprsunset -t 4000";
          format-icons = {
            "ON" = " ";
            "OFF" = " ";
          };
          interval = 5;
        };

        "custom/notification" = {
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = " <span foreground='red'><sup> </sup></span>";
            "none" = " ";
            "dnd-notification" = " <span foreground='red'><sup> </sup></span>";
            "dnd-none" = " ";
            "inhibited-notification" = " <span foreground='red'><sup> </sup></span>";
            "inhibited-none" = " ";
            "dnd-inhibited-notification" = " <span foreground='red'><sup> </sup></span>";
            "dnd-inhibited-none" = " ";
          };
          "return-type" = "json";
          "exec-if" = "which swaync-client";
          "exec" = "swaync-client -swb";
          "on-click" = "swaync-client -t -sw";
          "on-click-right" = "swaync-client -d -sw";
          "escape" = true;
        };

        tray = {
          icon-size = 21;
          spacing = 5;
        };
      };
    };
  };
}
