{
  config,
  lib,
  pkgs,
  ...
}:

{
  networking.hostName = "alice"; # Define your hostname.
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alice = {
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
      store-data	/dev/vdb	/home/alice/.ssh/id_ed25519	noauto,discard
    '';
  };

  fileSystems."/home/alice/.ssh" = {
    device = "user_ssh";
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
    allowed-users = [ "alice" ];
  };
}
