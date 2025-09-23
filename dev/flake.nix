{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-utils,
      home-manager,
      nixvim,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        legacyPackages = {
          homeConfigurations = {
            alice =
              let
                username = "alice";
              in
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                extraSpecialArgs = {
                  inherit system;
                  inherit nixvim;
                  inherit username;
                };
                modules = [
                  ../home/alice.dev.nix
                ];
              };
            oscar =
              let
                username = "oscar";
              in
              home-manager.lib.homeManagerConfiguration {
                inherit pkgs;

                extraSpecialArgs = {
                  inherit system;
                  inherit nixvim;
                  inherit username;
                };
                modules = [
                  ../home/oscar.dev.nix
                ];
              };
          };
        };
      }
    );
}
