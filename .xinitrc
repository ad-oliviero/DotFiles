#~/.config/scripts/start-dwm.s
#i3
#gnome-session
#xfce4-session



DESKTOP_SESSION=plasma
startplasma-x11



#openbox

# fix slow gtk apps loading
dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
xset r rate 500 33
