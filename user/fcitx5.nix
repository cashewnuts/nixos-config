{ config, pkgs, ... }:

{
  home.file.".config/fcitx5" = {
    source = ./fcitx5;
    recursive = true;
  };
}
