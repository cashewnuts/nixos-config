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
      gcc
      file
      cryptsetup
    ];
  };

  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # <volume-name> <encrypted-device> [key-file] [options]
      store-data	/dev/disk/by-uuid/c975cdfa-0bfd-4e42-a5fe-c00b2292d88a	none	noauto,discard,fido2-device=auto
    '';
  };

  fileSystems."/home/${username}/.ssh" = {
    device = "user_ssh";
    fsType = "virtiofs";
    options = [
      "defaults"
      "users"
      "nofail"
    ];
  };

  fileSystems."/home/${username}/projects" = {
    device = "projects";
    fsType = "virtiofs";
    options = [
      "defaults"
      "users"
      "nofail"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/mapper/store-data";
    fsType = "ext4";
    options = [
      "defaults"
      "users"
      "noauto"
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
