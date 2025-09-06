{ config, pkgs, ...}:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
    nerd-fonts.ubuntu-mono
  ];
}
