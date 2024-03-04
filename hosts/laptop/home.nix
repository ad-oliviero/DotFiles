{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  imports = [
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/desktop
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/nvchad
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/zsh.nix
  ];
  alacritty.enable = true;
  desktop.enable = true;
  git.enable = true;
  nvchad.enable = true;
  zathura.enable = true;
  zsh.enable = true;

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 40.83;
    longitude = 14.34;
    temperature.day = 5700;
    temperature.night = 3600;
  };

  gtk = {
    enable = true;
    #iconTheme = {
    #  name = "";
    #  package = pkgs.;
    #};
    theme = {
      name = "Gruvbox-Dark-B";
      package = pkgs.gruvbox-gtk-theme;
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
      gtk-theme = "Gruvbox-Dark-B";
      cursor-theme = "Phinger Cursors";
      #icon-theme = "";
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  home.file.".themes".source = "${pkgs.gruvbox-gtk-theme}/share/themes";
  fonts.fontconfig.enable = true;

  # TODO: move packages to their modules (if possible)
  home.packages = with pkgs; [
    alacritty
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
    firefox
    mako
    libnotify
    waybar
    wlogout
    bitwarden
    telegram-desktop
    jetbrains-mono
    helvetica-neue-lt-std
    nerdfonts
    ifwifi
    wl-clipboard
    starship
    eza
    hyprpaper
    wlogout
    swaylock-effects
    swayidle
    zathura
    imv
    mpv
    gnome.nautilus
    xwaylandvideobridge
    #rofi # for some reason if this package is installed you can't use plugins as there are some conflicts
    rofi-calc
    rofi-emoji
    rofi-rbw
    sway-contrib.grimshot
    playerctl
    imagemagick
    libreoffice
    inkscape
    discord
    gruvbox-gtk-theme
    nwg-look # just to take a look at themes, not to change them
    vscodium
    ghidra
    nurl # get "fetchFromGitHub" configurations

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.sessionVariables = rec {
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
    # OPENER = "xdg-open";

    # JAVA_HOME = "/usr/lib/jvm/java-20-openjdk";
    # PICO_SDK_PATH = "/usr/share/pico-sdk";
    # PATH = "$PATH:$JAVA_HOME/bin:$HOME/.local/bin:/opt/flutter/bin:$HOME/.pub-cache/bin";
    # ANDROID_HOME = "$HOME/Android/Sdk";
    # XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/local/share:/usr/share:$HOME/.local/share/flatpak/exports/share";
  };

  programs.home-manager.enable = true;
}
