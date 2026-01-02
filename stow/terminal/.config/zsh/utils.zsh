#!/usr/bin/env zsh
# Scripts that influence the workflow in the terminal

restow() {
  # pushd ~/dotfiles > /dev/null
  declare -a pkgs=("desktop" "apps" "terminal")
  stow_dir="$HOME/dotfiles/stow"
  host=$(printf "$HOST" | sed 's/.local//g')
  for p in "${pkgs[@]}"; do
    if [ -d "$stow_dir/$p" ]; then
      stow -d "$stow_dir" -t "$HOME" -R "$p"
      printf "$p\n"
    fi
    if [ -d "$stow_dir/$p-$host" ]; then
      stow -d "$stow_dir" -t "$HOME" -R "$p-$host"
      printf "$p-$host\n"
    fi
  done
  # popd > /dev/null
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
  mkdir -p $1
  cd $1
}

sandbox() {
  sudo btrfs subvolume snapshot / ./sandbox
  sudo systemd-nspawn --boot --directory=./sandbox --bind=/run/user/1000/pipewire-0:/run/user/1000/pipewire-0
  sudo btrfs subvolume delete ./sandbox
}

headless() {
  [ -f "/tmp/headless-hyprland" ] && {
    rm /tmp/headless-hyprland
    hyprctl output enable HDMI-A-1
    hyprctl output enable eDP-1
    exit
  }
  touch /tmp/headless-hyprland
  hyprctl output create headless HEADLESS-2
  hyprctl output disable HDMI-A-1
  hyprctl output disable eDP-1
}

stopwatch() {
  printf 'Press return to stop\nStarting in\n'
  local secs
  case "$1" in
    ''|*[!0-9]*)
      secs=3 ;;
    *)
      secs=$1 ;;
  esac
  while [ $secs -gt 0 ]; do
    printf '  %s\033[0K\r' "$secs"
    sleep 1
    secs=$((secs - 1))
  done
  printf '  NOW\033[0K\r'
  exec_time_null read
}
