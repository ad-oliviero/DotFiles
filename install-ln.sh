echo -e '\033[1;33m WARNING: THIS IS GOING TO DELETE MOST OF YOUR CONFIG FILES.\033[1;37m'
echo -e 'Are you sure that you want to continue? (y/n):\b'
read choice
[ $choice == "n" ] && echo 'Ok, you will install manually' && exit
echo 'Installing...'

rm -rf \
		~/.config/alacritty \
		~/.config/chrome-flags.conf \
		~/.config/brave-flags.conf \
		~/.config/chromium-flags.conf \
		~/.config/dunst \
		~/.config/htop \
		~/.config/i3 \
		~/.config/kitty \
		~/.config/mako \
		~/.config/picom \
		~/.config/polybar \
		~/.config/rofi \
		~/.config/redshift \
		~/.config/scripts \
		~/.config/sxhkd \
		~/.config/sway \
		~/.config/swaylock \
		~/.config/waybar \
		~/.config/wayfire.ini \
		~/.config/nvim \
		~/.config/uwufetch \
		~/.config/zsh \
		~/.vim* \
		~/.zprofile \
		~/.xinitrc \
		~/.zshrc

ln -s \
		~/.config/DotFiles/alacritty \
		~/.config/DotFiles/dunst \
		~/.config/DotFiles/htop \
		~/.config/DotFiles/i3 \
		~/.config/DotFiles/kitty \
		~/.config/DotFiles/mako \
		~/.config/DotFiles/picom \
		~/.config/DotFiles/polybar \
		~/.config/DotFiles/rofi \
		~/.config/DotFiles/redshift \
		~/.config/DotFiles/scripts \
		~/.config/DotFiles/sxhkd \
		~/.config/DotFiles/sway \
		~/.config/DotFiles/swaylock \
		~/.config/DotFiles/waybar \
		~/.config/DotFiles/wayfire.ini \
		~/.config/DotFiles/nvim \
		~/.config/DotFiles/uwufetch \
		~/.config/DotFiles/zsh \
		~/.config

ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/
ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/chromium-flags.conf
ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/brave-flags.conf

ln -s \
		~/.config/DotFiles/.vim* \
		~/.config/DotFiles/.xinitrc \
		~/.config/DotFiles/zsh/.zshrc \
		~/.config/DotFiles/zsh/.zprofile \
		~/

ln -s ~/.vimrc ~/.config/nvim/init.vim

echo 'Installed correctly!'
