#!/bin/sh

[ "$UID" == 0 ] && printf "[\x1b[31mERROR\x1b[0m]: you must NOT run this script as root"
ping -c1 google.com 2>/dev/null>/dev/null
[ "$?" != 0 ] && printf "[\x1b[31mERROR\x1b[0m]: you must be connected to the internet"

mkdir $HOME/.config
pushd $HOME/.config
git clone https://github.com/ad-oliviero/dotfiles
pushd dotfiles
git checkout nixos
git remote set-url origin git@github.com:ad-oliviero/DotFiles.git

sudo rm -f /bin/continue_install; sudo nixos-rebuild switch --flake $HOME/.config/dotfiles/nixos#adri-lap && printf "[\x1b[31mINFO\x1b[0m]: Installation completed successfully!\n"
