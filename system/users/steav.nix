{
  config,
  lib,
  hostName,
  username,
  pkgs,
  ...
}:

{
  networking.hostName = hostName; # Define your hostname.
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
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  fileSystems."/mnt/var" = {
    device = "/dev/mapper/vg01-store--var";
    fsType = "btrfs";
    options = [
      "defaults"
      "users"
      "compress=zstd"
      "rw"
      "user"
      "exec"
      "nofail"
    ];
  };

  fileSystems."/home/${username}/.local/share/Steam" = {
    device = "/dev/mapper/vg01-store--var";
    fsType = "btrfs";
    options = [
      "defaults"
      "users"
      "compress=zstd"
      "subvol=home/user/steam"
      "rw"
      "user"
      "exec"
      "nofail"
    ];
  };

  fileSystems."/home/${username}/.config/heroic" = {
    device = "/dev/mapper/vg01-store--var";
    fsType = "btrfs";
    options = [
      "defaults"
      "users"
      "compress=zstd"
      "subvol=home/user/heroic_games_launcher"
      "rw"
      "user"
      "exec"
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
