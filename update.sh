#!/bin/bash
dots=("qutebrowser" "foot"  "niri"  "waybar" "wayshot" "yazi"  "kitty" "mako" "nvim" "way-displays" )

# Loop through the list and print each fruit
for dot in "${dots[@]}"; do
    rm -rf ~/dotfiles/$dot
    cp -r ~/.config/$dot ~/dotfiles/
done

cp ~/.zshrc ~/dotfiles/
cp ~/.bashrc ~/dotfiles/

cd ~/dotfiles
git add --all
git commit -m "update"
git push origin main
