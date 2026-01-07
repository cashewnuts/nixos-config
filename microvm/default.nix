{
  nixpkgs,
  impermanence,
  microvm,
  ...
}:
let
  grahamx = import ./vm.nix {
    inherit nixpkgs;
    inherit impermanence;
    vm = "graphic";
    username = "graham";
    index = "01";
  };
in
{
  imports = [
    microvm.nixosModules.host
    ./host.nix
    grahamx
    ./vms/home.nix
    ./vms/k3s.nix
  ];
}
