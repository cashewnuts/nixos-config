{
  config,
  lib,
  username,
  pkgs,
  ...
}:

{
  config = {
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
      ++ config.my.microvm.openssh.authorizedKeys;
      packages = with pkgs; [
        tree
        file
      ];
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
  };
}
