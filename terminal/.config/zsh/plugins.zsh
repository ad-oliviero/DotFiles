source_if_exists "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source_if_exists "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
source_if_exists "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source_if_exists "/usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh" > /dev/null

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()
