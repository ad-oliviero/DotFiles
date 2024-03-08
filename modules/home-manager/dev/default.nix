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
    ./nvchad
    ./git.nix
  ];
  config = lib.mkIf cfg.enable {
    nvchad.enable = true;
    git.enable = true;
    # packages used for all kinds of development environments
    home.packages = with pkgs; [
      git
      neovim
      vscodium
      ghidra
      curl
      wget
      zip
      unzip
      apktool
      apksigner
      openjdk
      gnumake
      gcc
      android-tools
      python313
      android-studio
      # unstable.androidenv.androidPkgs_9_0.platform-tools
    ];
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
