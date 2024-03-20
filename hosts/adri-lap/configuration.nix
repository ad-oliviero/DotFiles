{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  # Additional hardware configurations
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # GPU
  boot.initrd.kernelModules = [
    "i915"
    "acpi_call"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    # "irqpoll" # if enabled wifi doesn't work, if disabled I get "Disabling IRQ #9"
    # "acpi=noirq"
    "quiet"
    "udev.log_level=3"
    "sysrq_always_enabled=1"
    "resume_offset=201912320"
  ];
  boot.kernel.sysctl."kernel.sysrq" = 502;
  boot.resumeDevice = "/dev/nvme0n1p2";
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.opengl.extraPackages = with pkgs; [
    (
      if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
      then vaapiIntel
      else intel-vaapi-driver
    )
    libvdpau-va-gl
    intel-media-driver
  ];
  powerManagement.enable = true;
  documentation.dev.enable = true;
  systemd.services.ydotoold.enable = true;
  services = {
    fwupd.enable=true;
    fstrim.enable = lib.mkDefault true;
    udev = {
      enable = true;
      packages = with pkgs; [
        android-udev-rules
      ];
    };
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
    blueman.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    thermald.enable = true;
    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
          scaling_max_freq = 400000;
        };
        charger = {
          governor = "performance";
          turbo = "always";
        };
      };
    };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  programs.virt-manager.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "adri-lap";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "it";
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  hardware.bluetooth.enable = true;

  # services.fprintd.enable = true;

  security.rtkit.enable = true;
  security.pam.services.swaylock = {};

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # nix search package_name
  environment.systemPackages = with pkgs; [
    uwufetch
    fprintd
    light
    zsh
    phinger-cursors
    gnome.gnome-control-center
    gnome.gnome-bluetooth
    gammastep
    blueman
    virt-manager
    ydotool
    file
    brlaser
    tree
    man-pages
    man-pages-posix
    nmap
    obs-studio
  ];

  users.users.adri = {
    isNormalUser = true;
    initialPassword = "1";
    extraGroups = ["wheel" "video" "networkmanager" "libvirtd" "adbusers" "docker"];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCAFcsKYreVcas0Kz94oWSBjgQVtyu3ENR3OV++YRTS adri@adri-lap"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuMW3O5BOOpTPUzPBrmloAP1mjw8SCnOaVdNVcyJoIl u0_a456@localhost"
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.adri = import ./home.nix;
  };
  programs.hyprland.enable = true;
  programs.zsh.enable = true;
  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "23.11";
}
