lfcd() {
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
	fi
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

reenv() {
	content=$(grep -v '#' /etc/environment)
	for l in $content; do
		export $l
	done
}

function get_dspid() {
	printf "%d" $(adb shell dumpsys display | grep -e "mDisplayId=[0-9]\\+" | awk -F'=' '$2 != 0 {gsub(/[^0-9]/, "", $2);print $2; exit}')
}

# ADB Screen Cast
asc() {
	display_id=$(get_dspid)
	screen_size="1920x1080/392\\;"
	[[ "$1" == "-h" ]] && screen_size="1880x2020/392\\;"
	[[ "$display_id" == "0" ]] && adb shell settings put global overlay_display_devices "$screen_size"
	display_id=$(get_dspid)
	scrcpy --no-audio --display $display_id
}

# ADB Screen Cast Remove
ascr() {adb shell settings put global overlay_display_devices null}
