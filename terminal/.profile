export BROWSER="floorp"
export EDITOR="nvim"
export GDK_BACKEND="wayland,x11"
export GIT_EDITOR="nvim"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export GTK_BACKEND="wayland,x11"
export GTK_THEME="WhiteSur-Dark"
export IMAGE="imv"
export JAVA_HOME=""
export LOCALE_ARCHIVE_2_27="/usr/lib/locale/locale-archive"
export PATH="$PATH:$HOME/.local/bin/:$HOME/.cargo/bin/:$HOME/.local/MATLAB/R2024b/bin/"
export QT_AUTO_SCREEN_SCALE_FACTOR="1"
export QT_QPA_PLATFORM="wayland;xcb"
export QT_QPA_PLATFORMTHEME="gtk2"
export QT_STYLE_OVERRIDE="WhiteSur-Dark"
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
export SDL_VIDEODRIVER="wayland"
export TERMINAL="alacritty"
export VIDEO="mpv"
export VISUAL="nvim"
export XCURSOR_PATH="$XCURSOR_PATH${XCURSOR_PATH:+:}/usr/share/icons"
export XCURSOR_SIZE="16"
export XCURSOR_THEME="phinger-cursors-dark"
export XDG_CURRENT_DESKTOP="Hyprland"
export XDG_SESSION_DESKTOP="Hyprland"
export XDG_SESSION_TYPE="wayland"
export _JAVA_AWT_WM_NONREPARENTING="1"
export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=lcd"

 
if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
if [[ -f "$HOME/.local/share/bob/env/env.sh" ]] then source "$HOME/.local/share/bob/env/env.sh"; fi

# Only source this once
if [ -n "$__SESS_VARS_SOURCED" ]; then return; fi
export __SESS_VARS_SOURCED=1
