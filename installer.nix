{
  config,
  system,
  username,
  pkgs,
  nixvim,
  ...
}:
{

  imports = [ ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.stateVersion = "25.05"; # Please read the comment before changing.

  home.packages = [
    pkgs.runme
  ];

  home.file = {
    "README.md" = {
      source = ./docs/installer.md;
    };
    "nix-config" = {
      source = ./.;
      recursive = true;
    };
  };
}
