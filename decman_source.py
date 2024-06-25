import socket
import os

import decman
import decman.config
from decman import UserPackage, File, Directory, UserRaisedError

decman.packages += [
        "base",
        "base-devel",
        "efibootmgr",
		"gst-plugin-pipewire",
		"intel-ucode",
		"libpulse",
		"linux-firmware",
		"linux-zen",
		"neovim",
		"pipewire",
		"pipewire-alsa",
		"pipewire-jack",
		"pipewire-pulse",
		"sof-firmware",
		"wireplumber",
		"zram-generator",
        "pacman",

        "python",
		"devtools",
		"git",
		"networkmanager",
        "neovim",
        "android-tools",

        "firefox",
        "hyprland",
        "alacritty",
        "waybar",
        "rofi",
        "bitwarden",
        "telegram-desktop",
        "ttf-jetbrains-mono",
        "xdg-user-dirs",

        ]

# decman.aur_packages += [""]

decman.user_packages.append(
    UserPackage(
        pkgname="decman-git",
        version="0.2.1",
        provides=["decman"],
        dependencies=[
            "python",
            "python-requests",
            "devtools",
            "pacman",
            "systemd",
            "git",
            "less",
        ],
        make_dependencies=[
            "python-setuptools",
            "python-build",
            "python-installer",
            "python-wheel",
        ],
        git_url="https://github.com/kiviktnm/decman-pkgbuild.git",
    ))

decman.files["/etc/vconsole.conf"] = File(content="KEYMAP=it", encoding="utf-8")

decman.enabled_systemd_units += ["NetworkManager.service"]

decman.config.suppress_command_output = False

# decman.config.quiet_output = False

