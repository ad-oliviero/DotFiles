# Default programs
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
export BROWSER=firefox
export VIDEO=mpv
export IMAGE=imv
export OPENER=xdg-open
export WM=sway

# QT variables
# QT_QPA_PLATFORMTHEME=qt5ct
# QT_QPA_PLATFORM=wayland
# QT_WAYLAND_SHELL_INTEGRATION=layer-shell

# app fixes
#WINIT_X11_SCALE_FACTOR=1 # for alacritty on the laptop
_JAVA_AWT_WM_NONREPARENTING=1

# wayland
# XDG_CURRENT_DESKTOP=sway
# XDG_SESSION_DESKTOP=sway
# GDK_BACKEND=wayland # sadly breaks microsoft teams

# PATH
export JAVA_HOME=/usr/lib/jvm/java-18-openjdk
export PICO_SDK_PATH=/opt/pico-sdk
export PATH=$PATH:$JAVA_HOME/bin:$HOME/.local/bin

# firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_USE_XINPUT2=1 # inertial scrolling in x11
export MOZ_DISABLE_RDD_SANDBOX=1 # gpu acceleration
