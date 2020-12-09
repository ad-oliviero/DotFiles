sudo pacman -Syyu --noconfirm xorg-server xorg-xinit zsh alacritty rofi pcmanfm dunst feh pulseaudio maim ttf-font-awesome ttf-roboto lightdm
sudo systemctl enable lightdm
cd
git clone https://aur.archlinux.org/yay
cp -rt ~/.config alacritty/ dunst/ i3/ picom/ polybar/ rofi/ scripts/
cd yay
makepkg -si
cd ..
rm -rf yay
yay -Syyu --noconfirm oh-my-zsh-git polybar visual-studio-code-bin pamac picom-jonaburg-git
reboot