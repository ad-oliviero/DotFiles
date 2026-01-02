mkdir -p ~/.config/zsh/plugins

ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi
source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

eval "$(starship init zsh --print-full-init)"

repos=(
  mattmc3/ez-compinit
  zdharma/fast-syntax-highlighting
  marlonrichert/zsh-autocomplete
  marlonrichert/zsh-edit
  zsh-users/zsh-history-substring-search
  zsh-users/zsh-autosuggestions
  olets/zsh-abbr
  wbingli/zsh-wakatime
  MichaelAquilina/zsh-you-should-use
  hlissner/zsh-autopair
)

plugin-load $repos

[ ! -f "$HOME/.wakatime.cfg" ] && printf "[\x1b[32mWARNING\x1b[0m] Please create a ~/.wakatime.cfg file with your api key\n"

ZSH_AUTOSUGGEST_STRATEGY=(history)
