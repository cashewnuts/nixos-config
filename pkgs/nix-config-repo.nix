{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    (callPackage ./nix-config-repo { inherit pkgs; })
  ];
}
