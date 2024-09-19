{pkgs, ...}: {
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  imports = [
    ./desktop
    ./nvim.nix
    ./zsh.nix
  ];
  desktop.enable = true;
  nvim.enable = true;
  zsh.enable = true;
  home.packages = with pkgs; [
    alacritty
    bitwarden
    discord
    firefox
    gnome.gnome-control-center
    heroic
    moonlight-qt
    notion-app-enhanced
    obs-studio
    obsidian
    remmina
    telegram-desktop
    tor-browser
    universal-android-debloater
    overskride
    swaynotificationcenter
    cliphist
    libnotify
    jq
    socat
    xdg-desktop-portal-hyprland
  ];
  programs.vscode.enable = true;
  home.sessionVariables = {
    BROWSER = "firefox";
    EDITOR = "nvim";
    GDK_BACKEND = "wayland,x11";
    GIT_EDITOR = "nvim";
    GTK2_RC_FILES = "/home/adri/.gtkrc-2.0";
    GTK_BACKEND = "wayland,x11";
    GTK_THEME = "Gruvbox-Dark-B";
    IMAGE = "imv";
    PATH = "$PATH:/home/adri/.local/bin/";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    TERMINAL = "alacritty";
    VIDEO = "mpv";
    VISUAL = "nvim";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };
}
