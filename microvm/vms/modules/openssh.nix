{ lib, config, ... }:
{
  config = lib.mkIf config.my.microvm.openssh.enable {
    my.microvm.openssh.authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOTlpccJLaR57c6RJ2GO/p/nFFjFhB6W2tIBRymOdkCP steav@main"
    ];
  };
}
