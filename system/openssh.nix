{
  lib,
  config,
  username,
  ...
}:
{
  config = lib.mkIf config.my.openssh.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings =
        let
          passAuth = if config.my.openssh.secure then false else true;
        in
        {
          PasswordAuthentication = passAuth;
          KbdInteractiveAuthentication = passAuth;
          PermitRootLogin = "no";
          AllowUsers = [ username ];
          X11Forwarding = true;
          StreamLocalBindUnlink = "yes";
          AcceptEnv = "LANG LC_* TERM TERM_* COLORTERM WEZTERM_*";
        };
    };
  };
}
