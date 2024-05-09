{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = lib.mkEnableOption "enable desktop module";
  };
  imports = [
    ./alacritty.nix
    #./hypr.nix
    #./mako.nix
    #./rofi.nix
    #./swaylock.nix
    #./waybar.nix
    #./wlogout.nix
  ];
  
  config = lib.mkIf cfg.enable {
    alacritty.enable = true;
    #hypr.enable = true;
    #mako.enable = true;
    #rofi.enable = true;
    #swaylock.enable = true;
    #waybar.enable = true;
    #wlogout.enable = true;
  };
}
