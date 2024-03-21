{
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../common/configuration.nix
  ];
  boot.kernelParams = [
    # "resume_offset=201912320"
  ];
  # environment.variables = {
  #   VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  # };
  # hardware.opengl.extraPackages = with pkgs; [
  #   (
  #     if (lib.versionOlder (lib.versions.majorMinor lib.version) "23.11")
  #     then vaapiIntel
  #     else intel-vaapi-driver
  #   )
  #   libvdpau-va-gl
  #   intel-media-driver
  # ];

  networking.hostName = "adri-desk";

  time.timeZone = "Europe/Rome";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # nix search package_name
  environment.systemPackages = with pkgs; [
    steam
  ];

  programs = {
    steam.enable = true;
  };

  system.stateVersion = "23.11";
}
