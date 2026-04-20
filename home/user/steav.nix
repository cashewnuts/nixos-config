{
  lib,
  username,
  pkgs,
  ...
}:
{

  imports = [
    ../modules/zsh.nix
    ../modules/hyprland.nix
    ../modules/fcitx5.nix
    ../modules/firefox.nix
    ../modules/devenv.nix
    ../modules/kitty.nix
    ../modules/wezterm.nix
    ../modules/neovim.nix
    ../modules/ssh-agent.nix
    ../modules/stylix.nix
    ../modules/fcitx5-bridge.nix
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
    pkgs.age
    pkgs.mosh
    pkgs.blender

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

    (pkgs.writeShellScriptBin "usb-ls" ''
      NAME="$1"
      cat <<EOF | sudo socat - UNIX-CONNECT:/var/lib/microvms/''${NAME}/''${NAME}.sock
      { "execute": "qmp_capabilities" }
      { "execute": "x-query-usb" }
      EOF
    '')
    (pkgs.writeShellScriptBin "usb-add" ''
      NAME="$1"
      ID="$2"
      VENDOR="$3"
      PRODUCT="$4"
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
    '')
    (pkgs.writeShellScriptBin "usb-del" ''
      NAME="$1"
      ID="$2"
      cat <<EOF | sudo socat - UNIX-CONNECT:/var/lib/microvms/''${NAME}/''${NAME}.sock
      { "execute": "qmp_capabilities" }
      {
        "execute": "device_del",
        "arguments": {
          "id": "''${ID}"
        }
      }
      EOF
    '')

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
      source = ../../docs/steav.md;
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
    settings.user = {
      name = username;
      email = "cashewnuts903@gmail.com";
    };
  };

  programs.zsh = {
    initContent = lib.mkOrder 1000 ''
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
      age-r = "age -r age1wts2kxfxajgu8xmhj2434hjhzj3fwksagvt88qypfkqy7jf84yxs8ll54k";
      age-d = "age --decrypt";
      vv = "virt-viewer --spice-usbredir-auto-redirect-filter='-1,-1,-1,-1,0' --spice-usbredir-redirect-on-connect='-1,0x18d1,0x9470,-1,1' --hotkeys=toggle-fullscreen=shift+f11 -a -d --connect qemu:///system";
      alice = "wezterm connect SSHMUX:alice";
      malice = "mosh alice@alice.microvm.vm";
      walice = "waypipe --no-gpu --compress none ssh alice@alice.microvm.vm";
      oscar = "wezterm connect SSHMUX:oscar";
      moscar = "mosh oscar@oscar.microvm.vm";
      woscar = "waypipe --no-gpu --compress none ssh oscar@oscar.microvm.vm";
      graham = "ssh graham@graham.microvm.vm";
      wgraham = "waypipe --no-gpu --compress none ssh graham@graham.microvm.vm";
    };
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks =
      let
        extraOptions = {
          "ServerAliveInterval" = "30";
          "ServerAliveCountMax" = "3";
          "ConnectTimeout" = "10";
        };
      in
      {
        "alice alice.*" = {
          hostname = "alice.microvm.vm";
          inherit extraOptions;
        };
        "oscar oscar.*" = {
          hostname = "oscar.microvm.vm";
          inherit extraOptions;
        };
      };
  };
}
