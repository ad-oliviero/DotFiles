# env variables
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE
export TERM=xterm-256color
export PATH=$PATH:~/.local/bin

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

# Plugins
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/themes/spaceship-prompt/spaceship.zsh-theme
#source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
#source ~/.p10k.zsh

# loading sources
source ~/.config/zsh/aliasrc
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/utils.zsh

uwufetch #|lolcat
