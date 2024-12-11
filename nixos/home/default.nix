{pkgs, ...}: 
{
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "24.05";
  # home.backupFileExtension = "backup";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  # android-sdk.enable = true;

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
    texlive.combined.scheme-full
    texlab
    rubber

    arduino
    arduino-ide
    picocom

    alacritty
    android-studio-full
    bambu-studio
    bitwarden
    bluetui
    bmon
    bottles
    cliphist
    czkawka
    discord
    ffmpeg-full
    firefox
    floorp
    freecad-wayland
    geeqie
    gimp
    gnome-control-center
    gnumake
    gocryptfs
    heroic
    jq
    libnotify
    libsForQt5.plasma-workspace
    libudev-zero
    moonlight-qt
    nemo-with-extensions
    notion-app-enhanced
    obs-studio
    obsidian
    overskride
    openscad
    povray
    qalculate-gtk
    remmina
    rnote
    screen
    socat
    speedtest-cli
    stress
    swaynotificationcenter
    telegram-desktop
    tor-browser
    universal-android-debloater
    usbutils
    xournalpp
  ];
  programs = {
    vscode.enable = true;
    sioyek = {
      enable = true;
      config = {
        "check_for_updates_on_startup" = "0";
        "background_color" = "0.90 0.90 0.90";
        "dark_mode_background_color" = "0.28 0.28 0.28";
        "zoom_inc_factor" = "1.1";
        "should_launch_new_window" = "1";
        "should_launch_new_instance" = "1";
        # "should_draw_unrendered_pages" = "1";
        # "startup_commands" = "toggle_smooth_scroll_mode;";
        "wheel_zoom_on_cursor" = "1";
        "touchpad_sensitivity" = "1.1";
        "page_separator_width" = "2";
        "page_separator_color" = "0.9 0.9 0.9";
      };
      bindings = {
        "fit_to_page_width_smart" = "=";
        "close_window" = "q";
      };
    };
    ranger = {
      enable = true;
      settings = {
        confirm_on_delete = "always";
        vcs_aware = true;
        save_console_history = false;
        mouse_enabled = false;
        cd_tab_fuzzy = true;
      };
      mappings.O = "shell xdg-open '%f'";
    };
  };
  services = {
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
  home.sessionVariables = {
    FLAKE = "/home/adri/.config/dotfiles/nixos";
    BROWSER = "floorp";
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    GIT_EDITOR = "nvim";
    GTK2_RC_FILES = "/home/adri/.gtkrc-2.0";
    GTK_BACKEND = "wayland,x11";
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
