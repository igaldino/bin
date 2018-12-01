#!/bin/sh

i3lock -i /usr/share/backgrounds/default.png -e -f
sleep 10
pgrep i3lock && xset dpms force off
