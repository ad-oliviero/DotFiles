#!/bin/bash
# see man zscroll for documentation of the following parameters
# From https://github.com/PrayagS/polybar-spotify
zscroll -l 60 \
        --delay 0.2 \
        --match-command "playerctl --player=spotify status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 0" \
        --update-check true '/home/vineeth/.config/i3/scripts/spotify/spotify_get_status.sh' &

wait
