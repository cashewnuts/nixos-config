{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      # due to stylix error cannot use 25.05
      # url = "github:nix-community/home-manager/release-25.05";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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
              ./system/users/alice.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/stub-ld.nix
              ./system/appimage.nix
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
                      ./home/alice.nix
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
                      ./home/installer.nix
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
        main =
          let
            hostName = "main";
            username = "steav";
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit hostName;
              inherit username;
            };
            modules = [
              ./hosts/metal/configuration.nix
              ./system/users/steav.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/stub-ld.nix
              ./system/appimage.nix
              ./system/flatpak.nix
              ./system/libvirt.nix
              ./system/networkmanager.nix
              ./system/game.nix
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
                  users.${username} = {
                    imports = [
                      stylix.homeModules.stylix
                      ./home/steav.nix
                    ];
                  };
                };
              }
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
              ./system/appimage.nix
              ./system/openssh.nix
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
                  users.${username} = {
                    imports = [
                      stylix.homeModules.stylix
                      ./home/alice.nix
                    ];
                  };
                };
              }
            ];
          };
        oscar =
          let
            username = "oscar";
          in
          lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit username;
            };
            modules = [
              ./hosts/kvm/luks/configuration.nix
              ./system/users/oscar.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/stub-ld.nix
              ./system/appimage.nix
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
                  users.${username} = {
                    imports = [
                      stylix.homeModules.stylix
                      ./home/oscar.nix
                    ];
                  };
                };
              }
            ];
          };
        ted =
          let
            username = "ted";
          in
          lib.nixosSystem {
            inherit system;
            inherit pkgs;
            specialArgs = {
              inherit username;
            };
            modules = [
              ./hosts/kvm/luks/configuration.nix
              ./system/users/ted.nix
              ./system/fonts.nix
              ./system/hyprland.nix
              ./system/fcitx5.nix
              ./system/firefox.nix
              ./system/appimage.nix
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
                  users.${username} = {
                    imports = [
                      stylix.homeModules.stylix
                      ./home/ted.nix
                    ];
                  };
                };
              }
            ];
          };
      };
    };
}
