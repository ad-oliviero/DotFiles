{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  boot = {
    initrd.kernelModules = [
      "i915"
      "acpi_call"
      "v4l2loopback"
    ];
    loader = {
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
      v4l2loopback
    ];
    consoleLogLevel = 3;
    kernelParams = [
      # "irqpoll" # if enabled wifi doesn't work, if disabled I get "Disabling IRQ #9"
      # "acpi=noirq"
      "quiet"
      "udev.log_level=3"
      "sysrq_always_enabled=1"
    ];
    kernel.sysctl."kernel.sysrq" = 502;
    resumeDevice = "/dev/nvme0n1p2";
  };

  hardware.bluetooth.enable = true;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
