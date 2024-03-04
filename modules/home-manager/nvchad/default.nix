{ lib, config, pkgs, ... }:
let
  cfg = config.nvchad;
in
{
  options.nvchad = {
    enable = lib.mkEnableOption "enable nvchad module";
  };
  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim/".source = pkgs.stdenv.mkDerivation {
      name = "NvChad";
      src = pkgs.fetchFromGitHub {
        owner = "NvChad";
        repo = "NvChad";
        rev = "v2.0";
        hash = "sha256-x1y2SkoLNwu0NzmnKxUfl5UQG+SIcW87FhpyZMEHuU8=";
      };
      installPhase = ''
        mkdir -p "$out"
        cp -r ./* $out/
        cp -r ${./custom} $out/lua/custom
      '';
    };
  };
}
