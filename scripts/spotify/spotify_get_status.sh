#!/bin/bash
# Based on https://github.com/PrayagS/polybar-spotify

if [ "$(playerctl --player=spotify status)" = "Stopped" ]; then
    echo "Start Spotify"
elif [ "$(playerctl --player=spotify status)" = "Playing"  ]; then
    polybar-msg -p "$(pgrep -f -n "polybar")" hook spotify-play-pause 1 >/dev/null
    playerctl --player=spotify metadata --format "{{title}}"
else # Can be configured to output differently when player is paused
    polybar-msg -p "$(pgrep -f -n "polybar")" hook spotify-play-pause 2 >/dev/null
    playerctl --player=spotify metadata --format "{{title}}"
fi
