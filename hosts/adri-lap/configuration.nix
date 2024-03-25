{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];
  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
  ];
  powerManagement.enable = true;

  networking.hostName = "adri-lap";
  console.keyMap = "it";

  security = {
    rtkit.enable = true;
    pam.services.swaylock = {};
  };

  environment.systemPackages = with pkgs; [
    # fprintd
    # light
    pciutils
  ];

  # services.fprintd.enable = true;
  programs.light.enable = true;

  system.stateVersion = "23.11";
}
