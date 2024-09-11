{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.rofi;
in {
  options = {
    rofi.enable = lib.mkEnableOption "Enable rofi";
  };
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      plugins = with pkgs; [
        rofi-calc
        rofi-emoji-wayland
        rofi-rbw
      ];
    };
    xdg.configFile."rofi".source = ./rofi;
  };
}
