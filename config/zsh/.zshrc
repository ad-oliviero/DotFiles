# env variables
source /etc/environment
source $HOME/.config/DotFiles/etc/envars.sh
source $HOME/.cargo/env
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE

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
#zstyle ':completition:*' use-cache on
#zstyle ':completition:*' cache-path $HOME/.cache/zsh_cache
#zstyle ':completion:*' format 'Completing %d'
#zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%p

# git status for prompt
#autoload -Uz add-zsh-hook vcs_info
#setopt PROMPT_SUBST
#add-zsh-hook precmd vcs_info
#zstyle ':vcs_info:*' check-for-changes true
#zstyle ':vcs_info:*' unstagedstr ' '
#zstyle ':vcs_info:*' stagedstr ' '
#zstyle ':vcs_info:git:*' formats       '%F{white}on %F{yellow}%b%u%c'
#zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c'

# Plugins
source $HOME/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
source $HOME/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh >/dev/null
source $HOME/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#fpath+=$HOME/.config/zsh/themes/pure
#fpath+=$HOME/.config/zsh/themes/purer
#autoload -Uz promptinit
#promptinit
#prompt pure
#source $HOME/.config/zsh/themes/spaceship-prompt/spaceship.zsh-theme
#source $HOME/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
#source $HOME/.p10k.zsh
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# prompt vars
#SPACESHIP_PROMPT_ADD_NEWLINE=false
#SPACESHIP_PTOMPT_SEPARATE_LINE=false
#PURE_PROMPT_SYMBOL=➜

# loading sources
source $HOME/.config/zsh/aliasrc
source $HOME/.config/zsh/keybindings.zsh
source $HOME/.config/zsh/utils.zsh

uwufetch -r
