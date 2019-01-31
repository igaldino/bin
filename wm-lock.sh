#!/bin/sh

WALLPAPER=`grep file ~/.config/nitrogen/bg-saved.cfg | awk -F "=" '{print $2}'`
RESOLUTION=`xrandr | grep \* | awk '{print $1}'`
IMAGE=~/.cache/i3lock.png

convert "$WALLPAPER" -resize $RESOLUTION^ -gravity center $IMAGE
i3lock -i $IMAGE -e -f

# Turn screen off
sleep 60
pgrep i3lock && xset dpms force off
