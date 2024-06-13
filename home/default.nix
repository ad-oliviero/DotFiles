{pkgs, ...}: {
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "23.11";
  imports = [
    ./desktop
    ./dev
    ./zathura.nix
    ./zsh.nix
  ];
  desktop.enable = true;
  dev.enable = true;
  zathura.enable = true;
  zsh.enable = true;

  fonts.fontconfig.enable = true;
  # TODO: move packages to their modules (if possible)
  home.packages = with pkgs; [
    # discord-x11
    alacritty
    android-studio
    bitwarden
    eza
    firefox
    gnome.adwaita-icon-theme
    gnome.nautilus
    gnomeExtensions.appindicator
    gruvbox-gtk-theme
    helvetica-neue-lt-std
    hyprpaper
    hyprshade
    ifwifi
    imagemagick
    imv
    inkscape
    jetbrains-mono
    libnotify
    libreoffice
    mako
    mpv
    nerdfonts
    nurl # get "fetchFromGitHub" configurations
    nwg-look # just to take a look at themes, not to change them
    papermc
    playerctl
    prismlauncher
    pyprland
    starship
    sway-contrib.grimshot
    swayidle
    swaylock-effects
    telegram-desktop
    unstable.discord
    waybar
    wl-clipboard
    wlogout
    xwaylandvideobridge

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.sessionVariables = {
    GIT_EDITOR = "nvim";
    EDITOR = "nvim";
    VISUAL = "nvim";
    GDK_BACKEND = "wayland,x11";
    GTK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    GTK_THEME = "Gruvbox-Dark-B";

    TERMINAL = "alacritty";
    BROWSER = "firefox";
    VIDEO = "mpv";
    IMAGE = "imv";
  };

  programs.home-manager.enable = true;
}
