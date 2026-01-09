#!/bin/sh
ask() {
  read -p "$1 [y/n]: " yn
  case $yn in
  [Yy]*) return 0 ;; # Yes
  *) return 1 ;;     # No
  esac
}

# change_wallpaper() {
#   osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$1\""
# }
change_wallpaper() {
  osascript -e "tell application \"System Events\" to set picture of every desktop to POSIX file \"$1\""
}

# Wallpaper selection
select_theme() {
  echo "Choose wallpaper: bladerunner, blue, wave"
  read -p "Enter your wallpaper: " choice

  case "$choice" in # Convert input to lowercase for easier matching
  bladerunner | br)
    wallpaper="br2049.png"
    active_color="0xffFF6B66"   # Neon pink/orange (Blade Runner vibe)
    inactive_color="0xff494d64" # Dark blue-gray
    ;;
  blue | blue)
    wallpaper="blue.jpg"
    active_color="0xff89b4fa" # Soft blue (like catppuccin/blue)
    inactive_color="0xff585b70"
    ;;
  wave | jpwave)
    wallpaper="jpwave.png"
    active_color="0xffbb9af7" # Purple-ish (vaporwave aesthetic)
    inactive_color="0xff414868"
    ;;
  *)
    echo "Invalid choice. Available: bladerunner (br), blue, wave (jpwave)"
    return 1
    ;;
  esac

  change_wallpaper "$(pwd)/wallpapers/$wallpaper"
  borders active_color="$active_color" inactive_color="$inactive_color" width=20.0

}

select_theme

# Create symbolic links for configuration
mkdir -p ~/.config
ask "Install Homebrew?" && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ask "Install packages from the Brewfile?" && brew bundle --file Brewfile && open /Applications/AeroSpace.app/

[ ! -e ~/.config/aerospace.toml ] && ln -s "$(pwd)/aerospace/.aerospace.toml" ~/.aerospace.toml
[ ! -e ~/.config/nvim ] && ln -s "$(pwd)/nvim" ~/.config/nvim
[ ! -e ~/Library/Application\ Support/com.mitchellh.ghostty/config ] &&
  ln -s "$(pwd)/ghostty/config" ~/Library/Application\ Support/com.mitchellh.ghostty/config
