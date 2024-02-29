{ lib, config, pkgs, ... }:
let
  cfg = config.zathura;
in
{
  options.zathura = {
    enable = lib.mkEnableOption "enable zathura module";
  };
  config = lib.mkIf cfg.enable {
    programs.zathura = {
      enable = true;
      options = {
        # https://github.com/eastack/zathura-gruvbox/blob/master/zathura-gruvbox-dark
        notification-error-bg = "#282828";
        notification-error-fg = "#fb4934";
        notification-warning-bg = "#282828";
        notification-warning-fg = "#fabd2f";
        notification-bg = "#282828";
        notification-fg = "#b8bb26";

        completion-bg = "#504945";
        completion-fg = "#ebdbb2";
        completion-group-bg = "#3c3836";
        completion-group-fg = "#928374";
        completion-highlight-bg = "#83a598";
        completion-highlight-fg = "#504945";

        # Define the color in index mode;
        index-bg = "#504945";
        index-fg = "#ebdbb2";
        index-active-bg = "#83a598";
        index-active-fg = "#504945";

        inputbar-bg = "#282828";
        inputbar-fg = "#ebdbb2";

        statusbar-bg = "#504945";
        statusbar-fg = "#ebdbb2";

        highlight-color = "#fabd2f";
        highlight-active-color = "#fe8019";

        default-bg = "#282828";
        default-fg = "#ebdbb2";
        render-loading = true;
        render-loading-bg = "#282828";
        render-loading-fg = "#ebdbb2";

        # Recolor book content's color;
        recolor-lightcolor = "#282828";
        recolor-darkcolor = "#ebdbb2";
        recolor = true;
        recolor-keephue = true     ;

        font = "JetBrains Mono 12";
      };
    };
  };
}
