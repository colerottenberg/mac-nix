{
  description = "CRotty's Darwin system flake";

  inputs = {
    # Where we retrieve nixpkgs from. Giant mono repo with all the packages.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; # nixpkgs-unstable is the rolling release channel and security patches are applied to it.

    # Nix-darwin is a tool for managing darwin configuration using nix.
    # Nix-darwin works on a systems level, while home-manager works on a user level.
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager is a tool for managing user configuration using nix.
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations.Coles-MacBook-Pro-3 =
      darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        # pkgs = nixpkgs.legacyPackages.aarch64-darwin;
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
          };
        };
        modules = [
          ./modules/darwin

          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.colerottenberg.imports = [
                ./modules/home-manager

              ];
            };
          }
        ];
      };
  };
}
