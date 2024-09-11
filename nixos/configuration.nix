{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  home-manager.backupFileExtension = "backup";

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
    libinput.enable = true;
    openssh.enable = true;
    printing.enable = true;
    zram-generator.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = ["/"];
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # syncthing = {
    #   enable = true;
    #   user = "adri";
    # };

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
            detached = [ "setsid steam steam =//open/bigpicture"];
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

  security.pam.enableEcryptfs = true;

  users.users.adri = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    curl
    ecryptfs
    eza
    git
    duf
  ];
  programs = {
    adb.enable = true;
    hyprland.enable = true;
    ydotool.enable = true;
    zsh.enable = true;
  };


  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      jetbrains-mono
      nerdfonts
    ];
  };

  environment = {
    pathsToLink = ["/share/zsh"];
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  system.stateVersion = "24.05";
}
