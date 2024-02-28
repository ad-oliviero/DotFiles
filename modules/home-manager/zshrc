source .profile

[ "$TTY" = "/dev/tty1" ] && Hyprland 2>&1 >/dev/null && exit
# [ "$TTY" = "/dev/tty1" ] && Hyprland # debug mode

# colored man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

#setopt correct
#setopt extendedglob
#setopt nocaseglob
setopt nocheckjobs
#setopt numericglobsort
setopt nobeep
#setopt appendhistory
setopt histignorealldups
setopt autocd
setopt inc_append_history

# edit comamnd line (vim mode)
autoload -U edit-command-line
zle -N edit-command-line

# completion
autoload -Uz compinit
compinit

zstyle ':completion:*' menu yes select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completition:*' rehash true
zstyle ':completition:*' accept-exact '*(N)'

# Plugins
source $HOME/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
source $HOME/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh >/dev/null
source $HOME/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
eval "$(starship init zsh)"

# loading sources
source $HOME/.config/zsh/aliasrc
source $HOME/.config/zsh/keybindings.zsh
source $HOME/.config/zsh/utils.zsh

uwufetch -r
