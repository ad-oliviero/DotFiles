{pkgs, ...}: {
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "24.05";
  # home.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

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
    gnumake
    texlive.combined.scheme-full

    alacritty
    android-studio
    bitwarden
    bottles
    cliphist
    czkawka
    discord
    firefox
    gnome-control-center
    heroic
    jq
    libnotify
    moonlight-qt
    notion-app-enhanced
    obs-studio
    obsidian
    overskride
    remmina
    rnote
    socat
    stress
    swaynotificationcenter
    telegram-desktop
    tor-browser
    universal-android-debloater
  ];
  programs.vscode.enable = true;
  home.sessionVariables = {
    FLAKE = "/home/adri/.config/dotfiles/nixos";
    BROWSER = "firefox";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
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
