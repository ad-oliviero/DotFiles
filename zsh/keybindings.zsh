# KeyBindings
bindkey '^a' vi-beginning-of-line
bindkey '^e' edit-command-line
bindkey '^H' backward-kill-word
bindkey '^[[3;5~' kill-word
bindkey '^[[1;5D' backward-word  
bindkey '^[[1;5C' forward-word  
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-history
bindkey '^[[3~' delete-char

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