{
  config,
  lib,
  username,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.hyprland.enable {
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
      pkgs.wezterm
      pkgs.wl-clipboard
    ];

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
