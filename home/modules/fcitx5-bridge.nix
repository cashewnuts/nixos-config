{ pkgs, ... }:
{
  systemd.user.services.fcitx5-remote-bridge = {
    Unit = {
      Description = "Fcitx5 Remote Bridge (UNIX Socket)";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/fcitx5-remote.sock";
      ExecStart = ''${pkgs.socat}/bin/socat UNIX-LISTEN:%t/fcitx5-remote.sock,fork,mode=600 EXEC:"${pkgs.findutils}/bin/xargs /run/current-system/sw/bin/fcitx5-remote"'';
      Restart = "always";
    };
  };
}
