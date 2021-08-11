#!/bin/sh

DATE1="$(date +%s%N)"

init="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"

printf "Recording bandwidth. Press enter to stop."

read -r lol

fin="$(($(cat /sys/class/net/[ew]*/statistics/rx_bytes | paste -sd '+')))"

DATE2="$(date +%s%N)"

# result="$(numfmt --to=iec $(($fin-$init)))"
result="$(expr $(expr $fin - $init) / 1024)"
time="$(expr $(expr $DATE2 - $DATE1) / 1000000000)"
speed="$((expr $result / $time))"

echo -e "$result used in $time\x00s at $speed"
