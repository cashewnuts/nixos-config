{ lib, config, ... }:
{
  config = lib.mkIf config.my.stub-ld.enable {
    programs.nix-ld.enable = true;
  };
}
