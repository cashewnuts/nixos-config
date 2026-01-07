{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.cloud-hypervisor.enable {
    environment.systemPackages = with pkgs; [
      cloud-hypervisor
    ];
  };
}
