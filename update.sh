#!/bin/bash
dots=("qutebrowser" "foot" "i3status-rust" "niri" "river" "waybar" "wayshot" "yazi" "i3bar-river" "kitty" "mako" "nvim" "way-displays" "wlogout")

# Loop through the list and print each fruit
for dot in "${dots[@]}"; do
    rm -rf ~/dotfiles/$dot
    cp -r ~/.config/$dot ~/dotfiles/
done

cd ~/dotfiles
git add --all
git commit -m "update"
git push origin main
