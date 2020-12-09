# DotFiles

My DotFiles

![dotfiles.png](https://github.com/TheDarkBug/DotFiles/blob/main/dotfiles.png)

## Dependances:

- WM: [i3-gaps-rounded](https://aur.archlinux.org/packages/i3-gaps-rounded-git/)

- Compositor: [Picom](https://wiki.archlinux.org/index.php/Picom)

- Gtk theme: [Sweet](https://github.com/EliverLara/Sweet)

- Terminal: [Alacritty](https://wiki.archlinux.org/index.php/Alacritty)

- Shell: [zsh](https://wiki.archlinux.org/index.php/zsh) + [oh my zsh](https://ohmyz.sh/)

- Zsh theme: [PowerLevel10k](https://github.com/romkatv/powerlevel10k)

- Bar: [Polybar](https://wiki.archlinux.org/index.php/Polybar)

- Launcher: [Rofi](https://wiki.archlinux.org/index.php/Rofi)

- File manager: [Thunar](https://wiki.archlinux.org/index.php/Thunar)

- Background: [Feh](https://feh.finalrewind.org/)

- Fonts: [Roboto](https://fonts.google.com/specimen/Roboto), [Awesome 5](https://fontawesome.com/)

- Notifications: [Dunst](https://dunst-project.org/)

- Audio: [Pulseaudio](https://en.wikipedia.org/wiki/PulseAudio)

- Screenshot: [Maim](https://github.com/naelstrof/maim)

## Installation

**<u>Make Backups</u>**

After instaling dependances, copy all the folders (except for .oh-my-zsh) in ~/.config/

```shell
git clone https://github.com/TheDarkBug/DotFiles.git && cd DotFiles
cp -rt ~/.config alacritty/ dunst/ i3/ picom/ polybar/ rofi/ scripts/
```

Now copy .zshrc and in the home directory and pwbgld.png in ~/Pictures/

```shell
cp .zshrc ~/
cp pwbgld.png ~/Pictures/
```

To configure PowerLevel10k, run ```p10k configure``` in terminal and follow the instructions.
Finally you should change some lines in the config files, you need to swap my username (adri) with yours.

Nothing else, if all works you can delete the DotFiles forlder, if you liked it please leave a star.
