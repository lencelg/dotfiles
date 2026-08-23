#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
LAST_WALLPAPER_FILE="$HOME/.last_wallpaper"

EXTENSIONS="jpg jpeg png bmp gif webp"

find_args=()
for ext in $EXTENSIONS; do
    find_args+=(-iname "*.$ext" -o)
done
unset 'find_args[${#find_args[@]}-1]'   

wallpapers=$(find "$WALLPAPER_DIR" -type f \( "${find_args[@]}" \))

if [ -z "$wallpapers" ]; then
    notify-send "error : $WALLPAPER_DIR does not contain wallpaper with specific type"
    exit 1
fi

if [ -f "$LAST_WALLPAPER_FILE" ]; then
    last_wallpaper=$(cat "$LAST_WALLPAPER_FILE")
else
    last_wallpaper=""
fi

if [ -n "$last_wallpaper" ]; then
    candidates=$(echo "$wallpapers" | grep -Fxv "$last_wallpaper")
else
    candidates="$wallpapers"
fi

if [ -z "$candidates" ]; then
    notify-send "only one wallpaper find"
    candidates="$wallpapers"
fi

selected=$(echo "$candidates" | shuf -n 1)

echo "$selected" > "$LAST_WALLPAPER_FILE"

awww img "$selected" \
    --transition-duration 2

notify-send "wallpaper ：$selected"
