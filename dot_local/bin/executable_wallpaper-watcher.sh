#!/usr/bin/env bash
WALLPAPER="/home/lain/Pictures/Wallpapers/blame3.jpg"
SOCK="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

sleep 1
hyprctl hyprpaper preload "$WALLPAPER"

for m in $(hyprctl monitors -j | jq -r '.[].name'); do
    hyprctl hyprpaper wallpaper "$m,$WALLPAPER"
done

nc -U "$SOCK" | while read -r line; do
    if [[ "$line" == monitoraddedv2* ]]; then
        name=$(echo "$line" | cut -d'>' -f3 | cut -d',' -f2)
        sleep 1
        hyprctl hyprpaper wallpaper "$name,$WALLPAPER"
    fi
done
