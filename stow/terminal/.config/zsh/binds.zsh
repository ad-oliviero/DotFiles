autoload -Uz match-words-by-style
autoload -Uz backward-word-match forward-word-match
autoload -Uz backward-kill-word-match kill-word-match
zle -N backward-word-match
zle -N forward-word-match
zle -N backward-kill-word-match
zle -N kill-word-match
zstyle ':zle:*' word-style subword

bindkey '^[[1;5D' backward-word-match
bindkey '^[[1;5C' forward-word-match

bindkey '^[[3;5~' kill-word-match
bindkey '^H' backward-kill-word-match
bindkey '^W' backward-kill-word-match 
bindkey '^[[127;5~' backward-kill-word-match

bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" reverse-menu-select
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

bindkey "^V" edit-command-line
