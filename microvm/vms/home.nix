{
  impermanence,
  username,
  ...
}:
{
  microvm = {
    optimize.enable = false;
    vcpu = 4;
    mem = 6144;
    hugepageMem = 6144;

    interfaces = [
      {
        type = "tap";
        id = "mvm-${username}";
        mac = "02:00:00:00:04:01";
      }
    ];

    devices = [
      {
        # Dummy for usb
        # https://github.com/microvm-nix/microvm.nix/blob/f4ae3dc4ee4c9b585b03c36bd73ef68d2a8eb3a9/lib/runners/qemu.nix#L64
        bus = "usb";
        path = "";
      }
    ];

    volumes = [
      {
        fsType = "ext4";
        autoCreate = false;
        image = "/dev/mapper/microvm-${username}";
        mountPoint = "/home/${username}";
      }
    ];

    shares = [
      {
        proto = "virtiofs";
        tag = "nixos-config";
        source = "/home/steav/nixos-config";
        mountPoint = "/home/${username}/nixos-config";
      }
    ];
  };

  services.udev.extraRules = ''
    # 特定の HID デバイスの権限を 0666 にする
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="9470", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="18d1", ATTRS{idProduct}=="9470", MODE="0666"
  '';

  programs.dconf.enable = true;

  # Any other configuration for your MicroVM
  imports = [
    impermanence.nixosModules.impermanence
    ./user/home.nix
    ./modules/network.nix
    ../../options.nix
    ../../system
    ./modules
  ];

  my = {
    fonts.enable = true;
    avahi.enable = true;
    openssh = {
      enable = true;
      secure = false;
    };
    waypipe.enable = true;
    firefox = {
      enable = true;
      type = "home";
    };
    appimage.enable = true;

    microvm = {
      openssh.enable = true;
      sound.enable = true;
      graphic.enable = true;
      persistence = {
        enable = true;
        source = "/var/lib/microvms/.persist/${username}";
      };
      nix-store = {
        enable = true;
        writableImage = "/dev/vg01/microvm-${username}-store";
      };
    };
  };
}
