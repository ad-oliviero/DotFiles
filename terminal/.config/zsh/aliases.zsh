alias -- apbs='ansible-playbook -K ~/dotfiles/ansible.yml' # ansible playbook sync
alias -- bakkesmod='WINEFSYNC=1 protontricks -c '\''wine ~/Games/bakkesmod.exe'\'' 252950'
alias -- clnipc='ipcrm -a $(ipcs | awk '\''{print $2}'\'' | grep -vE '\''[^0-9]'\'')'
alias -- cp='cp -iv'
alias -- grep='grep --color'
alias -- l='ll -a'
alias -- la='ls -a'
alias -- ll='ls -lSh'
alias -- lls='clear; ls'
alias -- ls='eza --group-directories-first'
alias -- md='mkdir'
alias -- mkdir='mkdir -pv'
alias -- mv='mv -iv'
alias -- myip='curl ipinfo.io/ip && printf '\''\n'\'''
alias -- rm='rm -v'
alias -- rs='rsync -arv --progress --stats'
alias -- scrsh='yes | wf-recorder -m avi -f >(ffplay -window_title Screenshare -f avi -) --geometry="$(slurp -o)"; pkill ffplay 2>&1 >/dev/null; pkill wf-recorder 2>&1 >/dev/null'
alias -- sv='EDITOR=nvim sudoedit'
alias -- termuxusb='adb forward tcp:8022 tcp:8022; ssh localhost -p 8022'
alias -- v='nvim'
alias -- vimdiff='nvim -d'
alias -- yt='youtube-dl --add-metadata -i'
alias -- yta='yt -x'
alias -- ytd='yt-dlp --add-metadata -i'
alias -- ytda='ytd -x'
