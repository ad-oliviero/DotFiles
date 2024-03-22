{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common/hardware-configuration.nix
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
    kernelModules = ["kvm-intel"];
    kernelParams = [
      # "irqpoll" # if enabled wifi doesn't work, if disabled I get "Disabling IRQ #9"
      # "acpi=noirq"
      "resume_offset=201912320"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d593588d-7419-4136-9200-3f2110fba204";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/99DD-8337";
    fsType = "vfat";
  };

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
