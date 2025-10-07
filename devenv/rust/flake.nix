{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
      flake-utils,
    }:
    flake-utils.lib.eachSystem flake-utils.lib.defaultSystems (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        rust = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src" # for rust-analyzer
            "rust-analyzer"
          ];
          targets = [
            "wasm32-unknown-unknown"
          ];
        };
      in
      {
        devShells = with pkgs; rec {
          default = mkShell {
            buildInputs = [
              openssl
              pkg-config
              rust
            ];
          };
          lambda = mkShell {
            buildInputs = [
              openssl
              pkg-config
              rust
              # https://www.cargo-lambda.info/guide/installation.html
              cargo-lambda
            ];
          };
        };
      }
    );
}
