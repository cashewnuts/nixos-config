{
  config,
  lib,
  username,
  pkgs,
  ...
}:

{
  options.users = with lib; {
    authorizedKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        openssh authorized keys for the user
      '';
    };
  };

  config = {
    networking.hostName = username;
    users.users.root.password = "";
    time.timeZone = "Asia/Tokyo";
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
      isNormalUser = true;
      uid = 1000;
      extraGroups = [
        "wheel"
      ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        # Add authorized keys
      ]
      ++ config.users.authorizedKeys;
    };

    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ username ];
    };
  };
}
