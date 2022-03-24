#!/bin/sh

# pkill -USR1 -x sxhkd || sxhkd &
# feh --bg-fill ~/Downloads/mikasa.png # https://images7.alphacoders.com/632/632843.png
# ~/.config/polybar/launch.sh
# pkill -USR1 -x picom --experimental-backends --backend glx || picom --experimental-backends --backend glx & # picom with blur
# pkill -USR1 -x dunst || dunst &
dconf reset -f /org/gnome # fix gtk-apps slow loading
redshift -oP 4400K
# if [ $(cat /sys/devices/virtual/dmi/id/product_name) == "81YK" ] # if i am on the laptop
# then
# 	setxkbmap -layout "it" # set keyboard layout
# else
# 	setxkbmap -layout "us" -option "compose:menu" # set keyboard layout and compose key 
# fi
light-locker --lock-on-suspend --lock-on-lid & # lock with suspension
pgrep syncthing || syncthing serve --no-browser & # start syncthing
env GTK_PATH=/usr/lib/gtk-3.0 /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & # polkit for authentication

# mouse and touchpad
xset -dpms s off
xinput set-prop pointer:"Micro-Star INT'L CO., LTD MSI GM11 Gaming Mouse" "libinput Accel Speed" +0.1 # speed
xinput set-prop pointer:"Micro-Star INT'L CO., LTD MSI GM11 Gaming Mouse" "libinput Accel Profile Enabled" 0, 1 # disable acceleration

xinput set-prop "MSFT0001:01 06CB:7F28 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "MSFT0001:01 06CB:7F28 Touchpad" "libinput Tapping Drag Enabled" 1
xinput set-prop "MSFT0001:01 06CB:7F28 Touchpad" "libinput Natural Scrolling Enabled" 1
xinput set-prop "MSFT0001:01 06CB:7F28 Touchpad" "libinput Scrolling Pixel Distance" 50

# wacom tablet flip
xsetwacom --set "Wacom One by Wacom S Pen stylus" Area 15200 9500 0 0
# xsetwacom --set "Wacom One by Wacom S Pen stylus" Button 2 key shift
# xsetwacom --set "Wacom One by Wacom S Pen stylus" Button 3 key 'x'

