#!/bin/env python

import subprocess, shutil, os


DOTFILES_PATH = os.path.abspath(__file__).replace('/installation/install.py', '')
HOME_DIR = os.getenv('HOME')
if HOME_DIR == None:
    raise RuntimeError('$HOME environment variable was not set, cannot proceed!')

os.makedirs(HOME_DIR + '/.local/share', exist_ok=True)
os.makedirs(HOME_DIR + '/.config', exist_ok=True)

def install_from_aur(url: str):
    download_path = url.replace('https://aur.archlinux.org/', '').replace('.git', '')
    subprocess.run(['git', 'clone', url])
    subprocess.run(['makepkg', '-si', '--noconfirm'], cwd=download_path)
    subprocess.run(['rm', '-rf', download_path])

if shutil.which('pacman'): # if arch desktop or laptop
    if not shutil.which('pacdef'):
        install_from_aur('https://aur.archlinux.org/pacdef-bin.git')
    if not shutil.which('paru'):
        install_from_aur('https://aur.archlinux.org/paru-bin.git')
    for f in os.listdir('./packages'):
        path = os.path.join('./packages', f)
        if os.path.isfile(path):
            subprocess.run(['pacdef', 'g', 'i', path])
    subprocess.run(['pacdef', 'p', 'sync'])


if shutil.which('apt'): # try another distro
    subprocess.run(['sudo apt install -y chezmoi'])

try:
    os.symlink(DOTFILES_PATH, HOME_DIR + '/.local/share/chezmoi')
except FileExistsError:
    pass

with open(HOME_DIR + '/.local/share/chezmoi/.chezmoiroot', 'w') as f:
    f.write('dot_files')

subprocess.run(['chezmoi', 'apply'])


print('[\x1b[32mINFO\x1b[0m]: dotfiles installation completed successfully!')
