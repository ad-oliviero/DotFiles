{
  lib,
  config,
  ...
}: let
  cfg = config.module_name;
in {
  options = {
    module_name.enable = lib.mkEnableOption "Enable module_name";
  };
  config = lib.mkIf cfg.enable {
    # content
  };
}
