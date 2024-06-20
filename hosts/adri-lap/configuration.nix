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
  hardware.opengl.enable = true;
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

  # wireguard
  networking.firewall.allowedTCPPorts = [22000];
  networking.wg-quick.interfaces = {
    wg0 = {
      address = ["10.8.0.3/24"];
      dns = ["10.8.1.1"];
      privateKeyFile = "/root/wg-keys/private";

      peers = [
        {
          publicKey = "iL120oCtcu85jqjLn48VtI/XEAMtB2fZhVmzQLtAuVc=";
          presharedKeyFile = "/root/wg-keys/preshared";
          allowedIPs = ["192.168.1.0/24" "10.8.0.0/24" "10.8.1.0/24"];
          endpoint = "olivierohome.ddns.net:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
  system.stateVersion = "23.11";
}
