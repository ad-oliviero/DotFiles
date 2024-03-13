{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./hosts/adri-lap/overlays {inherit inputs;};
    # nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    nixosConfigurations = {
      "adri-lap" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.android_sdk.accept_license = true;
        };
        modules = [
          ./hosts/adri-lap/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              #useGlobalPkgs = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.adri = import ./hosts/adri-lap/home.nix;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "adri-lap" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };
  };
}
