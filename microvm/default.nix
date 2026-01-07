{
  nixpkgs,
  pkgs,
  impermanence,
  microvm,
  ...
}:
let
  home = import ./vm.nix {
    inherit nixpkgs;
    inherit impermanence;
    vm = "home";
    username = "alice";
    index = "01";
  };
in
{

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "setup-persistence" ''
      set -euo pipefail

      NAME="$1"
      DIR="/var/lib/microvms/.persist"

      mkdir -p "''${DIR}/''${NAME}/etc/ssh/"
      cp ''${DIR}/etc/ssh/* "''${DIR}/''${NAME}/etc/ssh/"
    '')
  ];

  imports = [
    microvm.nixosModules.host
    ./host.nix
    home
    ./vms/k3s.nix
  ];
}
