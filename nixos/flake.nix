{
  description = "ad-oliviero";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      "adri-desk" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./adri-desk/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.adri = import ./home;
            };
          }
          (import ./overlays.nix)
        ];
      };
      "adri-lap" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./adri-lap/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.adri = import ./home;
            };
          }
          (import ./overlays.nix)
        ];
      };
    };
  };
}
