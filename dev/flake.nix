{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    home-manager = {
      # due to stylix error cannot use 25.05
      # url = "github:nix-community/home-manager/release-25.05";
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
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
    in
    {
      nixosConfigurations = {
        debian = lib.nixosSystem {
          inherit system;
          modules = [
            ../system/fonts.nix
          ];
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
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
          };
        };
      }
    );
}
