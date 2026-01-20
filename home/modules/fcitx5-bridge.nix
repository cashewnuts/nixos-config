{ pkgs, ... }:
let
  port = 22123;
  range = "192.168.180.0/24";
in
{
  systemd.user.services.fcitx5-remote-bridge = {
    Unit = {
      Description = "Fcitx5 Remote Bridge (TCP)";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = ''${pkgs.socat}/bin/socat TCP4-LISTEN:${builtins.toString port},range=${range},reuseaddr,fork EXEC:"${pkgs.findutils}/bin/xargs /run/current-system/sw/bin/fcitx5-remote"'';
      Restart = "always";
    };
  };
}
