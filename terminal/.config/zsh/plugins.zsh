mkdir -p ~/.config/zsh/plugins

function load_plugin()
{
  [ ! -d ~/.config/zsh/plugins/$1/$2 ] && {
    git clone --depth 1 --recurse-submodules https://github.com/$1/$2 ~/.config/zsh/plugins/$1/$2
    [ ! -d ~/.config/zsh/plugins/$1/$2 ] && {
      printf "\x1b[31m[ERROR]\x1b[0m Failed to clone $1/$2\n"
      return 1
    }
  }
  source_if_exists ~/.config/zsh/plugins/$1/$2/*plugin*.zsh
}

eval "$(starship init zsh --print-full-init)"

load_plugin zdharma fast-syntax-highlighting
load_plugin marlonrichert zsh-autocomplete
load_plugin marlonrichert zsh-edit
load_plugin zsh-users zsh-history-substring-search
load_plugin zsh-users zsh-autosuggestions
load_plugin olets zsh-abbr
load_plugin wbingli zsh-wakatime
load_plugin MichaelAquilina zsh-you-should-use

[ ! -f "$HOME/.wakatime.cfg" ] && printf "[\x1b[32mWARNING\x1b[0m] Please create a ~/.wakatime.cfg file with your api key\n"

ZSH_AUTOSUGGEST_STRATEGY=(history)
