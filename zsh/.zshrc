# env variables
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=$HISTSIZE
export TERM=xterm-256color
export PATH=$PATH:~/.local/bin:/var/lib/snapd/snap/bin:/usr/local/i386elfgcc/bin
export VISUAL=vim
export EDITOR=vim
export PICO_SDK_PATH=/opt/pico-sdk

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
#zstyle ':completition:*' cache-path ~/.cache/zsh_cache
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
source ~/.config/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fpath+=$HOME/.config/zsh/themes/pure
#fpath+=$HOME/.config/zsh/themes/purer
autoload -Uz promptinit
promptinit
prompt pure
#source ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh-theme
#source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
#source ~/.p10k.zsh

# prompt vars
#SPACESHIP_PROMPT_ADD_NEWLINE=false
#SPACESHIP_PTOMPT_SEPARATE_LINE=false
PURE_PROMPT_SYMBOL=➜

# loading sources
source ~/.config/zsh/aliasrc
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/utils.zsh

UWUFETCH_CACHE_ENABLED=1 uwufetch -d arch #|lolcat

source ~/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh # for some reason this plugin does not work if it isn't loaded at the end
