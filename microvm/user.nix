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
        "pipewire"
      ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        # Add authorized keys
      ]
      ++ config.users.authorizedKeys;
    };
    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = { };

      histSize = 10000;
      histFile = "$HOME/.zsh_history";
      setOptions = [
        "HIST_IGNORE_ALL_DUPS"
      ];
    };

    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ username ];
    };
  };
}
