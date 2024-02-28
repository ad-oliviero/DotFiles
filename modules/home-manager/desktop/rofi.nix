{ lib, config, pkgs, ... }:
let
  cfg = config.rofi;
in
{
  options.rofi = {
    enable = lib.mkEnableOption "enable rofi module";
  };
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      extraConfig = {
        threads = 4;
        show-icons = true;
        drun-display-format = "{name}";
        disable-history = false;
        sidebar-mode = false;
        hide-scrollbar = true;
        scroll-method = 1;
        display-drun = "";
      };
    };
    home.file.".config/rofi/themes/custom.rasi".text = ''
      * {
        background-color: transparent;
        color: #dfbf8e;
        font: "JetBrains Mono 15";
      }
      
      window {
        background-color: #282828;
        padding: 10px;
        width: 20%;
        height: 40%;
        border-radius: 10px;
      }
      
      inputbar {
        children: [prompt, entry];
      }
      
      prompt {
        border: 0;
      }
      
      entry {
        border-radius: 10px;
        padding: 10px;
        border: 1px;
        border-color: #dfbf8e;
      }
      
      listview {
        columns: 1;
        margin: 10 0 0 0;
        lines: 4;
        layout: vertical;
        dynamic: false;
      }
      
      element {
        border-radius: 10;
        orientation: horizontal;
      }
      
      element-text {
        expand: true;
        horizontal-align: 0.5;
        vertical-align: 0.5;
      }
      
      element-icon {
        size: 24px;
        padding: 16px;
      }
      
      element.selected {
        background-color: #8d5050;
      }
    '';
    };
}
