{ lib, config, pkgs, ... }:
let
  cfg = config.swaylock;
in
{
  options.swaylock = {
    enable = lib.mkEnableOption "enable swaylock module";
  };
  config = lib.mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        "font" = "JetBrains Mono";
        "font-size" = "32";
        
        "no-unlock-indicator" = true;
        "clock" = true;
        "timestr" = "%r";
        "datestr" = "%a, %e %B";
        "screenshots" = true;
        "fade-in" = "0.7";
        "effect-blur" = "10x5";
        
        "indicator" = true;
        "indicator-radius" = "150";
        "indicator-thickness" = "30";
        "indicator-caps-lock" = true;
        
        "key-hl-color" = "076678";
        
        "separator-color" = "076678";
        
        "inside-color" = "076678";
        "inside-clear-color" = "076678";
        "inside-caps-lock-color" = "009ddc00";
        "inside-ver-color" = "282828";
        "inside-wrong-color" = "cc241d";
        
        "ring-color" = "282828";
        "ring-clear-color" = "cc241d";
        "ring-caps-lock-color" = "231f20D9";
        "ring-ver-color" = "282828";
        "ring-wrong-color" = "cc241d";
        
        "line-color" = "076678";
        "line-clear-color" = "ffd204FF";
        "line-caps-lock-color" = "009ddcFF";
        "line-ver-color" = "076678";
        "line-wrong-color" = "cc241d";
        
        "text-clear-color" = "dfbf8e";
        "text-ver-color" = "dfbf8e";
        "text-wrong-color" = "ee2e2400";
        
        "bs-hl-color" = "cc241d";
        "caps-lock-key-hl-color" = "ffd204FF";
        "caps-lock-bs-hl-color" = "ee2e24FF";
        "disable-caps-lock-text" = true;
        "text-caps-lock-color" = "009ddc";

      };
    };
  };
}
