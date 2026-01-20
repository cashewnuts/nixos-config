{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.my.openmosh.enable {
    programs.mosh.enable = true;
  };
}
