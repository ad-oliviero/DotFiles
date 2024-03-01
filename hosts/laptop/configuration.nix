{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
  ];
  nixpkgs = {
    overlays = [
      outputs.overlays.unstable-packages
    ];
    config.allowUnfree = true;
  };
  # Additional hardware configurations
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # GPU
  boot.initrd.kernelModules = [
    "i915"
    "acpi_call"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  boot.consoleLogLevel = 3;
  boot.kernelParams = [
    # "irqpoll"
    "quiet"
    "udev.log_level=3"
    "sysrq_always_enabled=1"
    "resume_offset=201912320"
  ];
  boot.resumeDevice = "/dev/nvme0n1p2";
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.opengl.extraPackages = with pkgs; [
    (if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11") then vaapiIntel else intel-vaapi-driver)
    libvdpau-va-gl
    intel-media-driver
  ];
  powerManagement.enable = true;
  services = {
    fstrim.enable = lib.mkDefault true;
    tlp.enable = true;
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
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
    thermald.enable = true;
    # tlp
  };

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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # nix search package_name
  environment.systemPackages = with pkgs; [
    git
    neovim
    uwufetch
    fprintd
    light
    curl
    zsh
    gnumake
    gcc
    android-tools
    phinger-cursors
    gnome.gnome-control-center
    gnome.gnome-bluetooth
    gammastep
  ];

  users.users.adri = {
    isNormalUser = true;
    initialPassword = "1";
    extraGroups = [ "wheel" "video" "networkmanager" ];
    shell = pkgs.zsh;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
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

