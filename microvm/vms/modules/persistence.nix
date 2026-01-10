{
  lib,
  config,
  ...
}:
let
  cfg = config.my.microvm.persistence;
in
{
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.source != "";
        message = "my.microvm.persistence.source is not defined.";
      }
    ];

    microvm.shares = [
      {
        proto = "virtiofs";
        tag = "persist";
        # Source path can be absolute or relative
        # to /var/lib/microvms/$hostName
        source = cfg.source;
        mountPoint = "/persist";
      }
    ];

    fileSystems."/persist".neededForBoot = lib.mkForce true;
    environment.persistence."/persist" = {
      directories = [
        "/var/lib/nixos"
      ];
      files = [
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ];
    };
  };
}
