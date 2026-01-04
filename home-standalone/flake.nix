{
  description = "Alice's standalone home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      stylix,
      nixvim,
      nixpkgs,
      ...
    }:
    let
      system = "x86_64-linux";
    in
    {
      homeConfigurations = {
        alice =
          let
            username = "alice";
            pkgs = nixpkgs.legacyPackages.${system};
          in
          home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            extraSpecialArgs = {
              inherit system;
              inherit username;
              inherit nixvim;
              inherit stylix;
            };
            modules = [
              stylix.homeModules.stylix
              ../home/alice.microvm.nix
            ];
          };
      };
    };
}
