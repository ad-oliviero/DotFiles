printf "\033[1;33mWARNING: THIS IS GOING TO MOVE MOST OF YOUR CONFIG FILES TO A BACKUP DIRECTORY: $HOME/config_backup\033[1;0m\n"
printf "Are you sure that you want to continue? (y/N): "
read choice
[ "$choice" == "n" ] || [ -z "$choice" ] && printf "Ok, you will install manually\n" && exit
printf "Installing...\n"

cwd=$(pwd)
configdir="$XDG_CONFIG_HOME"
[ -z "$configdir" ] && configdir="$HOME/.config"
[ -d "$configdir" ] || mkdir -p "$configdir"

[ -d $HOME/config_backup ] || mkdir -pv $HOME/config_backup
mv -vt $HOME/config_backup \
	$configdir/alacritty \
	$configdir/brave-flags.conf \
	$configdir/bspwm \
	$configdir/chrome-flags.conf \
	$configdir/chromium-flags.conf \
	$configdir/dunst \
	$configdir/htop \
	$configdir/i3 \
	$configdir/init.sh \
	$configdir/keyd \
	$configdir/kitty \
	$configdir/libinput-gestures.conf \
	$configdir/mako \
	$configdir/nvim \
	$configdir/picom \
	$configdir/polybar \
	$configdir/river \
	$configdir/rofi \
	$configdir/scripts \
	$configdir/sxhkd \
	$configdir/sway \
	$configdir/swaylock \
	$configdir/waybar \
	$configdir/uwufetch \
	$configdir/zsh \
	$HOME/.emacs.d \
	$HOME/.env \
	$HOME/.vim* \
	$HOME/.xinitrc \
	$HOME/.zshrc

local_bin="$(ls bin)"
for f in $(ls $HOME/.local/bin); do
	mv $(echo "$local_bin" | grep -e "^$f$") $HOME/config_backup
done

ln -vs \
	$cwd/alacritty \
	$cwd/bspwm \
	$cwd/dunst \
	$cwd/htop \
	$cwd/i3 \
	$cwd/init.sh \
	$cwd/keyd \
	$cwd/kitty \
	$cwd/libinput-gestures.conf \
	$cwd/mako \
	$cwd/nvim \
	$cwd/picom \
	$cwd/polybar \
	$cwd/river \
	$cwd/rofi \
	$cwd/starship.toml \
	$cwd/sxhkd \
	$cwd/sway \
	$cwd/swaylock \
	$cwd/waybar \
	$cwd/uwufetch \
	$cwd/zsh \
	$configdir

ln -s \
	$cwd/.emacs.d \
	$cwd/.env \
	$cwd/.vim* \
	$cwd/.xinitrc \
	$cwd/zsh/.zshrc \
	$HOME

for f in $(ls); do
	ln -s \$cwd/$f \$HOME/.local/bin
done

# ln -s $configdir/alacritty/alacritty.yml.dark $configdir/alacritty/alacritty.yml

ln -s fffonts.conf $HOME/.var/app/org.mozilla.firefox/config/fontconfig/fonts.conf

printf "Installed correctly!\n"
printf "you should also
\tln -s $cwd/tlp.conf /etc
\tln -s $cwd/keyd/default.conf /etc/keyd/default.conf\n"
