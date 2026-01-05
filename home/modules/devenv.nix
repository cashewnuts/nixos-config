{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.stow
  ];
  programs = {
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
