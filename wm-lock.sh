#!/bin/sh

WALLPAPER=`grep file ~/.config/nitrogen/bg-saved.cfg | awk -F "=" '{print $2}'`

i3lock -i "${WALLPAPER}" -e -f
sleep 10
pgrep i3lock && xset dpms force off
