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
    home.file.".config/alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink /home/adri/.config/dotfiles/home/desktop/alacritty/alacritty.toml;
    home.file.".config/alacritty/colors.toml".source = config.lib.file.mkOutOfStoreSymlink /home/adri/.config/dotfiles/home/desktop/alacritty/colors.toml;
  };
}