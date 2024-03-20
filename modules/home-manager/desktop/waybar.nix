{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.waybar;
in {
  options.waybar = {
    enable = lib.mkEnableOption "enable waybar module";
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/waybar/config".text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 45,
        "modules-left": ["hyprland/workspaces", "hyprland/window"],
        "modules-center": ["clock"],
        "modules-right": ["network", "disk", "memory", "cpu", "tray", "battery", "idle_inhibitor", "pulseaudio"],
        "clock": {
          "interval": 1,
          "format": "{:%a %e %b %Y, %I:%M:%S %p %Z}"
        },
        "cpu": {
          "format": "{usage}%  ",
          "tooltip": false
        },
        "disk": {
          "interval": 30,
          "path": "/home",
          "format": "{free}  "
        },
        "memory": {
          "interval": 5,
          "format": "{used:0.2f}GB  ",
          "tooltip-format": "available {avail:0.2f}GB"
        },
        "idle_inhibitor": {
          "format": "{icon}",
          "format-icons": {
            "activated": "󱐋",
            "deactivated": "󰂏"
          },
          "tooltip-format-activated": "Performance mode",
          "tooltip-format-deactivated": "Power saving",
          "on-click": "~/.local/bin/hypr_batsave",
          "start-activated": false
        },
        "network": {
          "interval": 3,
          "format-wifi": "{ipaddr} 󰖩 ",
          "format-ethernet": "{ipaddr} 󰈀 ",
          "format-disconnected": "Disconnected ⚠ ",
          "on-click": "alacritty -e nmtui"
        },
        "pulseaudio": {
          "format": "{icon} {volume}% {format_source}",
          "format-muted": "󰖁 {format_source}",
          "format-source": "",
          "format-source-muted": "",
          "scroll-step": 5,
          "format-bluetooth": "󰂱 {icon} {volume}% {format_source}",
          "format-icons": ["󰕿", "󰖀", "󰕾"],
          "on-click-right": "helvum",
          "on-click": "wpctl set-mute @DEFAULT_SINK@ toggle"
        },
        "battery": {
          "interval": 2,
          "states": {
            "warning": 30,
            "critical": 20
          },
          "format": "{capacity} {icon}",
          "format-icons": [" ", " ", " ", " ", " "],
          "format-charging": "{capacity} {icon}",
          "max-length": 25
        },
        "sway/workspaces": {
          "format": "{name}",
          "disable-scroll-wraparound": true
        },
        "wlr/workspaces": {
          "format": "{name}",
          "disable-scroll-wraparound": true,
          "on-click": "activate",
          "sort-by-number": true,
          "sort-by-name": false
        }
      }
    '';
    home.file.".config/waybar/style.css".text = ''
      * {
        border: none;
        font-family: JetBrains Mono, Symbols Nerd Font;
        font-size: 15px;
        transition: 0.8s;
        color: #fbf1c7;
      }

      #waybar, #tray menu {
        background: #282828;
      }

      #workspaces {
        margin: 0px 8px;
      }

      #workspaces button.focused,
      #workspaces button.active,
      #workspaces button:hover {
        background: #458588;
      }

      #battery.critical,
      #workspaces button.urgent,
      #idle_inhibitor.deactivated,
      #pulseaudio.muted {
        background: #cc241d;
      }

      #battery.charging {
        background: #689d6a;
      }

      #battery.warning {
        background: #d79921;
      }

      #clock,
      #battery,
      #cpu,
      #disk,
      #memory,
      #idle_inhibitor,
      #network,
      #pulseaudio,
      #tray,
      #date,
      #idle_inhibitor,
      #battery,
      #workspaces button {
        padding: 3px 8px 2px;
        margin: 8px 4px;
        background: #076678;
        border-radius: 8px;
        box-shadow: inset 0px 0px 2px 2px #282828;
      }
    '';
  };
}
