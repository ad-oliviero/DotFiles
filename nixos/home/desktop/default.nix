{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktop;
in {
  imports = [
    ./rofi.nix
    ./wlogout.nix
  ];
  options = {
    desktop.enable = lib.mkEnableOption "Enable desktop";
  };
  config = lib.mkIf cfg.enable {
    rofi.enable = true;
    wlogout.enable = true;
    home.packages = with pkgs; [
      hyprpaper
      hyprshade
      pyprland
      xwaylandvideobridge
      playerctl
      eww
      wl-clipboard
      sway-contrib.grimshot
      swayidle
      waybar
      nwg-look
      ydotool
      waypipe
    ];
    services.swayosd.enable = true;
    services.swayidle = {
      enable = true;
      events = [
        {
          event = "before-sleep";
          command = "/bin/env loginctl lock-session $XDG_SESSION_ID";
        }
        {
          event = "lock";
          command = "${pkgs.playerctl}/bin/playerctl -a pause; ${pkgs.swaylock}/bin/swaylock";
        }
      ];
    };
    wayland.windowManager.hyprland = {
      enable = true;
      plugins = with pkgs.hyprlandPlugins; [
        hypr-dynamic-cursors
        hyprtrails
        # hyprspace
        hyprfocus
        hyprexpo
      ];
      xwayland.enable = true;
      systemd.variables = [ "--all" ];
      extraConfig = "source=~/.config/dotfiles/nixos/home/desktop/hypr/hyprland.hl";
    };

    services.mako = {
      enable = true;
      maxVisible = 3;
      sort = "+time";

      layer = "top";
      anchor = "top-right";

      font = "JetBrains Mono";
      backgroundColor = "#282828";
      textColor = "#dfbf8e";
      width = 300;
      height = 100;
      margin = "10";
      padding = "5";
      borderSize = 2;
      borderColor = "#d65d0e";
      borderRadius = 0;
      progressColor = "over #5588AAFF";
      icons = true;
      maxIconSize = 64;

      markup = true;
      actions = true;
      format = "<b>%s</b>\\n%b";
      defaultTimeout = 5000;
      ignoreTimeout = false;
    };
    programs.swaylock = {
      enable = true;
      package = pkgs.swaylock-effects;
      settings = {
        "bs-hl-color" = "cc241d";
        "caps-lock-bs-hl-color" = "ee2e24FF";
        "caps-lock-key-hl-color" = "ffd204FF";
        "clock" = true;
        "datestr" = "%a, %e %B";
        "disable-caps-lock-text" = true;
        "effect-blur" = "10x5";
        "fade-in" = "0.3";
        "font" = "JetBrains Mono";
        "font-size" = "32";
        "indicator" = true;
        "indicator-caps-lock" = true;
        "indicator-radius" = "150";
        "indicator-thickness" = "30";
        "inside-caps-lock-color" = "009ddc00";
        "inside-clear-color" = "076678";
        "inside-color" = "076678";
        "inside-ver-color" = "282828";
        "inside-wrong-color" = "cc241d";
        "key-hl-color" = "076678";
        "line-caps-lock-color" = "009ddcFF";
        "line-clear-color" = "ffd204FF";
        "line-color" = "076678";
        "line-ver-color" = "076678";
        "line-wrong-color" = "cc241d";
        "no-unlock-indicator" = true;
        "ring-caps-lock-color" = "231f20D9";
        "ring-clear-color" = "cc241d";
        "ring-color" = "282828";
        "ring-ver-color" = "282828";
        "ring-wrong-color" = "cc241d";
        "screenshots" = true;
        "separator-color" = "076678";
        "text-caps-lock-color" = "009ddc";
        "text-clear-color" = "dfbf8e";
        "text-ver-color" = "dfbf8e";
        "text-wrong-color" = "ee2e2400";
        "timestr" = "%r";
      };
    };
    gtk = {
      enable = true;
      iconTheme = {
        name = "WhiteSur";
        package = pkgs.whitesur-icon-theme;
      };
      theme = {
        name = "WhiteSur-Dark";
        package = pkgs.whitesur-gtk-theme;
      };
      cursorTheme = {
        name = "Phinger Cursors";
        package = pkgs.phinger-cursors;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "WhiteSur-Dark";
        cursor-theme = "Phinger Cursors";
        icon-theme = "WhiteSur";
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
    home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-dark";
    home.file.".themes".source = "${pkgs.gruvbox-gtk-theme}/share/themes";
    xdg.configFile."alacritty".source = ./alacritty;
    xdg.configFile."waybar".source = ./waybar;
  };
}
