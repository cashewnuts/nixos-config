{
  nixpkgs,
  nixpkgs-unstable,
  pkgs,
  impermanence,
  microvm,
  ...
}:
let
  home = import ./vm.nix {
    inherit pkgs;
    inherit nixpkgs;
    inherit nixpkgs-unstable;
    inherit impermanence;
    vm = "home";
    username = "alice";
    index = "01";
  };
  developer = import ./vm.nix {
    inherit pkgs;
    inherit nixpkgs;
    inherit nixpkgs-unstable;
    inherit impermanence;
    vm = "developer";
    username = "oscar";
    index = "01";
  };
in
{
  imports = [
    microvm.nixosModules.host
    ./host.nix
    home
    developer
    ./vms/k3s.nix
  ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "setup-persistence" ''
      set -euo pipefail

      NAME="$1"
      DIR="/var/lib/microvms/.persist"

      mkdir -p "''${DIR}/''${NAME}"
    '')
    (pkgs.writeShellScriptBin "start-graham" ''
      set -euo pipefail

      if [[ $EUID -ne 0 ]]; then
         exec sudo "$0" "$@"
      fi

      systemctl start microvm@graham.service
    '')
    (pkgs.writeShellScriptBin "start-alice" ''
      set -euo pipefail

      if [[ $EUID -ne 0 ]]; then
         exec sudo "$0" "$@"
      fi

      systemctl start systemd-cryptsetup@microvm\\x2dalice.service

      systemctl start microvm@alice.service
    '')
    (pkgs.writeShellScriptBin "start-oscar" ''
      set -euo pipefail

      if [[ $EUID -ne 0 ]]; then
         exec sudo "$0" "$@"
      fi

      systemctl start systemd-cryptsetup@microvm\\x2doscar.service

      systemctl start microvm@oscar.service
    '')
    (pkgs.writeShellScriptBin "start-k3s" ''
      set -euo pipefail

      if [[ $EUID -ne 0 ]]; then
         exec sudo "$0" "$@"
      fi

      systemctl start microvm@k3s.service
    '')
  ];
}
