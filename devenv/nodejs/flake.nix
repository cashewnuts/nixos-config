{
  description = "Nodejs development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells = with pkgs; rec {
          default = mkShell {
            buildInputs = [ nodejs ];
          };
          node22 = mkShell {
            buildInputs = [ nodejs_22 ];
          };
          node24 = mkShell {
            buildInputs = [ nodejs_24 ];
          };
        };
      }
    );
}
