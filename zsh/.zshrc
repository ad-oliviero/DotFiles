# env variables
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export TERM=xterm-256color
export PATH=$PATH:~/.local/bin
export USE_CCACHE=1
export CCACHE_EXEC=/usr/bin/ccache
export VISUAL=vim
export EDITOR=vim
export PICO_SDK_PATH=/opt/pico-sdk

# edit comamnd line (vim mode)
autoload -U edit-command-line
zle -N edit-command-line

# completion
autoload -Uz compinit
compinit

zstyle ':completion:*' menu yes select
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%p
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'

# git status for prompt
autoload -Uz add-zsh-hook vcs_info
setopt PROMPT_SUBST
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr ' '
zstyle ':vcs_info:*' stagedstr ' '
zstyle ':vcs_info:git:*' formats       '%F{white}on %F{yellow}%b%u%c'
#zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c'

# Plugins
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
#source ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh-theme
#source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
#source ~/.p10k.zsh

# loading sources
source ~/.config/zsh/aliasrc
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/utils.zsh

# prompt
PS1=$'%(?..%F{red}%?%F{white} )%(#.%F{red}.%F{white})%n in %F{green}%~ ${vcs_info_msg_0_}%F{yellow}\u1433 '

uwufetch #|lolcat
