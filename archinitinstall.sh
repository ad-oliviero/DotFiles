loadkeys it
timedatectl set-ntp true
pacman -Syyy --noconfirm refector
reflector -c Italy -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy git vim wget
lsblk