{
  config,
  lib,
  username,
  pkgs,
  ...
}:

{
  config = {
    networking.hostName = username;
    users.users.root.password = "";
    time.timeZone = "Asia/Tokyo";
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${username} = {
      isNormalUser = true;
      linger = true;
      uid = 1000;
      extraGroups = [
        "wheel"
        "pipewire"
        "video"
        "render"
      ]; # Enable ‘sudo’ for the user.
      openssh.authorizedKeys.keys = [
        # Add authorized keys
      ]
      ++ config.my.microvm.openssh.authorizedKeys;
      packages = with pkgs; [
        tree
        file
        cryptsetup
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

      loginShellInit = lib.mkOrder 1000 ''
        install-home-manager() {
          nix-channel --add https://channels.nixos.org/nixos-26.05 nixpkgs
          nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
          nix-channel --update
          nix-shell '<home-manager>' -A install
        }
      '';

      shellAliases = {
        home-update = "home-manager switch --flake ~/nixos-config/home-standalone";
      };

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
