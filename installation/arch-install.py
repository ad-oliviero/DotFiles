#!/bin/env python
import subprocess

if not b'archiso' in subprocess.check_output(['uname', '-n']):
    raise RuntimeError('[\x1b[31mERROR\x1b[0m]: This script is supposed to run only on the arch install iso')

from pathlib import Path
from getpass import getpass
import os

import archinstall
from archinstall import Installer
from archinstall import profile
import archinstall.default_profiles as profiles
from archinstall import disk
from archinstall import models
from archinstall import locale

USER_PASS = getpass(prompt='Enter the password for adri: ')
ENC_PASS = getpass(prompt='Enter the password for disk encryption: ')

# Getting installation disk ready
fs_type = disk.FilesystemType('ext4')
device_path = Path('/dev/nvme0n1')
device = disk.device_handler.get_device(device_path)
if not device:
	raise ValueError('No device found for given path')
device_modification = disk.DeviceModification(device, wipe=True)

# Creating partitions
boot_partition = disk.PartitionModification(
	status=disk.ModificationStatus.Create,
	type=disk.PartitionType.Primary,
	start=disk.Size(1, disk.Unit.MiB, device.device_info.sector_size),
	length=disk.Size(512, disk.Unit.MiB, device.device_info.sector_size),
	mountpoint=Path('/boot'),
	fs_type=disk.FilesystemType.Fat32,
	flags=[disk.PartitionFlag.Boot]
)
root_partition = disk.PartitionModification(
	status=disk.ModificationStatus.Create,
	type=disk.PartitionType.Primary,
	start=boot_partition.length + disk.Size(1, disk.Unit.MiB, device.device_info.sector_size),
	length=disk.Size(20, disk.Unit.GiB, device.device_info.sector_size),
	mountpoint=Path('/'),
	fs_type=fs_type,
)
home_partition = disk.PartitionModification(
	status=disk.ModificationStatus.Create,
	type=disk.PartitionType.Primary,
	start=root_partition.length + disk.Size(513, disk.Unit.MiB, device.device_info.sector_size),
	length=(device.device_info.total_size - root_partition.length) - disk.Size(514, disk.Unit.MiB, device.device_info.sector_size),
	mountpoint=Path('/home'),
	fs_type=fs_type,
)

device_modification.add_partition(root_partition)
device_modification.add_partition(boot_partition)
device_modification.add_partition(home_partition)

# Additional disk configuration
disk_config = disk.DiskLayoutConfiguration(
	config_type=disk.DiskLayoutType.Default,
	device_modifications=[device_modification]
)
disk_encryption = disk.DiskEncryption(
	encryption_password=ENC_PASS,
	encryption_type=disk.EncryptionType.Luks,
	partitions=[home_partition],
	hsm_device=None
)

# Applying changes to the disk
fs_handler = disk.FilesystemHandler(disk_config)#, disk_encryption)
fs_handler.perform_filesystem_operations(show_countdown=False)

with Installer(
	Path('/mnt'),
	disk_config,
	#disk_encryption=disk_encryption,
	kernels=['linux-zen']
) as installation:
    installation.mount_ordered_layout()
    installation.sanity_check()
    installation.add_additional_packages(['git'])
    installation.setup_swap('zram')
    installation.set_timezone('Europe/Rome')
    installation.activate_time_synchronization()
    installation.genfstab()
    installation.add_bootloader(models.Bootloader.Systemd)
    installation.minimal_installation(
        hostname='adri-lap',
        multilib=True,
        locale_config=locale.LocaleConfiguration('it', 'en_US', 'UTF-8')
    )

    network_config = models.NetworkConfiguration.parse_arg({'type': 'nm'})
    network_config.install_network_config(installation)
    audio_model = models.AudioConfiguration(installation)
    audio_model.audio = models.Audio.Pipewire
    audio_model.install_audio_config(installation)
    #profile.profile_handler.install_profile_config(installation, profile.ProfileConfiguration(profiles.MinimalProfile()))
    installation.create_users(models.User('adri', USER_PASS, True))

HOME_DIR = '/mnt/home/adri'
os.makedirs(f'{HOME_DIR}/.ssh', exist_ok=True)
os.makedirs(f'{HOME_DIR}/.config', exist_ok=True)
subprocess.run(['ssh-keygen', '-t', 'ed25519', '-f', './.ssh/id_ed25519', '-C', '"adri@adri-lap"'], cwd=HOME_DIR)
subprocess.run(['pacman', '-Sy', '--noconfirm', 'git'])
subprocess.run(['git', 'clone', 'https://github.com/ad-oliviero/DotFiles.git', '--depth', '1', './.config/dotfiles'], cwd=HOME_DIR)
subprocess.run(['git', 'remote', 'set-url', 'origin', 'git@github.com:ad-oliviero/DotFiles.git'], cwd=f'{HOME_DIR}/.config/dotfiles')
subprocess.run(['./installation/install.py'], cwd=f'{HOME_DIR}/.config/dotfiles')
subprocess.run(['chown', '-R', 'adri:adri', HOME_DIR])
subprocess.run(['umount', '-a'])

print('[\x1b[33mINFO\x1b[0m]: Installation completed successfully!')
