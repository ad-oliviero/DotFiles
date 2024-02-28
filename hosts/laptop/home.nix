{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  home.username = "adri";
  home.homeDirectory = "/home/adri";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  imports = [
    ../../modules/home-manager/alacritty.nix
    ../../modules/home-manager/desktop/default.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/zsh.nix
  ];
  alacritty.enable = true;
  desktop.enable = true;
  git.enable = true;
  zsh.enable = true;

  home.file.".icons/default".source = "${pkgs.phinger-cursors}/share/icons/phinger-cursors";
  fonts.fontconfig.enable = true;

  # TODO: move packages to their modules (if possible)
  home.packages = with pkgs; [
    alacritty
    gnome.gnome-control-center
    firefox
    mako
    libnotify
    waybar
    rofi
    wlogout
    bitwarden
    telegram-desktop
    jetbrains-mono
    nerdfonts
    ifwifi
    gnome.adwaita-icon-theme
    wl-clipboard
    starship
    eza
    hyprpaper
    wlogout
    swaylock-effects

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
  };

  programs.home-manager.enable = true;
}
