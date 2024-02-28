{ lib, config, pkgs, ... }:
let
  cfg = config.mako;
in
{
  options.mako = {
    enable = lib.mkEnableOption "enable mako module";
  };
  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      maxVisible = 3;
      sort = "+time";
      font = "JetBrains Mono";
      backgroundColor = "#282828";
      textColor = "#dfbf8e";
      borderSize = 2;
      borderColor = "#d65d0e";
      borderRadius = 0;
      defaultTimeout = 5000;
    };
  };
}
