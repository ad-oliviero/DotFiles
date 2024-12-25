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

      mpv = {
        enable = true;
        scripts = with pkgs.mpvScripts; [
          modernx-zydezu
        ];
      };
