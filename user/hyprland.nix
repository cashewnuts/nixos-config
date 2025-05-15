{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  home.packages = [
    pkgs.walker
    pkgs.nautilus
    pkgs.waybar
  ];
}
