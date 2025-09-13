{ config, pkgs, ... }:

{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
  home.file.".config/waybar/config.jsonc".source = ./waybar/config.jsonc;
  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.packages = [
    pkgs.nautilus
    pkgs.waybar
  ];

  services.walker = {
    enable = true;
    systemd.enable = true;
  };
}
