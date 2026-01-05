{ pkgs, lib, ... }:
{
  config.colorschemes = {
    tokyonight = {
      # https://github.com/folke/tokyonight.nvim
      enable = true;
      settings = {
        style = "moon";
        light_style = "day";
      };
    };
  };
}
