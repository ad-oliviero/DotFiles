sudo pacman -Syyu --noconfirm xf86-video-amdgpu xorg-server xorg-xinit zsh alacritty rofi pcmanfm dunst feh pulseaudio maim ttf-font-awesome ttf-roboto lightdm polkit-gnome
sudo systemctl enable lightdm
cd /etc/X11/xorg.conf.d/
echo 'Section "Device"' >> 20-amdgpu.conf
echo '    Identifier "AMD"' >> 20-amdgpu.conf
echo '    Driver  "amdgpu"' >> 20-amdgpu.conf
echo '    Option "TearFree" "true"' >> 20-amdgpu.conf
echo 'EndSection' >> 20-amdgpu.conf
cd
git clone https://github.com/MentalOutlaw/dwm
git cloen https://aur.archlinux.org/yay.git
cp -rt ~/.config alacritty/ dunst/ i3/ picom/ polybar/ rofi/ scripts/
cd yay
makepkg -si
cd
rm -rf yay
yay -Syyu --noconfirm oh-my-zsh-git polybar visual-studio-code-bin pamac picom-jonaburg-git
reboot
