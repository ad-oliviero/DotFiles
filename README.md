# DotFiles

My .files, here is a preview (*keep in mind: the screenshots are not updated*):

![](https://raw.githubusercontent.com/TheDarkBug/DotFiles/main/dotfiles.png)

## Programs and other resources used

_A command to install all the dependances will be printed after running the `./install` script (arch linux only)._

- WM: [hyprland](https://hyprland.org/)

- Color scheme: [Srcery](https://github.com/srcery-colors)

- Wallpaper: [none](#)

<!--- Gtk theme: [Gruvbox](https://github.com/TheGreatMcPain/gruvbox-material-gtk)-->

- Terminal: [Alacritty](https://alacritty.org/)

- Shell: [zsh](https://wiki.archlinux.org/index.php/zsh)

- Fetch tool: [UwUfetch](https://github.com/TheDarkBug/uwufetch)

- Zsh prompt: [Starship](https://starship.rs/)

- Bar: [Waybar](https://github.com/Alexays/Waybar)

- Launcher: [Rofi](https://github.com/davatorium/rofi)

- File manager: [Nautilus](https://gitlab.gnome.org/GNOME/nautilus)

- Fonts: [JetBrains Mono](https://www.jetbrains.com/lp/mono/), [Nerd Fonts](https://www.nerdfonts.com/)

- Notifications: [Mako](https://github.com/emersion/mako)

- Audio: [Pipewire](https://pipewire.org/) + [wireplumber](https://pipewire.pages.freedesktop.org/wireplumber/)

- Screenshot: [flameshot](https://flameshot.org/)

### Other dependances

- [swaylock-effects](https://github.com/jirutka/swaylock-effects): locks wayland session

- [swayidle](https://github.com/swaywm/swayidle): lock the session before hibernating/suspending

- [rofi-lbonn-wayland](https://github.com/lbonn/rofi): rofi but for wayland

- [waybar-hyprland](https://aur.archlinux.org/packages/waybar-hyprland): waybar but the workspaces widget works with hyprland

- [rofi-calc](https://github.com/svenstaro/rofi-calc), rofi-file-browser-extended: some useful rofi "extensions"

- [syncthing](https://syncthing.net/): syncs things

- [gammastep](https://gitlab.com/chinstrap/gammastep): like redshift but for wayland

- [sunshine](https://github.com/LizardByte/Sunshine): server for [moonlight](https://moonlight-stream.org/)

- [polkit-gnome](https://wiki.gnome.org/Projects/PolicyKit): graphical authentication

- [wlogout](https://github.com/ArtsyMacaw/wlogout): logout window for wayland

## Installation

Run

```shell
mkdir .config && cd .config
git clone --recursive https://github.com/TheDarkBug/DotFiles.git
cd DotFiles
./install
```

Before the installation begins, a backup of your current configuration will be automatically generated in `~/config_backup`.

## Post installation

This post installation to-do list is mainly for me as I use arch linux (btw) and I **always** forget to do this things.

- `systemctl --user enable --now pipewire.service pipewire.socket wireplumber # WhY IsN't PiPeWiRe WoRKiNg?? Well, that's why. Also maybe installing sof-firmware is a good idea`
- Setup [swapfile](https://wiki.archlinux.org/title/Swap#Swap_file) and [hibernation](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Hibernation_into_swap_file)
- To enable pipewire video capture in obs, you need to `pacman -S xdg-desktop-portal xdg-desktop-portal-wlr`, and go in `Settings > Output > set "Output Mode" to "Advanced" > Streaming > set "Encoder" to the "VAAPI" option` and that should be it
