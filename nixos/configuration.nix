    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666", GROUP="wheel"
    '';

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };

    sunshine = {
      enable = true;
      autoStart = true;
      openFirewall = true;
      capSysAdmin = true;
      applications = {
        env = {
          PATH = "$(PATH):$(HOME)/.local/bin";
        };
        apps = [
          {
            name = "Desktop";
            image-path = "desktop.png";
          }
          {
            name = "Steam Big Picture";
            detached = ["setsid steam steam =//open/bigpicture"];
            image-path = "steam.png";
          }
        ];
      };
      settings = {
        upnp = "enabled";
        address_family = "both";
        lan_encryption_mode = 2;
        wan_encryption_mode = 2;
      };
    };

  environment.systemPackages = with pkgs; [
    curl
    duf
    ecryptfs
    eza
    fd
    ripgrep
    dust
    git
    nh
    nix-output-monitor
    iptables

    libftdi
    i2c-tools
    flashrom
    ch341eeprom
    xxd
    smuview
    pulseview
    sigrok-cli
    sigrok-firmware-fx2lafw
  ];
  programs = {
    ydotool.enable = true;
  };

  networking.firewall.enable = true;
