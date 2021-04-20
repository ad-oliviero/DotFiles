#[ ! "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && exec startx
[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec sway #startx -- vt2 &> /dev/null
eval "$(/home/adri/.linuxbrew/bin/brew shellenv)"
