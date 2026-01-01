{
  impermanence,
  nixpkgs,
  lib,
  ...
}:
{
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
            vcpu = 4;
            mem = 6144;
            hugepageMem = 6144;

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
            ./user.nix
            ../system/openssh.nix
            ../system/waypipe.nix
            ../system/firefox.nix
          ];

          systemd.network.enable = true;

          # Graphics
          hardware.graphics.enable = true;
          # Wayland アプリを headless で動かすために必要
          environment.variables = {
            XDG_RUNTIME_DIR = "/run/user/1000";
          };

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
