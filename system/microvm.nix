{
  microvm,
  impermanence,
  nixpkgs,
  lib,
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
  microvm.vms =
    let
      vm01 = "graham";
    in
    {

      "${vm01}" = {
        # The package set to use for the microvm. This also determines the microvm's architecture.
        # Defaults to the host system's package set if not given.
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        # (Optional) A set of special arguments to be passed to the MicroVM's NixOS modules.
        specialArgs = {
          username = vm01;
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
                id = "mvm-${vm01}";
                mac = "02:00:00:00:00:01";
              }
            ];

            shares = [
              {
                proto = "virtiofs";
                source = "/nix/store";
                mountPoint = "/nix/.ro-store";
                tag = "ro-store";
                readOnly = true;
              }
              {
                proto = "virtiofs";
                tag = "home";
                # Source path can be absolute or relative
                # to /var/lib/microvms/$hostName
                source = "home";
                mountPoint = "/home";
              }
              {
                proto = "virtiofs";
                tag = "persist";
                # Source path can be absolute or relative
                # to /var/lib/microvms/$hostName
                source = "/var/lib/microvms/persist";
                mountPoint = "/persist";
              }
            ];
          };

          openssh.secure = false;
          users.authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTlpccJLaR57c6RJ2GO/p/nFFjFhB6W2tIBRymOdkCP steav@main"
          ];

          # Any other configuration for your MicroVM
          imports = [
            impermanence.nixosModules.impermanence
            ./users/microvm.nix
            ./openssh.nix
          ];

          systemd.network.enable = true;

          fileSystems."/persist".neededForBoot = lib.mkForce true;
          environment.persistence."/persist" = {
            files = [
              "/etc/ssh/ssh_host_ed25519_key"
              "/etc/ssh/ssh_host_ed25519_key.pub"
              "/etc/ssh/ssh_host_rsa_key"
              "/etc/ssh/ssh_host_rsa_key.pub"
            ];
          };
        };
      };
    };
}
