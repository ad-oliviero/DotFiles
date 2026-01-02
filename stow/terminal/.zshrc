function source_if_exists() {
  if [[ -f "$1" ]]; then
    source "$1"
  fi
}

source_if_exists "$HOME/.config/zsh/scripts.zsh"
source_if_exists "$HOME/.config/zsh/plugins.zsh"
source_if_exists "$HOME/.config/zsh/opts.zsh"
source_if_exists "$HOME/.config/zsh/binds.zsh"
source_if_exists "$HOME/.config/zsh/aliases.zsh"
source_if_exists "$HOME/.config/zsh/utils.zsh"

