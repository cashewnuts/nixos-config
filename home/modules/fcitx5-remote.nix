{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "fcitx5-remote" ''
      #!/bin/bash
      # 引数を TCP 経由で送信
      echo "$@" | ${pkgs.socat}/bin/socat - TCP4:localhost:22123
    '')
  ];
}
