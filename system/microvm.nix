{
  microvm,
  system,
  nixpkgs,
  username,
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

      # 上流 DNS（例）
      server=1.1.1.1
      server=8.8.8.8

      dhcp-range=192.168.180.2,192.168.180.254,255.255.255.0,12h
      dhcp-range=fd12:3456:789a::2,fd12:3456:789a::254

      dhcp-option=option:router,192.168.180.1
      dhcp-option=option:dns-server,192.168.180.1
      dhcp-option=option6:dns-server,[fd12:3456:789a::1]
      enable-ra
    '';
  };
  networking.useNetworkd = true;
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
  microvm.vms = {

    test-vm = {
      # The package set to use for the microvm. This also determines the microvm's architecture.
      # Defaults to the host system's package set if not given.
      pkgs = import nixpkgs { system = "x86_64-linux"; };

      # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
      specialArgs = {
        inherit username;
      };

      # The configuration for the MicroVM.
      # Multiple definitions will be merged as expected.
      config = {
        # It is highly recommended to share the host's nix-store
        # with the VMs to prevent building huge images.
        microvm = {
          interfaces = [
            {
              type = "tap";
              id = "mvm-test1";
              mac = "02:00:00:00:00:01";
            }
          ];

          shares = [
            {
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }
          ];
        };

        openssh.secure = false;
        users.authorizedKeys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTlpccJLaR57c6RJ2GO/p/nFFjFhB6W2tIBRymOdkCP steav@main"
        ];

        # Any other configuration for your MicroVM
        imports = [
          ./users/microvm.nix
          ./openssh.nix
        ];

        systemd.network.enable = true;
      };
    };
  };
}
