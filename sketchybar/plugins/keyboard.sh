#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"
PLUGIN_DIR="$CONFIG_DIR/plugins"

source "$CONFIG_DIR/colors.sh"

KEYBOARD_ACTIVE_COLOR="${ACTIVE_COLOR:-0xff40826d}"
KEYBOARD_INACTIVE_COLOR="${INACTIVE_DEFAULT_COLOR:-0x332f343f}"

ACTIVE_TEXT="0xffffffff"
INACTIVE_TEXT="0xff8f959e"

PLIST="$HOME/Library/Preferences/com.apple.HIToolbox.plist"

get_layout() {
  plutil -extract AppleSelectedInputSources json -o - "$PLIST" 2>/dev/null |
    /usr/bin/python3 -c '
import json
import sys

try:
    sources = json.load(sys.stdin)
except Exception:
    raise SystemExit(1)

for source in sources:
    name = source.get("KeyboardLayout Name")
    if name:
        print(name)
        break
'
}

update_keyboard_indicator() {
  # Determine which layout SketchyBar currently displays as active.
  EN_COLOR="$(
    sketchybar --query keyboard.en 2>/dev/null |
      plutil -extract background.color raw -o - - 2>/dev/null
  )"

  NO_COLOR="$(
    sketchybar --query keyboard.no 2>/dev/null |
      plutil -extract background.color raw -o - - 2>/dev/null
  )"

  PREVIOUS_LAYOUT=""

  if [[ "$EN_COLOR" == "$KEYBOARD_ACTIVE_COLOR" ]]; then
    PREVIOUS_LAYOUT="ABC"
  elif [[ "$NO_COLOR" == "$KEYBOARD_ACTIVE_COLOR" ]]; then
    PREVIOUS_LAYOUT="Norwegian"
  fi

  LAYOUT=""

  # The notification can arrive before the plist has updated.
  for _ in {1..20}; do
    CANDIDATE="$(get_layout)"

    case "$CANDIDATE" in
    ABC | Norwegian)
      LAYOUT="$CANDIDATE"

      if [[ -z "$PREVIOUS_LAYOUT" ||
        "$LAYOUT" != "$PREVIOUS_LAYOUT" ]]; then
        break
      fi
      ;;
    esac

    sleep 0.05
  done

  case "$LAYOUT" in
  ABC)
    sketchybar \
      --set keyboard.en \
      background.drawing=on \
      background.color="$KEYBOARD_ACTIVE_COLOR" \
      label.color="$ACTIVE_TEXT" \
      --set keyboard.no \
      background.drawing=on \
      background.color="$KEYBOARD_INACTIVE_COLOR" \
      label.color="$INACTIVE_TEXT"
    ;;

  Norwegian)
    sketchybar \
      --set keyboard.en \
      background.drawing=on \
      background.color="$KEYBOARD_INACTIVE_COLOR" \
      label.color="$INACTIVE_TEXT" \
      --set keyboard.no \
      background.drawing=on \
      background.color="$KEYBOARD_ACTIVE_COLOR" \
      label.color="$ACTIVE_TEXT"
    ;;

  *)
    # Keep the existing visual state if the layout cannot be read.
    exit 0
    ;;
  esac
}

setup_keyboard_items() {
  local toggle_command
  toggle_command="osascript -e 'tell application \"System Events\" to keystroke space using {control down, option down}'"

  sketchybar \
    --add event keyboard_change \
    "com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged" \
    --add item keyboard.en right \
    --set keyboard.en \
    icon.drawing=off \
    label="EN" \
    label.drawing=on \
    padding_left=0 \
    background.drawing=on \
    background.color=0x00000000 \
    background.corner_radius=3 \
    background.height=20 \
    script="$PLUGIN_DIR/keyboard.sh" \
    click_script="$toggle_command" \
    --subscribe keyboard.en keyboard_change \
    --add item keyboard.no right \
    --set keyboard.no \
    icon.drawing=off \
    label="NO" \
    label.drawing=on \
    padding_right=0 \
    background.drawing=on \
    background.color=0x00000000 \
    background.corner_radius=3 \
    background.height=20 \
    click_script="$toggle_command"

  # Initialize the indicator after creating the items.
  update_keyboard_indicator
}

case "${1:-}" in
--setup)
  setup_keyboard_items
  ;;
*)
  update_keyboard_indicator
  ;;
esac
