{
  lib,
  config,
  ...
}: let
  cfg = config.scripts;
in {
  options.scripts = {
    enable = lib.mkEnableOption "enable scripts module";
  };
  config = lib.mkIf cfg.enable {
    home.file.".local/bin/cpg".source = ../scripts/cpg;

    home.sessionVariables = {
      PATH = "$PATH:/home/adri/.local/bin/";
    };
  };
}
