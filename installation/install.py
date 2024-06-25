#!/bin/env python

import subprocess, shutil, os


DOTFILES_PATH = os.path.abspath(__file__).replace('/installation/install.py', '')

if shutil.which('pacman'): # if arch desktop or laptop
    if not shutil.which('decman'):
        subprocess.run(['git', 'clone', 'https://github.com/kiviktnm/decman-pkgbuild.git'])
        subprocess.run(['makepkg', '-si', '--noconfirm'], cwd='decman-pkgbuild')
        subprocess.run(['rm', '-rf', 'decman-pkgbuild'])
        subprocess.run(['sudo', 'decman', '--source', DOTFILES_PATH + '/decman_source.py'])

if shutil.which('apt'): # try another distro
    subprocess.run(['sudo apt install -y chezmoi'])

os.makedirs(os.getenv('HOME') + '/.local/share', exist_ok=True)
try:
    os.symlink(DOTFILES_PATH, os.getenv('HOME') + '/.local/share/chezmoi')
except FileExistsError:
    print('Chezmoi configuration already exists!')

with open(os.getenv('HOME') + '/.local/share/chezmoi/.chezmoiroot', 'w') as f:
    f.write('dot_files')


print('[\x1b[32mINFO\x1b[0m]: dotfiles installation completed successfully!')
