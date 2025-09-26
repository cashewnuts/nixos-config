{
  config,
  lib,
  username,
  pkgs,
  ...
}:

{
  services.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
    autoLogin = {
      enable = true;
      user = username;
    };
  };
  # for trash
  services.gvfs.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  environment.systemPackages = [
    pkgs.kitty
    pkgs.wl-clipboard
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  hardware.graphics.enable = true;
}
