# Scripts not related to the "workflow" in the terminal

# lenovo laptop conservation mode
consmode() {
  [ -z "$1" ] && printf "[\x1b[033mERROR\x1b[0m]: $0 requires an argument\n" && return 1
  [ "$1" != "g" ] && [ "$1" != "0" ] && [ "$1" != "1" ] && printf "[\x1b[033mERROR\x1b[0m]: argument must be [ \"g\", \"0\" or \"1\" ]\n" && return 1
  [ "$1" = "g" ] && cat /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode && return
  sudo bash -c "printf $1 > /sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode"
  cat /sys/class/power_supply/BAT0/status
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
