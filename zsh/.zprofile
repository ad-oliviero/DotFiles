



#[ ! "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && exec startx
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec startx -- vt1 &> /dev/null
