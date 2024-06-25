#!/bin/env python

import subprocess, shutil, os


if shutil.which('pacman'): # if arch desktop or laptop
    if not shutil.which('decman'):
        subprocess.run(['git', 'clone', 'https://github.com/kiviktnm/decman-pkgbuild.git'])
        subprocess.run(['makepkg', '-si', '--noconfirm'], cwd='decman-pkgbuild')
        subprocess.run(['rm', '-rf', 'decman-pkgbuild'])
        subprocess.run(['sudo', 'decman', '--source', os.path.abspath(__file__).replace('installation/install.py', '')])

print('[\x1b[32mINFO\x1b[0m]: dotfiles installation completed successfully!')
