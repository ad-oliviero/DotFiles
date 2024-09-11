{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.nvim;
in {
  options = {
    nvim.enable = lib.mkEnableOption "Enable nvim";
  };
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      alejandra
      codeium
      clang-tools
      lua-language-server
      llvm
      nil
      stylua
      shfmt
      shellcheck
      pyright
      ripgrep
    ];
    programs.neovim = {
      enable = true;
      vimAlias = true;
      withNodeJs = true;
      # extraLuaConfig = ''
      #   package.path = package.path .. ";/home/adri/.config/dotfiles/nixos/nvim/?.lua;/home/adri/.config/dotfiles/nixos/nvim/lua/?.lua"
      #   require "init"'';

      #extraLuaConfig = lib.fileContents ./init.lua;
    };

    xdg.configFile."nvim".source = ./nvim;
  };
}
