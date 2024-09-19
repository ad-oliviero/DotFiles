{...}: {
  imports = [
    ../adri-common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "adri-lap";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  console.keyMap = "it";

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  system.stateVersion = "24.05";
}
