# KeyBindings
WORDCHARS=""
bindkey '^a' vi-beginning-of-line
bindkey '^e' vi-end-of-line
bindkey -s '^o' "clifm\n"
bindkey '^v' edit-command-line
bindkey '^[[3;5~' delete-word
bindkey '^H' backward-delete-word
bindkey '^[[1;5D' vi-backward-word
bindkey '^[[1;5C' vi-forward-word
bindkey '^[[3~' delete-char
