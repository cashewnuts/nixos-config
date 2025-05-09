{ config, lib, pkgs, ... }:

{
  networking.hostName = "alice"; # Define your hostname.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "alice" ];
  };
}
