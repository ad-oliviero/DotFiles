#[ ! "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && exec startx
#[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec sway #startx -- vt2 &> /dev/null

export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=12
export QT_QPA_PLATFORM=wayland-egl
