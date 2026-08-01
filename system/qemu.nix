{
  lib,
  config,
  pkgs,
  nixpkgs,
  nixpkgs-unstable,
  ...
}:
{
  config = lib.mkIf config.my.qemu.enable {
    environment.systemPackages = with pkgs; [
      qemu
    ];

    nixpkgs.overlays = [
      (final: prev: {
        qemu = nixpkgs-unstable.legacyPackages.${prev.system}.qemu;
      })
    ];
  };
}
