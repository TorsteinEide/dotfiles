source "$CONFIG_DIR/colors.sh"

workspace_icon() {
  case "$1" in
  1 | 2 | 3)
    echo "$BUILT_IN_DISPLAY_ICON $1"
    ;;
  M1 | M2 | M3)
    echo "$MONITOR_ICON ${1:1}"
    ;;
  Music)
    echo "$MUSIC_ICON"
    ;;
  Slack)
    echo "$SLACK_ICON"
    ;;
  Teams)
    echo "$POOP_ICON"
    ;;
  *)
    echo "$1"
    ;;
  esac
}

workspace_color() {
  case "$1" in
  Slack)
    echo "$SLACK_COLOR"
    ;;
  Music)
    echo "$MUSIC_COLOR"
    ;;
  Teams)
    echo "$TEAMS_COLOR"
    ;;
  *)
    echo "$ACTIVE_COLOR"
    ;;
  esac
}

workspace_inactive_color() {
  case "$1" in
  Slack) echo "$INACTIVE_SLACK_COLOR" ;;
  Music) echo "$INACTIVE_MUSIC_COLOR" ;;
  Teams) echo "$INACTIVE_TEAMS_COLOR" ;;
  *) echo "0x6f40826d" ;;
  esac
}
