litefetch #| lolcat
export ZSH="/home/adri/.oh-my-zsh"
export XCURSOR_PATH=${XCURSOR_PATH}:~/.local/share/icons # cursor theme path

ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="false"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions colored-man-pages emoji gpg-agent pip python sudo systemd)

source ~/.config/aliasrc
source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
if [ -e /home/adri/.nix-profile/etc/profile.d/nix.sh ]; then . /home/adri/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
