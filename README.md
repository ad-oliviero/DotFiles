# DotFiles

My .files (the screenshot was removed, in future i will restore it).

## Dependances:

- WM: [xmonad](https://archlinux.org/packages/community/x86_64/xmonad/) + [xmonad-contrib](https://archlinux.org/packages/community/x86_64/xmonad-contrib/),  [i3-gaps](https://aur.archlinux.org/packages/i3-gaps/), or [sway](https://swaywm.org/)

- Compositor: [Picom](https://wiki.archlinux.org/index.php/Picom)

- Gtk theme: [layan-dark](https://github.com/vinceliuice/Layan-gtk-theme)

- Terminal: [kitty](https://github.com/kovidgoyal/kitty)

- Shell: [zsh](https://wiki.archlinux.org/index.php/zsh) + [oh my zsh](https://ohmyz.sh/)

- Zsh theme: [PowerLevel10k](https://github.com/romkatv/powerlevel10k)

- Bar: [Polybar](https://wiki.archlinux.org/index.php/Polybar)/[Waybar](https://github.com/Alexays/Waybar)

- Launcher: [Rofi](https://wiki.archlinux.org/index.php/Rofi)/[dmenu](https://tools.suckless.org/dmenu/)

- File manager: [Nautilus](https://archlinux.org/packages/extra/x86_64/nautilus/)

- Background manager: [Feh](https://feh.finalrewind.org/)

- Fonts: [Roboto](https://fonts.google.com/specimen/Roboto), [JetBrains Mono](https://www.jetbrains.com/lp/mono/), [Awesome 5]([Font Awesome](https://fontawesome.com/))

- Notifications: [Dunst](https://dunst-project.org/)/[Mako](https://github.com/emersion/mako)

- Audio: [Pulseaudio](https://en.wikipedia.org/wiki/PulseAudio)

- Screenshot: [Maim](https://github.com/naelstrof/maim)/[swayshot](https://gitlab.com/radio_rogal/swayshot)

## Installation

**<u>Make Backups</u>**

After instaling dependances, copy all the folders (except for .oh-my-zsh, .xmonad and .vim) in ~/.config/

```shell
git clone https://github.com/TheDarkBug/DotFiles.git && cd DotFiles
cp -rt ~/.config alacritty  aliasrc  dunst  htop  i3rofi  scripts  sway  swaylock  waybar  zsh
```

Now copy the other files in the home directory and the wallpaper in ~/Pictures/

```shell
cp -t ~/ .zshrc .xmonad .vim .vimrc
cp -t ~/Pictures/ *.png *.jpg
```

To configure PowerLevel10k, run ```p10k configure``` in terminal and follow the instructions.
Finally you should change some lines in the config files, you need to swap my username (adri) with yours.

Nothing else, if all works you can delete the DotFiles forlder, if you liked it please leave a star.
