{
  # config,
  lib,
  # pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  hardware.graphics.enable = true;

  boot = {
    # initrd = {
    #   availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    #   verbose = false;
    # };
    # kernelPackages = pkgs.linuxPackages_zen;
    # kernelModules = ["kvm-intel" "acpi_call" "ecryptfs"];
    # plymouth.enable = true;
    # consoleLogLevel = 0;
    # kernelParams = [
    #   "i915.enable_guc=2"
    #   "quiet"
    #   "splash"
    #   "boot.shell_on_fail"
    #   "loglevel=3"
    #   "rd.systemd.show_status=false"
    #   "rd.udev.log_level=3"
    #   "udev.log_priority=3"
    # ];
    loader = {
      timeout = 0;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  swapDevices = [{device = "/swap/file";}];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
