#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   notify-send 'This script must be run as root' 
   printf 'This script must be run as root\n' 
   exit 1
fi

if ! lxc info ubuntu >/dev/null 2>&1 || [ "$(lxc info ubuntu | grep Status | cut -d' ' -f2)" != "RUNNING" ]; then
  notify-send 'Starting lxc container...'
  lxc start ubuntu
  sleep 5
fi

if lxc exec ubuntu -- sudo -u ubuntu bash -c "tmux has-session -t matlab 2>/dev/null"; then
  notify-send 'MATLAB is already running in the container'
  exit 0
fi

lxc exec ubuntu -- sudo -u ubuntu bash -c "pushd /home/ubuntu/matlab/workspace; tmux new-session -d -s matlab '/opt/MATLAB/R2025a/bin/matlab'; tmux pipe-pane -t matlab 'cat >> /home/ubuntu/matlab-tmux.log'"
