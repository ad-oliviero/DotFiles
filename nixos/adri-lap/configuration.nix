{...}: {
  imports = [
    ../adri-common/configuration.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "adri-lap";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;

  console.keyMap = "it";

  services = {
    syncthing = {
      enable = true;
      user = "adri";
      dataDir = "/home/adri/Sync";
      openDefaultPorts = true;
    };
  };

  environment = {
    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  system.stateVersion = "24.05";
}
