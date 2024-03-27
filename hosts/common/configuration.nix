{
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: {
  # garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;
  documentation.dev.enable = true;
  systemd.services.ydotoold.enable = true;
  services = {
    fwupd.enable = true;
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
    getty.autologinUser = "adri";
    # xserver = {
    #   enable = false;
    #   windowManager.hypr.enable = true;
    #   displayManager.sessionPackages = [pkgs.hyprland];
    #   displayManager.defaultSession = "hyprland";
    #   displayManager.lightdm = {
    #     enable = true;
    #     greeters.tiny = {
    #       enable = true;
    #     };
    #     # greeter = let
    #     #   nody_greeter = import ../../pkgs/nody-greeter {inherit pkgs;};
    #     # in {
    #     #   package = nody_greeter;
    #     #   name = "nody-greeter";
    #     # };
    #   };
    # };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  programs.virt-manager.enable = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Rome";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit.enable = true;
    pam.services.swaylock = {};
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    uwufetch
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
    swayosd
    fd
    unzip
  ];

  users.users.adri = {
    isNormalUser = true;
    initialPassword = "1";
    extraGroups = ["wheel" "video" "networkmanager" "libvirtd" "adbusers" "docker"];
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCAFcsKYreVcas0Kz94oWSBjgQVtyu3ENR3OV++YRTS adri@adri-lap"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7AhdlGxd4A8aZgAyvJiJ9y8Gw62bsf2m11RiLiJidw adri@adri-desk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuMW3O5BOOpTPUzPBrmloAP1mjw8SCnOaVdNVcyJoIl u0_a456@localhost"
    ];
  };
  users.defaultUserShell = pkgs.zsh;
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.adri = import ../../home;
  };
  programs = {
    hyprland.enable = true;
    zsh.enable = true;
  };

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

  system.stateVersion = "23.11";
}
