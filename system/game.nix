{ pkgs, ... }:
{
  programs = {
    gamescope = {
      enable = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
  environment.systemPackages = with pkgs; [
    (heroic.override {
      extraPkgs = pkgs: [
        gamescope
      ];
    })
  ];
}
