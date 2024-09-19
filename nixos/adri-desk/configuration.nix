{...}: {
  imports = [
    ../adri-common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "adri-desk";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  console.keyMap = "us";

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  system.stateVersion = "24.05";
}
