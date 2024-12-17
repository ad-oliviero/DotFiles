typeset -U path cdpath fpath manpath

LESS="-R"
LESS_TERMCAP_mb="$'\E[01;32m'"
LESS_TERMCAP_md="$'\E[01;32m'"
LESS_TERMCAP_me="$'\E[0m'"
LESS_TERMCAP_se="$'\E[0m'"
LESS_TERMCAP_so="$'\E[01;47;34m'"
LESS_TERMCAP_ue="$'\E[0m'"
LESS_TERMCAP_us="$'\E[01;36m'"
WORDCHARS=""

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd

zstyle ":completion:*" menu yes select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completition:*' rehash true
zstyle ':completition:*' accept-exact '*(N)'
