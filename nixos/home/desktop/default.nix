{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.desktop;
  # icon_theme = {
  #   name = "Papirus";
  #   package = pkgs.papirus-icon-theme;
  # };
  icon_theme = {
    name = "Tela";
    package = pkgs.tela-icon-theme;
  };
  # gtk_theme = {
  #   name = "Orchis-Yellow-Dark-Compact";
  #   package = pkgs.orchis-theme;
  # };
  gtk_theme = {
    name = "WhiteSur-Dark";
    package = pkgs.whitesur-gtk-theme;
  };
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
      hypridle
      hyprlock
      pyprland
      xwaylandvideobridge
      playerctl
      eww
      wl-clipboard
      sway-contrib.grimshot
      waybar
      nwg-look
      ydotool
      waypipe
    ];
    services = {
      swayosd.enable = true;
      gnome-keyring.enable = true;
    };
    wayland.windowManager.hyprland = {
      enable = true;
      # plugins = with pkgs.hyprlandPlugins; [hypr-dynamic-cursors];
      xwayland.enable = true;
      systemd.variables = ["--all"];
      extraConfig = "source=~/.config/dotfiles/nixos/home/desktop/hypr/hyprland.conf";
    };
    xdg.configFile."hypr/hypridle.conf".source = ./hypr/hypridle.conf;
    xdg.configFile."hypr/pyprland.toml".source = ./hypr/pyprland.toml;
    home.file.".mozilla/firefox/default/chrome/userChrome.css".text = ''@import url("/home/adri/.config/dotfiles/nixos/home/desktop/firefox/userChrome.css");'';
    xdg.portal = {
      enable = true;
      # xdgOpenUsePortal = true;
      config.common.default = ["hyprland"];
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
      ];
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
    programs = {
      mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          modernx-zydezu
        ];
      };
      swaylock = {
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
    };
    xdg.configFile."alacritty".source = ./alacritty;
    xdg.configFile."waybar".source = ./waybar;
    xdg.configFile."mpv".source = ./mpv;
    gtk = {
      enable = true;
      iconTheme = icon_theme;
      theme = gtk_theme;
      cursorTheme = {
        name = "Phinger Cursors";
        package = pkgs.phinger-cursors;
      };
      gtk3.extraConfig = {
        gtk-decoration-layout = "menu:";
        gtk-application-prefer-dark-theme = true;
      };
    };
    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style = gtk_theme;
    };
    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = gtk_theme.name;
          cursor-theme = "Phinger Cursors";
          icon-theme = icon_theme.name;
        };
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };
    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.phinger-cursors;
      name = "Phinger Cursors";
      size = 16;
    };
    home.sessionVariables.GTK_THEME = gtk_theme.name;
    home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors-dark";
    home.file.".themes".source = "${gtk_theme.package}/share/themes";
  };
}
