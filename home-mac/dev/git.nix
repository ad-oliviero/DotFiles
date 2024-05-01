{
  lib,
  config,
  ...
}: let
  cfg = config.git;
in {
  options.git = {
    enable = lib.mkEnableOption "enable git module";
  };
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "ad.oliviero";
      userEmail = "adrianoliviero23@gmail.com";
    };
  };
}
