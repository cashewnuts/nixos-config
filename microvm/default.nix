{
  microvm,
  ...
}:
{
  imports = [
    microvm.nixosModules.host
    ./host.nix
    ./vm_graphic.nix
  ];
}
