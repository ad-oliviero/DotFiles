{
  description = "TheDarkBug's nixos configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-flake.url = "github:srid/nixos-flake";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-flake,
    home-manager,
    ...
  } @ inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "x86_64-linux"];
      imports = [inputs.nixos-flake.flakeModule];
      flake = let
        inherit (self) outputs;
        system = "x86_64-linux";
        pkgs = import nixpkgs {
          system = "${system}";
          config.allowUnfree = true;
          overlays = [
            outputs.overlays.unstable-packages
          ];
        };
        user = "adri";
      in {
        overlays = import ./overlays {inherit inputs;};
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
        darwinConfigurations = {
          mac = self.nixos-flake.lib.mkMacosSystem {
            nixpkgs = {
              hostPlatform = "aarch64-darwin";
              config.allowUnfree = true;
              overlays = [
                outputs.overlays.unstable-packages
              ];
            };
            imports = [
              ./hosts/adri-mac
              self.darwinModules_.home-manager
              {
                home-manager.users.adrianooliviero = {
                  imports = [
                    ./home-mac
                    #inputs.agenix.homeManagerModules.age
                  ];
                  home.stateVersion = "23.11";
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
    };
}
