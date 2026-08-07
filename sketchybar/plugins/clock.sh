#!/bin/sh

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

sketchybar --set "$NAME" \
  label="$(date '+%d/%m %H:%M')" \
  label.drawing=on \
  icon.drawing=odd \
  label.padding_left=0 \
  label.padding_right=0 \
  background.drawing=on \
  background.corner_radius=3 \
  background.height=20
