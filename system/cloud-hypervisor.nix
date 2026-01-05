{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cloud-hypervisor
  ];
}
