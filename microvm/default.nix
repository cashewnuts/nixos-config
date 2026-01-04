{
  microvm,
  ...
}:
{
  imports = [
    microvm.nixosModules.host
    ./host.nix
    ./vms/graphic.nix
    ./vms/home.nix
  ];
}
