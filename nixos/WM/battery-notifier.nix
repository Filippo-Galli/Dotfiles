{ config, pkgs, ...}:
{
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    libnotify      # provides notify-send command
    acpi          # provides battery information commands
    systemd       # for systemctl (usually already available)
  ];

  # User service for battery monitoring
  systemd.user.services.battery-monitor = {
    description = "Battery Level Monitor";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "battery-check" ''
        #!/bin/bash
        
        # Read battery capacity and status
        CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo "0")
        STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null || echo "Unknown")
        
        # Create state directory for flags
        STATE_DIR="$HOME/.cache/battery-monitor"
        mkdir -p "$STATE_DIR"
        
        # Flag files to prevent duplicate notifications
        FULL_FLAG="$STATE_DIR/full_flag"
        LOW_30_FLAG="$STATE_DIR/low_30_flag"
        LOW_20_FLAG="$STATE_DIR/low_20_flag"
        CRIT_FLAG="$STATE_DIR/crit_flag"
        VCRIT_FLAG="$STATE_DIR/vcrit_flag"
        
        if [[ "$STATUS" != "Discharging" ]]; then
          # Charging state - clear discharge flags
          ${pkgs.systemd}/bin/systemctl --user cancel-shutdown 2>/dev/null || true
          rm -f "$LOW_30_FLAG" "$LOW_20_FLAG" "$CRIT_FLAG" "$VCRIT_FLAG"
          
          # Full battery notification
          if [[ $CAPACITY -ge 90 ]] && [[ ! -f "$FULL_FLAG" ]]; then
            ${pkgs.libnotify}/bin/notify-send "🔋 Battery FULL" "Unplug the charger" -u low
            touch "$FULL_FLAG"
          elif [[ $CAPACITY -lt 90 ]]; then
            rm -f "$FULL_FLAG"
          fi
        else
          # Discharging state - clear full flag
          rm -f "$FULL_FLAG"
          
          # 30% warning
          if [[ $CAPACITY -le 30 ]] && [[ $CAPACITY -gt 20 ]] && [[ ! -f "$LOW_30_FLAG" ]]; then
            ${pkgs.libnotify}/bin/notify-send "⚠️ Battery LOW" "Battery at $CAPACITY%" -u low -t 5000
            touch "$LOW_30_FLAG"
          fi
          
          # 20% warning  
          if [[ $CAPACITY -le 20 ]] && [[ $CAPACITY -gt 10 ]] && [[ ! -f "$LOW_20_FLAG" ]]; then
            ${pkgs.libnotify}/bin/notify-send "⚠️ Battery LOW" "Battery at $CAPACITY%, find your charger!" -u normal
            touch "$LOW_20_FLAG"
          fi
          
          # 10% critical
          if [[ $CAPACITY -le 10 ]] && [[ $CAPACITY -gt 5 ]] && [[ ! -f "$CRIT_FLAG" ]]; then
            ${pkgs.libnotify}/bin/notify-send "🚨 CRITICAL Battery Level" "Plug in charger NOW! ($CAPACITY%)" -u critical
            touch "$CRIT_FLAG"
          fi
          
          # 5% very critical - shutdown
          if [[ $CAPACITY -le 5 ]] && [[ ! -f "$VCRIT_FLAG" ]]; then
            ${pkgs.libnotify}/bin/notify-send "💀 BYE BYE" "SHUTDOWN in 1 minute! ($CAPACITY%)" -u critical -t 10000
            # Schedule shutdown in 1 minute
            ${pkgs.systemd}/bin/systemctl poweroff --when="+1"
            touch "$VCRIT_FLAG"
          fi
          
          # Clear flags when battery level increases
          if [[ $CAPACITY -gt 30 ]]; then
            rm -f "$LOW_30_FLAG"
          fi
          if [[ $CAPACITY -gt 20 ]]; then
            rm -f "$LOW_20_FLAG"  
          fi
          if [[ $CAPACITY -gt 10 ]]; then
            rm -f "$CRIT_FLAG"
          fi
          if [[ $CAPACITY -gt 5 ]]; then
            rm -f "$VCRIT_FLAG"
          fi
        fi
      '';
    };
  };

  # Timer to run the battery check every 30 seconds
  systemd.user.timers.battery-monitor = {
    description = "Battery Monitor Timer";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1min";        # Start 1 minute after boot
      OnUnitActiveSec = "30s";   # Run every 30 seconds
      Persistent = true;         # Catch up missed runs
    };
  };

  # Optional: Enable the timer by default for all users
  # You can also enable it manually with: systemctl --user enable --now battery-monitor.timer
}