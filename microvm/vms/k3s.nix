{
  config,
  lib,
  impermanence,
  pkgs,
  nixpkgs,
  ...
}:
{
  microvm.vms =
    let
      vm01 = "k3s";
    in
    {

      "${vm01}" = {
        # The package set to use for the microvm. This also determines the microvm's architecture.
        # Defaults to the host system's package set if not given.
        pkgs = import nixpkgs { system = "x86_64-linux"; };

        autostart = false;

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
            hypervisor = "cloud-hypervisor";
            vcpu = 2;
            mem = 2048;

            cloud-hypervisor.extraArgs = [ ];

            interfaces = [
              {
                type = "tap";
                id = "mvm-${vm01}";
                mac = "02:00:00:01:00:01";
              }
            ];

            volumes = [
              {
                fsType = "ext4";
                autoCreate = false;
                image = "/dev/vg01/microvm-k3s-00";
                mountPoint = "/var/lib/rancher/k3s";
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
                tag = "persist";
                # Source path can be absolute or relative
                # to /var/lib/microvms/$hostName
                source = "/var/lib/microvms/.persist";
                mountPoint = "/persist";
              }
              {
                proto = "virtiofs";
                tag = "journal";
                source = "journal";
                mountPoint = "/var/log/journal";
              }
            ];
          };

          networking.hostName = "${vm01}";

          users.authorizedKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTlpccJLaR57c6RJ2GO/p/nFFjFhB6W2tIBRymOdkCP steav@main"
          ];

          # Any other configuration for your MicroVM
          imports = [
            impermanence.nixosModules.impermanence
            ./user/monitor.nix
            ../../options.nix
            ../../system
          ];

          my = {
            avahi.enable = true;
            openssh = {
              enable = true;
              secure = false;
            };
            k3s = {
              enable = true;
              fqdn = "k3s.local";
              ip = "192.168.180.200";
            };
          };

          systemd.network.enable = true;
          networking.useNetworkd = true;
          networking.useDHCP = false;

          # すべてのイーサネットインターフェースに対するデフォルト設定
          systemd.network.networks."40-ethernet" = {
            # 名前が "en" で始まるすべてのインターフェースにマッチさせる
            matchConfig.Name = "en*";

            # 固定 IP アドレスとサブネット
            address = [
              "192.168.180.200/24"
            ];

            # デフォルトゲートウェイ
            gateway = [
              "192.168.180.1"
            ];

            # 必要に応じて DHCP を明示的にオフにする
            networkConfig.IPv6PrivacyExtensions = "kernel";
          };

          environment.systemPackages = with pkgs; [ ];

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
