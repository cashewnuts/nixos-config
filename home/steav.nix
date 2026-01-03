{
  config,
  system,
  lib,
  username,
  pkgs,
  ...
}:
{

  imports = [
    ../user/zsh.nix
    ../user/hyprland.nix
    ../user/fcitx5.nix
    ../user/firefox.nix
    ../user/devenv.nix
    ../user/kitty.nix
    ../user/neovim.nix
    ../user/ssh-agent.nix
    ../user/stylix.nix
  ];

  # due to home-manager/stylix bug add this line
  home.enableNixpkgsReleaseCheck = false;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = username;
  home.homeDirectory = "/home/${username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.fzf
    pkgs.fd
    pkgs.ripgrep
    pkgs.gitui
    pkgs.vlc
    pkgs.runme
    pkgs.socat

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    "README.md" = {
      source = ../docs/steav.md;
    };
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/alice/etc/profile.d/hm-session-vars.sh
  #
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = username;
    userEmail = "cashewnuts903@gmail.com";
  };

  programs.zsh = {
    initContent = lib.mkOrder 1000 ''
      usb-add() {
        local NAME="$1"
        local ID="$2"
        local VENDOR="$3"
        local PRODUCT="$4"
        cat <<EOF | sudo socat - UNIX-CONNECT:/var/lib/microvms/''${NAME}/''${NAME}.sock
        { "execute": "qmp_capabilities" }
        {
          "execute": "device_add",
          "arguments": {
            "driver": "usb-host",
            "id": "''${ID}",
            "vendorid": ''${VENDOR},
            "productid": ''${PRODUCT}
          }
        }
      EOF
      }

      usb-del() {
        local NAME="$1"
        local ID="$2"
        cat <<EOF | sudo socat - UNIX-CONNECT:/var/lib/microvms/''${NAME}/''${NAME}.sock
        { "execute": "qmp_capabilities" }
        {
          "execute": "device_del",
          "arguments": {
            "id": "''${ID}"
          }
        }
      EOF
      }

      usb-ls() {
        local NAME="$1"
        cat <<EOF | sudo socat - UNIX-CONNECT:/var/lib/microvms/''${NAME}/''${NAME}.sock
        { "execute": "qmp_capabilities" }
        { "execute": "x-query-usb" }
      EOF
      }

      usb-titan() {
        local VM="$1"
        usb-add $VM usb_titan 6353 38000
      }

      usb-titan-del() {
        local VM="$1"
        usb-del $VM usb_titan
      }

      usb-t7() {
        local VM="$1"
        usb-add $VM usb_t7 1256 25083
      }

      usb-t7-del() {
        local VM="$1"
        usb-del $VM usb_t7
      }
    '';

    shellAliases = {
      vv = "virt-viewer --spice-usbredir-auto-redirect-filter='-1,-1,-1,-1,0' --spice-usbredir-redirect-on-connect='-1,0x18d1,0x9470,-1,1' --hotkeys=toggle-fullscreen=shift+f11 -a -d --connect qemu:///system";
      alice = "kitten ssh alice@alice.internal.vm";
      walice = "waypipe --video none,av1,hw ssh alice@alice.internal.vm";
      xalice = "ssh -X alice@alice.internal.vm";
      oscar = "kitten ssh oscar@oscar.internal.vm";
      woscar = "waypipe --video none,av1,hw ssh oscar@oscar.internal.vm";
      xoscar = "ssh -X oscar@oscar.internal.vm";
      graham = "kitten ssh graham@graham.microvm.vm";
      wgraham = "waypipe --video none,av1,hw ssh graham@graham.microvm.vm";
    };
  };
}
