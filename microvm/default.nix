{
  nixpkgs,
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
  imports = [
    microvm.nixosModules.host
    ./host.nix
    home
    ./vms/k3s.nix
  ];
}
