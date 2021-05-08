# KeyBindings
autoload -U select-word-style
select-word-style bash
bindkey '^a' vi-beginning-of-line
bindkey '^e' vi-end-of-line
bindkey -s '^o' "clifm\n"
bindkey '^v' edit-command-line
#bindkey '^H' backward-delete-word
bindkey '^[[1;5D' vi-backward-word
bindkey '^[[1;5C' vi-forward-word
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



# vi-style kill word

WORDCHARS='[/ -]'
MOTION_WORDCHARS='[/ -]'

zle -N vi-forward-kill-word
bindkey '^[[3;5~' kill-word

vi-backward-kill-word() {
    if [[ "${LBUFFER[CURSOR]}" =~ "${WORDCHARS}" ]]; then
        LBUFFER="${LBUFFER[1, CURSOR - 1]}"
        return
    fi
    while [[ CURSOR -gt 0 && ! "${LBUFFER[CURSOR]}" =~ "${WORDCHARS}" ]]; do
            LBUFFER="${LBUFFER[1, CURSOR - 1]}"
    done
}

zle -N vi-backward-kill-word
bindkey '^H' vi-backward-kill-word
