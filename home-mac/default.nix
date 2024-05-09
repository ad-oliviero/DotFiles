{pkgs, ...}: {
  home.username = "adrianooliviero";
  home.homeDirectory = pkgs.lib.mkForce "/Users/adrianooliviero";
  home.stateVersion = "23.11";
  imports = [
    ./desktop
    ./dev
    #./zathura.nix
    ./zsh.nix
  ];
  desktop.enable = true;
  dev.enable = true;
  #zathura.enable = true;
  zsh.enable = true;


  #fonts.fontconfig.enable = true;
  # TODO: move packages to their modules (if possible)
  home.packages = with pkgs; [
    alacritty
    jetbrains-mono
    helvetica-neue-lt-std
    nerdfonts
    eza
    btop
    yabai
  ];

  home.sessionVariables = {
    GIT_EDITOR = "nvim";
    EDITOR = "nvim";
    VISUAL = "nvim";

    TERMINAL = "alacritty";
    BROWSER = "firefox";
  };

  programs.home-manager.enable = true;
}
