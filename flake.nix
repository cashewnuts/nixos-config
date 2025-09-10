{
  description = "A very basic flake";

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
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixvim,
      stylix,
      ...
    }:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/kvm/default/configuration.nix
          ];
        };
        alice = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/kvm/default/configuration.nix
            ./system/fonts.nix
            ./system/users/alice.nix
            ./system/hyprland.nix
            ./system/fcitx5.nix
            ./system/firefox.nix
          ];
        };
      };
      homeConfigurations = {
        alice = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit system;
            inherit nixvim;
          };
          modules = [
            stylix.homeModules.stylix
            ./alice.nix
          ];
        };
      };
    };
}
