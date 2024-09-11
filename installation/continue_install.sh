#!/bin/sh

set -e

[ "$UID" == 0 ] && printf "[\x1b[31mERROR\x1b[0m]: you must NOT run this script as root"
ping -c1 google.com 2>/dev/null>/dev/null
[ "$?" != 0 ] && printf "[\x1b[31mERROR\x1b[0m]: you must be connected to the internet"

mkdir -p $HOME/.config
pushd $HOME/.config
git clone https://github.com/ad-oliviero/dotfiles
pushd dotfiles
git checkout nixos
git remote set-url origin git@github.com:ad-oliviero/DotFiles.git

cp /etc/nixos/hardware-configuration.nix $HOME/.config/dotfiles/nixos/devices.nix
ssh-keygen -t ed25519 -N ''

sudo rm -f /bin/continue_install
sudo nixos-rebuild switch --flake $HOME/.config/dotfiles/nixos#adri-lap
sudo rm -f /etc/nixos/{configuration.nix,hardware-configuration.nix}
sudo rmdir /etc/nixos
printf "[\x1b[31mINFO\x1b[0m]: Installation completed successfully!\nSystem will reboot in 2 seconds!\n"
sleep 2
sudo reboot
