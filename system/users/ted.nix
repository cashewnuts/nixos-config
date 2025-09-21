{
  config,
  lib,
  username,
  pkgs,
  ...
}:

{
  networking.hostName = username; # Define your hostname.
  time.timeZone = "Asia/Tokyo";
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      file
      cryptsetup
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fileSystems."/home/${username}/.ssh" = {
    device = "user_ssh";
    fsType = "virtiofs";
    options = [
      "defaults"
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/share" = {
    device = "share";
    fsType = "virtiofs";
    options = [
      "defaults"
      "users"
      "nofail"
    ];
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    allowed-users = [ username ];
  };
}
