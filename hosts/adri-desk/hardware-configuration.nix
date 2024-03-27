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

  # environment.variables = {
  #   VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  # };
  # hardware.opengl.extraPackages = with pkgs; [
  #   (
  #     if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
  #     then vaapiIntel
  #     else intel-vaapi-driver
  #   )
  #   libvdpau-va-gl
  #   intel-media-driver
  # ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sr_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-amd" "amdgpu"];
    extraModulePackages = [];
    kernelParams = [
      "resume_offset=1849344"
    ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e5f43164-9593-43e7-9106-d82b09ccbaec";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9170-CE6F";
    fsType = "vfat";
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
