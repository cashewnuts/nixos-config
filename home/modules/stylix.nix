{ pkgs, ... }:
{
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    polarity = "dark";
    fonts = {
      serif = {
        package = pkgs.noto-fonts-cjk-serif;
        name = "Noto Serif CJK JP";
      };

      sansSerif = {
        package = pkgs.noto-fonts-cjk-sans;
        name = "Noto Sans CJK JP";
      };

      monospace = {
        package = pkgs.nerd-fonts.ubuntu-mono;
        name = "UbuntuMono Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        desktop = 11;
        applications = 12;
        terminal = 11;
        popups = 12;
      };
    };
    targets = {
      kitty.enable = true;
      wezterm = {
        enable = true;
        colors.enable = false;
        fonts.enable = false;
      };
      firefox = {
        enable = true;
        profileNames = [ "default" ];
      };
      gtk.enable = true;
      gtk.flatpakSupport.enable = false;
    };
  };
}
