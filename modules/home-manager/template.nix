{ lib, config, pkgs, ... }:
let
  cfg = config.modname;
in
{
  options.modname = {
    enable = lib.mkEnableOption "enable modname module";
  };
  config = lib.mkIf cfg.enable {
  };
}
