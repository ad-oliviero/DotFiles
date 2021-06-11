#~/.config/scripts/start-dwm.sh
i3
#gnome-session
#xfce4-session
#plasmashell
#openbox

# fix slow gtk apps loading
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
