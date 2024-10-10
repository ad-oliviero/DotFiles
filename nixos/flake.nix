{
  description = "ad-oliviero";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations = {
      adri = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [./home];
      };
    };
    nixosConfigurations = {
      "adri-desk" = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs;};
        modules = [
          ./adri-desk/configuration.nix
          (import ./overlays.nix)
        ];
      };
      "adri-lap" = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs;};
        modules = [
          ./adri-lap/configuration.nix
          (import ./overlays.nix)
        ];
      };
    };
  };
}
