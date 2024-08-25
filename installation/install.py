#!/bin/env python

import subprocess, shutil, os, sys, time
import re
import curses
from urllib import request

DOTFILES_PATH = os.path.abspath(__file__).replace('/installation/install.py', '')
HOME_DIR = os.getenv('HOME')

def read_file(name: str) -> str:
    try:
        with open(name, 'r') as f:
            return f.read()
    except Exception as e:
        raise e

def check_connection() -> bool:
    try:
        request.urlopen('https://8.8.8.8/', timeout=1)
        return True
    except request.URLError as err:
        return False

def check_root() -> bool:
    return os.getuid() == 0

def selection_menu(opts) -> str:
    scr = curses.initscr()
    curses.noecho()
    curses.cbreak()
    curses.curs_set(0)
    scr.keypad(True)

    sel = 0
    while True:
        scr.clear()
        for i, o in enumerate(opts):
            if i == sel:
                scr.addstr(i, 0, f"> {o}")
            else:
                scr.addstr(i, 0, f"  {o}")
        scr.refresh()

        c = scr.getch()
        if c == curses.KEY_UP:
            sel = (sel - 1) % len(opts)
        elif c == curses.KEY_DOWN:
            sel = (sel + 1) % len(opts)
        elif c == ord('\n'):  # Enter key
            break

    scr.keypad(False)
    curses.curs_set(1)
    curses.nocbreak()
    curses.echo()
    curses.endwin()
    return opts[sel]

class Configuration(object):
    def __init__(self, hostname) -> None:
        self.hostname = hostname
        self.username = 'adri'
        self.mountpoint = '/mnt'
        self.values = {
                '# *(networking.hostName = )"nixos";': f'\\1"{self.hostname}";',
                '# *(networking.networkmanager.enable = true;)': '\\1',
                '# *(time.timeZone = )".*";': '\\1"Europe/Rome";',
                '# *(i18n.defaultLocale = )".*";': '\\1"en_US.UTF-8";',
                '# *(console) = {': '\\1.keyMap = "it";',
                '# *(users.users.).*( = {)': f'\\1{self.username}\\2',
                '# *(isNormalUser = ).*;': '\\1;',
                '# *(extraGroups = )\\[.*\\];': '\\1[ "wheel" ];\n};',
                '# *(environment.systemPackages = with pkgs; \\[)': '\\1\nnvim\ncurl\necryptfs\ngit\n];',
                '# *(programs).mtr.enable = true;': 'security.pam.enableEcryptfs = true;',
                '#.*': '',
                }

    def install(self):
        print('\nPartitioning disk:\n\n')
        time.sleep(5)
        self.partition_disk()
        print('\nGenerating nix configuration:\n\n')
        time.sleep(5)
        self.gen_config()
        print('\nDownloading continue install script\n\n')
        time.sleep(5)
        with open('/bin/continue_install', 'w') as f:
            content = request.urlopen('https://raw.githubusercontent.com/ad-oliviero/DotFiles/nixos/installation/continue_install.sh')
            f.write(content.read().decode())
        os.chmod('/bin/continue_install', 0o777)
        print('[INFO]: Installation completed. The system will reboot. If you want to continue installing ad-oliviero/DotFiles, run /bin/continue_install, otherwise remove that executable\nRebooting in 10 seconds.')
        time.sleep(10)
        subprocess.run(['reboot'])

    def partition_disk(self):
        avail_disks = [d.replace('Disk ', '') for d in re.findall('Disk (/dev/.*)', subprocess.check_output('fdisk -l'.split(' ')).decode())]
        disk = selection_menu(avail_disks).split(':')[0]
        fdisk = subprocess.Popen(f'fdisk {disk}'.split(' '), stdout=subprocess.PIPE, stdin=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        fdisk_out = fdisk.communicate('g\n' +
                                'n\n\n\n+1G\nt\n1\n' +
                                'n\n\n\n\n' +
                                '\nw\nq\n')[0]
        boot_part, root_part = re.findall(f'{disk}p[^ ]', fdisk_out)
        subprocess.check_output(f'mkfs.fat -F32 -n BOOT {boot_part}'.split(' '))
        subprocess.check_output(f'mkfs.btrfs {root_part} -l nixos'.split(' '))
        subprocess.check_output(f'mount {root_part} {self.mountpoint}'.split(' '))
        subprocess.check_output(f'btrfs subvolume create {self.mountpoint}/@'.split(' '))
        subprocess.check_output(f'btrfs subvolume create {self.mountpoint}/@swap'.split(' '))
        subprocess.check_output(f'btrfs subvolume create {self.mountpoint}/@home'.split(' '))
        subprocess.check_output(f'btrfs subvolume create {self.mountpoint}/@nix'.split(' '))
        subprocess.check_output(f'umount {self.mountpoint}'.split(' '))
        subprocess.check_output(f'mount {root_part} -o subvol=@ {self.mountpoint}'.split(' '))
        subprocess.check_output(f'mkdir -p {self.mountpoint}/{{boot,swap,home,nix}}'.split(' '))
        subprocess.check_output(f'mount {boot_part} -o umask=077 {self.mountpoint}/boot'.split(' '))
        subprocess.check_output(f'mount {root_part} -o subvol=@swap{self.mountpoint}/swap'.split(' '))
        subprocess.check_output(f'mount {root_part} -o subvol=@home {self.mountpoint}/home'.split(' '))
        subprocess.check_output(f'mount {root_part} -o subvol=@nix {self.mountpoint}/nix'.split(' '))
        subprocess.check_output(f'btrfs filesystem mkswapfile --size 8g --uuid clear /swap/file'.split(' '))

    def gen_config(self):
        try:
            subprocess.check_output(('env nixos-generate-config --root ' + self.mountpoint).split(' '))
            conf = read_file(f'/etc/nixos/configuration.nix')
            result = conf[:]
            for k in self.values:
                reg = re.compile(k)
                result = reg.sub(self.values[k], result)
            result = '\n'.join([l for l in result.split('\n') if l.strip()])
            with open(f'/etc/nixos/configuration.nix', 'w') as f:
                f.write(result)
        except Exception as e:
            print(str(e))

if __name__ == '__main__':
    if not check_connection():
        print("[\x1b[31mERROR\x1b[0m]: you must connect to a network with internet access")
        sys.exit(1)
    if not check_root():
        print("[\x1b[31mERROR\x1b[0m]: this script must be executed as root")
        sys.exit(1)
    avail_confs = [
        Configuration("adri-lap"),
    ]
    hostname = selection_menu([c.hostname for c in avail_confs])
    selected_conf = [c for c in avail_confs if c.hostname == hostname][0]
    selected_conf.install()

