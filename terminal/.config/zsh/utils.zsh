#!/usr/bin/env zsh
# Scripts that influence the workflow in the terminal

restow() {
  function usage() {
    {
      printf "Usage: $1 [options]\n"
      printf "\toptions:\n"
      printf "\t\t-h\tprints this\n"
      printf "\t\t-a\tstow apps only\n"
      printf "\t\t-d\tstow desktop only\n"
      printf "\t\t-t\tstow terminal only\n"
      printf "\t\t\tif no option, stow everything\n"
    }>&2
  }

  while getopts hadt flag; do
    case "${flag}" in
    h)
      usage "$0"
      return 0
      ;;
    a) apps=1 ;;
    d) desktop=1 ;;
    t) terminal=1 ;;
    *)
      printf >&2 "\033[31m[ERROR]: \033[33m%s is not a valid flag!\n" "${flag}"
      usage "$0"
      return 1
      ;;
    esac
  done
  pushd ~/dotfiles > /dev/null
  [[ ! -z "$desktop" ]] && stow desktop
  [[ ! -z "$apps" ]] && stow apps
  [[ ! -z "$terminal" ]] && stow terminal
  [[ -z "$desktop" && -z "$apps" && -z "$terminal" ]] && stow desktop apps terminal
  printf "Done!\n"
  popd > /dev/null
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
