{
  config,
  username,
  pkgs,
  ...
}:

{
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/${username}.conf;
  home.file.".config/waybar" = {
    source = ./waybar;
    recursive = true;
  };
  home.file.".config/walker" = {
    source = ./walker;
    recursive = true;
  };
  home.file.".config/hypr/hypridle.conf".source = ./hypridle/hypridle.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprlock/hyprlock.conf;
  home.packages = [
    pkgs.nautilus
    pkgs.waybar
    pkgs.walker
    pkgs.hypridle
    pkgs.hyprlock
    pkgs.brightnessctl
  ];
  services = {
    hyprpaper = {
      enable = true;
      settings = {
        ipc = "on";
        splash = false;
        splash_offset = 2.0;

        preload = [
          "$HOME/wallpaper.webp"
        ];

        wallpaper = [
          ", $HOME/wallpaper.webp"
        ];
      };
    };
    hyprpolkitagent.enable = true;
  };
}
