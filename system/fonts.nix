{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.my.fonts.enable {
    fonts.packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.fira-code
      nerd-fonts.fira-mono
      nerd-fonts.ubuntu-mono
    ];
  };
}
