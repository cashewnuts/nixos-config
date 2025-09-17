{ pkgs }:
with pkgs;
stdenv.mkDerivation {
  pname = "nix-config-repo";
  version = "0.0.1";

  src = ./../..;

  buildInputs = [ ];

  installPhase = ''
    mkdir -p $out/nix-config
    cp -r . $out/nix-config/
    mkdir -p $out/bin
    cp ./pkgs/nix-config-repo/nix-config-repo.sh $out/bin/nix-config-repo
    chmod +x $out/bin/nix-config-repo
  '';
}
