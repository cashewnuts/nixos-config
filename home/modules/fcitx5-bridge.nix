{ pkgs, ... }:
{
  systemd.user.services.fcitx5-remote-bridge = {
    Unit = {
      Description = "Fcitx5 Remote Bridge (TCP)";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = ''${pkgs.socat}/bin/socat TCP4-LISTEN:22123,bind=127.0.0.1,reuseaddr,fork EXEC:"${pkgs.findutils}/bin/xargs /run/current-system/sw/bin/fcitx5-remote"'';
      Restart = "always";
    };
  };
}
