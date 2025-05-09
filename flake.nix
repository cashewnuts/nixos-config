{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let 
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
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
          ./system/users/alice.nix
          ./system/shared-fs.nix
          ./system/hyprland.nix
        ];
      };
    };
    homeConfigurations = {
      alice = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./alice.nix ];
      };
    };
  };
}
