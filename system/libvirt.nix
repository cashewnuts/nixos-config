{
  config,
  lib,
  username,
  pkgs,
  ...
}:
{
  programs.virt-manager = {
    enable = true;
  };
  environment.systemPackages = with pkgs; [
    virt-viewer
  ];

  users.groups.libvirtd.members = [ username ];

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
    };
    spiceUSBRedirection.enable = true;
  };
}
