{
  lib,
  config,
  ...
}: let
  cfg = config.alacritty;
in {
  options.alacritty = {
    enable = lib.mkEnableOption "enable alacritty module";
  };
  config = lib.mkIf cfg.enable {
    home.file.".config/alacritty/alacritty.toml".text = ''
      live_config_reload = false
      import = ["~/.config/alacritty/colors.toml"]
      ipc_socket = true

      [env]
      TERM = "xterm-256color"

      [window]
      dimensions = {columns = 100, lines = 24}
      decorations_theme_variant = "Dark"

      [scrolling]
      history = 10000

      [font]
      normal = {family = "JetBrains Mono", style = "Regular"}
      size = 12.0

      [selection]
      save_to_clipboard = true

      [cursor]
      style = {shape = "Beam"}
      vi_mode_style = {shape = "Block"}

      [mouse]
      hide_when_typing = true

      [keyboard]
      bindings = [
        {key = "0", mods = "Control", action = "ResetFontSize"},
        {key = "Plus", mods = "Control", action = "IncreaseFontSize"},
        {key = "Minus", mods = "Control", action = "DecreaseFontSize"},
      ]

    '';
    home.file.".config/alacritty/colors.toml".text = ''
      [colors.primary]
      foreground = "#ebdbb2"
      background = "#282828"
      dim_foreground = "#a89984"
      bright_foreground = "#fbf1c7"

      [colors.normal]
      black = "#282828"
      blue = "#458588"
      cyan = "#689d6a"
      green = "#98971a"
      magenta = "#b16286"
      red = "#cc241d"
      white = "#a89984"
      yellow = "#d79921"

      [colors.bright]
      black = "#928374"
      blue = "#83a598"
      cyan = "#8ec07c"
      green = "#b8bb26"
      magenta = "#d3869b"
      red = "#fb4934"
      white = "#ebdbb2"
      yellow = "#fabd2f"

      [colors.dim]
      black = "#32302f"
      blue = "#076678"
      cyan = "#427b58"
      green = "#79740e"
      magenta = "#8f3f71"
      red = "#9d0006"
      white = "#928374"
      yellow = "#b57614"

      [colors.cursor]
      cursor = "#458588"
    '';
  };
}
