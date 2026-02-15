#!/usr/bin/env bash
# dependencies: pipewire (pw-dump), jq

mic=0
cam=0
loc=0
scr=0

mic_app=""
cam_app=""
loc_app=""
scr_app=""

# PipeWire detection (mic + screen)
if command -v pw-dump >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  dump=$(pw-dump 2>/dev/null) || dump=""
  
  if [[ -n "$dump" ]]; then
    # Mic detection
    mic=$(printf '%s' "$dump" | jq -r '
      [.[] | select(.type=="PipeWire:Interface:Node")
           | select(.info.props."media.class"=="Audio/Source" or .info.props."media.class"=="Audio/Source/Virtual")
           | select(.info.state=="running")] | if length>0 then 1 else 0 end' 2>/dev/null) || mic=0
    
    if [[ "$mic" == "1" ]]; then
      mic_app=$(printf '%s' "$dump" | jq -r '
        [.[] | select(.type=="PipeWire:Interface:Node")
             | select(.info.props."media.class"=="Stream/Input/Audio")
             | select(.info.state=="running")
             | .info.props["node.name"] // empty] | unique | join(", ")' 2>/dev/null) || mic_app=""
    fi
    
    # Screen sharing detection
    scr=$(printf '%s' "$dump" | jq -r '
      [.[] | select(.info?.props?["media.name"]? // "" | test("xdph-streaming|gsr-default|game capture"))]
      | if length>0 then 1 else 0 end' 2>/dev/null) || scr=0
    
    if [[ "$scr" == "1" ]]; then
      scr_app=$(printf '%s' "$dump" | jq -r '
        [.[] | select(.type=="PipeWire:Interface:Node")
             | select(.info.state=="running")
             | select(.info.props."media.class"=="Stream/Input/Video" or 
                      (.info.props."media.name" // "" | test("gsr-default|game capture")))
             | .info.props["media.name"] // empty] | unique | join(", ")' 2>/dev/null) || scr_app=""
    fi
  fi
fi

# Camera detection - using find with -lname (fast)
cam_result=$(find /proc/[0-9]*/fd -maxdepth 1 -lname '/dev/video*' -printf '%h\n' 2>/dev/null | head -5)
if [[ -n "$cam_result" ]]; then
  cam=1
  while IFS= read -r fd_dir; do
    pid="${fd_dir#/proc/}"
    pid="${pid%/fd}"
    pname=$(cat "/proc/$pid/comm" 2>/dev/null) || continue
    [[ "$cam_app" != *"$pname"* ]] && cam_app="${cam_app:+$cam_app, }$pname"
  done <<< "$cam_result"
fi

# Location detection
if pgrep -x geoclue >/dev/null 2>&1; then
  loc=1
  loc_app="geoclue"
fi

# Output
green="#30D158"
orange="#FF9F0A"
blue="#0A84FF"
purple="#9B32FA"

text=""
[[ "$mic" == "1" ]] && text+="<span foreground=\"$green\">●</span>"
[[ "$cam" == "1" ]] && text+="<span foreground=\"$orange\">●</span>"
[[ "$loc" == "1" ]] && text+="<span foreground=\"$blue\">●</span>"
[[ "$scr" == "1" ]] && text+="<span foreground=\"$purple\">●</span>"

tooltip="Mic: ${mic_app:-off}  |  Cam: ${cam_app:-off}  |  Location: ${loc_app:-off}  |  Screen: ${scr_app:-off}"

classes="privacydot"
[[ "$mic" == "1" ]] && classes+=" mic-on" || classes+=" mic-off"
[[ "$cam" == "1" ]] && classes+=" cam-on" || classes+=" cam-off"
[[ "$loc" == "1" ]] && classes+=" loc-on" || classes+=" loc-off"
[[ "$scr" == "1" ]] && classes+=" scr-on" || classes+=" scr-off"

jq -c -n --arg text "$text" --arg tooltip "$tooltip" --arg class "$classes" \
  '{text:$text, tooltip:$tooltip, class:$class}'