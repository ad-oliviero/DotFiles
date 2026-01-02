export BROWSER="zen-browser"
export EDITOR="nvim" # hey, before changing this, check if the env.sh file for bob exists
export GDK_BACKEND="wayland,x11"
export GIT_EDITOR="nvim"
export TERMINAL="alacritty"
export VIDEO="mpv"
export VISUAL="nvim"
 
if [[ -f "$HOME/.cargo/env" ]]; then source "$HOME/.cargo/env"; fi
if [[ -f "$HOME/.local/share/bob/env/env.sh" ]] then source "$HOME/.local/share/bob/env/env.sh"; fi
if [[ -f "/opt/homebrew/bin/brew" ]] then eval "$(/opt/homebrew/bin/brew shellenv)"; fi

if [[ -f "$HOME/.profile-local" ]] then source "$HOME/.profile-local"; fi

# Only source this once
if [ -n "$__SESS_VARS_SOURCED" ]; then return; fi
export __SESS_VARS_SOURCED=1

