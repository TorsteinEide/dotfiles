source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/workspace-helpers.sh"

##### Adding AeroSpace Workspace Indicators #####

sketchybar --add event aerospace_workspace_change
sketchybar --add event aerospace_monitor_change

MONITOR_ICON="󰍹"
BUILT_IN_DISPLAY_ICON=""
UP_ARROW="󰁝"
DOWN_ARROW="󰁅"
SLACK_ICON=""
MUSIC_ICON=""
POOP_ICON="󰱵"

# Separator between monitor workspaces and normal workspaces.
sketchybar \
  --add item space.normal_header left \
  --set space.normal_header \
  icon="$DOWN_ARROW" \
  label.drawing=off \
  icon.padding_left=6 \
  icon.padding_right=6

# Add built in monitor workspaces.
aerospace list-workspaces --all |
  while IFS= read -r sid; do
    [[ "$sid" =~ ^M[0-9]+$ ]] && continue
    # Although this workspace does not exist in aerospace, it still shows up? so manually ignore it here
    [[ "$sid" =~ "Monitor1" ]] && continue

    sketchybar \
      --add item "space.$sid" left \
      --subscribe "space.$sid" \
      aerospace_workspace_change \
      aerospace_monitor_change \
      front_app_switched \
      --set "space.$sid" \
      icon="$(workspace_icon "$sid")" \
      icon.padding_left=7 \
      icon.padding_right=7 \
      label.drawing=on \
      label.width=0 \
      label.padding_left=0 \
      label.padding_right=0 \
      background.drawing=on \
      background.color="$(workspace_color "$sid")" \
      background.corner_radius=3 \
      background.height=20 \
      script="$PLUGIN_DIR/aerospace.sh" \
      click_script="aerospace workspace '$sid'"
  done

# Start the monitor-workspace group.
sketchybar \
  --add item space.monitor_header left \
  --set space.monitor_header \
  icon="$UP_ARROW" \
  label.drawing=off \
  icon.padding_left=6 \
  icon.padding_right=6

# Add workspaces on secondary monitor.
aerospace list-workspaces --all |
  while IFS= read -r sid; do
    [[ "$sid" =~ ^M[0-9]+$ ]] || continue
    number="${sid:1}"

    sketchybar \
      --add item "space.$sid" left \
      --subscribe "space.$sid" \
      aerospace_workspace_change \
      aerospace_monitor_change \
      front_app_switched \
      --set "space.$sid" \
      icon="$(workspace_icon "$sid")" \
      icon.padding_left=7 \
      icon.padding_right=7 \
      label.drawing=on \
      label.width=0 \
      label.padding_left=0 \
      label.padding_right=0 \
      background.drawing=on \
      background.color="$(workspace_color "$sid")" \
      background.corner_radius=3 \
      background.height=20 \
      script="$PLUGIN_DIR/aerospace.sh" \
      click_script="aerospace workspace '$sid'"
  done

sketchybar \
  --add item bracket_gap left \
  --set bracket_gap \
  width=8

drawing=on

sketchybar --reorder \
  space.normal_header \
  space.Music \
  space.Slack \
  space.Teams \
  space.1 \
  space.2 \
  space.3 \
  bracket_gap \
  space.monitor_header \
  space.M1 \
  space.M2 \
  space.M3
