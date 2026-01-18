{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "fcitx5-remote" ''
      #!/bin/bash
      # 引数を UNIX ソケット経由で送信
      echo "$@" | ${pkgs.socat}/bin/socat - UNIX-CONNECT:/tmp/fcitx5-remote.sock
    '')
  ];
}
