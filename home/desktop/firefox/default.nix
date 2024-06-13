{
  lib,
  config,
  ...
}: let
  cfg = config.firefox;
in {
  options.firefox = {
    enable = lib.mkEnableOption "enable firefox module";
  };
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default = {
        name = "Default";
        userChrome = "@import url(\"/home/adri/.config/dotfiles/home/desktop/firefox/userChrome.css\");";
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "layers.acceleration.force-enabled" = true;
          "gfx.webrender.all" = true;
          "gfx.webrender.enabled" = true;
          "layout.css.backdrop-filter.enabled" = true;
          "svg.context-properties.content.enabled" = true;
          "widget.gtk.ignore-bogus-leave-notify" = 1;
          "ui.key.menuAccessKeyFocuses" = false;
          "browser.tabs.drawInTitlebar" = true;
        };
      };
    };
  };
}
