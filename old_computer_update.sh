#!/bin/bash
dots=("weathr" "kew" "qutebrowser" "foot" "i3status-rust" "niri"  "waybar" "wayshot" "yazi"  "kitty" "mako" "nvim" "way-displays" "wlogout")

# Loop through the list and print each fruit
for dot in "${dots[@]}"; do
    rm -rf ~/dotfiles/$dot
    cp -r ~/.config/$dot ~/dotfiles/
done

cp ~/.zshrc ~/dotfiles/
cp ~/.bashrc ~/dotfiles/
cp ~/.inputrc ~/dotfiles/

cd ~/dotfiles
git add --all
