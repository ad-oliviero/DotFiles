{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];
  networking.hostName = "adri-desk";

  time.timeZone = "Europe/Rome";

  hardware.opengl.extraPackages = with pkgs; [
    rocmPackages.clr.icd
    amdvlk
    driversi686Linux.amdvlk
  ];

  environment.systemPackages = with pkgs; [
    steam
  ];

  programs = {
    steam.enable = true;
  };

  system.stateVersion = "23.11";
}
