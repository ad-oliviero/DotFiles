{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.zsh;
in {
  options = {
    zsh.enable = lib.mkEnableOption "Enable zsh";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      python313
      gcc
      cmake
      scrcpy
      nmap

      imagemagick
      imv
      mpv
      zip
      unzip
      btop
      file
      man-pages
      sshfs
      tree
    ];
    programs = {
      starship = {
        enable = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };

      git = {
        enable = true;
        userName = "Adriano Oliviero";
        userEmail = "adrianoliviero23@gmail.com";
        extraConfig.init."defaultBranch" = "main";
      };

      zsh = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        autocd = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        historySubstringSearch = {
          enable = true;
          searchDownKey = "$terminfo[kcud1]";
          searchUpKey = "$terminfo[kcuu1]";
        };
        localVariables = {
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
        initExtra = ''
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

        '';
        shellAliases = {
          bakkesmod = "WINEFSYNC=1 protontricks -c 'wine ~/Games/bakkesmod.exe' 252950";
          clnipc = "ipcrm -a $(ipcs | awk '{print $2}' | grep -vE '[^0-9]')";
          cp = "cp -iv";
          dev = "exec nix develop ~/.config/dotfiles/home/dev#default";
          eww = "eww --config ~/.config/dotfiles/nixos/home/desktop/eww";
          grep = "grep --color";
          hrs = "home-manager switch --flake ~/.config/dotfiles#$HOST";
          l = "ll -a";
          la = "ls -a";
          ll = "ls -lSh";
          lls = "clear; ls";
          ls = "exa --group-directories-first";
          md = "mkdir";
          mkdir = "mkdir -pv";
          mv = "mv -iv";
          myip = "curl ipinfo.io/ip && printf '\\n'";
          rm = "rm -v";
          rs = "rsync -av --progress --stats";
          scrsh = "yes | wf-recorder -m avi -f >(ffplay -window_title Screenshare -f avi -) --geometry=\"$(slurp -o)\"; pkill ffplay 2>&1 >/dev/null; pkill wf-recorder 2>&1 >/dev/null";
          snvim = "EDITOR=nvim sudoedit";
          termuxusb = "adb forward tcp:8022 tcp:8022; ssh localhost -p 8022";
          vimdiff = "nvim -d";
          yt = "youtube-dl --add-metadata -i";
          yta = "yt -x";
          ytd = "yt-dlp --add-metadata -i";
          ytda = "ytd -x";
        };
        zsh-abbr = {
          enable = true;
          abbreviations = {
            nos = "nh os switch";
            nou = "nh os switch -u";
            nhs = "nh home switch";
            nhu = "nh home switch -u";
            ns = "nh search";
            free = "free -h";
            ga = "git add .";
            gc = "git add . && git commit";
            gcp = "git add . && git commit && git push";
            gpl = "git pull";
            gpu = "git push";
            rmd = "rmdir";
            rmf = "rm -rf";
            ungz = "tar -zxvf";
          };
        };
      };
    };
  };
}
