      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libvdpau-va-gl
        vpl-gpu-rt
      ];
    };
    i2c.enable = true;
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "i915.enable_guc=2"
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "usbcore.autosuspend=-1"
    ];
  swapDevices = [{device = "/swap/file";}];
