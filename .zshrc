cfetch #| lolcat

if [ -f ~/.config/aliasrc ]; then
    source ~/.config/aliasrc
else
    print "/home/$USER/.config/aliasrc not found."
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="/home/adri/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons # cursor theme path

ENABLE_CORRECTION="false"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions colored-man-pages emoji  gpg-agent pip python sudo systemd)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
