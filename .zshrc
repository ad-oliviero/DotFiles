#if command -v theme.sh > /dev/null; then
#	export THEME_HISTFILE=~/.theme_history
#	[ -e "$THEME_HISTFILE" ] && theme.sh "$(theme.sh -l|tail -n1)"
#fi
HISTSIZE= HISTFILESIZE= 
ZSH_DISABLE_COMPFIX=true 
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORRECTION="false"
plugins=(git fast-syntax-highlighting zsh-abbr zsh-autosuggestions colored-man-pages gpg-agent pip python sudo systemd)

source ~/.config/aliasrc
source $ZSH/oh-my-zsh.sh
source ~/.p10k.zsh
source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

uwufetch -i #| lolcat
