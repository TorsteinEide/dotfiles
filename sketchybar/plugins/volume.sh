#!/bin/sh

# The volume_change event supplies a $INFO variable in which the current volume
# percentage is passed to the script.

source "$CONFIG_DIR/colors.sh"

if [ "$SENDER" = "volume_change" ]; then
  VOLUME="$INFO"
  COLOR="$GREEN"

  case "$VOLUME" in
  [6-9][0-9] | 100)
    ICON="󰕾"
    COLOR=$RED
    ;;

  [5-9][0-9] | 100)
    ICON="󰕾"
    COLOR=$YELLOW
    ;;
  [3-4][0-9])
    ICON="󰖀"
    COLOR=$GREEN
    ;;
  [1-9] | [1-2][0-9])
    ICON="󰕿"
    COLOR=$GREEN
    ;;
  *)
    ICON="󰖁"
    COLOR=$CYAN
    ;;
  esac

  sketchybar --set "$NAME" icon="$ICON" label="$VOLUME%" background.color="$COLOR" background.corner_radius=3 background.height=20
fi
