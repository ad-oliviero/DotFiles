{
  lib,
  config,
  ...
}: let
  cfg = config.zsh;
in {
  options.zsh = {
    enable = lib.mkEnableOption "enable zsh module";
  };
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      # autosuggestion.enable = true;
      enableAutosuggestions = true;
      history.ignoreAllDups = true;
      historySubstringSearch = {
        enable = true;
        searchDownKey = "$terminfo[kcud1]";
        searchUpKey = "$terminfo[kcuu1]";
      };
      syntaxHighlighting.enable = true;
      zsh-abbr.enable = true;
      cdpath = [
        "$HOME/.config/dotfiles"
      ];
      initExtra = ''
        [ "$TTY" = "/dev/tty1" ] && Hyprland 2>&1 >/dev/null && exit
        uwufetch -r

        autoload -U edit-command-line
        zle -N edit-command-line

        zstyle ":completion:*" menu yes select
        zstyle -e ':completion:*:default' list-colors 'reply=("''${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:''${(s.:.)LS_COLORS}")'
        zstyle ':completion:*' matcher-list ''' 'm:{a-zA-Z}={A-Za-z}'
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

        source $HOME/.config/zsh/utils.zsh
      '';
      localVariables = {
        # colored man pages
        LESS_TERMCAP_mb = "$'\\E[01;32m'";
        LESS_TERMCAP_md = "$'\\E[01;32m'";
        LESS_TERMCAP_me = "$'\\E[0m'";
        LESS_TERMCAP_se = "$'\\E[0m'";
        LESS_TERMCAP_so = "$'\\E[01;47;34m'";
        LESS_TERMCAP_ue = "$'\\E[0m'";
        LESS_TERMCAP_us = "$'\\E[01;36m'";
        LESS = "-R";
        WORDCHARS = "";
      };
      shellAliases = {
        grep = "grep --color";
        ls = "exa --group-directories-first";
        ll = "ls -lSh";
        lls = "clear; ls";
        l = "ll -a";
        la = "ls -a";
        cp = "cp -iv";
        rs = "rsync -av --progress --stats";
        mv = "mv -iv";
        rm = "rm -v";
        mkdir = "mkdir -pv";
        md = "mkdir";
        yt = "youtube-dl --add-metadata -i";
        yta = "yt -x";
        ytd = "yt-dlp --add-metadata -i";
        ytda = "ytd -x";
        snvim = "EDITOR=nvim sudoedit";

        nrs = "sudo nixos-rebuild switch --flake ~/.config/dotfiles#$HOST";
        hrs = "home-manager switch --flake ~/.config/dotfiles#$HOST";
        ns = "nix search nixpkgs";
        nu = "sudo nix flake update";

        myip = "curl ipinfo.io/ip && printf '\\n'";
        bakkesmod = "WINEFSYNC=1 protontricks -c 'wine ~/Games/bakkesmod.exe' 252950";
        termuxusb = "adb forward tcp:8022 tcp:8022; ssh localhost -p 8022";
        scrsh = "yes | wf-recorder -m avi -f >(ffplay -window_title Screenshare -f avi -) --geometry=\"\$(slurp -o)\"; pkill ffplay 2>&1 >/dev/null; pkill wf-recorder 2>&1 >/dev/null";
        clnipc = "ipcrm -a \$(ipcs | awk '{print \\$2}' | grep -vE '[^0-9]')";
      };
      zsh-abbr.abbreviations = {
        rmd = "rmdir";
        rmf = "rm -rf";
        rmr = "rm -r";
        ungz = "tar -zxvf";
        free = "free -h";
        sprd = "speedread -w 300";
        gpl = "git pull";
        gpu = "git push";
        gc = "git add . && git commit";
        gcp = "git add . && git commit && git push";

        # error correction
        pc = "cp";
        vm = "mv";
        dc = "cd";
        mr = "rm";
      };
    };
    programs.starship = {
      enable = true;
      settings = {
        add_newline = true;
        character.success_symbol = "[➜](bold green)";
        python.symbol = " ";
        rust.symbol = " ";
      };
    };
    xdg.configFile."zsh/utils.zsh".text = ''
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
      	$${*:1}
      	DATE2=$(date +%s%N)
      	printf "'$${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!\n"
      }

      exec_time_null() {
      	[ "$1" = "help" ] || [ "$1" = "" ] && printf "Usage: exec_time <program to execute>\n" && return
      	DATE1=$(date +%s%N)
      	$${*:1} >/dev/null
      	DATE2=$(date +%s%N)
      	printf "'$${*:1}' took $(expr $(expr $DATE2 - $DATE1) / 1000000)ms to run!\n"
      }

      mc() {
      	mkdir $1
      	cd $1
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
    '';
  };
}
