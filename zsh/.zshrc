# suggestions
autoload -U compinit compaudit edit-command-line
zle -N edit-command-line
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' list-colors menu select
zmodload zsh/complist
compinit && compaudit

# history file
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=5000000
[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=1000000

# Plugins
source ~/.config/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source ~/.config/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
source ~/.p10k.zsh

# loading sources
source ~/.config/zsh/aliasrc
source ~/.config/zsh/keybindings.zsh
source ~/.config/zsh/utils.zsh

uwufetch #| lolcat