{...}: {
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3dac05ff-59d0-4f3e-b616-de0df8256789";
    fsType = "btrfs";
    options = ["subvol=@"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4CC6-F896";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  fileSystems."/swap" = {
    device = "/dev/disk/by-uuid/3dac05ff-59d0-4f3e-b616-de0df8256789";
    fsType = "btrfs";
    options = ["subvol=@swap"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/3dac05ff-59d0-4f3e-b616-de0df8256789";
    fsType = "btrfs";
    options = ["subvol=@home"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/3dac05ff-59d0-4f3e-b616-de0df8256789";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };
}
