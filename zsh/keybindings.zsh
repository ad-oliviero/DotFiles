bindkey -e
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^v' edit-command-line
bindkey '^[[3;5~' delete-word
bindkey '^H' backward-delete-word
bindkey '^[[3~' delete-char
bindkey '^[[Z' undo
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
