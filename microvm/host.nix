{
  microvm,
  ...
}:
let
  mvm-bridge = "mvmbr0";
in
{
  environment.etc = {
    "/NetworkManager/dnsmasq.d/microvm_dnsmasq.conf".text = ''
      interface=${mvm-bridge}
      interface=lo
      bind-interfaces

      domain=microvm.vm
      local=/microvm.vm/
      expand-hosts

      listen-address=192.168.180.1
      listen-address=127.0.0.1
      listen-address=fd12:3456:789a::1

      dhcp-range=192.168.180.2,192.168.180.254,255.255.255.0,12h
      dhcp-range=fd12:3456:789a::2,fd12:3456:789a::254

      dhcp-option=option:router,192.168.180.1
      dhcp-option=option:dns-server,192.168.180.1
      dhcp-option=option6:dns-server,[fd12:3456:789a::1]
      enable-ra
    '';
  };
  services.resolved.enable = false;

  networking.nat = {
    enable = true;
    enableIPv6 = true;
    externalInterface = "enp39s0";
    internalInterfaces = [ mvm-bridge ];
  };

  systemd.network = {
    enable = true;

    netdevs."${mvm-bridge}" = {
      netdevConfig = {
        Name = mvm-bridge;
        Kind = "bridge";
      };
    };

    networks."10-${mvm-bridge}" = {
      matchConfig.Name = mvm-bridge;

      networkConfig = {
        DHCPServer = false;
        IPv6SendRA = true;
        ConfigureWithoutCarrier = true;
      };
      addresses = [
        {
          Address = "192.168.180.1/24";
        }
        {
          Address = "fd12:3456:789a::1/64";
        }
      ];
      ipv6Prefixes = [
        {
          Prefix = "fd12:3456:789a::/64";
        }
      ];
    };

    networks."11-microvms" = {
      matchConfig.Name = "mvm-*";
      # Attach to the bridge that was configured above
      networkConfig.Bridge = mvm-bridge;
    };
  };

  networking.firewall.allowedUDPPorts = [
    # Allow inbound traffic for the DHCP server
    67
    # Allow inbound traffic for DNS server
    53
  ];

  # try to automatically start these MicroVMs on bootup
  microvm.autostart = [ ];

  imports = [
    microvm.nixosModules.host
  ];

  users.users.microvm.extraGroups = [ "pipewire" ];
}
