{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.waypipe.enable {
    environment.systemPackages = with pkgs; [
      waypipe
    ];
  };
}
