{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.fcitx5.enable {
    i18n.inputMethod = {
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-nord
        ];
      };
    };
  };
}
