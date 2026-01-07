{ lib, config, ... }:
{

  config = lib.mkIf config.my.appimage.enable {
    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
