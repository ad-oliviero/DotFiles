mkdir -p ~/.config/zsh/plugins
[[ -r ~/.config/zsh/plugins/znap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.config/zsh/plugins/znap
source_if_exists ~/.config/zsh/plugins/znap/znap.zsh

zstyle ':znap:*' auto-compile no

znap eval starship 'starship init zsh --print-full-init'
# znap prompt
if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

znap source zdharma/fast-syntax-highlighting
znap source marlonrichert/zsh-edit
znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-history-substring-search
znap source olets/zsh-abbr
znap source zsh-users/zsh-autosuggestions
znap source wbingli/zsh-wakatime

[ ! -f "$HOME/.wakatime.cfg" ] && printf "[\x1b[32mWARNING\x1b[0m] Please create a ~/.wakatime.cfg file with your api key\n"

ZSH_AUTOSUGGEST_STRATEGY=(history)
