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
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
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
      packages.${system} = {
        build_iso =
          let
            username = "alice";
          in
          inputs.nixos-generators.nixosGenerate {
            inherit system;
            specialArgs = {
              inherit username;
            };
            modules = [
              ./hosts/iso/user/configuration.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/stub-ld.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit system;
                    inherit nixvim;
                    inherit username;
                  };
                  users.alice = {
                    imports = [
                      stylix.homeModules.stylix
                      ./alice.nix
                    ];
                  };
                };
              }
            ];
            format = "iso";
          };
        build_installer =
          let
            username = "nixos";
          in
          inputs.nixos-generators.nixosGenerate {
            inherit system;
            modules = [
              ./hosts/iso/installer/configuration.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit system;
                    inherit username;
                  };
                  users.${username} = {
                    imports = [
                      ./installer.nix
                    ];
                  };
                };
              }
            ];
            format = "iso";
          };
      };
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/kvm/default/configuration.nix
          ];
        };
        alice =
          let
            username = "alice";
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit username;
            };
            modules = [
              ./hosts/kvm/luks/configuration.nix
              ./system/users/alice.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/stub-ld.nix
              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = false;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit system;
                    inherit nixvim;
                    inherit username;
                  };
                  users.alice = {
                    imports = [
                      stylix.homeModules.stylix
                      ./alice.nix
                    ];
                  };
                };
              }
            ];
          };
      };
    };
}
