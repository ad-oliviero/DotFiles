{
  lib,
  config,
  ...
}: let
  cfg = config.waybar;
in {
  options.waybar = {
    enable = lib.mkEnableOption "enable waybar module";
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/waybar/config".source = config.lib.file.mkOutOfStoreSymlink ./config;
    home.file.".config/waybar/style.css".source = config.lib.file.mkOutOfStoreSymlink ./style.css;
  };
}
