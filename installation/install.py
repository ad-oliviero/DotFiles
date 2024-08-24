#!/bin/env python

import subprocess, shutil, os, sys
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
        self.mountpoint = '/'
        self.etc_nixos = '/etc/nixos'
        self.nixos_config = 'configuration.nix'
        self.nixos_hardware = 'hardware-configuration.nix'
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

    def run(self):
        # self.partition_disk()
        self.gen_config()

    def partition_disk(self):
        avail_disks = [d for d in re.findall('/dev/.*', subprocess.check_output('env parted -l'.split(' ')).decode())]
        selected_disk = "/dev/nvme0n1" # selection_menu(avail_disks).split(': ')[0]
        print(selected_disk)

    def gen_config(self):
        try:
            #subprocess.check_output(('env nixos-generate-config --root ' + self.mountpoint).split(' '))
            subprocess.check_output(('env nixos-generate-config').split(' '))
            conf = read_file(f'{self.etc_nixos}/{self.nixos_config}')
            result = conf[:]
            for k in self.values:
                reg = re.compile(k)
                result = reg.sub(self.values[k], result)
            result = '\n'.join([l for l in result.split('\n') if l.strip()])
            with open(f'{self.etc_nixos}/{self.nixos_config}', 'w') as f:
                f.write(result)
            hardware = read_file(f'{self.etc_nixos}/{self.nixos_hardware}')
            #with open(f'{self.etc_nixos}/{self.nixos_hardware}', 'w') as f:
            #    pass
        except Exception as e:
            print(str(e))



if __name__ == '__main__':
    # if not check_connection():
    #     print("[\x1b[31mERROR\x1b[0m]: you must connect to a network with internet access")
    #     sys.exit(1)
    if not check_root():
        print("[\x1b[31mERROR\x1b[0m]: this script must be executed as root")
        sys.exit(1)

    avail_confs = {
        "Laptop" : Configuration("adri-lap"),
        "Desktop" : Configuration("adri-desk"),
        "New": Configuration("new"),
    }

    selected_conf = avail_confs["Laptop"] # selection_menu([k for k in avail_confs])
    selected_conf.run()
    # subprocess.run(['reboot'])

