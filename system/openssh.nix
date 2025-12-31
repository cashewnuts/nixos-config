{
  lib,
  config,
  username,
  ...
}:
{
  options.openssh = with lib; {
    secure = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether disallow password authentication or not.
      '';
    };
  };

  config = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings =
        let
          passAuth = if config.openssh.secure then false else true;
        in
        {
          PasswordAuthentication = passAuth;
          KbdInteractiveAuthentication = passAuth;
          PermitRootLogin = "no";
          AllowUsers = [ username ];
          X11Forwarding = true;
        };
    };
  };
}
