# zsh vars
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

# Default programs
export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty
export BROWSER=firefox
export VIDEO=mpv
export IMAGE=imv
export OPENER=xdg-open
export WM=sway

# backends
export GDK_BACKEND=wayland,x11
export GTK_BACKEND=wayland,x11
# export QT_QPA_PLATFORM=wayland
# export QT_QPA_PLATFORMTHEME=qt5ct
# export QT_WAYLAND_SHELL_INTEGRATION=layer-shell

# app fixes
#WINIT_X11_SCALE_FACTOR=1 # for alacritty on the laptop
export _JAVA_AWT_WM_NONREPARENTING=1

# wayland
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=Hyprland

# PATH
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
export PICO_SDK_PATH=/usr/share/pico-sdk
export PATH=$PATH:$JAVA_HOME/bin:$HOME/.local/bin:/opt/flutter/bin
export ANDROID_HOME=$HOME/Android/Sdk
export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share
