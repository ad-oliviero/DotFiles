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
        "zsh",

        "python",
		"devtools",
		"git",
		"networkmanager",
        "neovim",
        "android-tools",

        "firefox",
        "hyprland",
        "alacritty",
        "rofi",
        "bitwarden",
        "telegram-desktop",
        "ttf-jetbrains-mono",
        "xdg-user-dirs",
        "chezmoi",
        'eza',
        'imagemagick',
        'imv',
        'libnotify',
        'mako',
        'mpv',
        'ttf-nerd-fonts-symbols-mono',
        'nwg-look',
        'playerctl',
        'starship',
        'swayidle',
        'waybar',
        'wl-clipboard',
        'xwaylandvideobridge',
        ]

# decman.aur_packages += [
#         "paru",
#         'grimshot',
#         #'hyprpaper',
#         #'hyprshade',
#         'pyprland',
#         'wlogout',
#         'swaylock-effects',
#         ]

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
decman.files["/etc/systemd/zram-generator.conf"] = File(content="[zram0]\nzram-size = ram\ncompression-algorithm = zstd\n", encoding="utf-8")

decman.enabled_systemd_units += ["NetworkManager.service"]

decman.config.suppress_command_output = False

# decman.config.quiet_output = False

class MyCommands(decman.config.Commands):

    def list_pkgs(self) -> list[str]:
        return ["pacman", "-Qeq", "--color=never"]

    def list_foreign_pkgs_versioned(self) -> list[str]:
        return ["pacman", "-Qm", "--color=never"]

    def install_pkgs(self, pkgs: list[str]) -> list[str]:
        return ["pacman", "-S", "--needed", "--noconfirm"] + pkgs

    def install_files(self, pkg_files: list[str]) -> list[str]:
        return ["pacman", "-U", "--asdeps", "--noconfirm"] + pkg_files

    def set_as_explicitly_installed(self, pkgs: list[str]) -> list[str]:
        return ["pacman", "-D", "--asexplicit"] + pkgs

    def install_deps(self, deps: list[str]) -> list[str]:
        return ["pacman", "-S", "--needed", "--asdeps", "--noconfirm"] + deps

    def is_installable(self, pkg: str) -> list[str]:
        return ["pacman", "-Sddp", pkg]

    def upgrade(self) -> list[str]:
        return ["pacman", "-Syu", "--noconfirm"]

    def remove(self, pkgs: list[str]) -> list[str]:
        return ["pacman", "-Rs", "--noconfirm"] + pkgs

    def enable_units(self, units: list[str]) -> list[str]:
        return ["systemctl", "enable"] + units

    def disable_units(self, units: list[str]) -> list[str]:
        return ["systemctl", "disable"] + units

    def enable_user_units(self, units: list[str], user: str) -> list[str]:
        return ["systemctl", "--user", "-M", f"{user}@", "enable"] + units

    def disable_user_units(self, units: list[str], user: str) -> list[str]:
        return ["systemctl", "--user", "-M", f"{user}@", "disable"] + units

    def compare_versions(self, installed_version: str,
                         new_version: str) -> list[str]:
        return ["vercmp", installed_version, new_version]

    def git_clone(self, repo: str, dest: str) -> list[str]:
        return ["git", "clone", repo, dest]

    def git_diff(self, from_commit: str) -> list[str]:
        return ["git", "diff", from_commit]

    def git_get_commit_id(self) -> list[str]:
        return ["git", "rev-parse", "HEAD"]

    def review_file(self, file: str) -> list[str]:
        return ["less", file]

    def make_chroot(self, chroot_dir: str, with_pkgs: list[str]) -> list[str]:
        return ["mkarchroot", chroot_dir] + with_pkgs

    def install_chroot_packages(self, chroot_dir: str, packages: list[str]):
        return [
            "arch-nspawn", chroot_dir, "pacman", "-S", "--needed",
            "--noconfirm"
        ] + packages

    def remove_chroot_packages(self, chroot_dir: str, packages: list[str]):
        return ["arch-nspawn", chroot_dir, "pacman", "-Rsu", "--noconfirm"
                ] + packages

    def make_chroot_pkg(self, chroot_wd_dir: str, user: str,
                        pkgfiles_to_install: list[str]) -> list[str]:
        makechrootpkg_cmd = [
            "makechrootpkg", "-c", "-r", chroot_wd_dir, "-U", user
        ]

        for pkgfile in pkgfiles_to_install:
            makechrootpkg_cmd += ["-I", pkgfile]

        return makechrootpkg_cmd


# To apply your overrides, set the commands variable.
decman.config.commands = MyCommands()
