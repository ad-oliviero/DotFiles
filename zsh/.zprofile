#[ ! "$DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ] && exec startx
#[ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null && exec sway #startx -- vt2 &> /dev/null

#export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1
#export QT_QPA_PLATFORM=wayland-egl
