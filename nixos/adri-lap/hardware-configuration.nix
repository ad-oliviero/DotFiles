{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../adri-common/hardware-configuration.nix
    ./devices.nix
  ];
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        vpl-gpu-rt
      ];
    };
  };

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
      verbose = false;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["kvm-intel" "acpi_call" "ecryptfs"];
    plymouth.enable = true;
    consoleLogLevel = 0;
    kernelParams = [
      "i915.enable_guc=2"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
