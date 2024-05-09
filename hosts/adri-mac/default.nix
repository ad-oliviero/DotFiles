{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    #./system.nix
    #./packages.nix
    #./fonts.nix
    #./brew.nix
  ];
  users.users.user.home = "/Users/adrianooliviero";
  #networking.computerName = "MacBook-Pro-110.local";
  #networking.localHostName = "MacBook-Pro-110.local";

  # garbage collection
  nix.gc = {
    automatic = true;
    #interval = "weekly";
    options = "--delete-older-than 1w";
  };
  nix.settings.auto-optimise-store = true;
  services = {
    nix-daemon.enable = true; # Auto-Upgrade Daemon
  };
  programs = {
    zsh.enable = true;
  };

  time.timeZone = "Europe/Rome";

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages = with pkgs; [
    uwufetch
    tree
    man-pages
    man-pages-posix
    nmap
    fd
    unzip
  ];

  users.users.adrianooliviero = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDCAFcsKYreVcas0Kz94oWSBjgQVtyu3ENR3OV++YRTS adri@adri-lap"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7AhdlGxd4A8aZgAyvJiJ9y8Gw62bsf2m11RiLiJidw adri@adri-desk"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuMW3O5BOOpTPUzPBrmloAP1mjw8SCnOaVdNVcyJoIl u0_a456@localhost"
    ];
  };
  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users.adrianooliviero = import ../../home-mac;
  };
}
