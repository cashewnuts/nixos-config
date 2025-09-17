let
  pkgs = import <nixpkgs> { };
in
with pkgs;

stdenv.mkDerivation {
  pname = "hello-world";
  version = "0.0.1";

  src = ./.;

  buildPhase = ''
    gcc main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp a.out $out/bin/hello
  '';
}
