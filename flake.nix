{
  description = "TheDarkBug's nixos configuration";

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
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = "${system}";
      config.allowUnfree = true;
      overlays = [outputs.overlays.unstable-packages];
    };
    user = "adri";
  in {
    overlays = import ./hosts/common/overlays {inherit inputs;};
    # nixosModules = import ./modules/nixos;
    nixosConfigurations = {
      "${user}-desk" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = {inherit inputs outputs;};
        pkgs = pkgs;
        modules = [
          ./hosts/${user}-desk/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.${user} = import ./home;
            };
          }
        ];
      };
      "${user}-lap" = nixpkgs.lib.nixosSystem {
        system = "${system}";
        specialArgs = {inherit inputs outputs;};
        pkgs = pkgs;
        modules = [
          ./hosts/${user}-lap/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs outputs;};
              users.${user} = import ./home;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      "${user}-desk" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
      };
      "${user}-lap" = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgs;
      };
    };
  };
}
