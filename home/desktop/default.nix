{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.desktop;
in {
  options.desktop = {
    enable = lib.mkEnableOption "enable desktop module";
  };
  imports = [
    ./alacritty
    ./firefox
    ./hypr
    ./mako.nix
    ./rofi.nix
    ./swaylock.nix
    ./waybar
    ./wlogout.nix
  ];
  config = lib.mkIf cfg.enable {
    alacritty.enable = true;
    firefox.enable = true;
    hypr.enable = true;
    mako.enable = true;
    rofi.enable = true;
    swaylock.enable = true;
    waybar.enable = true;
    wlogout.enable = true;

    services.swayosd.enable = true;
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
      # theme = {
      #   name = "Gruvbox-Dark-B";
      #   package = pkgs.gruvbox-gtk-theme;
      # };
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
  };
}
