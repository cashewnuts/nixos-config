{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (heroic.override {
      extraPkgs = pkgs: [
        gamescope
      ];
    })
  ];
}
