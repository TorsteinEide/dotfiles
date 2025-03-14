#!/bin/sh
ask() {
    read -p "$1 [y/n]: " yn
    case $yn in
        [Yy]* ) return 0;;  # Yes
        * ) return 1;;      # No
    esac
}

change_wallpaper() {
    osascript -e "tell application \"Finder\" to set desktop picture to POSIX file \"$1\""
}

# Wallpaper selection
select_wallpaper(){
    echo "Choose wallpaper: forest"
    read -p "Enter your wallpaper: " choice

    case $choice in 
        forest) wallpaper="wallpapers/forest.jpg";;
        *) echo "Invalid choice, not setting wallpaper"; return;;
    esac

    change_wallpaper "$(pwd)/$wallpaper"
}

select_wallpaper

# Create symbolic links for configuration
mkdir -p ~/.config
ask "Install Homebrew?" && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ask "Install packages from the Brewfile?" && brew bundle --file Brewfile && open /Applications/Rectangle.app/

[ ! -e ~/.config/kitty ] && ln -s "$(pwd)/kitty" ~/.config/kitty
[ ! -e ~/.config/nvim ] && ln -s "$(pwd)/nvim" ~/.config/nvim
