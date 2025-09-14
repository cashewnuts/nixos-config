{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
  home.file.".config/walker" = {
    source = ./walker;
    recursive = true;
  };
  home.packages = [
    pkgs.nautilus
    pkgs.waybar
    pkgs.walker
  ];
}
