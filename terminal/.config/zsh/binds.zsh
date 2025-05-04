bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey '^I' menu-select
bindkey "$terminfo[kcbt]" reverse-menu-select
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete

bindkey "^V" edit-command-line

bindkey '^H' backward-kill-word
bindkey '5~' kill-word
