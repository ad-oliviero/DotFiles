#!/usr/bin/env zsh
# Scripts that influence the workflow in the terminal

restow() {
  local pkgs=("desktop" "apps" "terminal")
  local stow_dir="$HOME/dotfiles/stow"
  local host="${${HOST/adri-/}/.local/}"
  local os="${${OSTYPE%%[0-9-]*}/#darwin/mac}"
  for p in "${pkgs[@]}"; do
    for d in "$stow_dir"/$p*(N/); do
      local pkg_name="${d:t}"
      if [[ "$pkg_name" =~ ^$p(-($host|$os)(-.+)?|-.+-($host|$os))?$ ]]; then
	stow --no-folding -d "$stow_dir" -t "$HOME" -R "$pkg_name"
	print "$pkg_name\n"
      fi
    done
  done
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

# this only works on mac os obviously
lx() {
  container start alpinedev
  container exec -it alpinedev zsh -l
}

doc() {
  set -a
  if [ -f "$HOME/homelab/.env" ]; then
    source "$HOME/homelab/.env"
  else
    printf "Failed to load $HOME/homelab/.env!\n"
    set +a
    exit 1
  fi
  set +a
  sudo -E docker "$@"
}

reisub() {
  printf "s" | sudo tee /proc/sysrq-trigger
  printf "u" | sudo tee /proc/sysrq-trigger
  printf "b" | sudo tee /proc/sysrq-trigger
}

nvclaude() {
  LITELLM_CONFIG_PATH="/tmp/litellm_claude_config.yaml"
  cat <<EOF > "$LITELLM_CONFIG_PATH"
model_list:
  - model_name: z-ai/glm-5.2
    litellm_params:
      model: nvidia_nim/z-ai/glm-5.2
      api_base: https://integrate.api.nvidia.com/v1
      api_key: $NVIDIA_API_KEY

litellm_settings:
  drop_params: true
EOF
    if ! pgrep -f "litellm --config $LITELLM_CONFIG_PATH" > /dev/null 2>&1; then
      
	litellm --config "$LITELLM_CONFIG_PATH" --port $LITELLM_PORT > /tmp/litellm_claude.log 2>&1 &
        local PROXY_PID=$!
        
        local retries=0
        while ! curl -s http://localhost:$LITELLM_PORT/health/liveliness > /dev/null 2>&1; do
            sleep 1
            retries=$((retries + 1))
            if [ $retries -ge 15 ]; then
                echo "Failed to start LiteLLM proxy. Check /tmp/litellm_claude.log for errors."
                return 1
            fi
        done
        
        command claude "$@"
        local EXIT_CODE=$?
        
        kill $PROXY_PID > /dev/null 2>&1
        
        return $EXIT_CODE
    else
        command claude "$@"
    fi
}
