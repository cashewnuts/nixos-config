{
  lib,
  ...
}:
{
  networking = {
    useDHCP = lib.mkForce false;
    dhcpcd.enable = lib.mkForce false;
    networkmanager = {
      enable = true;
      dns = "dnsmasq";
    };
  };
  environment.etc = {
    "/NetworkManager/dnsmasq.d/libvirt_dnsmasq.conf".text = ''
      server=/internal.vm/192.168.122.1
    '';
  };
}
