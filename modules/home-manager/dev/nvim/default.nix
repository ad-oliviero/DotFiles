{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.nvim;
in {
  options.nvim = {
    enable = lib.mkEnableOption "enable nvim module";
  };
  config =
    lib.mkIf cfg.enable {
      home.packages = with pkgs; [
      llvm
      lua-language-server
      pyright
      nil
      ];
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      # uncomment the following option to reload neovim config without rebuilding the whole nix config
      # useful for debugging
      extraLuaConfig = ''package.path = package.path .. ";/home/adri/.config/dotfiles/modules/home-manager/dev/nvim/?.lua;/home/adri/.config/dotfiles/modules/home-manager/dev/nvim/lua/?.lua"
      require "init"'';
      #extraLuaConfig = lib.fileContents ./init.lua;
    };
    };
}
