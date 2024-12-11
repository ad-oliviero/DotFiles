{
  description = "ad-oliviero";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
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
      "adri-lap" = nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          (import ./overlays.nix)
        ];
      };
    };
  };
}
