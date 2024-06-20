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
          aircrack-ng
          android-tools
          apksigner
          apktool
          cmake
          curl
          gcc
          ghidra
          git
          gnumake
          gradle
          linuxHeaders
          nodejs_21
          openjdk
          pciutils
          python311
          python311Packages.pip
          sqlite
          sqlitebrowser
          unzip
          vscodium
          wget
          wifite2
          wirelesstools
          wireshark
          zip
          # unstable.androidenv.androidPkgs_9_0.androidsdk
        ];

        shellHook = ''
          exec zsh
        '';
      };
  };
}
