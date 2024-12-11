{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  documentation = {
    dev.enable = true;
    man.generateCaches = true;
    nixos.includeAllModules = true;
  };

  networking.hostName = "adri-lap";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "it";

  services = {
    syncthing = {
      enable = true;
      user = "adri";
      dataDir = "/home/adri/Sync";
      openDefaultPorts = true;
    };
    libinput.enable = true;
    openssh.enable = true;
    printing.enable = true;
    zram-generator.enable = true;

    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="0925", ATTR{idProduct}=="3881", MODE="0666", GROUP="wheel"
    '';

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    greetd = {
      enable = true;
      restart = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "adri";
        };
        default_session = initial_session;
      };
    };
    displayManager = {
      autoLogin = {
        enable = true;
        user = "adri";
      };
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

    udisks2 = {
      enable = true;
      mountOnMedia = true;
    };
  };

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      storageDriver = "btrfs";
      rootless.setSocketVariable = true;
    };
  };

  security.pam.enableEcryptfs = true;

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  users.users.adri = {
    isNormalUser = true;
    extraGroups = ["wheel" "kvm" "networkmanager" "docker" "dialout"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKoy1RDMy50qUm3+MdWdvkUQKFoA2AR1UM9dvdtI19Y+ adri@adri-lap
"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIeraJiTtn4DbCnDLKSOE1YKE20uAOb910v7+nk7de8Y adri@adri-rpi"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSmXsZj3qCS1DRSwpc5KZag+/vH0Bw16UobsUNbAT/z u0_a262@localhost"
    ];
    shell = pkgs.zsh;
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
    adb.enable = true;
    hyprland.enable = true;
    firejail.enable = true;
    steam.enable = true;
    regreet = {
      enable = false;
      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };
      cursorTheme = {
        name = "Phinger Cursors";
        package = pkgs.phinger-cursors;
      };
      font = {
        name = "JetBrains Mono 16";
        package = pkgs.jetbrains-mono;
      };
      settings = {
        GTK.application_prefer_dark_theme = true;
        appearance.greeting_msg = "Oh non toccare sto computer, via da qui!";
      };
    };
    ydotool.enable = true;
    zsh.enable = true;
  };

  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };

  networking.firewall.enable = true;

  environment.pathsToLink = ["/share/zsh"];

  system.stateVersion = "24.05";
}
