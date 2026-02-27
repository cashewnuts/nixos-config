{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.wezterm.enable {
    environment.systemPackages = [
      pkgs.wezterm
    ];
  };
}
