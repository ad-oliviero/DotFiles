{
  lib,
  config,
  ...
}: let
  cfg = config.hypr;
in {
  options.hypr = {
    enable = lib.mkEnableOption "enable hypr module";
  };
  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      extraConfig = "source=~/.config/dotfiles/home/desktop/hypr/hypr.conf";
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload=~/Pictures/wallpaper.jpg
      wallpaper=eDP-1,~/Pictures/wallpaper.jpg
      wallpaper=HDMI-A-1,~/Pictures/wallpaper.jpg
      wallpaper=HDMI-A-2,~/Pictures/wallpaper.jpg
      ipc = off
    '';
    home.file.".local/bin/hypr_batsave".source = ../../scripts/hypr_batsave;
  };
}
