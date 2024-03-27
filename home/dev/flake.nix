{
  description = "Development shell for every language I use";
  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    inherit (self) outputs;
    system = "x86_64-linux";
  in {
    devShells."${system}".default = let
      pkgs = import nixpkgs {
        system = "${system}";
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
    in
      pkgs.mkShell {
        packages = with pkgs; [
          pciutils
          git
          vscodium
          ghidra
          curl
          wget
          zip
          unzip
          apktool
          apksigner
          openjdk
          gnumake
          gcc
          android-tools
          python311
          python311Packages.pip
          # (python311.withPackages (python-pkgs:
          #   with python-pkgs; [
          #     python-telegram-bot
          #   ]))
          android-studio
          cmake
          linuxHeaders
          # unstable.androidenv.androidPkgs_9_0.androidsdk
        ];

        shellHook = ''
          exec zsh
        '';
      };
  };
}
