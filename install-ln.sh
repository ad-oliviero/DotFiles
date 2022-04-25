printf "\033[1;33mWARNING: THIS IS GOING TO MOVE MOST OF YOUR CONFIG FILES TO A BACKUP DIRECTORY: ~/config_backup\033[1;0m\n"
printf "Are you sure that you want to continue? (y/N): "
read choice
[ "$choice" == "n" ] || [ -z "$choice" ] && printf "Ok, you will install manually\n" && exit
printf "Installing...\n"

[ ! -d ~/config_backup ] && mkdir -pv ~/config_backup
mv -vt ~/config_backup \
		~/.config/alacritty \
		~/.config/chrome-flags.conf \
		~/.config/brave-flags.conf \
		~/.config/chromium-flags.conf \
		~/.config/libinput-gestures.conf \
		~/.config/bspwm \
		~/.config/dunst \
		~/.config/htop \
		~/.config/helix \
		~/.config/init.sh \
		~/.config/i3 \
		~/.config/kitty \
		~/.config/keyd \
		~/.config/mako \
		~/.config/nvim \
		~/.config/picom \
		~/.config/polybar \
		~/.config/rofi \
		~/.config/redshift \
		~/.config/river \
		~/.config/scripts \
		~/.config/sxhkd \
		~/.config/sway \
		~/.config/swaylock \
		~/.config/waybar \
		~/.config/wayfire.ini \
		~/.config/nvim/init.vim \
		~/.config/uwufetch \
		~/.config/zsh \
		~/.local/bin/lemonconfig \
		~/.emacs.d \
		~/.vim* \
		~/.zprofile \
		~/.xinitrc \
		~/.zshrc

ln -vs \
		~/.config/DotFiles/alacritty \
		~/.config/DotFiles/bspwm \
		~/.config/DotFiles/dunst \
		~/.config/DotFiles/htop \
		~/.config/DotFiles/helix \
		~/.config/DotFiles/init.sh \
		~/.config/DotFiles/i3 \
		~/.config/DotFiles/kitty \
		~/.config/DotFiles/keyd \
		~/.config/DotFiles/mako \
		~/.config/DotFiles/nvim \
		~/.config/DotFiles/libinput-gestures.conf \
		~/.config/DotFiles/picom \
		~/.config/DotFiles/polybar \
		~/.config/DotFiles/rofi \
		~/.config/DotFiles/redshift \
		~/.config/DotFiles/river \
		~/.config/DotFiles/scripts \
		~/.config/DotFiles/starship.toml \
		~/.config/DotFiles/sxhkd \
		~/.config/DotFiles/sway \
		~/.config/DotFiles/swaylock \
		~/.config/DotFiles/waybar \
		~/.config/DotFiles/wayfire.ini \
		~/.config/DotFiles/uwufetch \
		~/.config/DotFiles/zsh \
		~/.config

ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/
ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/chromium-flags.conf
ln -s ~/.config/DotFiles/chrome-flags.conf ~/.config/brave-flags.conf

ln -s \
		~/.config/DotFiles/.emacs.d \
		~/.config/DotFiles/.profile \
		~/.config/DotFiles/.vim* \
		~/.config/DotFiles/.xinitrc \
		~/.config/DotFiles/zsh/.zshrc \
		~/.config/DotFiles/zsh/.zprofile \
		~/

ln -s ~/.config/DotFiles/bin/lemonconfig/lemonconfig ~/.local/bin

ln -s ~/.vimrc ~/.config/nvim/init.vim
# ln -s ~/.config/alacritty/alacritty.yml.dark ~/.config/alacritty/alacritty.yml

printf "Installed correctly!\n"
printf "you should also
\tln -s ~/.config/DotFiles/ffvars.sh /etc/profile.d
\tln -s ~/.config/DotFiles/tlp.conf /etc
\tln -s ~/.config/DotFiles/keyd/default.conf /etc/keyd/default.conf
\tcp fffonts.conf ~/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf\n"
