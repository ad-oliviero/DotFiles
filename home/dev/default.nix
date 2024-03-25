{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.dev;
in {
  options.dev = {
    enable = lib.mkEnableOption "enable dev module";
  };
  imports = [
    ./nvim
    ./git.nix
    ./scripts.nix
  ];
  config = lib.mkIf cfg.enable {
    nvim.enable = true;
    git.enable = true;
    scripts.enable = true;
    home.sessionVariables = {
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
      # JAVA_HOME = "/usr/lib/jvm/java-20-openjdk";
      # PICO_SDK_PATH = "/usr/share/pico-sdk";
      # PATH = "$PATH:$JAVA_HOME/bin:$HOME/.local/bin:/opt/flutter/bin:$HOME/.pub-cache/bin";
      # ANDROID_HOME = "$HOME/Android/Sdk";
      # XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/local/share:/usr/share:$HOME/.local/share/flatpak/exports/share";
    };
  };
}
