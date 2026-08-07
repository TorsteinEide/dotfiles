#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/workspace-helpers.sh"

ACTIVE_TEXT="0xffffffff"
INACTIVE_TEXT="0xffb8b8b8"

current_workspace="${NAME#space.}"
focused_workspace="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

active_color="$(workspace_color "$current_workspace")"
inactive_color="$(workspace_inactive_color "$current_workspace")"

get_focused_app() {
  aerospace list-windows \
    --focused \
    --format '%{app-name}' \
    2>/dev/null |
    head -n 1
}

case "$SENDER" in
front_app_switched)
  # Only the selected workspace needs a text update.
  [[ "$current_workspace" == "$focused_workspace" ]] || exit 0

  focused_app="$(get_focused_app)"

  sketchybar --set "$NAME" \
    label="$focused_app"

  exit 0
  ;;

aerospace_workspace_change)
  if [[ "$current_workspace" == "$focused_workspace" ]]; then
    focused_app="$(get_focused_app)"

    if [[ -n "$focused_app" ]]; then
      sketchybar \
        --animate tanh 6 \
        --set "$NAME" \
        background.color="$active_color" \
        icon.color="$ACTIVE_TEXT" \
        label="$focused_app" \
        label.color="$ACTIVE_TEXT" \
        label.width=dynamic \
        label.padding_left=4 \
        label.padding_right=8
    else
      sketchybar \
        --animate tanh 6 \
        --set "$NAME" \
        background.color="$active_color" \
        icon.color="$ACTIVE_TEXT" \
        label.width=0 \
        label.padding_left=0 \
        label.padding_right=0
    fi
  else
    sketchybar \
      --animate tanh 6 \
      --set "$NAME" \
      background.color="$inactive_color" \
      icon.color="$INACTIVE_TEXT" \
      label.width=0 \
      label.padding_left=0 \
      label.padding_right=0
  fi
  ;;

*)
  # Initial setup or manual update: set state without animation.
  if [[ "$current_workspace" == "$focused_workspace" ]]; then
    focused_app="$(get_focused_app)"

    sketchybar --set "$NAME" \
      background.color="$active_color" \
      icon.color="$ACTIVE_TEXT" \
      label="$focused_app" \
      label.color="$ACTIVE_TEXT" \
      label.width=dynamic \
      label.padding_left=4 \
      label.padding_right=8
  else
    sketchybar --set "$NAME" \
      background.color="$inactive_color" \
      icon.color="$INACTIVE_TEXT" \
      label.width=0 \
      label.padding_left=0 \
      label.padding_right=0
  fi
  ;;
esac
