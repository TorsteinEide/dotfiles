#!/bin/sh

source "$CONFIG_DIR/colors.sh" # Loads all defined colors

IP_ADDRESS=$(scutil --nwi | grep address | sed 's/.*://' | tr -d ' ' | head -1)
IS_VPN=$(scutil --nwi | grep -m1 'utun' | awk '{ print $1 }')

if [[ $IS_VPN != "" ]]; then
  COLOR=$CYAN
  ICON=󱛀
elif [[ $IP_ADDRESS != "" ]]; then
  COLOR=$BLUE
  ICON=
else
  COLOR=$YELLOW
  ICON=󱚼
fi

sketchybar --set $NAME background.color=$COLOR \
  icon=$ICON \
  label.drawing=off
