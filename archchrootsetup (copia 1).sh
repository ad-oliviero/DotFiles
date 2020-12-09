pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober base-devel linux-headers reflector git xdg-utils xdg-user-dirs
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
useradd -mG wheel adri
passwd adri
echo 'uncomment %wheel ALL=(ALL) ALL'
sleep 3
EDITOR=vim visudo
