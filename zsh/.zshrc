# history file things
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000000
export SAVEHIST=$HISTSIZE

# colors for vim
export TERM=xterm-256color

# suggestions
autoload -U edit-command-line
zle -N edit-command-line

# Plugins
source ~/.config/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
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
