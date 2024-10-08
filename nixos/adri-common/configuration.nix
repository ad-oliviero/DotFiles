{pkgs, inputs, ...}: {
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

  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  time.timeZone = "Europe/Rome";
  i18n.defaultLocale = "en_US.UTF-8";

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

    # greetd.enable = true;

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
  };

  security.pam.enableEcryptfs = true;

  users.users.adri = {
    isNormalUser = true;
    extraGroups = ["wheel" "kvm"];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    curl
    duf
    ecryptfs
    eza
    git
    nh
    nix-output-monitor
    iptables
    inputs.zen-browser.packages."${system}".specific
  ];
  programs = {
    adb.enable = true;
    hyprland.enable = true;
    firejail.enable = true;
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
      nerdfonts
    ];
  };

  environment.pathsToLink = ["/share/zsh"];
}
