{
  description = "NixOS in MicroVMs";

  nixConfig = {
    extra-substituters = [ "https://microvm.cachix.org" ];
    extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      microvm,
      impermanence,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      graham = "graham";
    in
    {
      packages.${system} = {
        default = self.packages.${system}.${graham};
        ${graham} = self.nixosConfigurations.${graham}.config.microvm.declaredRunner;
      };

      nixosConfigurations = {
        ${graham} =
          let
            username = graham;
          in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit username;
            };
            modules =
              let
                vmModule = import ./vms/gpu.nix {
                  inherit (nixpkgs) lib; # graphic.nix が必要としている引数
                  inherit
                    pkgs
                    nixpkgs
                    nixpkgs-unstable
                    impermanence
                    ;
                  inherit username;
                  index = "12";
                };
              in
              [
                microvm.nixosModules.microvm
                vmModule
              ];
          };
      };
    };
}
