{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
  home.packages = [
    pkgs.nautilus
    pkgs.waybar
  ];

  services.walker = {
    enable = true;
    systemd.enable = true;
  };
}
