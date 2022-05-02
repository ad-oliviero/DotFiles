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
    printf "'${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!"
}

exec_time_null() {
    [ "$1" = "help" ] || [ "$1" = "" ] && printf "Usage: exec_time <program to execute>\n" && return
    DATE1=$(date +%s%N)
    ${*:1} >/dev/null
    DATE2=$(date +%s%N)
    printf "'${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!"
}
