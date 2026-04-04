export EDITOR="$HOME/.local/bin/nvim"
export VISUAL="$HOME/.local/bin/nvim"
export GIT_EDITOR="$HOME/.local/bin/nvim"
export GDK_BACKEND="wayland,x11"
export TERMINAL="alacritty"
export VIDEO="mpv"
 
if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
if [[ -f "/opt/homebrew/bin/brew" ]] then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
if [[ -f "$HOME/.profile-local" ]] then source "$HOME/.profile-local"; fi

# Only source this once
if [ -n "$__SESS_VARS_SOURCED" ]; then return; fi
export __SESS_VARS_SOURCED=1

