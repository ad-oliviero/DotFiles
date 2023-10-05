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

# PATH
export JAVA_HOME=/usr/lib/jvm/java-20-openjdk
export PICO_SDK_PATH=/usr/share/pico-sdk
export PATH=$PATH:$JAVA_HOME/bin:$HOME/.local/bin:/opt/flutter/bin:$HOME/.pub-cache/bin
export ANDROID_HOME=$HOME/Android/Sdk
export XDG_DATA_DIRS=$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share
. "$HOME/.cargo/env"
