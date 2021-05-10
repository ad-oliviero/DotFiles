# KeyBindings
bindkey '^a' vi-beginning-of-line
bindkey '^e' vi-end-of-line
bindkey -s '^o' "clifm\n"
bindkey '^v' edit-command-line
bindkey '^[[1;5D' vi-backward-word
bindkey '^[[1;5C' vi-forward-word
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-search
bindkey '^[[3~' delete-char

# vi-style kill word

vi-forward-delete-word () {
  local WORDCHARS=""
  zle delete-word
}
zle -N vi-forward-delete-word
bindkey '^[[3;5~' vi-forward-delete-word

vi-backward-delete-word () {
  local WORDCHARS=""
  zle backward-delete-word
}
zle -N vi-backward-delete-word
bindkey '^H' vi-backward-delete-word

if [[ -n "${terminfo[kcuu1]}" ]]; then
	autoload -U up-line-or-beginning-search
	zle -N up-line-or-beginning-search
	bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
	autoload -U down-line-or-beginning-search
	zle -N down-line-or-beginning-search
	bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
fi
