typeset -U path cdpath fpath manpath

LESS="-R"
LESS_TERMCAP_mb="$'\E[01;32m'"
LESS_TERMCAP_md="$'\E[01;32m'"
LESS_TERMCAP_me="$'\E[0m'"
LESS_TERMCAP_se="$'\E[0m'"
LESS_TERMCAP_so="$'\E[01;47;34m'"
LESS_TERMCAP_ue="$'\E[0m'"
LESS_TERMCAP_us="$'\E[01;36m'"
WORDCHARS=""

autoload -U compinit && compinit

HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="$HOME/.zsh_history"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd

zstyle ":completion:*" menu yes select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completition:*' rehash true
zstyle ':completition:*' accept-exact '*(N)'
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^v' edit-command-line
bindkey '^[[3;5~' delete-word
bindkey '^H' backward-delete-word
bindkey '^[[3~' delete-char
bindkey '^[[Z' undo
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# lenovo laptop conservation mode
consmode() {
  [ -z "$1" ] && printf "[\x1b[033mERROR\x1b[0m]: $0 requires an argument\n" && return 1
  [ "$1" != "g" ] && [ "$1" != "0" ] && [ "$1" != "1" ] && printf "[\x1b[033mERROR\x1b[0m]: argument must be [ \"g\", \"0\" or \"1\" ]\n" && return 1
  [ "$1" = "g" ] && cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode && return
  sudo bash -c "printf $1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
  cat /sys/class/power_supply/BAT0/status
}

exec_time() {
  [ "$1" = "help" ] || [ "$1" = "" ] && printf "Usage: exec_time <program to execute>\n" && return
  DATE1=$(date +%s%N)
  ${*:1}
  DATE2=$(date +%s%N)
  printf "'${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!\n"
}

exec_time_null() {
  [ "$1" = "help" ] || [ "$1" = "" ] && printf "Usage: exec_time <program to execute>\n" && return
  DATE1=$(date +%s%N)
  ${*:1} >/dev/null
  DATE2=$(date +%s%N)
  printf "'${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!\n"
}

mc() {
  mkdir $1
  cd $1
}

sandbox() {
  sudo btrfs subvolume snapshot / ./sandbox
  sudo systemd-nspawn --boot --directory=./sandbox --bind=/run/user/1000/pipewire-0:/run/user/1000/pipewire-0
  sudo btrfs subvolume delete ./sandbox
}

function get_dspid() {
  printf "%d" $(adb shell dumpsys display | grep -e "mDisplayId=[0-9]\\+" | awk -F'=' '$2 != 0 {gsub(/[^0-9]/, "", $2);print $2; exit}')
}

# ADB sshfs
# this requires usb tethering to be enabled on the device
asshfs() {
  address=$(adb shell ip a | rg "inet.*rndis0" | awk '{print $2}' | sed "s/\/.*//g")
  sshfs -p 2222 -o ssh_command="ssh -i /home/adri/.ssh/id_ed25519" $address:/storage/emulated/0 /mnt
}

# ADB Screen Cast
asc() {
  adb shell settings put global force_desktop_mode_on_external_displays 1
  display_id=$(get_dspid)
  screen_size="1920x1080/392\\;"
  [[ "$1" == "-h" ]] && screen_size="1880x2020/392\\;"
  [[ "$display_id" == "0" ]] && adb shell settings put global overlay_display_devices "$screen_size"
  display_id=$(get_dspid)
  scrcpy --no-audio --display $display_id
}

# ADB Screen Cast Remove
ascr() {adb shell settings put global overlay_display_devices null}

if [[ $TERM != "dumb" ]]; then
  eval "$(starship init zsh)"
fi

# Aliases
alias -- bakkesmod='WINEFSYNC=1 protontricks -c '\''wine ~/Games/bakkesmod.exe'\'' 252950'
alias -- clnipc='ipcrm -a $(ipcs | awk '\''{print $2}'\'' | grep -vE '\''[^0-9]'\'')'
alias -- cp='cp -iv'
alias -- grep='grep --color'
alias -- hrs='home-manager switch --flake ~/.config/dotfiles#$HOST'
alias -- l='ll -a'
alias -- la='ls -a'
alias -- ll='ls -lSh'
alias -- lls='clear; ls'
alias -- ls='exa --group-directories-first'
alias -- md=mkdir
alias -- mkdir='mkdir -pv'
alias -- mv='mv -iv'
alias -- myip='curl ipinfo.io/ip && printf '\''\n'\'''
alias -- rm='rm -v'
alias -- rs='rsync -av --progress --stats'
alias -- scrsh='yes | wf-recorder -m avi -f >(ffplay -window_title Screenshare -f avi -) --geometry="$(slurp -o)"; pkill ffplay 2>&1 >/dev/null; pkill wf-recorder 2>&1 >/dev/null'
alias -- sv='EDITOR=nvim sudoedit'
alias -- termuxusb='adb forward tcp:8022 tcp:8022; ssh localhost -p 8022'
alias -- v=nvim
alias -- vimdiff='nvim -d'
alias -- yt='youtube-dl --add-metadata -i'
alias -- yta='yt -x'
alias -- ytd='yt-dlp --add-metadata -i'
alias -- ytda='ytd -x'

if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
if [[ -f "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
fi
if [[ -f "/usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh" ]]; then
  source "/usr/share/zsh/plugins/zsh-abbr/zsh-abbr.plugin.zsh"
fi

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_HIGHLIGHT_HIGHLIGHTERS+=()

