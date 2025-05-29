#!/bin/bash

# Get the class or title of the kitten terminal window
WINDOW_CLASS="kitty" # You might need to adjust this

# Check if the window is visible
if hyprctl clients | grep -q "$WINDOW_CLASS" | grep -q "mapped: 1"; then
  # If visible, minimize it
  hyprctl dispatch movetoworkspace special:minimize "$WINDOW_CLASS"
else
  # If not visible or minimized, restore it and focus
  hyprctl dispatch focuswindow "$WINDOW_CLASS"
fi
